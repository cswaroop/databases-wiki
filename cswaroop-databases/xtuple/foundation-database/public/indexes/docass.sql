select xt.add_index('docass', 'docass_source_id', 'docass_source_id_idx', 'btree', 'public');
select xt.add_index('docass', 'docass_source_type COLLATE pg_catalog."default"', 'docass_source_type_idx', 'btree', 'public');
select xt.add_index('docass', 'docass_target_id', 'docass_target_id_idx', 'btree', 'public');
select xt.add_index('docass', 'docass_target_type COLLATE pg_catalog."default"', 'docass_target_type_idx', 'btree', 'public');
