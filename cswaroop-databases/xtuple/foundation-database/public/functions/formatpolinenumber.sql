
CREATE OR REPLACE FUNCTION formatPoLineNumber(pPoitemid INTEGER,
                                              pIncludeItem BOOLEAN DEFAULT FALSE) RETURNS TEXT IMMUTABLE AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _r RECORD;

BEGIN

  SELECT poitem_linenumber, item_number
    INTO _r
    FROM poitem LEFT OUTER JOIN itemsite ON (itemsite_id=poitem_itemsite_id)
                LEFT OUTER JOIN item ON (item_id=itemsite_item_id)
   WHERE(poitem_id=pPoitemid);

  IF(NOT FOUND) THEN
    RETURN NULL;
  END IF;

  IF(pIncludeItem) THEN
    RETURN LPAD(_r.poitem_linenumber::TEXT, 3, '0') || ':' || _r.item_number;
  END IF;

  RETURN LPAD(_r.poitem_linenumber::TEXT, 3, '0'); 
END;
$$ LANGUAGE plpgsql;

