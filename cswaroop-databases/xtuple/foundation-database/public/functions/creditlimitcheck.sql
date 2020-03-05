CREATE OR REPLACE FUNCTION creditlimitcheck(pCustomerId integer)
  RETURNS SETOF creditcheck AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _result  creditcheck%ROWTYPE;
BEGIN

   _result.creditcheck_cust_id = pCustomerId;
   
   -- Open (saved) Sales Orders
   SELECT COALESCE( SUM( (noNeg(coitem_qtyord - coitem_qtyshipped + coitem_qtyreturned) * coitem_qty_invuomratio) *
                                                    (coitem_price / coitem_price_invuomratio) ), 0 ) 
                 INTO _result.creditcheck_bookings                                   
                 FROM cohead, coitem, itemsite, item 
                 WHERE ( (coitem_cohead_id=cohead_id)
                  AND (coitem_itemsite_id=itemsite_id)
                  AND (itemsite_item_id=item_id)
                  AND (coitem_status='O')
                  AND (cohead_cust_id=pCustomerId) ); 
                  
    --  Open AR Items 
    SELECT COALESCE( SUM( CASE WHEN (aropen_doctype IN ('I', 'D')) THEN (aropen_amount - aropen_paid)
                                                        ELSE ((aropen_amount - aropen_paid) * -1)
                                                    END ), 0 ) 
                 INTO _result.creditcheck_aropen                                  
                 FROM aropen 
                 WHERE ( (aropen_open)
                  AND (aropen_cust_id=pCustomerId)); 

    -- Customer Credit Limit
    SELECT COALESCE(cust_creditlmt, 0 ) INTO _result.creditcheck_limit
                 FROM custinfo
                 WHERE (cust_id=pCustomerId); 

    RETURN NEXT _result;  

END;
$$ LANGUAGE plpgsql;

