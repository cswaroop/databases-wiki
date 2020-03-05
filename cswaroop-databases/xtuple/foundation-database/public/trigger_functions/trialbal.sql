CREATE OR REPLACE FUNCTION _trialbalaltertrigger()
  RETURNS trigger AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _accntid INTEGER[];
BEGIN
  IF (TG_OP='DELETE') THEN
    IF (SELECT period_closed FROM period WHERE period_id=OLD.trialbal_period_id) THEN
      RAISE EXCEPTION 'You may not delete Trial Balance Transactions in closed periods.';
    END IF;

    RETURN OLD;
  END IF;

  IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
    IF (coalesce(fetchMetricValue('GLCompanySize'),0) = 0) THEN
    --  Get the default account number for year end closing
      _accntid := array_append(_accntid, fetchmetricvalue('YearEndEquityAccount')::integer);
    ELSE
    --  Multi-company setup
      _accntid := (SELECT array_agg(company_yearend_accnt_id) FROM company);
    END IF;

    If (NEW.trialbal_accnt_id = ANY(_accntid) OR (NEW.trialbal_beginning = 0.00 AND NEW.trialbal_ending = 0.00)
         OR (NEW.trialbal_beginning = NEW.trialbal_ending)) THEN
    --  Dont check new accounts, accounts that have not changed value, or Retained Earnings account 
    ELSE
      IF (SELECT period_closed FROM period WHERE period_id=NEW.trialbal_period_id) THEN
        RAISE EXCEPTION 'You may not alter Trial Balance records in a closed Period.';
      END IF;
    END IF;
  
    RETURN NEW;
  END IF;

END;
$$   LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'trialbalaltertrigger');
CREATE TRIGGER trialbalaltertrigger BEFORE INSERT OR UPDATE OR DELETE
  ON trialbal FOR EACH ROW EXECUTE PROCEDURE _trialbalaltertrigger();
