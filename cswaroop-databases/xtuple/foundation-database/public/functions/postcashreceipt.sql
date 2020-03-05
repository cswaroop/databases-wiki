CREATE OR REPLACE FUNCTION postCashReceipt(pCashrcptid    INTEGER,
                                           pJournalNumber INTEGER) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _ccpayid  INTEGER;
  _cctype TEXT;
  _p RECORD;
  _r RECORD;
  _t RECORD;
  _v RECORD;
  _cashcust RECORD; -- Cash Rcpt and Customer
  _postToAR NUMERIC;
  _postToMisc NUMERIC;
  _postToCM NUMERIC;
  _posted_base NUMERIC := 0;
  _posted NUMERIC := 0;
  _sequence INTEGER;
  _aropenid INTEGER;
  _arMemoNumber TEXT;
  _arAccntid INTEGER;
  _closed BOOLEAN;
  _debitAccntid INTEGER;
  _exchGain NUMERIC;
  _comment TEXT;
  _predist BOOLEAN;
  _check INTEGER;

BEGIN
  _posted := 0;
  _posted_base := 0;

  SELECT fetchGLSequence() INTO _sequence;

------------------------------------------------------------------
-- Begin Main loop of Cash Receipt and Customer
  FOR _cashcust IN
   SELECT DISTINCT cashrcpt_id,
		COALESCE(cashrcpt_cust_id, cashrcptitem_cust_id, cashrcptmisc_cust_id, -1) AS rcptcust,
		cashrcpt_number, cashrcpt_salescat_id
     FROM cashrcpt
     LEFT OUTER JOIN cashrcptitem ON (cashrcpt_id=cashrcptitem_cashrcpt_id)
     LEFT OUTER JOIN cashrcptmisc ON (cashrcpt_id=cashrcptmisc_cashrcpt_id)
     WHERE cashrcpt_id = pCashrcptid
  LOOP

  IF (_cashcust.rcptcust IS NULL) THEN
    RAISE EXCEPTION 'Cash Receipt % is assigned to a Customer Group but no allocations have been made.  Please fully allocate this Cash Receipt before posting.', _cashcust.cashrcpt_number;
  END IF;

  SELECT salescat_ar_accnt_id INTO _arAccntid
  FROM salescat
  WHERE _cashcust.cashrcpt_salescat_id = salescat_id;
  IF COALESCE(_arAccntid, -1) < 0 THEN
	_arAccntid := findArAccount(_cashcust.rcptcust);
    IF COALESCE(_arAccntid, -1) < 0 THEN
      RETURN -5;
    END IF;
  END IF;

  SELECT _cashcust.rcptcust AS cashrcpt_cust_id,
         CASE WHEN (COALESCE(cashrcpt_cust_id,0) > 0)
		      THEN (cust_number||'-'||cust_name)
	          ELSE (SELECT custgrp_name||'-'||custgrp_descrip FROM custgrp WHERE custgrp_id = cashrcpt_custgrp_id)
         END AS custnote,
         COALESCE(cashrcpt_custgrp_id, 0) as groupid,
         cashrcpt_fundstype, cashrcpt_number, cashrcpt_docnumber,
         cashrcpt_distdate, cashrcpt_amount, cashrcpt_discount,
         (cashrcpt_amount / cashrcpt_curr_rate) AS cashrcpt_amount_base,
	 (cashrcpt_discount / cashrcpt_curr_rate) AS cashrcpt_discount_base,
         cashrcpt_notes, cashrcpt_alt_curr_rate,
         cashrcpt_bankaccnt_id AS bankaccnt_id,
         findPrepaidAccount(_cashcust.rcptcust) AS prepaid_accnt_id,
         cashrcpt_usecustdeposit,
         COALESCE(cashrcpt_applydate, cashrcpt_distdate) AS applydate,
	          cashrcpt_curr_id, cashrcpt_curr_rate, cashrcpt_posted, cashrcpt_void, cashrcpt_prj_id INTO _p
	  FROM cashrcpt
	  LEFT OUTER JOIN cashrcptitem ON cashrcpt_id = cashrcptitem_cashrcpt_id
	  LEFT OUTER JOIN custinfo ON (cashrcpt_cust_id=cust_id)
	 WHERE cashrcpt_id = pCashrcptid
	   AND COALESCE(cashrcptitem_cust_id, _cashcust.rcptcust) = _cashcust.rcptcust;
  IF (NOT FOUND OR COALESCE(_p.prepaid_accnt_id, -1) < 0) THEN
    RETURN -7;
  END IF;

  IF (COALESCE(_p.cashrcpt_distdate > _p.applydate, false)) THEN
    RAISE EXCEPTION 'Cannot post cashrcpt % because application date is before distribution date.', _p.cashrcpt_docnumber;
  END IF;

  IF (COALESCE(_p.cashrcpt_posted, false)) THEN
    RAISE EXCEPTION 'Cannot post cashrcpt % because the document has already been posted.', _p.cashrcpt_docnumber;
  END IF;

  IF (COALESCE(_p.cashrcpt_void, false)) THEN
    RAISE EXCEPTION 'Cannot post cashrcpt % because the document has been voided.', _p.cashrcpt_docnumber;
  END IF;

  _predist := COALESCE(_p.cashrcpt_distdate < _p.applydate, false);

  IF (isPrePayFundsType(_p.cashrcpt_fundstype)) THEN
    SELECT ccpay_id, ccpay_type INTO _ccpayid, _cctype
    FROM ccpay
    WHERE ((ccpay_r_ordernum IN (CAST(pCashrcptid AS TEXT), _p.cashrcpt_docnumber))
       AND (ccpay_status IN ('C', 'A')));

    IF NOT FOUND THEN
      -- the following select seems to work except for xikar - bug 8848. why?
      -- raise warning so there is some visibility if people fall into this path.
      SELECT ccpay_id, ccpay_type INTO _ccpayid, _cctype
      FROM ccpay
      WHERE ((ccpay_order_number IN (CAST(pCashrcptid AS TEXT), _p.cashrcpt_docnumber))
         AND (ccpay_status IN ('C', 'A')));
      IF (NOT FOUND) THEN
        RETURN -8;
      ELSE
        RAISE WARNING 'PostCashReceipt() found ccpay_id % for order number %/% (ref 8848).',
                      _ccpayid, pCashrcptid, _p.cashrcpt_docnumber;
      END IF;
    END IF;

