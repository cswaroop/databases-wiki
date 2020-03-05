SELECT xt.add_column('cmitem', 'cmitem_number',	'TEXT', NULL, 'public');
SELECT xt.add_column('cmitem', 'cmitem_descrip','TEXT', NULL, 'public');
SELECT xt.add_column('cmitem', 'cmitem_salescat_id', 'INTEGER', NULL, 'public');
SELECT xt.add_column('cmitem', 'cmitem_rev_accnt_id', 'INTEGER', NULL, 'public');
SELECT xt.add_column('cmitem', 'cmitem_listprice', 'NUMERIC(16,4)', NULL, 'public');

SELECT xt.add_constraint('cmitem', 'cmitem_itemsite_id_fkey', 'FOREIGN KEY (cmitem_itemsite_id)
                                                  REFERENCES itemsite (itemsite_id) MATCH SIMPLE
                                                  ON UPDATE NO ACTION ON DELETE NO ACTION', 'public');
SELECT xt.add_constraint('cmitem', 'cmitem_salescat_id_fkey', 'FOREIGN KEY (cmitem_salescat_id)
                                                  REFERENCES salescat (salescat_id) MATCH SIMPLE
                                                  ON UPDATE NO ACTION ON DELETE NO ACTION', 'public');
SELECT xt.add_constraint('cmitem', 'cmitem_rev_accnt_id_fkey', 'FOREIGN KEY (cmitem_rev_accnt_id)
                                                  REFERENCES accnt (accnt_id) MATCH SIMPLE
                                                  ON UPDATE NO ACTION ON DELETE NO ACTION', 'public');

ALTER TABLE cmitem ALTER COLUMN cmitem_qty_uom_id DROP NOT NULL;
ALTER TABLE cmitem ALTER COLUMN cmitem_price_uom_id DROP NOT NULL;
ALTER TABLE cmitem ALTER COLUMN cmitem_itemsite_id DROP NOT NULL;

comment on column public.cmitem.cmitem_listprice is 'List price of Item.';
