SELECT xt.add_column('cashrcptmisc','cashrcptmisc_cust_id', 'INTEGER', NULL, 'public');
SELECT xt.add_column('cashrcptmisc','cashrcptmisc_tax_id', 'INTEGER', NULL, 'public');

select xt.add_constraint('cashrcptmisc', 'cashrcptmisc_tax_id_fkey', 'FOREIGN KEY (cashrcptmisc_tax_id) REFERENCES tax (tax_id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION', 'public');

ALTER TABLE cashrcptmisc
   ALTER COLUMN cashrcptmisc_accnt_id DROP NOT NULL;

