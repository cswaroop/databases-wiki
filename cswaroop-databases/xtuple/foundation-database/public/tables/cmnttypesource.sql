select xt.create_table('cmnttypesource', 'public');
select xt.add_column('cmnttypesource', 'cmnttypesource_id', 'serial', 'primary key', 'public');
select xt.add_column('cmnttypesource', 'cmnttypesource_cmnttype_id', 'integer', NULL, 'public');
select xt.add_column('cmnttypesource', 'cmnttypesource_source_id', 'integer', NULL, 'public');

ALTER SEQUENCE public.cmnttypesource_cmnttypesource_id_seq OWNED BY cmnttypesource.cmnttypesource_id;
ALTER TABLE public.cmnttypesource_cmnttypesource_id_seq OWNER TO admin;

COMMENT ON TABLE cmnttypesource IS 'Description of which types of comment the user should be allowed to select for various types of document (source).';

ALTER TABLE public.cmnttypesource ALTER cmnttypesource_cmnttype_id set not null;
ALTER TABLE public.cmnttypesource ALTER cmnttypesource_source_id set not null;

select xt.add_constraint('cmnttypesource','cmnttypesource_cmnttypesource_cmnttype_id_fkey', 'foreign key (cmnttypesource_cmnttype_id) references cmnttype(cmnttype_id)', 'public');
select xt.add_constraint('cmnttypesource','cmnttypesource_cmnttypesource_source_id_fkey', 'foreign key (cmnttypesource_source_id) references source(source_id)', 'public');
