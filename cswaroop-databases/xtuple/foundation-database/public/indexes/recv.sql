--CREATE INDEX recv_itemsite_id_index ON recv USING btree (recv_itemsite_id);
select xt.add_index('recv', 'recv_itemsite_id', 'recv_itemsite_id_idx', 'btree', 'public');
