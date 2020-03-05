select xt.add_column('taxhist','taxhist_doctype', 'TEXT', NULL, 'public');
select xt.add_column('taxhist','taxhist_reverse_charge', 'BOOLEAN', 'NOT NULL DEFAULT FALSE', 'public');
