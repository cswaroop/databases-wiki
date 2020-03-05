CREATE OR REPLACE FUNCTION _cashRcptMiscTrigger () RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _check      BOOLEAN;
  _taxaccnt   INTEGER;
BEGIN

  -- Checks
  -- Start with Privileges
  IF (TG_OP = 'INSERT') THEN
    SELECT checkPrivilege('MaintainCashReceipts') INTO _check;
    IF NOT (_check) THEN
      RAISE EXCEPTION 'You do not have privileges to add a new Cash Receipt Misc. Application. [xtuple: cashRcptMiscTrigger, -1]';
    END IF;
  ELSE
    SELECT checkPrivilege('MaintainCashReceipts') INTO _check;
    IF NOT (_check) THEN
      RAISE EXCEPTION 'You do not have privileges to alter a Cash Receipt Misc. Application. [xtuple: cashRcptMiscTrigger, -1]';
    END IF;
  END IF;

-- If a Tax Code is used, determine the relevant GL account to make things simpler later
  IF (NEW.cashrcptmisc_tax_id IS NOT NULL) THEN
    _taxaccnt := COALESCE((SELECT tax_sales_accnt_id FROM tax WHERE tax_id=NEW.cashrcptmisc_tax_id), -1);
    IF (_taxaccnt > 0) THEN
      NEW.cashrcptmisc_accnt_id = _taxaccnt;
    END IF;
  END IF;

  -- Account is required
  IF (NEW.cashrcptmisc_accnt_id IS NULL) THEN
    RAISE EXCEPTION 'You must supply a valid GL Account or Tax Code. [xtuple: cashRcptMiscTrigger, -2';
  END IF;

  -- Amount is required
  IF (COALESCE(NEW.cashrcptmisc_amount, 0) = 0) THEN
    RAISE EXCEPTION 'You must supply a valid Amount. [xtuple: cashRcptMiscTrigger, -3]';
  END IF;

  RETURN NEW;

END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'cashRcptMiscTrigger');
CREATE TRIGGER cashRcptMiscTrigger BEFORE INSERT OR UPDATE ON cashrcptmisc FOR EACH ROW EXECUTE PROCEDURE _cashRcptMiscTrigger();
