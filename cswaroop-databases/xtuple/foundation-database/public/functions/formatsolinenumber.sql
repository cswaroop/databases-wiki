
CREATE OR REPLACE FUNCTION formatSoLineNumber(pSoitemid INTEGER) RETURNS TEXT IMMUTABLE AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _r RECORD;

BEGIN

  SELECT coitem_linenumber, coitem_subnumber
    INTO _r
    FROM coitem
   WHERE(coitem_id=pSoitemid);

  IF(NOT FOUND) THEN
    RETURN NULL;
  END IF;

  IF(COALESCE(_r.coitem_subnumber, 0) > 0) THEN
    RETURN LPAD(_r.coitem_linenumber::TEXT, 3, '0') || '.' || LPAD(_r.coitem_subnumber::TEXT, 3, '0');
  END IF;

  RETURN LPAD(_r.coitem_linenumber::TEXT, 3, '0'); 
END;
$$ LANGUAGE plpgsql;

