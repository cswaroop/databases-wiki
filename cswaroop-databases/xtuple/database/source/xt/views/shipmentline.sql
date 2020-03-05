select xt.create_view('xt.shipmentline', $$

  select
    shipitem_shiphead_id as shiphead_id,
    coitem.obj_uuid as obj_uuid,
    coalesce(sum(shipitem_qty)) as quantity,
    coalesce(sum(coitem_qtyord)) as ordered,
    coitem_status as verified,
    coitem_memo as notes
  from coitem
    left join (
      select shipitem_orderitem_id,
        shipitem_shiphead_id,
        shipitem_qty
      from shipitem
        join shiphead on shipitem_shiphead_id=shiphead_id
      where shiphead_order_type='SO')
      shipitem on shipitem_orderitem_id=coitem_id
  group by shipitem_shiphead_id, verified, notes,
    coitem.obj_uuid;

$$, true);
