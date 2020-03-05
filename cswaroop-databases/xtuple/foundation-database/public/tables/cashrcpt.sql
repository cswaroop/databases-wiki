select xt.add_column('cashrcpt','cashrcpt_alt_curr_rate', 'NUMERIC', NULL, 'public');
select xt.add_column('cashrcpt','cashrcpt_custgrp_id', 	  'INTEGER', NULL, 'public');
select xt.add_column('cashrcpt','cashrcpt_prj_id',        'INTEGER', 'REFERENCES prj (prj_id)', 'public');

ALTER TABLE cashrcpt ALTER COLUMN cashrcpt_cust_id DROP NOT NULL;
select xt.add_constraint('cashrcpt','cashrcpt_cust_id_check', 'CHECK((cashrcpt_custgrp_id IS NULL AND cashrcpt_cust_id IS NOT NULL) OR (cashrcpt_custgrp_id IS NOT NULL AND cashrcpt_cust_id IS NULL))', 'public');
select xt.add_constraint('cashrcpt', 'fk_cashrcpt_custgrp_id', 'FOREIGN KEY (cashrcpt_custgrp_id) REFERENCES custgrp(custgrp_id)', 'public');
