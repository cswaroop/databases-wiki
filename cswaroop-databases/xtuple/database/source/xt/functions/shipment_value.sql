create or replace function xt.shipment_value(shiphead_id integer) returns numeric stable as $$
  select sum(round((shipitem_qty * coitem_qty_invuomratio) * (coitem_price / coitem_price_invuomratio),2))
  from shiphead
    join shipitem on shiphead_id=shipitem_shiphead_id
    join coitem on shipitem_orderitem_id=coitem_id
  where shiphead_id=$1
    and shiphead_order_type = 'SO';
$$ language sql;
