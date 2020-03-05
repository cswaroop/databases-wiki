CREATE OR REPLACE FUNCTION _docassTrigger () RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  IF (NEW.docass_source_type = 'INCDT') THEN
    UPDATE incdt SET incdt_updated = now() WHERE incdt_id = NEW.docass_source_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

SELECT dropifexists('TRIGGER' ,'docassTrigger');
CREATE TRIGGER docassTrigger AFTER INSERT OR UPDATE ON docass FOR EACH ROW EXECUTE PROCEDURE _docassTrigger();


CREATE OR REPLACE FUNCTION _docassbeforetrigger()
  RETURNS trigger AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  NEW.docass_username := geteffectivextuser();
  NEW.docass_created  := (SELECT CURRENT_TIMESTAMP);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

SELECT dropifexists('TRIGGER' ,'docassbeforeTrigger');
CREATE TRIGGER docassbeforeTrigger BEFORE INSERT ON docass FOR EACH ROW EXECUTE PROCEDURE _docassbeforetrigger();

