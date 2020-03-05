--CREATE INDEX womatlpost_womatl_id_idx on womatlpost using btree (womatlpost_womatl_id);
select xt.add_index('womatlpost', 'womatlpost_womatl_id','womatlpost_womatl_id_idx', 'btree', 'public');
