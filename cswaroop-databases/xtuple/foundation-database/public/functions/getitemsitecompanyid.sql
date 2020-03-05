CREATE OR REPLACE FUNCTION getitemsitecompanyid(pItemSite integer)
  RETURNS integer AS
$BODY$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _returnVal INTEGER;
BEGIN
  IF (pItemSite IS NULL) THEN
    RETURN -1;
  END IF;

  SELECT getcompanyid(warehous_default_accnt_id) INTO _returnVal
    FROM whsinfo
    JOIN itemsite ON (itemsite_warehous_id=warehous_id)
  WHERE itemsite_id = pItemSite;

  IF (_returnVal IS NULL) THEN
    RETURN -1;
  END IF;

  RETURN _returnVal;
END;
$BODY$
  LANGUAGE plpgsql;
