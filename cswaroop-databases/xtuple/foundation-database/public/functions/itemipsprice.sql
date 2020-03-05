
DROP FUNCTION IF EXISTS itemipsprice(integer, integer, integer, numeric, integer, integer, integer, date, date, integer);

CREATE OR REPLACE FUNCTION itemipsprice(pItemid INTEGER,
                                        pCustid INTEGER,
                                        pShiptoid INTEGER,
                                        pQty NUMERIC,
                                        pQtyuom INTEGER,
                                        pPriceuom INTEGER,
                                        pCurrid INTEGER,
                                        pEffective DATE,
                                        pAsof DATE,
                                        pSiteid INTEGER,
                                        pShipzoneid INTEGER DEFAULT (-1),
                                        pSaletypeid INTEGER DEFAULT (-1)) RETURNS SETOF itemprice AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _row  itemprice%ROWTYPE;
  _sale RECORD;
  _ips RECORD;
  _item RECORD;
  _cust RECORD;
  _shipto RECORD;
  _listprice NUMERIC := 0.0;
  _asof DATE;
  _itempricingprecedence BOOLEAN := false;
  _wholesalepricecosting BOOLEAN := false;

BEGIN
  _itempricingprecedence := fetchMetricBool('ItemPricingPrecedence');
  _wholesalepricecosting := fetchMetricBool('WholesalePriceCosting');

-- If no as of passed, use current date
  _asof := COALESCE(pAsOf, CURRENT_DATE);

--  Cache Item, Customer and Shipto
  SELECT item.*,
         CASE WHEN (itemsite_id IS NULL) THEN
                   (stdCost(item_id) / itemuomtouomratio(item_id, item_inv_uom_id, item_price_uom_id))
               ELSE
                   (itemCost(itemsite_id) / itemuomtouomratio(item_id, item_inv_uom_id, item_price_uom_id))
         END AS invcost INTO _item
  FROM item LEFT OUTER JOIN itemsite ON (itemsite_item_id=item_id AND itemsite_warehous_id=pSiteid)
  WHERE (item_id=pItemid);

  SELECT cust_id, cust_custtype_id, custtype_code, cust_discntprcnt INTO _cust
  FROM custinfo JOIN custtype ON (custtype_id=cust_custtype_id)
  WHERE (cust_id=pCustid);

  SELECT * INTO _shipto
  FROM shiptoinfo
  WHERE (shipto_id=pShiptoid);

  _listprice := listPrice(pItemid, pCustid, pShiptoid, pSiteid);

-- Price Schedule Assignment Order of Precedence
-- 1. Specific Customer Shipto Id
-- 2. Specific Customer Shipto Pattern
-- 3. Any Customer Shipto Pattern
-- 4. Specific Customer
-- 5. Customer Type
-- 6. Customer Type Pattern
-- 7. Shipping Zone
-- 8. Sale Type 

-- First get a sales price if any so we when we find other prices
-- we can determine if we want that price or this price.
--  Check for a Sale Price
  SELECT INTO _sale
    *, currToCurr(ipshead_curr_id,
                  pCurrid,
                  (protoprice / itemuomtouomratio(pItemid, _item.item_price_uom_id, pPriceUOM)),
                  pEffective) AS rightprice
  FROM (
    SELECT *,
           1 AS assignseq,
           calcIpsitemPrice(ipsitem_id,
                            pItemid,
                            pSiteid,
                            _listprice,
                            pEffective) AS protoprice,
           CASE WHEN (ipsitem_item_id=_item.item_id) THEN itemuomtouom(ipsitem_item_id, ipsitem_qty_uom_id, NULL, ipsitem_qtybreak)
                ELSE ipsitem_qtybreak
           END AS protoqtybreak,
           (COALESCE(ipsitem_price_uom_id, -1)=COALESCE(pPriceUOM,-1)) AS uommatched,
           CASE WHEN (_itempricingprecedence) THEN (COALESCE(ipsitem_item_id, -1)=_item.item_id)
                ELSE true END AS itemmatched
    FROM sale JOIN ipshead ON (ipshead_id=sale_ipshead_id AND NOT ipshead_listprice)
              JOIN ipsiteminfo ON (ipsitem_ipshead_id=ipshead_id)
    WHERE ( (ipsitem_item_id=_item.item_id) OR (ipsitem_prodcat_id=_item.item_prodcat_id) )
      AND (_asof BETWEEN ipshead_effective AND (ipshead_expires - 1))
      AND ((ipsitem_warehous_id=pSiteid) OR (ipsitem_warehous_id IS NULL))
      AND (_asof BETWEEN sale_startdate AND (sale_enddate - 1))
  ) AS proto
  WHERE (protoqtybreak <= pQty)
  ORDER BY assignseq, itemmatched DESC, protoqtybreak DESC, rightprice
  LIMIT 1;

