CREATE OR REPLACE FUNCTION changePoitemQty(pPoitemid INTEGER,
                                           pQty NUMERIC) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  RETURN changePoitemQty(pPoitemid, pQty, false);

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION changePoitemQty(pPoitemid INTEGER,
                                           pQty NUMERIC,
                                           pBySO BOOLEAN) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE

BEGIN

  IF ( ( SELECT (poitem_status IN ('C'))
         FROM poitem
         WHERE (poitem_id=pPoitemid) ) ) THEN
    RETURN -1;
  END IF;

  UPDATE poitem
  SET poitem_qty_ordered=pQty
  WHERE (poitem_id=pPoitemid);

  IF (pBySO) THEN
    --Generate the PoItemUpdatedBySo event
    PERFORM postEvent('PoItemUpdatedBySo', 'P', poitem_id,
                      itemsite_warehous_id,
                      formatPoitemNumber(poitem_id, TRUE),
                      NULL, NULL, NULL, NULL)
    FROM poitem JOIN itemsite ON (itemsite_id=poitem_itemsite_id)
    WHERE (poitem_id=pPoitemid)
      AND (poitem_duedate <= (CURRENT_DATE + itemsite_eventfence));
  END IF;

  RETURN pPoitemid;

END;
$$ LANGUAGE plpgsql;
