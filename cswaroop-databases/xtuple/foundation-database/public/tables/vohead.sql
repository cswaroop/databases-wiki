select xt.add_column('vohead','vohead_freight', 'NUMERIC', NULL, 'public');
select xt.add_column('vohead','vohead_freight_expcat_id', 'INTEGER', NULL, 'public');

select xt.add_constraint('vohead', 'fk_vohead_expcat_id', 'FOREIGN KEY (vohead_freight_expcat_id) REFERENCES expcat(expcat_id)', 'public');
