CREATE OR REPLACE FUNCTION itemCost(pItemid INTEGER,
                                    pCustid INTEGER,
                                    pShiptoid INTEGER,
                                    pQty NUMERIC,
                                    pQtyUOM INTEGER,
                                    pPriceUOM INTEGER,
                                    pCurrid INTEGER,
                                    pEffective DATE,
                                    pAsOf DATE,
                                    pSiteid INTEGER) RETURNS NUMERIC STABLE AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
--
-- Overload for future costing enhancements
--
BEGIN
  RETURN itemCost(pItemid,
                  pCustid,
                  pShiptoid,
                  pQty,
                  pQtyUOM,
                  pPriceUOM,
                  pCurrid,
                  pEffective,
                  pAsOf,
                  pSiteid,
                  FALSE);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION itemCost(pItemid INTEGER,
                                    pCustid INTEGER,
                                    pShiptoid INTEGER,
                                    pQty NUMERIC,
                                    pQtyUOM INTEGER,
                                    pPriceUOM INTEGER,
                                    pCurrid INTEGER,
                                    pEffective DATE,
                                    pAsOf DATE,
                                    pSiteid INTEGER,
                                    pDropShip BOOLEAN) RETURNS NUMERIC STABLE AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
--
-- Overload for future costing enhancements
--
DECLARE
  _r RECORD;
  _cost NUMERIC := 0.0;
BEGIN
  -- cache item info
  SELECT itemsite_id, item_id, item_type, item_listcost,
         itemInvPriceRat(item_id) AS itempriceinvrat INTO _r
    FROM itemsite
    JOIN item on (itemsite_item_id=item_id)
  WHERE (itemsite_item_id=pItemid)
    AND (itemsite_warehous_id=pSiteid);

  IF (_r.item_type = 'K') THEN
    SELECT SUM(roundQty(itemuomfractionalbyuom(bomitem_item_id, bomitem_uom_id),
                                               (bomitem_qtyfxd + bomitem_qtyper) * (1 + bomitem_scrap))
               * stdCost(bomitem_item_id)) INTO _cost
    FROM bomitem
    WHERE (bomitem_parent_item_id=_r.item_id)
      AND (bomitem_rev_id=getActiveRevid('BOM', _r.item_id))
      AND (pEffective BETWEEN bomitem_effective AND (bomitem_expires - 1));
  ELSIF fetchMetricBool('WholesalePriceCosting') THEN
    _cost := _r.item_listcost / _r.itempriceinvrat;
  ELSE
    _cost := itemcost(_r.itemsite_id);
  END IF;

  RETURN _cost;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION itemCost(pItemsiteid INTEGER) RETURNS NUMERIC STABLE AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _cost NUMERIC;
BEGIN
  SELECT CASE WHEN (itemsite_costmethod='A' AND itemsite_qtyonhand != 0.0) THEN (itemsite_value / itemsite_qtyonhand)
              WHEN (itemsite_costmethod='A' AND itemsite_qtyonhand = 0.0) THEN stdCost(itemsite_item_id)
              WHEN (itemsite_costmethod='N') THEN 0.0
              ELSE stdCost(itemsite_item_id)
         END INTO _cost
    FROM itemsite
   WHERE(itemsite_id=pItemsiteid);
  RETURN _cost;
END;
$$ LANGUAGE plpgsql;
