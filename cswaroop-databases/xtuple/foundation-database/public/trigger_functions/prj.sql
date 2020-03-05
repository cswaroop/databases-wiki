CREATE OR REPLACE FUNCTION _prjBeforeDeleteTrigger() RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _recurid     INTEGER;
  _newparentid INTEGER;
BEGIN

  IF (TG_OP = 'DELETE') THEN
    DELETE FROM docass WHERE docass_source_id = OLD.prj_id AND docass_source_type = 'J';
    DELETE FROM docass WHERE docass_target_id = OLD.prj_id AND docass_target_type = 'J';

    SELECT recur_id INTO _recurid
      FROM recur
     WHERE ((recur_parent_id=OLD.prj_id)
        AND (recur_parent_type='J'));

    IF (_recurid IS NOT NULL) THEN
      SELECT MIN(prj_id) INTO _newparentid
        FROM prj
       WHERE ((prj_recurring_prj_id=OLD.prj_id)
          AND (prj_id!=OLD.prj_id));

      -- client is responsible for warning about deleting a recurring prj
      IF (_newparentid IS NULL) THEN
        DELETE FROM recur WHERE recur_id=_recurid;
      ELSE
        UPDATE recur SET recur_parent_id=_newparentid
         WHERE recur_id=_recurid;
      END IF;

    END IF;

    RETURN OLD;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'prjbeforedeletetrigger');
CREATE TRIGGER prjbeforedeletetrigger
  BEFORE DELETE
  ON prj
  FOR EACH ROW
  EXECUTE PROCEDURE _prjBeforeDeleteTrigger();

CREATE OR REPLACE FUNCTION _prjAfterDeleteTrigger() RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE

BEGIN

  DELETE
  FROM charass
  WHERE charass_target_type = 'PROJ'
    AND charass_target_id = OLD.prj_id;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'prjAfterDeleteTrigger');
CREATE TRIGGER prjAfterDeleteTrigger
  AFTER DELETE
  ON prj
  FOR EACH ROW
  EXECUTE PROCEDURE _prjAfterDeleteTrigger();

CREATE OR REPLACE FUNCTION _prjBeforeTrigger() RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  -- Timestamps
  IF (TG_OP = 'INSERT') THEN
    NEW.prj_created := now();
  ELSIF (TG_OP = 'UPDATE') THEN
    NEW.prj_lastupdated := now();
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'prjbeforetrigger');
CREATE TRIGGER prjbeforetrigger
  BEFORE INSERT OR UPDATE
  ON prj
  FOR EACH ROW
  EXECUTE PROCEDURE _prjBeforeTrigger();

CREATE OR REPLACE FUNCTION _prjAfterTrigger() RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  IF (TG_OP = 'INSERT') THEN
    PERFORM postComment('ChangeLog', 'J', NEW.prj_id, 'Created');
  ELSIF (TG_OP = 'UPDATE') THEN
    IF (OLD.prj_start_date <> NEW.prj_start_date) THEN
      PERFORM postComment('ChangeLog', 'J', NEW.prj_id, 'Start Date',
                          formatDate(OLD.prj_start_date), formatDate(NEW.prj_start_date));
    END IF;
    IF (OLD.prj_due_date <> NEW.prj_due_date) THEN
      PERFORM postComment('ChangeLog', 'J', NEW.prj_id, 'Due Date',
                          formatDate(OLD.prj_due_date), formatDate(NEW.prj_due_date));
    END IF;
    IF (OLD.prj_assigned_date <> NEW.prj_assigned_date) THEN
      PERFORM postComment('ChangeLog', 'J', NEW.prj_id, 'Assigned Date',
                          formatDate(OLD.prj_assigned_date), formatDate(NEW.prj_assigned_date));
    END IF;
    IF (OLD.prj_completed_date <> NEW.prj_completed_date) THEN
      PERFORM postComment('ChangeLog', 'J', NEW.prj_id, 'Completed Date',
                          formatDate(OLD.prj_completed_date), formatDate(NEW.prj_completed_date));
    END IF;

  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'prjaftertrigger');
CREATE TRIGGER prjaftertrigger
  AFTER INSERT OR UPDATE
  ON prj
  FOR EACH ROW
  EXECUTE PROCEDURE _prjAfterTrigger();
