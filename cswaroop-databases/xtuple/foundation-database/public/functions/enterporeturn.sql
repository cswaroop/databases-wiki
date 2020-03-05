CREATE OR REPLACE FUNCTION enterPoReturn(INTEGER, NUMERIC, INTEGER) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  RETURN enterPoReturn($1, $2, $3, NULL);
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS enterPoReturn(INTEGER, NUMERIC, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION enterPoReturn(pPoitemid INTEGER, pQty NUMERIC, pRjctcodeid INTEGER, pRecvid INTEGER, 
                                         pRMA TEXT DEFAULT NULL ) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _porejectid INTEGER;
BEGIN

  INSERT INTO poreject
  ( poreject_date, poreject_ponumber, poreject_poitem_id, poreject_trans_username,
    poreject_agent_username, poreject_itemsite_id,
    poreject_vend_id, poreject_vend_item_number, poreject_vend_item_descrip, poreject_vend_uom,
    poreject_qty, poreject_rjctcode_id, poreject_posted, poreject_invoiced, poreject_recv_id,
    poreject_rma )
  SELECT CURRENT_TIMESTAMP, pohead_number, poitem_id, getEffectiveXtUser(),
         pohead_agent_username, poitem_itemsite_id,
         pohead_vend_id, poitem_vend_item_number, poitem_vend_item_descrip, poitem_vend_uom,
         pQty, pRjctcodeid, FALSE, FALSE, pRecvid, pRMA
  FROM poitem JOIN pohead ON (pohead_id=poitem_pohead_id)
  WHERE (poitem_id=pPoitemid)
  RETURNING poreject_id INTO _porejectid;

  RETURN _porejectid;

END;
$$ LANGUAGE plpgsql;
