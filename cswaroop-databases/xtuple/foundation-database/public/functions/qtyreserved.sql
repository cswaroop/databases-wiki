CREATE OR REPLACE FUNCTION qtyReserved(pItemsiteid INTEGER) RETURNS NUMERIC AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/EULA for the full text of the software license.
DECLARE
  _qty NUMERIC;

BEGIN

  SELECT COALESCE(SUM(coitem_qtyreserved),0) INTO _qty
    FROM coitem
   WHERE(coitem_itemsite_id=pItemsiteid);

  RETURN _qty;
END;
$$ LANGUAGE plpgsql;
