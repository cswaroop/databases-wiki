select xt.add_column('aropen','aropen_taxzone_id', 'INTEGER', NULL, 'public');

select xt.add_constraint('aropen','aropen_taxzone_id_fkey', 'foreign key (aropen_taxzone_id) references taxzone(taxzone_id)', 'public');
