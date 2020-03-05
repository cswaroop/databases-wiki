select xt.add_column('quitem', 'quitem_listprice', 'NUMERIC(16,4)', NULL, 'public');
select xt.add_column('quitem', 'quitem_created',      'TIMESTAMP WITH TIME ZONE', NULL, 'public');
select xt.add_column('quitem', 'quitem_lastupdated',  'TIMESTAMP WITH TIME ZONE', NULL, 'public');

comment on column public.quitem.quitem_listprice is 'List price of Item.';
