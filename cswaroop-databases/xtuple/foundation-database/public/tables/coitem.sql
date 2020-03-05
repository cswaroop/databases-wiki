select xt.add_column('coitem', 'coitem_qtyreserved_uom_id', 'INTEGER', NULL, 'public');
select xt.add_column('coitem', 'coitem_listprice', 'NUMERIC(16,4)', NULL, 'public');

select xt.add_constraint('coitem','coitem_coitem_qtyreserved_uom_id_fkey', 'foreign key (coitem_qtyreserved_uom_id) references uom(uom_id)', 'public');

comment on column public.coitem.coitem_qtyreserved_uom_id is 'UOM of qtyreserved (same as Item Inv UOM).';
comment on column public.coitem.coitem_listprice is 'List price of Item.';
