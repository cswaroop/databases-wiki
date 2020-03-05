CREATE OR REPLACE FUNCTION createFiscalYear(pStartDate DATE DEFAULT NULL, pStyle TEXT DEFAULT 'M')
  RETURNS INTEGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _current   DATE;
  _next      DATE;
  _increment INTERVAL;
  _ap        INTEGER;
  _quarter   INTEGER;
  _yp        INTEGER;
BEGIN
  pStartDate := COALESCE(pStartDate, date_trunc('year', current_timestamp)::DATE);
  _current = pStartDate;

  SELECT yearperiod_id INTO _yp FROM yearperiod
   WHERE _current BETWEEN yearperiod_start AND yearperiod_end;
  IF _yp IS NULL THEN
    _yp := createAccountingYearPeriod(_current,
                     (_current + INTERVAL '1 year' - INTERVAL '1 day')::DATE);
  END IF;
  
  IF pStyle = 'M' THEN
    _increment := INTERVAL '1 month';
  ELSIF pStyle = 'Q' THEN
    _increment := INTERVAL '3 month';
  ELSE
    RAISE EXCEPTION 'Cannot create a fiscal year with style % [xtuple: createFiscalYear, -1, %, %]',
                    pStyle, pStartDate, pStyle;
  END IF;

  WHILE _current < pStartDate + INTERVAL '1 year' LOOP
    _next := _current + _increment;
    _quarter := EXTRACT(QUARTER FROM ('2000-01-01'::DATE + (_current - pStartDate + 1) * INTERVAL '1 day'));
    _ap   := createAccountingPeriod(_current, (_next - interval '1 day')::DATE, _yp, _quarter);
    _current := _next;
  END LOOP;

  RETURN _yp;
END
$$ language plpgsql;
