select xt.add_column('accnt','accnt_1099_form_type', 'TEXT', NULL, 'public');
ALTER TABLE accnt DROP CONSTRAINT IF EXISTS accnt_accnt_1099_form_check;
ALTER TABLE accnt ADD  CONSTRAINT accnt_accnt_1099_form_check
  CHECK (accnt_1099_form_type = ANY (ARRAY['MISC', 'RENT']));
