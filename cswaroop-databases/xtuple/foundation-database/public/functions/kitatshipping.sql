CREATE OR REPLACE FUNCTION kitAtShipping(plineitemid INTEGER) RETURNS NUMERIC AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _coheadid    INTEGER;
  _linenumber  INTEGER;
  _qty         NUMERIC  := 0.0;

BEGIN
  -- kit components that have been issued to shipping
  SELECT coitem_cohead_id, coitem_linenumber INTO _coheadid, _linenumber
  FROM coitem
  WHERE (coitem_id=plineitemid);

  SELECT COALESCE(SUM(qtyAtShipping('SO', coitem_id, 'U')), 0.0) INTO _qty
  FROM coitem
  WHERE (coitem_cohead_id=_coheadid)
    AND (coitem_linenumber=_linenumber)
    AND (coitem_id != plineitemid);

  RETURN COALESCE(_qty, 0.0);

END;
$$ LANGUAGE plpgsql STABLE;
