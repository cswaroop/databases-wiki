select xt.create_table('qm', 'public');
select xt.add_column('qm', 'qm_id', 'SERIAL', 'PRIMARY KEY', 'public');
select xt.add_column('qm', 'qm_created', 'TIMESTAMP WITH TIME ZONE', 'NOT NULL', 'public');
select xt.add_column('qm', 'qm_extension_name', 'TEXT', 'NOT NULL', 'public');
select xt.add_column('qm', 'qm_lang', 'TEXT', 'NOT NULL', 'public');
select xt.add_column('qm', 'qm_country', 'TEXT', 'NOT NULL', 'public');
select xt.add_column('qm', 'qm_data', 'BYTEA', 'NOT NULL', 'public');


