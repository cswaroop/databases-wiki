select xt.add_column('ipshead', 'ipshead_listprice', 'BOOLEAN', 'NOT NULL DEFAULT FALSE', 'public');

comment on column public.ipshead.ipshead_listprice is 'Indicates if list price schedule.';
