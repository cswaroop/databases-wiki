CREATE OR REPLACE FUNCTION orderhasshipped(integer)
  RETURNS boolean AS 
$BODY$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pCoheadid ALIAS FOR $1;
  _record   RECORD;
  _backorder BOOLEAN := FALSE;

BEGIN
-- determine total shipped and total balance
SELECT sum(coitem_qtyshipped) AS shipped, 
       sum(noNeg(coitem_qtyord - coitem_qtyshipped + coitem_qtyreturned -
                       ( SELECT COALESCE(SUM(shipitem_qty), 0)
                         FROM shipitem, shiphead
                         WHERE ( (shipitem_orderitem_id=coitem_id)
                           AND (shipitem_shiphead_id=shiphead_id)
                           AND (NOT shiphead_shipped)
                           AND (shiphead_order_type='SO') 
                         ) ) ) ) AS balance INTO _record 
FROM coitem
JOIN cohead ON coitem_cohead_id = cohead_id
WHERE cohead_id = pCoheadid;

-- is it totally shipped?
IF (_record.balance <= 0.00) THEN
 RETURN TRUE;
END IF;

-- does cust accept backorders?
SELECT cust_backorder INTO _backorder
FROM   cohead
JOIN   custinfo ON cust_id = cohead_cust_id
WHERE  cohead_id = pCoheadid;

-- is it partially shipped but customer does not accept backorders
IF (_record.balance > 0.00 AND _record.shipped > 0.00 AND _backorder = FALSE) THEN
  RETURN TRUE;
END IF;

RETURN FALSE;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  ALTER FUNCTION orderhasshipped(integer) OWNER to xtrole;
