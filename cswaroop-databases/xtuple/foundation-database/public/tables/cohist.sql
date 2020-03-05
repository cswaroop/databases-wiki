select xt.add_column('cohist', 'cohist_listprice', 'NUMERIC(16,4)', NULL, 'public');
select xt.add_column('cohist', 'cohist_billtocountry', 'TEXT', NULL, 'public');
select xt.add_column('cohist', 'cohist_shiptocountry', 'TEXT', NULL, 'public');

comment on column public.cohist.cohist_listprice is 'List price of Item.';
