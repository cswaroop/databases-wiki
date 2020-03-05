
CREATE OR REPLACE FUNCTION validateItemsrcQty(pItemsrcid INTEGER,
                                              pQty NUMERIC) RETURNS NUMERIC AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _p RECORD;
  _qty NUMERIC;

BEGIN

  _qty := pQty;

  SELECT COALESCE(itemsrc_minordqty, 1.0) AS minordqty,
         COALESCE(itemsrc_multordqty, 1.0) AS multordqty,
         item_fractional, item_type INTO _p
  FROM itemsrc JOIN item ON (item_id=itemsrc_item_id)
  WHERE (itemsrc_id=pItemsrcid);

  IF (_qty < _p.minordqty) THEN
    _qty := _p.minordqty;
  END IF;

  IF ( (_p.multordqty > 0) AND ((_qty % _p.multordqty) > 0) ) THEN
    _qty := ((TRUNC(_qty / _p.multordqty) * _p.multordqty) + _p.multordqty);
  END IF;

  _qty := roundQty(_p.item_fractional, _qty);

  RETURN _qty;

END;
$$ LANGUAGE plpgsql;

