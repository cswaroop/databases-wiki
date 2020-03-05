select xt.create_table('charuse', 'public');

select xt.add_column('charuse', 'charuse_id',           'SERIAL', 'PRIMARY KEY',                                   'public');
select xt.add_column('charuse', 'charuse_char_id',      'INTEGER', 'REFERENCES "char"(char_id) ON DELETE CASCADE', 'public');
select xt.add_column('charuse', 'charuse_target_type',  'TEXT',    $$NOT NULL DEFAULT ''$$,      'public');
select xt.add_column('charuse', 'charuse_created',      'TIMESTAMP WITH TIME ZONE', 'NOT NULL DEFAULT CURRENT_TIMESTAMP', 'public');
select xt.add_column('charuse', 'charuse_last_modified','TIMESTAMP WITH TIME ZONE', 'NOT NULL DEFAULT CURRENT_TIMESTAMP', 'public');

comment on table public.charuse is '';

comment on column public.charuse.charuse_id is 'Internal ID of this charuse record.';
comment on column public.charuse.charuse_target_type is 'If a row exists in the charuse table for a given target type, characteristic assignments can be used';
