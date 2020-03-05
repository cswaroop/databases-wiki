select xt.add_column('checkhead','checkhead_alt_curr_rate', 'NUMERIC', NULL, 'public');
select xt.add_column('checkhead','checkhead_taxzone_id', 'INTEGER', NULL, 'public');
select xt.add_column('checkhead','checkhead_taxtype_id', 'INTEGER', NULL, 'public');

select xt.add_constraint('checkhead','checkhead_taxzone_id_fkey', 'foreign key (checkhead_taxzone_id) references taxzone(taxzone_id)', 'public');
select xt.add_constraint('checkhead','checkhead_taxtype_id_fkey', 'foreign key (checkhead_taxtype_id) references taxtype(taxtype_id)', 'public');
