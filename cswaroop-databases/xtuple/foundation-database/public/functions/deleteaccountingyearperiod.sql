CREATE OR REPLACE FUNCTION deleteAccountingYearPeriod(pPeriodid INTEGER) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _period INTEGER;
  _result INTEGER;

BEGIN

  IF (SELECT yearperiod_closed
        FROM yearperiod
       WHERE yearperiod_id = pPeriodid) THEN
    RAISE EXCEPTION 'Cannot delete a closed Fiscal Year. [xtuple: deleteAccountingYearPeriod, -1]';
  END IF;

  FOR _period IN SELECT period_id
                   FROM period
                  WHERE period_yearperiod_id = pPeriodid
                  ORDER BY period_start DESC LOOP
    _result := deleteAccountingPeriod(_period);
    IF _result < 0 THEN
      RAISE EXCEPTION 'Cannot delete an Accounting Period. [xtuple: deleteAccountingPeriod, %, %]',
                      _result, _period;
    END IF;
  END LOOP;

  DELETE FROM yearperiod WHERE yearperiod_id = pPeriodid;

  RETURN 1;

END;
$$ LANGUAGE plpgsql;