-- If there is a ccpay entry and the card was charged directly, use the prepaid account
    IF (_cctype = 'C' ) THEN
      _debitAccntid := findPrepaidAccount(_p.cashrcpt_cust_id);
-- If there is a ccpay entry and the card was preauthed and then charged, use the Bank account
    ELSE
      SELECT accnt_id INTO _debitAccntid
      FROM cashrcpt, bankaccnt, accnt
      WHERE ( (cashrcpt_bankaccnt_id=bankaccnt_id)
       AND (bankaccnt_accnt_id=accnt_id)
       AND (cashrcpt_id=pCashrcptid) );
      IF (NOT FOUND) THEN
        RETURN -6;
      END IF;
    END IF;
  ELSE
    SELECT accnt_id INTO _debitAccntid
    FROM cashrcpt, bankaccnt, accnt
    WHERE ( (cashrcpt_bankaccnt_id=bankaccnt_id)
     AND (bankaccnt_accnt_id=accnt_id)
     AND (cashrcpt_id=pCashrcptid) );
    IF (NOT FOUND) THEN
      RETURN -6;
    END IF;
  END IF;

--  Determine the amount to post to A/R Open Items
  SELECT COALESCE(SUM(cashrcptitem_amount), 0) INTO _postToAR
  FROM cashrcptitem JOIN aropen ON (aropen_id=cashrcptitem_aropen_id)
  WHERE (cashrcptitem_cashrcpt_id=pCashrcptid);
  IF (NOT FOUND) THEN
    _postToAR := 0;
  END IF;

--  Determine the amount to post to Misc. Distributions
  SELECT COALESCE(SUM(cashrcptmisc_amount), 0) INTO _postToMisc
  FROM cashrcptmisc
  WHERE (cashrcptmisc_cashrcpt_id=pCashrcptid);
  IF (NOT FOUND) THEN
    _postToMisc := 0;
  END IF;

--  Determine the amount to post to Discount Credit Memo
  SELECT COALESCE(SUM(cashrcptitem_discount), 0) INTO _postToCM
  FROM cashrcptitem JOIN aropen ON ( (aropen_id=cashrcptitem_aropen_id) AND (aropen_doctype IN ('I', 'D')) )
  WHERE (cashrcptitem_cashrcpt_id=pCashrcptid);
  IF (NOT FOUND) THEN
    _postToCM := 0;
  END IF;

