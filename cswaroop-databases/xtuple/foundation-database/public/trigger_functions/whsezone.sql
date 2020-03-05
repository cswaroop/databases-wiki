CREATE OR REPLACE FUNCTION _whseZoneTrigger () RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _check      BOOLEAN;
  _checkId    INTEGER;

BEGIN

  -- Checks
  -- Start with privileges
  IF (TG_OP = 'INSERT') THEN
    SELECT checkPrivilege('MaintainWarehouses') INTO _check;
    IF NOT (_check) THEN
      RAISE EXCEPTION 'You do not have privileges to add new Site Zones. [xtuple: whseZoneTrigger]';
    END IF;
  ELSE
    SELECT checkPrivilege('MaintainWarehouses') INTO _check;
    IF NOT (_check) THEN
      RAISE EXCEPTION 'You do not have privileges to alter a Site Zone. [xtuple: whseZoneTrigger]';
    END IF;
  END IF;

  -- Name is required
  IF (LENGTH(COALESCE(NEW.whsezone_name,''))=0) THEN
    RAISE EXCEPTION 'You must supply a valid Site Zone Name. [xtuple: whseZoneTrigger]';
  END IF;
  
  -- Site is required
  IF (NEW.whsezone_warehous_id IS NULL) THEN
    RAISE EXCEPTION 'You must supply a valid Site. [xtuple: whseZoneTrigger]';
  END IF;

  RETURN NEW;

END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'whseZoneTrigger');
CREATE TRIGGER whseZoneTrigger BEFORE INSERT OR UPDATE ON whsezone FOR EACH ROW EXECUTE PROCEDURE _whseZoneTrigger();


CREATE OR REPLACE FUNCTION _whseZoneDeleteTrigger () RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  -- Check no locations are assigned to this Zone
  IF (EXISTS (SELECT 1 FROM location
              WHERE (location_whsezone_id=OLD.whsezone_id))) THEN
    RAISE EXCEPTION 'The selected Site Zone cannot be deleted 
           as one or more Site Locations have been assigned to it. [xtuple: whseZoneDeleteTrigger]';
  END IF;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'whseZoneDeleteTrigger');
CREATE TRIGGER whseZoneDeleteTrigger BEFORE DELETE ON whsezone FOR EACH ROW EXECUTE PROCEDURE _whseZoneDeleteTrigger();

