CREATE OR REPLACE FUNCTION copyaccountingyearperiod(pyearperiodid integer)
  RETURNS integer AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _newYear 	INTEGER;
  _r 		RECORD;
BEGIN

  -- First create new fiscal year
  INSERT INTO yearperiod (yearperiod_start, yearperiod_end, yearperiod_closed)
    SELECT yearperiod_start + INTERVAL ' 1 year',  yearperiod_end + INTERVAL ' 1 year', FALSE
      FROM yearperiod
      WHERE yearperiod_id = pYearPeriodid
  RETURNING yearperiod_id INTO _newYear;

  IF (NOT COALESCE(_newYear, -1) > 0) THEN
    RAISE EXCEPTION 'An error occurred creating the Fiscal Year [xtuple: copyaccountingyearperiod, -1]';
  END IF;

-- Copy corresponding fiscal periods across to the new fiscal year
  INSERT INTO period (period_start, period_end,
                      period_closed, period_freeze, period_initial,
                      period_name,
                      period_yearperiod_id, period_quarter, period_number)
    SELECT (period_start + INTERVAL '1 year')::date, (period_end + INTERVAL '1 year')::date,
                      FALSE, FALSE, FALSE,
                      EXTRACT(year FROM period_start + INTERVAL '1 year') || '-' || to_char((period_start + INTERVAL '1 year'), 'Mon'),
                      _newYear, period_quarter, period_number
    FROM period
    WHERE (period_yearperiod_id = pYearPeriodid);

--  Forward Update Accounting Periods for all G/L Accounts
  FOR _r IN
    SELECT DISTINCT ON (trialbal_accnt_id) trialbal_id
    FROM trialbal
    JOIN period ON (period_id=trialbal_period_id)
    ORDER BY trialbal_accnt_id, period_end DESC
  LOOP
    PERFORM forwardupdatetrialbalance(_r.trialbal_id);
  END LOOP;

  RETURN _newYear;

END;
$$ LANGUAGE plpgsql;