--  Check to see if the C/R is over applied
  IF ((_postToAR + _postToMisc) > _p.cashrcpt_amount) THEN
    RETURN -1;
  END IF;

--  Check to see if the C/R is positive amount
  IF (_p.cashrcpt_amount <= 0) THEN
    RETURN -2;
  END IF;

--  Distribute A/R Applications
    FOR _r IN SELECT aropen_id, aropen_doctype, aropen_docnumber, aropen_docdate,
                     aropen_duedate, aropen_curr_id, aropen_curr_rate, aropen_amount,
                     round(aropen_amount - aropen_paid, 2) <=
                        round(currToCurr(_p.cashrcpt_curr_id, aropen_curr_id,abs(cashrcptitem_amount + cashrcptitem_discount),_p.cashrcpt_distdate),2)
                                 AS closed,
                     cashrcptitem_id, cashrcptitem_amount, cashrcptitem_discount,
                     (cashrcptitem_amount / _p.cashrcpt_curr_rate) AS cashrcptitem_amount_base,
		     (cashrcptitem_discount / _p.cashrcpt_curr_rate) AS cashrcptitem_discount_base,
                     round(aropen_paid +
                       currToCurr(_p.cashrcpt_curr_id, aropen_curr_id,abs(cashrcptitem_amount),_p.cashrcpt_distdate),2) AS new_paid,
                     round(currToCurr(_p.cashrcpt_curr_id, aropen_curr_id,cashrcptitem_discount,_p.cashrcpt_distdate),2) AS new_discount
              FROM cashrcptitem JOIN aropen ON (aropen_id=cashrcptitem_aropen_id)
              WHERE ((cashrcptitem_cashrcpt_id=pCashrcptid)
	       AND (cashrcptitem_cust_id=_p.cashrcpt_cust_id)
               AND (NOT _predist OR aropen_doctype IN ('C','R'))) LOOP

  --  Handle discount
      IF (_r.cashrcptitem_discount_base > 0) THEN
        PERFORM postCashReceiptDisc(_r.cashrcptitem_id, pJournalNumber);
      END IF;

  --  Update the aropen item to post the paid amount
      UPDATE aropen
      SET aropen_paid = _r.new_paid + _r.new_discount,
          aropen_open = (NOT _r.closed),
          aropen_closedate = CASE WHEN _r.closed THEN _p.cashrcpt_distdate END
      WHERE (aropen_id=_r.aropen_id);

  --  Cache the running amount posted
      _posted_base := _posted_base + _r.cashrcptitem_amount_base;
      _posted := _posted + _r.cashrcptitem_amount;

  --  Record the cashrcpt application
    IF (_r.aropen_doctype IN ('I','D')) THEN
      INSERT INTO arapply
      ( arapply_cust_id,
        arapply_source_aropen_id, arapply_source_doctype, arapply_source_docnumber,
        arapply_target_aropen_id, arapply_target_doctype, arapply_target_docnumber,
        arapply_fundstype, arapply_refnumber, arapply_reftype, arapply_ref_id,
        arapply_applied, arapply_closed,
        arapply_postdate, arapply_distdate, arapply_journalnumber, arapply_username,
        arapply_curr_id )
      VALUES
      ( _p.cashrcpt_cust_id,
        -1, 'K', _p.cashrcpt_number,
        _r.aropen_id, _r.aropen_doctype, _r.aropen_docnumber,
        _p.cashrcpt_fundstype, _p.cashrcpt_docnumber, 'CRA', _r.cashrcptitem_id,
        round(_r.cashrcptitem_amount, 2), _r.closed,
        _p.applydate, _p.cashrcpt_distdate, pJournalNumber, getEffectiveXtUser(), _p.cashrcpt_curr_id);
    ELSE
      INSERT INTO arapply
      ( arapply_cust_id,
        arapply_source_aropen_id, arapply_source_doctype, arapply_source_docnumber,
        arapply_target_aropen_id, arapply_target_doctype, arapply_target_docnumber,
        arapply_fundstype, arapply_refnumber, arapply_reftype, arapply_ref_id,
        arapply_applied, arapply_closed, arapply_postdate, arapply_distdate,
        arapply_journalnumber, arapply_username, arapply_curr_id )
      VALUES
      ( _p.cashrcpt_cust_id,
        _r.aropen_id, _r.aropen_doctype, _r.aropen_docnumber,
        -1, 'R', _p.cashrcpt_number,
        '', '', 'CRA', _r.cashrcptitem_id,
        round(abs(_r.cashrcptitem_amount), 2), _r.closed,
        _p.applydate, _p.cashrcpt_distdate, pJournalNumber, getEffectiveXtUser(), _p.cashrcpt_curr_id );
    END IF;

      _exchGain := arCurrGain(_r.aropen_id,_p.cashrcpt_curr_id, abs(_r.cashrcptitem_amount),
                             _p.cashrcpt_distdate);

       PERFORM insertIntoGLSeries( _sequence, 'A/R', 'CR',
                          (_r.aropen_doctype || '-' || _r.aropen_docnumber),
                          CASE WHEN _r.aropen_doctype != 'R' THEN getPrjAccntId(_p.cashrcpt_prj_id, _arAccntid)
                          ELSE getPrjAccntId(_p.cashrcpt_prj_id, findDeferredAccount(_p.cashrcpt_cust_id)) END,
                          round(_r.cashrcptitem_amount_base + _exchGain, 2),
                          _p.cashrcpt_distdate, _p.custnote, pCashrcptid );

      IF (_exchGain <> 0) THEN
          PERFORM insertIntoGLSeries(_sequence, 'A/R', 'CR',
                 _r.aropen_doctype || '-' || _r.aropen_docnumber,
                 getGainLossAccntId(
                   CASE WHEN _r.aropen_doctype != 'R' THEN getPrjAccntId(_p.cashrcpt_prj_id, _arAccntid)
                   ELSE getPrjAccntId(_p.cashrcpt_prj_id, findDeferredAccount(_p.cashrcpt_cust_id)) END
                 ), round(_exchGain, 2) * -1,
                 _p.cashrcpt_distdate, _p.custnote, pCashrcptid);
      END IF;

    END LOOP; -- AR Applications loop

  END LOOP; -- Cash Receipt Customer/Group Loop