-- Find the best Price Schedule Price
 
  SELECT INTO _ips
    *, currToCurr(ipshead_curr_id,
                  pCurrid,
                  (protoprice / itemuomtouomratio(pItemid, _item.item_price_uom_id, pPriceUOM)),
                  pEffective) AS rightprice
  FROM (
    SELECT *,
           CASE WHEN (COALESCE(ipsass_shipto_id, -1) > 0) THEN 1
                WHEN (COALESCE(LENGTH(ipsass_shipto_pattern), 0) > 0 AND COALESCE(ipsass_cust_id, -1) > 0) THEN 2
                WHEN (COALESCE(LENGTH(ipsass_shipto_pattern), 0) > 0) THEN 3
                WHEN (COALESCE(ipsass_cust_id, -1) > 0) THEN 4
                WHEN (COALESCE(ipsass_custtype_id, -1) > 0) THEN 5
                WHEN (COALESCE(LENGTH(ipsass_custtype_pattern), 0) > 0) THEN 6
                WHEN (COALESCE(ipsass_shipzone_id, -1) > 0) THEN 7
                WHEN (COALESCE(ipsass_saletype_id, -1) > 0) THEN 8
                ELSE 99
           END AS assignseq,
           calcIpsitemPrice(ipsitem_id,
                            pItemid,
                            pSiteid,
                            _listprice,
                            pEffective) AS protoprice,
           CASE WHEN (ipsitem_item_id=_item.item_id) THEN itemuomtouom(ipsitem_item_id, ipsitem_qty_uom_id, NULL, ipsitem_qtybreak)
                ELSE ipsitem_qtybreak
           END AS protoqtybreak,
           (COALESCE(ipsitem_price_uom_id, -1)=COALESCE(pPriceUOM,-1)) AS uommatched,
           CASE WHEN (_itempricingprecedence) THEN (COALESCE(ipsitem_item_id, -1)=_item.item_id)
                ELSE true END AS itemmatched
    FROM ipsass JOIN ipshead ON (ipshead_id=ipsass_ipshead_id AND NOT ipshead_listprice)
                JOIN ipsiteminfo ON (ipsitem_ipshead_id=ipshead_id)
    WHERE ( (ipsitem_item_id=_item.item_id) OR (ipsitem_prodcat_id=_item.item_prodcat_id) )
      AND (_asof BETWEEN ipshead_effective AND (ipshead_expires - 1))
      AND ( (ipsitem_warehous_id=pSiteid) OR (ipsitem_warehous_id IS NULL) )
      AND ( (ipsass_shipto_id=_shipto.shipto_id)
       OR   ((COALESCE(LENGTH(ipsass_shipto_pattern), 0) > 0) AND (ipsass_cust_id > -1) AND (_shipto.shipto_num ~ ipsass_shipto_pattern) AND (ipsass_cust_id = _cust.cust_id))
       OR   ((COALESCE(LENGTH(ipsass_shipto_pattern), 0) > 0) AND (ipsass_cust_id = -1) AND (_shipto.shipto_num ~ ipsass_shipto_pattern))
       OR   ((COALESCE(LENGTH(ipsass_shipto_pattern), 0) = 0) AND (ipsass_cust_id=_cust.cust_id))
       OR   (ipsass_custtype_id=_cust.cust_custtype_id)
       OR   ((COALESCE(LENGTH(ipsass_custtype_pattern), 0) > 0) AND (_cust.custtype_code ~ ipsass_custtype_pattern))
       OR   ((COALESCE(ipsass_shipzone_id, 0) > 0) AND (ipsass_shipzone_id=pShipZoneid))
       OR   ((COALESCE(ipsass_saletype_id, 0 ) > 0) AND (ipsass_saletype_id=pSaleTypeid)) )
  ) AS proto
  WHERE (protoqtybreak <= pQty)
  ORDER BY assignseq, itemmatched DESC, protoqtybreak DESC, rightprice
  LIMIT 1;
 
  IF (_ips.rightprice IS NOT NULL) THEN
    IF ((_sale.rightprice IS NOT NULL) AND (_sale.rightprice < _ips.rightprice)) THEN
      RAISE DEBUG 'itemprice, item=%, cust=%, shipto=%, sale price= %', pItemid, pCustid, pShiptoid, _sale.rightprice;
      _row.itemprice_price := _sale.rightprice;
      _row.itemprice_method := 'S';
      _row.itemprice_type  := _sale.ipsitem_type;
      _row.itemprice_sale := _sale.sale_name;
      _row.itemprice_schedule := _sale.ipshead_name;
      IF (_ips.ipsitem_type = 'M') THEN
        IF (_wholesalepricecosting) THEN
          _row.itemprice_basis := _item.item_listcost;
        ELSE
          _row.itemprice_basis := _item.invcost;
        END IF;
      ELSEIF (_ips.ipsitem_type = 'N') THEN
        _row.itemprice_basis := _sale.rightprice;
      ELSE
        _row.itemprice_basis := _listprice;
      END IF;
      _row.itemprice_listprice := _listprice;
      _row.itemprice_modifierpct := _sale.ipsitem_discntprcnt;
      _row.itemprice_modifieramt := _sale.ipsitem_fixedamtdiscount;
      _row.itemprice_qtybreak := _sale.protoqtybreak;
      _row.itemprice_exclusive := _item.item_exclusive;
      _row.itemprice_qty_uom_id := _sale.ipsitem_qty_uom_id;
      _row.itemprice_price_uom_id := _sale.ipsitem_price_uom_id;
      RETURN NEXT _row;
    END IF;
    RAISE DEBUG 'itemprice, item=%, cust=%, shipto=%, schedule price= %', pItemid, pCustid, pShiptoid, _ips.rightprice;
    _row.itemprice_price := _ips.rightprice;
    _row.itemprice_method := 'I';
    _row.itemprice_type  := _ips.ipsitem_type;
    _row.itemprice_schedule := _ips.ipshead_name;
    _row.itemprice_assignment := _ips.assignseq;
    IF (_ips.ipsitem_type = 'M') THEN
      IF (_wholesalepricecosting) THEN
        _row.itemprice_basis := _item.item_listcost;
      ELSE
        _row.itemprice_basis := _item.invcost;
      END IF;
    ELSEIF (_ips.ipsitem_type = 'N') THEN
      _row.itemprice_basis := _ips.rightprice;
    ELSE
      _row.itemprice_basis := _listprice;
    END IF;
    _row.itemprice_listprice := _listprice;
    _row.itemprice_modifierpct := _ips.ipsitem_discntprcnt;
    _row.itemprice_modifieramt := _ips.ipsitem_fixedamtdiscount;
    _row.itemprice_qtybreak := _ips.protoqtybreak;
    _row.itemprice_exclusive := _item.item_exclusive;
    _row.itemprice_qty_uom_id := _sale.ipsitem_qty_uom_id;
    _row.itemprice_price_uom_id := _sale.ipsitem_price_uom_id;
    RETURN NEXT _row;
  END IF;

