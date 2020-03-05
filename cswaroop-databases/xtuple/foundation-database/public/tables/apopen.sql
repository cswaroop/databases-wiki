select xt.add_column('apopen','apopen_taxzone_id', 'INTEGER', NULL, 'public');

select xt.add_constraint('apopen','apopen_taxzone_id_fkey', 'foreign key (apopen_taxzone_id) references taxzone(taxzone_id)', 'public');