--  Distribute Misc. Applications
  FOR _r IN SELECT cashrcptmisc_id, cashrcptmisc_accnt_id, cashrcptmisc_amount,
                   (cashrcptmisc_amount / cashrcpt_curr_rate) AS cashrcptmisc_amount_base,
                   cashrcptmisc_tax_id,
                   cashrcptmisc_notes, cashrcpt_curr_id,
                   CASE WHEN (COALESCE(cashrcptmisc_cust_id, 0) >0) THEN cashrcptmisc_cust_id
                     ELSE cashrcpt_cust_id
                   END AS cust_id,
                   CASE WHEN (COALESCE(cashrcptmisc_cust_id,0) > 0) THEN
			(SELECT cust_number||'-'||cust_name FROM custinfo WHERE cust_id=cashrcptmisc_cust_id)
		     ELSE (SELECT cust_number||'-'||cust_name FROM custinfo WHERE cust_id=cashrcpt_cust_id)
		   END AS custnote
            FROM cashrcptmisc JOIN
                 cashrcpt ON (cashrcptmisc_cashrcpt_id = cashrcpt_id)
            WHERE (cashrcptmisc_cashrcpt_id=pCashrcptid)  LOOP

--  Cache the running amount posted
    _posted_base := (_posted_base + _r.cashrcptmisc_amount_base);
    _posted := (_posted + _r.cashrcptmisc_amount);

--  Record the cashrcpt application
    INSERT INTO arapply
    ( arapply_cust_id,
      arapply_source_aropen_id, arapply_source_doctype, arapply_source_docnumber,
      arapply_target_aropen_id, arapply_target_doctype, arapply_target_docnumber,
      arapply_fundstype, arapply_refnumber,
      arapply_applied, arapply_closed,
      arapply_postdate, arapply_distdate, arapply_journalnumber, arapply_username,
      arapply_curr_id, arapply_reftype, arapply_ref_id )
    VALUES
    ( _p.cashrcpt_cust_id,
      -1, 'K', '',
      -1, 'Misc.', '',
      _p.cashrcpt_fundstype, _p.cashrcpt_docnumber,
      round(_r.cashrcptmisc_amount, 2), TRUE,
      _p.applydate, _p.cashrcpt_distdate, pJournalNumber, getEffectiveXtUser(),
      _r.cashrcpt_curr_id, 'CRD', _r.cashrcptmisc_id );
    IF (COALESCE(_r.cashrcptmisc_tax_id, -1) < 0 ) THEN
