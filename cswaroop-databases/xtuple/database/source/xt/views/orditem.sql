select xt.create_view('xt.orditem', $$

  select
    coitem.obj_uuid as obj_uuid,
    coitem.coitem_id as orditem_id,
    cohead.cohead_id as orditem_ordhead_id,
    cohead.obj_uuid as orditem_ordhead_uuid,
    coitem_linenumber as orditem_linenumber,
    coitem_subnumber as orditem_subnumber,
    coitem_status as orditem_status,
    coitem_itemsite_id as orditem_itemsite_id,
    itemsite_item_id as orditem_item_id,
    itemsite_warehous_id as orditem_warehous_id,
    coitem_scheddate as orditem_scheddate,
    coitem_qty_uom_id as orditem_qty_uom_id,
    coitem_qtyord as orditem_qtyord,
    coitem_qtyshipped as orditem_qtytransacted,
    coitem_qtyreturned as orditem_qtyreturned,
    ship_balance as transacted_balance,
    at_shipping as at_dock,
    null::numeric as to_transact,
    null::numeric as undistributed,
    shiphead_id as transacted_head_id,
    null::numeric as orditem_freight,
    coitem_unitcost as orditem_cost,
    coitem_memo::text as orditem_notes
  from xt.coiteminfo as coitem
    join itemsite on itemsite_id=coitem_itemsite_id
    join item on itemsite_item_id=item_id
    join cohead on cohead_id=coitem_cohead_id
    left join shiphead on cohead_id=shiphead_order_id
      and shiphead_order_type='SO'
      and not shiphead_shipped
  where item_type != 'K'
  union all
  select
    poitem.obj_uuid,
    poitem.poitem_id,
    pohead.pohead_id,
    pohead.obj_uuid,
    poitem_linenumber,
    0,
    poitem_status,
    poitem_itemsite_id,
    item_id,
    itemsite_warehous_id,
    poitem_duedate,
    item_inv_uom_id,
    poitem_qty_ordered,
    poitem_qty_received,
    poitem_qty_returned,
    greatest((poitem_qty_ordered - poitem_qty_received), 0) as transacted_balance,
    coalesce(recv_qty, 0.00) as at_dock,
    null::numeric as to_transact,
    null::numeric as undistributed,
    coalesce(recv_id, null)::integer as transacted_head_id,
    poitem_freight,
    poitem_unitprice,
    poitem_comments::text
  from poitem
    join pohead on poitem_pohead_id = pohead_id
    left join recv on poitem_id = recv_orderitem_id and recv_order_type = 'PO' and not recv_posted
    join itemsite on poitem_itemsite_id = itemsite_id
    join item on itemsite_item_id = item_id
  union all
  select
    cmitem.obj_uuid,
    cmitem.cmitem_id,
    cmhead.cmhead_id,
    cmhead.obj_uuid,
    cmitem_linenumber,
    0,
    'O',--cmitem_status,
    cmitem_itemsite_id,
    item_id,
    itemsite_warehous_id,
    null, --cmitem_duedate,
    item_inv_uom_id,
    cmitem_qtyreturned, -- (ordered)
    0, --transacted,
    0, --"returned" (reversed)
    cmitem_qtyreturned as transacted_balance,
    coalesce(recv_qty, 0.00) as at_dock,
    null::numeric as to_transact,
    null::numeric as undistributed,
    coalesce(recv_id, null)::integer as transacted_head_id,
    0, --cmitem_freight,
    cmitem_unitprice,
    cmitem_comments::text
  from cmitem
    join cmhead on cmitem_cmhead_id = cmhead_id
    left join recv on cmitem_id = recv_orderitem_id and recv_order_type = 'CM' and not recv_posted
    join itemsite on cmitem_itemsite_id = itemsite_id
    join item on itemsite_item_id = item_id
  union all
  select
    invcitem.obj_uuid,
    invcitem.invcitem_id,
    invchead.invchead_id,
    invchead.obj_uuid,
    invcitem_linenumber,
    0,
    'O',--invcitem_status,
    itemsite_id,
    item_id,
    itemsite_warehous_id,
    null, --invcitem_duedate,
    item_inv_uom_id,
    invcitem_billed, -- (ordered)
    0,
    0,
    invcitem_billed as transacted_balance,
    0 as at_dock,
    null::numeric as to_transact,
    null::numeric as undistributed,
    invchead_id as transacted_head_id,
    0, --invcitem_freight,
    invcitem_price,
    invcitem_notes::text
  from invcitem
    join invchead on invcitem_invchead_id = invchead_id
    join itemsite on invcitem_item_id = itemsite_item_id and invcitem_warehous_id = itemsite_warehous_id
    join item on itemsite_item_id = item_id
  where invcitem_updateinv = true and not invchead_posted
  order by orditem_linenumber, orditem_subnumber

$$);
