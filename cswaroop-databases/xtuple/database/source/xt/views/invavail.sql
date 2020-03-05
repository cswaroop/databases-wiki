-- Unfortunately performance is really bad if you attempt to sort on toOne
-- relations in large data sets. Need to expose the critical columns
-- directly for reasonable performance.
select xt.create_view('xt.invavail', $$
   select itemsite.*,
     item_id, item_number, item_type, item_descrip1, item_descrip2, item_inv_uom_id, item_classcode_id,
     warehous_code
   from itemsite
     join item on itemsite_item_id=item_id
     join whsinfo on itemsite_warehous_id=warehous_id;
$$);