--  Standard Misc. Distribution
      PERFORM insertIntoGLSeries( _sequence, 'A/R', 'CR', _r.cashrcptmisc_notes,
                                getPrjAccntId(_p.cashrcpt_prj_id, _r.cashrcptmisc_accnt_id),
                                round(_r.cashrcptmisc_amount_base, 2),
                                _p.cashrcpt_distdate, _p.custnote, pCashrcptid );
    ELSE
--  Misc Tax Distribution, record in taxhist
      INSERT INTO cashrcpttax (taxhist_basis,taxhist_percent,taxhist_amount,taxhist_docdate, taxhist_tax_id, taxhist_tax,
                                taxhist_taxtype_id, taxhist_parent_id, taxhist_journalnumber )
          VALUES (0, 0, 0, _p.cashrcpt_distdate, _r.cashrcptmisc_tax_id, _r.cashrcptmisc_amount_base,
                          getadjustmenttaxtypeid(), pcashrcptid, pjournalnumber);

      PERFORM addTaxToGLSeries(_sequence, 'A/R'::TEXT, 'CR'::TEXT, _p.cashrcpt_number,
		       _p.cashrcpt_curr_id, _p.cashrcpt_distdate, _p.cashrcpt_distdate,
                      'cashrcpttax'::TEXT, pcashrcptid,_p.custnote);
    END IF;
  END LOOP;

--  Post any remaining Cash to an A/R Cash Deposit (Credit Memo)
--  this credit memo may absorb an occasional currency exchange rounding error
  IF (round(_posted_base, 2) < round(_p.cashrcpt_amount_base, 2)) THEN

--  Prevent Posting of unapplied amounts on receipts against a customer group
--  This is due to not being able to create customer documents as we cannot determine the customer id
    IF (_p.groupid > 0) THEN
      RAISE EXCEPTION 'Cannot post Receipt % as there is an outstanding amount of %. Please add a miscellanous distribution to assign this amount to a customer',
             _p.cashrcpt_docnumber, (round(_p.cashrcpt_amount_base, 2)-round(_posted_base, 2));
    END IF;

    _comment := ('Unapplied from ' || _p.cashrcpt_fundstype || '-' || _p.cashrcpt_docnumber);
    PERFORM insertIntoGLSeries( _sequence, 'A/R', 'CR',
                                _comment,
                                getPrjAccntId(_p.cashrcpt_prj_id, _p.prepaid_accnt_id),
                                round(_p.cashrcpt_amount_base, 2) -
                                                        round(_posted_base, 2),
                                _p.cashrcpt_distdate, _p.custnote, pCashrcptid );
    SELECT fetchArMemoNumber() INTO _arMemoNumber;
    IF(_p.cashrcpt_usecustdeposit) THEN
      -- Post Customer Deposit
      _aropenid := createARCashDeposit(_p.cashrcpt_cust_id, _arMemoNumber, '',
                                 _p.cashrcpt_distdate, (_p.cashrcpt_amount - _posted),
                                 _comment, pJournalNumber, _p.cashrcpt_curr_id);
    ELSE
      -- Post A/R Credit Memo
      _aropenid := createARCreditMemo(NULL, _p.cashrcpt_cust_id, _arMemoNumber, '',
                                _p.cashrcpt_distdate, (_p.cashrcpt_amount - _posted),
                                _comment, -1, -1, -1, _p.cashrcpt_distdate, -1, NULL, 0,
                                pJournalNumber, _p.cashrcpt_curr_id, _arAccntid);
    END IF;

    IF (_ccpayid IS NOT NULL) THEN
      INSERT INTO payaropen (payaropen_ccpay_id, payaropen_aropen_id,
                             payaropen_amount,   payaropen_curr_id
                   ) VALUES (_ccpayid,           _aropenid,
                             _p.cashrcpt_amount, _p.cashrcpt_curr_id);
    END IF;

    -- Create Cash Receipt Item to capture posting
    IF (_predist=false) THEN
      INSERT INTO cashrcptitem
        ( cashrcptitem_cashrcpt_id, cashrcptitem_aropen_id, cashrcptitem_amount, cashrcptitem_applied )
      VALUES
        ( pCashrcptid, _aropenid, (_p.cashrcpt_amount - _posted), false );
    END IF;

  ELSIF (round(_posted_base, 2) > round((_p.cashrcpt_amount_base), 2)) THEN

