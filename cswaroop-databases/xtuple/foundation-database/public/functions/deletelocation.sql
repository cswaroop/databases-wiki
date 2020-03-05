CREATE OR REPLACE FUNCTION deletelocation( pLocationid integer)
  RETURNS integer AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _check INTEGER;
BEGIN

  SELECT checklocation(pLocationid) INTO _check;
  IF (_check < 0) THEN
    RETURN _check;
  END IF;  

--  Delete any associated locitem records
  DELETE FROM locitem
  WHERE (locitem_location_id=pLocationid);

--  Delete the location record
  DELETE FROM location
  WHERE (location_id=pLocationid);

  RETURN pLocationid;

END;
$$ LANGUAGE plpgsql;
