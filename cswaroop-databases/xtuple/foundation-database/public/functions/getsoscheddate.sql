CREATE OR REPLACE FUNCTION getSoSchedDate(INTEGER) RETURNS DATE AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pCoheadid ALIAS FOR $1;
  _minscheddate DATE;

BEGIN

  SELECT MIN(coitem_scheddate) INTO _minscheddate
  FROM cohead
  JOIN coitem ON (coitem_cohead_id=pCoheadid)
  WHERE true
    AND cohead_id=pCoheadid
    AND CASE WHEN (cohead_status='C')
      THEN coitem_status != 'X'
      ELSE coitem_status NOT IN ('C','X')
    END;

  RETURN _minscheddate;

END;
$$ LANGUAGE 'plpgsql';
