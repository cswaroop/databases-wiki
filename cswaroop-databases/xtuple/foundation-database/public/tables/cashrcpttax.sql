select xt.create_table('cashrcpttax', 'public', false, 'taxhist');

select xt.add_constraint('cashrcpttax', 'cashrcpttax_pkey', 'PRIMARY KEY (taxhist_id)', 'public');
select xt.add_constraint('cashrcpttax', 'cashrcpttax_taxhist_basis_tax_id_fkey', 'FOREIGN KEY (taxhist_basis_tax_id) REFERENCES tax (tax_id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION', 'public');
select xt.add_constraint('cashrcpttax', 'cashrcpttax_taxhist_parent_id_fkey', 'FOREIGN KEY (taxhist_parent_id) REFERENCES cashrcpt (cashrcpt_id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE CASCADE', 'public');
select xt.add_constraint('cashrcpttax', 'cashrcpttax_taxhist_tax_id_fkey', 'FOREIGN KEY (taxhist_tax_id) REFERENCES tax (tax_id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION', 'public');
select xt.add_constraint('cashrcpttax', 'cashrcpttax_taxhist_taxtype_id_fkey', 'FOREIGN KEY (taxhist_taxtype_id) REFERENCES taxtype (taxtype_id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION', 'public');

COMMENT ON TABLE cashrcpttax
  IS 'Tax History table for Miscellaneous Receipts';

