CREATE OR REPLACE FUNCTION _prjtaskTrigger () RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  --  Checks
  IF (NEW.prjtask_owner_username=getEffectiveXtUser()) THEN
    IF (NOT checkPrivilege('MaintainAllProjects') AND NOT checkPrivilege('MaintainPersonalProjects')) THEN
      RAISE EXCEPTION 'You do not have privileges to maintain Projects.';
    END IF;
  ELSIF (NOT checkPrivilege('MaintainAllProjects')) THEN
    RAISE EXCEPTION 'You do not have privileges to maintain Projects.';
  ELSIF (LENGTH(COALESCE(NEW.prjtask_number,'')) = 0) THEN
    RAISE EXCEPTION 'You must enter a valid number.';
  ELSIF (LENGTH(COALESCE(NEW.prjtask_name,'')) = 0) THEN
    RAISE EXCEPTION 'You must enter a valid name.';
  END IF;

  -- Timestamps
  IF (TG_OP = 'INSERT') THEN
    NEW.prjtask_created := now();
  ELSIF (TG_OP = 'UPDATE') THEN
    NEW.prjtask_lastupdated := now();
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'prjtaskTrigger');
CREATE TRIGGER prjtaskTrigger
  BEFORE INSERT OR UPDATE
  ON prjtask
  FOR EACH ROW
  EXECUTE PROCEDURE _prjtaskTrigger();

CREATE OR REPLACE FUNCTION _prjtaskAfterTrigger () RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  IF (TG_OP = 'INSERT') THEN
    PERFORM postComment('ChangeLog', 'TA', NEW.prjtask_id, 'Created');

  ELSIF (TG_OP = 'UPDATE') THEN
    IF (OLD.prjtask_start_date <> NEW.prjtask_start_date) THEN
      PERFORM postComment('ChangeLog', 'TA', NEW.prjtask_id, 'Start Date',
                          formatDate(OLD.prjtask_start_date), formatDate(NEW.prjtask_start_date));
    END IF;
    IF (OLD.prjtask_due_date <> NEW.prjtask_due_date) THEN
      PERFORM postComment('ChangeLog', 'TA', NEW.prjtask_id, 'Due Date',
                          formatDate(OLD.prjtask_due_date), formatDate(NEW.prjtask_due_date));
    END IF;
    IF (OLD.prjtask_assigned_date <> NEW.prjtask_assigned_date) THEN
      PERFORM postComment('ChangeLog', 'TA', NEW.prjtask_id, 'Assigned Date',
                          formatDate(OLD.prjtask_assigned_date), formatDate(NEW.prjtask_assigned_date));
    END IF;
    IF (OLD.prjtask_completed_date <> NEW.prjtask_completed_date) THEN
      PERFORM postComment('ChangeLog', 'TA', NEW.prjtask_id, 'Completed Date',
                          formatDate(OLD.prjtask_completed_date), formatDate(NEW.prjtask_completed_date));
    END IF;
    IF (OLD.prjtask_hours_actual != NEW.prjtask_hours_actual) THEN
      PERFORM postComment('ChangeLog', 'TA', NEW.prjtask_id, 'Actual Hours',
                          formatQty(OLD.prjtask_hours_actual), formatQty(NEW.prjtask_hours_actual));
    END IF;
    IF (OLD.prjtask_exp_actual != NEW.prjtask_exp_actual) THEN
      PERFORM postComment('ChangeLog', 'TA', NEW.prjtask_id, 'Actual Expense',
                          formatMoney(OLD.prjtask_exp_actual), formatMoney(NEW.prjtask_exp_actual));
    END IF;

  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'prjtaskAfterTrigger');
CREATE TRIGGER prjtaskAfterTrigger
  AFTER INSERT OR UPDATE
  ON prjtask
  FOR EACH ROW
  EXECUTE PROCEDURE _prjtaskAfterTrigger();

CREATE OR REPLACE FUNCTION _prjtaskAfterDeleteTrigger() RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE

BEGIN

  DELETE
  FROM charass
  WHERE charass_target_type = 'TASK'
    AND charass_target_id = OLD.prjtask_id;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'prjtaskAfterDeleteTrigger');
CREATE TRIGGER prjtaskAfterDeleteTrigger
  AFTER DELETE
  ON prjtask
  FOR EACH ROW
  EXECUTE PROCEDURE _prjtaskAfterDeleteTrigger();
