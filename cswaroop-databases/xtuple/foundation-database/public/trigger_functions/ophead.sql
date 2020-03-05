CREATE OR REPLACE FUNCTION _opheadBeforeTrigger () RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _check boolean;
  _test text;
BEGIN

  --  Auto inactivate
  IF (TG_OP = 'UPDATE') THEN
    IF ( (NEW.ophead_opstage_id != OLD.ophead_opstage_id) AND
         (SELECT opstage_opinactive FROM opstage WHERE opstage_id=NEW.ophead_opstage_id) ) THEN
      NEW.ophead_active := FALSE;
    END IF;
  END IF;

  IF (TG_OP = 'INSERT') THEN
    IF (SELECT opstage_opinactive FROM opstage WHERE opstage_id=NEW.ophead_opstage_id) THEN
      NEW.ophead_active := FALSE;
    END IF;
  END IF;

  -- Timestamps
  IF (TG_OP = 'INSERT') THEN
    NEW.ophead_created := now();
  ELSIF (TG_OP = 'UPDATE') THEN
    NEW.ophead_lastupdated := now();
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'opheadBeforeTrigger');
CREATE TRIGGER opheadBeforeTrigger
  BEFORE INSERT OR UPDATE
  ON ophead
  FOR EACH ROW
  EXECUTE PROCEDURE _opheadBeforeTrigger();

CREATE OR REPLACE FUNCTION _opheadAfterTrigger () RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  --  Comments
  IF (fetchMetricBool('OpportunityChangeLog')) THEN
    IF (TG_OP = 'INSERT') THEN
      PERFORM postComment('ChangeLog', 'OPP', NEW.ophead_id, 'Created');

      --- clear the number from the issue cache
      PERFORM clearNumberIssue('OpportunityNumber', NEW.ophead_number);
    ELSIF (TG_OP = 'UPDATE') THEN
      IF (OLD.ophead_active <> NEW.ophead_active) THEN
        IF (NEW.ophead_active) THEN
          PERFORM postComment('ChangeLog', 'OPP', NEW.ophead_id, 'Activated');
        ELSE
          PERFORM postComment('ChangeLog', 'OPP', NEW.ophead_id, 'Deactivated');
        END IF;
      END IF;

      IF (OLD.ophead_name <> NEW.ophead_name) THEN
        PERFORM postComment('ChangeLog', 'OPP', NEW.ophead_id, 'Name',
                            OLD.ophead_name, NEW.ophead_name);
      END IF;

      IF (OLD.ophead_owner_username <> NEW.ophead_owner_username) THEN
        PERFORM postComment('ChangeLog', 'OPP', NEW.ophead_id, 'Owner Name',
                            OLD.ophead_owner_username, NEW.ophead_owner_username);
      END IF;

      IF (OLD.ophead_probability_prcnt <> NEW.ophead_probability_prcnt) THEN
        PERFORM postComment('ChangeLog', 'OPP', NEW.ophead_id, 'Probability %',
                            formatPrcnt(OLD.ophead_probability_prcnt), formatPrcnt(NEW.ophead_probability_prcnt));
      END IF;

      IF (OLD.ophead_amount <> NEW.ophead_amount) THEN
        PERFORM postComment('ChangeLog', 'OPP', NEW.ophead_id, 'Amount',
                            formatMoney(OLD.ophead_amount), formatMoney(NEW.ophead_amount));
      END IF;

      IF (OLD.ophead_target_date <> NEW.ophead_target_date) THEN
        PERFORM postComment('ChangeLog', 'OPP', NEW.ophead_id, 'Target Date',
                            formatDate(OLD.ophead_target_date), formatDate(NEW.ophead_target_date));
      END IF;

      IF (OLD.ophead_actual_date <> NEW.ophead_actual_date) THEN
        PERFORM postComment('ChangeLog', 'OPP', NEW.ophead_id, 'Actual Date',
                            formatDate(OLD.ophead_actual_date), formatDate(NEW.ophead_actual_date));
      END IF;

      IF (OLD.ophead_crmacct_id <> NEW.ophead_crmacct_id) THEN
        PERFORM postComment('ChangeLog', 'OPP', NEW.ophead_id, 'CRM Account',
                            (SELECT crmacct_name FROM crmacct WHERE crmacct_id=OLD.ophead_crmacct_id),
                            (SELECT crmacct_name FROM crmacct WHERE crmacct_id=NEW.ophead_crmacct_id));
      END IF;

      IF (OLD.ophead_curr_id <> NEW.ophead_curr_id) THEN
        PERFORM postComment('ChangeLog', 'OPP', NEW.ophead_id, 'Currency',
                            (SELECT curr_name FROM curr_symbol WHERE curr_id=OLD.ophead_curr_id),
                            (SELECT curr_name FROM curr_symbol WHERE curr_id=NEW.ophead_curr_id));
      END IF;

      IF (OLD.ophead_opstage_id <> NEW.ophead_opstage_id) THEN
        PERFORM postComment('ChangeLog', 'OPP', NEW.ophead_id, 'Stage',
                            (SELECT opstage_name FROM opstage WHERE opstage_id=OLD.ophead_opstage_id),
                            (SELECT opstage_name FROM opstage WHERE opstage_id=NEW.ophead_opstage_id));
      END IF;

      IF (OLD.ophead_opsource_id <> NEW.ophead_opsource_id) THEN
        PERFORM postComment('ChangeLog', 'OPP', NEW.ophead_id, 'Source',
                            (SELECT opsource_name FROM opsource WHERE opsource_id=OLD.ophead_opsource_id),
                            (SELECT opsource_name FROM opsource WHERE opsource_id=NEW.ophead_opsource_id));
      END IF;

      IF (OLD.ophead_optype_id <> NEW.ophead_optype_id) THEN
        PERFORM postComment('ChangeLog', 'OPP', NEW.ophead_id, 'Type',
                            (SELECT optype_name FROM optype WHERE optype_id=OLD.ophead_optype_id),
                            (SELECT optype_name FROM optype WHERE optype_id=NEW.ophead_optype_id));
      END IF;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'opheadAfterTrigger');
CREATE TRIGGER opheadAfterTrigger
  AFTER INSERT OR UPDATE
  ON ophead
  FOR EACH ROW
  EXECUTE PROCEDURE _opheadAfterTrigger();

CREATE OR REPLACE FUNCTION _opheadAfterDeleteTrigger() RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE

BEGIN

  DELETE FROM charass
  WHERE charass_target_type = 'OPP'
    AND charass_target_id = OLD.ophead_id;

  DELETE FROM docass WHERE docass_source_id = OLD.ophead_id AND docass_source_type = 'OPP';
  DELETE FROM docass WHERE docass_target_id = OLD.ophead_id AND docass_target_type = 'OPP';

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'opheadAfterDeleteTrigger');
CREATE TRIGGER opheadAfterDeleteTrigger
  AFTER DELETE
  ON ophead
  FOR EACH ROW
  EXECUTE PROCEDURE _opheadAfterDeleteTrigger();
