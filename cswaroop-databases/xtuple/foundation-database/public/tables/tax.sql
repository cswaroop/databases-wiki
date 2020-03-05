select xt.add_column('tax','tax_dist_accnt_id', 'INTEGER', NULL, 'public');

-- Removed prior to 4.10 beta
-- select xt.add_column('tax','tax_armemo', 'BOOLEAN', NULL, 'public');
-- select xt.add_column('tax','tax_apmemo', 'BOOLEAN', NULL, 'public');

-- COMMENT ON COLUMN tax.tax_armemo IS 'Automatically apply this tax code to AR Memos';
-- COMMENT ON COLUMN tax.tax_apmemo IS 'Automatically apply this tax code to AP Memos';

ALTER TABLE tax DROP COLUMN IF EXISTS tax_armemo;
ALTER TABLE tax DROP COLUMN IF EXISTS tax_apmemo;
