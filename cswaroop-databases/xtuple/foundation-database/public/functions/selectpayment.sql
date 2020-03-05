
CREATE OR REPLACE FUNCTION selectPayment(pApopenid INTEGER,
                                         pBankaccntid INTEGER) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _p RECORD;
  _amount NUMERIC;
  _discount NUMERIC;

BEGIN

  SELECT apopen_amount, apopen_paid,
         apopen_doctype, apopen_docdate,
         apopen_curr_id,
         apopen_amount - apopen_paid - apCheckPending(apopen_id) AS balance,
         noNeg(COALESCE(apopen_discountable_amount, 0) *
               CASE WHEN (CURRENT_DATE <= determineDiscountDate(apopen_terms_id, apopen_docdate)) THEN terms_discprcnt
                    ELSE 0.0 END - discount_applied) AS discount_available
    INTO _p
    FROM apopen LEFT OUTER JOIN terms ON (apopen_terms_id=terms_id),
         (SELECT COALESCE(SUM(apapply_amount),0) AS discount_applied
            FROM apapply, apopen
           WHERE((apapply_target_apopen_id=pApopenid)
             AND (apapply_source_apopen_id=apopen_id)
             AND (apopen_discount)) ) AS data
   WHERE(apopen_id=pApopenid);

  IF(NOT FOUND OR (NOT _p.apopen_doctype IN ('V','D','C'))) THEN
    RAISE EXCEPTION 'Apopen not found or invalid document type [xtuple: selectPayment, -1]';
  END IF;

  _discount := round(_p.discount_available, 2);
  _amount := noNeg(round(_p.balance, 2) - _discount);

  RETURN selectPayment(pApopenid, pBankaccntid, _p.apopen_docdate,
                       _p.apopen_curr_id, _amount, _discount);

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION selectPayment(pApopenid INTEGER,
                                         pBankaccntid INTEGER,
                                         pDocDate DATE,
                                         pCurrid INTEGER,
                                         pAmount NUMERIC,
                                         pDiscount NUMERIC) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _p RECORD;
  _bankcompany TEXT;
  _distcompany TEXT;
  _apselectid INTEGER;
  _amount NUMERIC;
  _discount NUMERIC;

BEGIN

  SELECT apopen_amount, apopen_paid,
         apopen_doctype, apopen_docdate,
         apopen_docnumber, apopen_curr_id,
         apopen_amount - apopen_paid - apCheckPending(apopen_id) AS balance
    INTO _p
    FROM apopen
   WHERE(apopen_id=pApopenid);

  IF(NOT FOUND OR (NOT _p.apopen_doctype IN ('V','D','C'))) THEN
    RAISE EXCEPTION 'Apopen not found or invalid document type [xtuple: selectPayment, -1]';
  END IF;

  IF (round(_p.balance,2) < round(pDiscount + pAmount, 2)) THEN
    RAISE EXCEPTION 'Apopen balance less than amount plus discount [xtuple: selectPayment, -2]';
  END IF;

  IF (_p.apopen_doctype = 'V') THEN
    SELECT COALESCE(accnt_company, '') INTO _bankcompany
    FROM bankaccnt JOIN accnt ON (accnt_id=bankaccnt_accnt_id)
    WHERE (bankaccnt_id=pBankaccntid);

    SELECT COALESCE(accnt_company, '') INTO _distcompany
    FROM vohead JOIN vodist ON (vodist_vohead_id=vohead_id)
                JOIN accnt ON (accnt_id=vodist_accnt_id)
    WHERE (vohead_number=_p.apopen_docnumber)
      AND (COALESCE(accnt_company, '') != _bankcompany);

    IF (FOUND) THEN
      RAISE EXCEPTION 'Bank account company does not match Voucher distribution company [xtuple: selectPayment, -3]';
    END IF;

    SELECT COALESCE(accnt_company, '') INTO _distcompany
    FROM vohead JOIN vodist ON (vodist_vohead_id=vohead_id)
                JOIN expcat ON (expcat_id=vodist_expcat_id)
                JOIN accnt ON (accnt_id=expcat_exp_accnt_id)
    WHERE (vohead_number=_p.apopen_docnumber)
      AND (COALESCE(accnt_company, '') != _bankcompany);

    IF (FOUND) THEN
      RAISE EXCEPTION 'Bank account company does not match Voucher distribution company [xtuple: selectPayment, -3]';
    END IF;

  END IF;

  IF (pAmount > 0.0) THEN
    SELECT apselect_id INTO _apselectid
    FROM apselect
    WHERE (apselect_apopen_id=pApopenid);

    IF (FOUND) THEN
      UPDATE apselect
         SET apselect_amount=pAmount,
             apselect_discount=pDiscount,
             apselect_curr_id=pCurrid
       WHERE(apselect_id=_apselectid);
    ELSE
      INSERT INTO apselect
      ( apselect_apopen_id,
        apselect_amount, apselect_discount,
        apselect_bankaccnt_id,
        apselect_curr_id, apselect_date )
      VALUES
      ( pApopenid,
        pAmount, pDiscount,
        pBankaccntid,
        pCurrid, pDocdate )
      RETURNING apselect_id INTO _apselectid;
    END IF;
  ELSE
    _apselectid := 0;
  END IF;
  
  RETURN _apselectid;

END;
$$ LANGUAGE plpgsql;
