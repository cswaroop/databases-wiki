select xt.add_column('vodist','vodist_taxtype_id', 'INTEGER', NULL, 'public');

select xt.add_constraint('vodist','vodist_taxtype_id_fkey', 'foreign key (vodist_taxtype_id) references taxtype(taxtype_id)', 'public');
