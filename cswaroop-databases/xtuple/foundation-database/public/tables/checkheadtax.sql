select xt.create_table('checkheadtax', 'public', false, 'taxhist');

select xt.add_constraint('checkheadtax', 'checkheadtax_pkey', 'PRIMARY KEY (taxhist_id)', 'public');
select xt.add_constraint('checkheadtax', 'checkheadtax_taxhist_basis_tax_id_fkey', 'FOREIGN KEY (taxhist_basis_tax_id) REFERENCES tax (tax_id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION', 'public');
select xt.add_constraint('checkheadtax', 'checkheadtax_taxhist_parent_id_fkey', 'FOREIGN KEY (taxhist_parent_id) REFERENCES checkhead (checkhead_id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE CASCADE', 'public');
select xt.add_constraint('checkheadtax', 'checkheadtax_taxhist_tax_id_fkey', 'FOREIGN KEY (taxhist_tax_id) REFERENCES tax (tax_id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION', 'public');
select xt.add_constraint('checkheadtax', 'checkheadtax_taxhist_taxtype_id_fkey', 'FOREIGN KEY (taxhist_taxtype_id) REFERENCES taxtype (taxtype_id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION', 'public');

COMMENT ON TABLE checkheadtax
  IS 'Tax History table for Miscellaneous Payments';

