select xt.add_column('invcitem', 'invcitem_listprice', 'NUMERIC(16,4)', NULL, 'public');

comment on column public.invcitem.invcitem_listprice is 'List price of Item.';
