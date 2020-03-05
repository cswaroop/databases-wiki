ALTER TABLE itemalias DROP CONSTRAINT IF EXISTS itemalias_itemalias_item_id_key;

select  xt.add_constraint('itemalias', 'itemalias_itemalias_item_id_key', 'UNIQUE (itemalias_item_id, itemalias_crmacct_id, itemalias_number)', 'public');
