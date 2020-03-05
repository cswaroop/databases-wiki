
DROP FUNCTION IF EXISTS listprice(integer, integer, integer, integer);

CREATE OR REPLACE FUNCTION listprice(pItemid INTEGER,
                                     pCustid INTEGER DEFAULT (NULL),
                                     pShiptoid INTEGER DEFAULT (NULL),
                                     pSiteid INTEGER DEFAULT (NULL),
                                     pAsOf DATE DEFAULT CURRENT_DATE) RETURNS NUMERIC AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _ips RECORD;
  _item RECORD;
  _cust RECORD;
  _shipto RECORD;
  _itempricingprecedence BOOLEAN := false;

BEGIN

-- Returns the list price of an item by either selecting from an
-- assigned List Price Schedule or the item_listprice.
-- List price always returned in base currency and price uom.

  _itempricingprecedence := fetchMetricBool('ItemPricingPrecedence');

--  Cache Item, Customer and Shipto
  SELECT * INTO _item
  FROM item
  WHERE (item_id=pItemid);

  SELECT * INTO _cust
  FROM custinfo JOIN custtype ON (custtype_id=cust_custtype_id)
  WHERE (cust_id=pCustid);

  SELECT * INTO _shipto
  FROM shiptoinfo
  WHERE (shipto_id=pShiptoid);

-- Price Schedule Assignment Order of Precedence
-- 1. Specific Customer Shipto Id
-- 2. Specific Customer Shipto Pattern
-- 3. Any Customer Shipto Pattern
-- 4. Specific Customer
-- 5. Customer Type
-- 6. Customer Type Pattern

-- Find the best List Price Schedule Price
 
  SELECT INTO _ips
    *, currToBase(ipshead_curr_id, protoprice, pAsOf) AS rightprice
  FROM (
    SELECT *,
           CASE WHEN (COALESCE(ipsass_shipto_id, -1) > 0) THEN 1
                WHEN (COALESCE(LENGTH(ipsass_shipto_pattern), 0) > 0 AND COALESCE(ipsass_cust_id, -1) > 0) THEN 2
                WHEN (COALESCE(LENGTH(ipsass_shipto_pattern), 0) > 0) THEN 3
                WHEN (COALESCE(ipsass_cust_id, -1) > 0) THEN 4
                WHEN (COALESCE(ipsass_custtype_id, -1) > 0) THEN 5
                WHEN (COALESCE(LENGTH(ipsass_custtype_pattern), 0) > 0) THEN 6
                ELSE 99
           END AS assignseq,
           calcIpsitemPrice(ipsitem_id,
                            pItemid,
                            pSiteid,
                            NULL,
                            pAsOf) AS protoprice,
           (COALESCE(ipsitem_price_uom_id, -1)=COALESCE(_item.item_price_uom_id,-1)) AS uommatched,
           CASE WHEN (_itempricingprecedence) THEN (COALESCE(ipsitem_item_id, -1)=_item.item_id)
                ELSE true END AS itemmatched
    FROM ipsass JOIN ipshead ON (ipshead_id=ipsass_ipshead_id AND ipshead_listprice)
                JOIN ipsiteminfo ON (ipsitem_ipshead_id=ipshead_id)
    WHERE ( (ipsitem_item_id=_item.item_id) OR (ipsitem_prodcat_id=_item.item_prodcat_id) )
      AND (CURRENT_DATE BETWEEN ipshead_effective AND (ipshead_expires - 1))
      AND ( (ipsitem_warehous_id=pSiteid) OR (ipsitem_warehous_id IS NULL) )
      AND ( (ipsass_shipto_id=_shipto.shipto_id)
       OR   ((COALESCE(LENGTH(ipsass_shipto_pattern), 0) > 0) AND (ipsass_cust_id > -1) AND (_shipto.shipto_num ~ ipsass_shipto_pattern) AND (ipsass_cust_id = _cust.cust_id))
       OR   ((COALESCE(LENGTH(ipsass_shipto_pattern), 0) > 0) AND (ipsass_cust_id = -1) AND (_shipto.shipto_num ~ ipsass_shipto_pattern))
       OR   ((COALESCE(LENGTH(ipsass_shipto_pattern), 0) = 0) AND (ipsass_cust_id=_cust.cust_id))
       OR   (ipsass_custtype_id=_cust.cust_custtype_id)
       OR   ((COALESCE(LENGTH(ipsass_custtype_pattern), 0) > 0) AND (_cust.custtype_code ~ ipsass_custtype_pattern)) )
  ) AS proto
  ORDER BY assignseq, itemmatched DESC, protoprice
  LIMIT 1;
 
  IF (_ips.rightprice IS NOT NULL) THEN
    RETURN _ips.rightprice;
  END IF;

--  If item is exclusive then list list price does not apply
  IF (_item.item_exclusive) THEN
    RETURN -9999.0;
  END IF;

  RETURN _item.item_listprice;

END; $$
  LANGUAGE plpgsql;
