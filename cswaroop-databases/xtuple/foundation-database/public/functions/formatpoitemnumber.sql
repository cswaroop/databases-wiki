CREATE OR REPLACE FUNCTION formatPoitemNumber(pPoitemid INTEGER,
                                              pIncludeItem BOOLEAN DEFAULT FALSE) RETURNS TEXT IMMUTABLE AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  RETURN ( SELECT (pohead_number::TEXT || '-' || formatpolinenumber(poitem_id, pIncludeItem))
           FROM poitem JOIN pohead ON (poitem_pohead_id=pohead_id)
           WHERE (poitem_id=pPoitemid) );
END;
$$ LANGUAGE plpgsql;