--  Prevent Posting of currency rounding amounts on receipts against a customer group
--  This is due to not being able to create customer documents as we cannot determine the customer id
    IF (_p.groupid > 0) THEN
      RAISE EXCEPTION 'Cannot post Receipt % as there is an currency rounding error of %. Please add a miscellanous distribution to assign this amount to a customer',
             _p.cashrcpt_docnumber, abs(round(_p.cashrcpt_amount_base, 2)-round(_posted_base, 2));
    END IF;

    PERFORM insertIntoGLSeries(_sequence, 'A/R', 'CR',
                   'Currency Exchange Rounding - ' || _p.cashrcpt_docnumber,
                   getPrjAccntId(_p.cashrcpt_prj_id, getGainLossAccntId(_debitAccntid)),
                   round(_posted_base, 2) - round((_p.cashrcpt_amount_base + _p.cashrcpt_discount_base), 2),
                   _p.cashrcpt_distdate, _p.custnote, pCashrcptid);
  END IF;

--  Debit Cash
  PERFORM insertIntoGLSeries( _sequence, 'A/R', 'CR',
                    (_p.cashrcpt_fundstype || '-' || _p.cashrcpt_docnumber),
                     getPrjAccntId(_p.cashrcpt_prj_id, _debitAccntid), round(_p.cashrcpt_amount_base, 2) * -1,
                     _p.cashrcpt_distdate,
                     _p.custnote, pCashrcptid );

  PERFORM postGLSeries(_sequence, pJournalNumber);

  -- Post any gain/loss from the alternate currency exchange rate
  IF (COALESCE(_p.cashrcpt_alt_curr_rate, 0.0) <> 0.0) THEN
    _exchGain := ROUND((_p.cashrcpt_amount / _p.cashrcpt_alt_curr_rate) -
                       (_p.cashrcpt_amount / _p.cashrcpt_curr_rate), 2);

    IF (_exchGain <> 0) THEN
      PERFORM insertIntoGLSeries( _sequence, 'A/R', 'CR',
                          (_p.cashrcpt_fundstype || '-' || _p.cashrcpt_docnumber),
                          getPrjAccntId(_p.cashrcpt_prj_id, _debitAccntid), (_exchGain * -1.0),
                          _p.cashrcpt_distdate, _p.custnote, pCashrcptid );

      PERFORM insertIntoGLSeries( _sequence, 'A/R', 'CR',
                          (_p.cashrcpt_fundstype || '-' || _p.cashrcpt_docnumber),
                          getPrjAccntId(_p.cashrcpt_prj_id, getGainLossAccntId(_debitAccntid)), _exchGain,
                          _p.cashrcpt_distdate, _p.custnote, pCashrcptid );
    END IF;
  END IF;
  -- convert the cashrcptitem records to applications against the cm/cd if we are _predist
  IF(_predist=true) THEN
    FOR _r IN SELECT *
              FROM cashrcptitem
              WHERE ((cashrcptitem_cashrcpt_id=pCashrcptid)
                AND (cashrcptitem_amount > 0)) LOOP

      -- Handle discount if applicable
      IF (_r.cashrcptitem_discount > 0) THEN
        PERFORM postCashReceiptDisc(_r.cashrcptitem_id, pJournalNumber);
      END IF;

      INSERT INTO arcreditapply (arcreditapply_source_aropen_id, arcreditapply_target_aropen_id,
                                 arcreditapply_amount, arcreditapply_curr_id)
                          VALUES(_aropenid, _r.cashrcptitem_aropen_id,
                                 _r.cashrcptitem_amount, _p.cashrcpt_curr_id);
      _posted := (_posted + _r.cashrcptitem_amount);

    END LOOP;

    PERFORM postArCreditMemoApplication(_aropenid, _p.applydate);

    -- If there is any left over go ahead and create an additional cashrcptitem record for it with the amount
    IF (round(_posted, 2) < round(_p.cashrcpt_amount, 2)) THEN
      INSERT INTO cashrcptitem
        ( cashrcptitem_cashrcpt_id, cashrcptitem_aropen_id, cashrcptitem_amount, cashrcptitem_applied )
      VALUES
        ( pCashrcptid, _aropenid, (_p.cashrcpt_amount - _posted), false );
    END IF;
  END IF;

--  Update the posted cashrcpt
  UPDATE cashrcpt SET cashrcpt_posted=TRUE,
                      cashrcpt_posteddate=CURRENT_DATE,
                      cashrcpt_postedby=getEffectiveXtUser()
  WHERE (cashrcpt_id=pCashrcptid);

  RETURN 1;

END;
$$ LANGUAGE plpgsql;
