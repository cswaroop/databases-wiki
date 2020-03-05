CREATE OR REPLACE FUNCTION qtyAtShipping(plineitemid INTEGER) RETURNS NUMERIC AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  RETURN qtyAtShipping('SO', plineitemid);
END;
$$ LANGUAGE plpgsql STABLE;

CREATE OR REPLACE FUNCTION qtyAtShipping(pordertype TEXT,
                                         plineitemid INTEGER) RETURNS NUMERIC AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  RETURN qtyAtShipping(pordertype, plineitemid, 'U');
END;
$$ LANGUAGE plpgsql STABLE;

CREATE OR REPLACE FUNCTION qtyAtShipping(pordertype TEXT,
                                         plineitemid INTEGER,
                                         pstatus TEXT) RETURNS NUMERIC AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _qty         NUMERIC  := 0.0;

BEGIN

-- pstatus U=unshipped
--         S=shipped
--         B=both unshipped and shipped

  IF (pordertype NOT IN ('SO', 'TO')) THEN
    RAISE EXCEPTION '% is not a valid order type', pordertype;
  END IF;

  IF (pstatus NOT IN ('U', 'S', 'B')) THEN
    RAISE EXCEPTION '% is not a valid status', pstatus;
  END IF;

  SELECT COALESCE(SUM(shipitem_qty), 0.0) INTO _qty
  FROM shipitem, shiphead
  WHERE ((shipitem_shiphead_id=shiphead_id)
    AND  (shiphead_order_type=pordertype)
    AND  (shipitem_orderitem_id=plineitemid)
    AND  (((shiphead_shipped) AND (pstatus IN ('S', 'B'))) OR ((NOT shiphead_shipped) AND (pstatus IN ('U', 'B'))))  );

  RETURN COALESCE(_qty, 0.0);

END;
$$ LANGUAGE plpgsql STABLE;