--  If item is exclusive then list list price does not apply
  IF (_item.item_exclusive) THEN
    RAISE DEBUG 'itemprice, item=%, cust=%, shipto=%, item exclusive, price=-9999', pItemid, pCustid, pShiptoid;
    _row.itemprice_price := -9999.0;
    _row.itemprice_type := '';
    _row.itemprice_exclusive := _item.item_exclusive;
    RETURN NEXT _row;
  END IF;

--  Check for a list price
  _row.itemprice_listprice := _listprice;
  _row.itemprice_basis := _listprice;
  _listprice := noNeg(currToLocal(pCurrid, _listprice, pEffective)
                      / itemuomtouomratio(pItemid, _item.item_price_uom_id, pPriceUOM));

  RAISE DEBUG 'itemprice, item=%, cust=%, shipto=%, list price= %', pItemid, pCustid, pShiptoid, _listprice;

  _row.itemprice_price := _listprice - (_listprice * COALESCE(_cust.cust_discntprcnt, 0.0));
  _row.itemprice_type := 'P';
  _row.itemprice_method := 'L';
  _row.itemprice_modifierpct := _cust.cust_discntprcnt;
  _row.itemprice_exclusive := _item.item_exclusive;
  RETURN NEXT _row;

  RETURN;

END; $$
  LANGUAGE plpgsql;
