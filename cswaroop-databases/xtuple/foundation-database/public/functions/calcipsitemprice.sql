
CREATE OR REPLACE FUNCTION calcIpsitemPrice(pIpsitemid INTEGER,
                                            pItemid INTEGER,
                                            pWarehousid INTEGER DEFAULT (NULL),
                                            pListPrice NUMERIC DEFAULT (NULL),
                                            pAsOf DATE DEFAULT CURRENT_DATE) RETURNS NUMERIC AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _result NUMERIC := 0.0;
  _item RECORD;
  _wholesalepricecosting BOOLEAN := false;
  _long30markups BOOLEAN := false;
BEGIN
  -- List Price argument in base currency and item pricing uom
  -- Returns ips price in ipshead currency and item pricing uom

  _wholesalepricecosting := fetchMetricBool('WholesalePriceCosting');
  _long30markups := fetchMetricBool('Long30Markups');

--  Cache Item
  SELECT item.*,
         CASE WHEN (itemsite_id IS NULL) THEN
                   (stdCost(item_id) / itemuomtouomratio(item_id, item_inv_uom_id, item_price_uom_id))
              ELSE
                   (itemCost(itemsite_id) / itemuomtouomratio(item_id, item_inv_uom_id, item_price_uom_id))
         END AS invcost INTO _item
  FROM item LEFT OUTER JOIN itemsite ON (itemsite_item_id=item_id AND itemsite_warehous_id=pWarehousid)
  WHERE (item_id=pItemid);

  SELECT   CASE WHEN (ipsitem_type = 'N') THEN
                 (ipsitem_price / itemuomtouomratio(_item.item_id, ipsitem_price_uom_id, _item.item_price_uom_id))
                WHEN (ipsitem_type = 'D') THEN
                 noNeg(currToLocal(ipshead_curr_id, COALESCE(pListPrice, _item.item_listprice), pAsOf) -
                      (currToLocal(ipshead_curr_id, COALESCE(pListPrice, _item.item_listprice), pAsOf) * ipsitem_discntprcnt) - ipsitem_fixedamtdiscount)
                WHEN ((ipsitem_type = 'M') AND _long30markups AND _wholesalepricecosting) THEN
                 (currToLocal(ipshead_curr_id, _item.item_listcost, pAsOf) / (1.0 - ipsitem_discntprcnt) + ipsitem_fixedamtdiscount)
                WHEN ((ipsitem_type = 'M') AND _long30markups) THEN
                 (currToLocal(ipshead_curr_id, _item.invcost, pAsOf) / (1.0 - ipsitem_discntprcnt) + ipsitem_fixedamtdiscount)
                WHEN (ipsitem_type = 'M' AND _wholesalepricecosting) THEN
                 (currToLocal(ipshead_curr_id, _item.item_listcost, pAsOf) + (currToLocal(ipshead_curr_id, _item.item_listcost, pAsOf) * ipsitem_discntprcnt) + ipsitem_fixedamtdiscount)
                WHEN (ipsitem_type = 'M') THEN
                 (currToLocal(ipshead_curr_id, _item.invcost, pAsOf) + (currToLocal(ipshead_curr_id, _item.invcost, pAsOf) * ipsitem_discntprcnt) + ipsitem_fixedamtdiscount)
                ELSE 0.00
           END INTO _result
  FROM ipsiteminfo JOIN ipshead ON (ipshead_id=ipsitem_ipshead_id)
  WHERE (ipsitem_id=pIpsitemid);

  RETURN COALESCE(_result, 0.0);
END;
$$ LANGUAGE plpgsql;

