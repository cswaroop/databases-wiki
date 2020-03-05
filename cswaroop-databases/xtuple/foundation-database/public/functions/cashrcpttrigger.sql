CREATE OR REPLACE FUNCTION _cashrcpttrigger()
  RETURNS trigger AS
$BODY$
-- Copyright (c) 1999-2011 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _check      BOOLEAN;
  _checkId    INTEGER;
  _currId     INTEGER;
  _bankCurrId INTEGER;
  _evntType   TEXT;
  _whsId      INTEGER;
  _custNumber TEXT;
  _currrate   NUMERIC;

BEGIN

  -- Checks
  -- Start with privileges
  IF (TG_OP = 'INSERT') THEN
    SELECT checkPrivilege('MaintainCashReceipts') INTO _check;
    IF NOT (_check) THEN
      RAISE EXCEPTION 'You do not have privileges to add new Cash Receipts.';
    END IF;
  ELSE
    SELECT checkPrivilege('MaintainCashReceipts') INTO _check;
    IF NOT (_check) THEN
      RAISE EXCEPTION 'You do not have privileges to alter a Cash Receipt.';
    END IF;
  END IF;

  -- Currency must be same as Bank Currency
  IF (TG_OP = 'INSERT') THEN
    _currId = COALESCE(NEW.cashrcpt_curr_id, basecurrid());
  ELSE
    _currId = NEW.cashrcpt_curr_id;
  END IF;

-- get the base exchange rate for the dist date
  SELECT curr_rate INTO _currrate
  FROM curr_rate
  WHERE ( (NEW.cashrcpt_curr_id=curr_id)
    AND ( NEW.cashrcpt_distdate BETWEEN curr_effective 
                                 AND curr_expires) );
  IF (FOUND) THEN
    NEW.cashrcpt_curr_rate := _currrate;
  ELSE
    RAISE EXCEPTION 'Currency exchange rate not found';
  END IF;

  -- Sort out Customer versus Customer Group
  IF  ((TG_OP = 'INSERT' OR TG_OP = 'UPDATE') AND NEW.cashrcpt_cust_id = -1) THEN
      NEW.cashrcpt_cust_id = NULL;
  END IF;
      
  -- Create CashReceiptPosted Event
  IF (TG_OP = 'UPDATE') THEN
    IF (OLD.cashrcpt_posted=FALSE AND NEW.cashrcpt_posted=TRUE) THEN
      _evntType = 'CashReceiptPosted';
      -- Find the warehouse for which to create evntlog entries
      SELECT usrpref_value  INTO _whsId
      FROM usrpref
      WHERE usrpref_username = getEffectiveXtUser()
        AND usrpref_name = 'PreferredWarehouse';
      -- Find the Customer Number
      SELECT cust_number INTO _custNumber
      FROM custinfo
      WHERE (cust_id=NEW.cashrcpt_cust_id);

      INSERT INTO evntlog (evntlog_evnttime, evntlog_username, evntlog_evnttype_id,
                           evntlog_ord_id, evntlog_warehous_id, evntlog_number)
      SELECT DISTINCT CURRENT_TIMESTAMP, evntnot_username, evnttype_id,
                      NEW.cashrcpt_id, _whsId,
                     (_custNumber || '-' || NEW.cashrcpt_docnumber || ' ' || currConcat(NEW.cashrcpt_curr_id) || formatMoney(NEW.cashrcpt_amount))
      FROM evntnot, evnttype
      WHERE ((evntnot_evnttype_id=evnttype_id)
        AND  (evnttype_name=_evntType));
    END IF;
  END IF;

  RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql;
