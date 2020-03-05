SELECT xt.create_table('fundstype', 'public');

select xt.add_column('fundstype', 'fundstype_id','SERIAL', 'PRIMARY KEY',    'public');
select xt.add_column('fundstype', 'fundstype_code', 'TEXT', 'NOT NULL', 'public');
select xt.add_column('fundstype', 'fundstype_name', 'TEXT', 'NOT NULL', 'public');
select xt.add_column('fundstype', 'fundstype_descrip', 'TEXT', 'NOT NULL', 'public');
select xt.add_column('fundstype', 'fundstype_creditcard', 'BOOLEAN', 'NOT NULL DEFAULT FALSE', 'public');
select xt.add_column('fundstype', 'fundstype_external', 'BOOLEAN', 'NOT NULL DEFAULT FALSE', 'public');
select xt.add_column('fundstype', 'fundstype_prepay', 'BOOLEAN', 'NOT NULL DEFAULT FALSE', 'public');
select xt.add_column('fundstype', 'fundstype_extension', 'TEXT', 'NOT NULL DEFAULT ''core''', 'public');
SELECT xt.add_column('fundstype', 'fundstype_created', 'TIMESTAMP WITH TIME ZONE', 'NOT NULL DEFAULT NOW()', 'public');
SELECT xt.add_column('fundstype', 'fundstype_lastupdated', 'TIMESTAMP WITH TIME ZONE', 'NOT NULL DEFAULT NOW()', 'public');
SELECT xt.add_column('fundstype', 'fundstype_lastusername', 'text', 'NOT NULL DEFAULT CURRENT_USER', 'public');
SELECT xt.add_column('fundstype', 'obj_uuid', 'uuid', 'DEFAULT uuid_generate_v4()', 'public');

SELECT xt.add_constraint('fundstype','fundstype_unique', 'unique(fundstype_code, fundstype_name)', 'public');

SELECT xt.add_index('fundstype', 'fundstype_code', 'fundstype_fundstype_code_idx', 'btree', 'public');
SELECT xt.add_index('fundstype', 'fundstype_name', 'fundstype_fundstype_name_idx', 'btree', 'public');
SELECT xt.add_index('fundstype', 'fundstype_external', 'fundstype_fundstype_external_idx', 'btree', 'public');

COMMENT ON TABLE  public.fundstype IS 'Lists the different type of funding sources availble for Cash Receipts. Maps their code to their name. Flags external types.';
COMMENT ON COLUMN public.fundstype.fundstype_code IS 'Abbreviation for this funding type.';
COMMENT ON COLUMN public.fundstype.fundstype_name IS 'Name of this funding type.';
COMMENT ON COLUMN public.fundstype.fundstype_descrip IS 'Human-readable description for this funding type.';
COMMENT ON COLUMN public.fundstype.fundstype_creditcard IS 'A flag to indicate if this funding type is used for credit cards.';
COMMENT ON COLUMN public.fundstype.fundstype_external IS 'A flag to indicate if this funding type is used for external gateways like Credit Cards and Bank Accounts.';
COMMENT ON COLUMN public.fundstype.fundstype_prepay IS 'A flag to indicate if this funding type Cash Receipts go to the Customer Prepaid Account.';
COMMENT ON COLUMN public.fundstype.fundstype_extension IS 'The name of the extension that added this funding type.';

GRANT ALL ON TABLE public.fundstype TO xtrole;
GRANT ALL ON SEQUENCE public.fundstype_fundstype_id_seq TO xtrole;
