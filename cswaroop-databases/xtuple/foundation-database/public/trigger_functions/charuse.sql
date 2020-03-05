CREATE OR REPLACE FUNCTION _charuseBeforeUpsertTrigger () RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
BEGIN
  IF NEW.charuse_target_type != 'LSR' AND
      NOT EXISTS (SELECT 1 FROM source WHERE source_charass = NEW.charuse_target_type) THEN
    RAISE EXCEPTION 'Cannot use Characteristic % with undefined target type % [ xtuple: charuse, -1, %, % ]',
                    NEW.charuse_char_id, NEW.charuse_target_type,
                    NEW.charuse_char_id, NEW.charuse_target_type;
  END IF;
  IF (TG_OP = 'INSERT') THEN
    NEW.charuse_created = CURRENT_TIMESTAMP;
  ELSE
    NEW.charuse_created = OLD.charuse_created;
  END IF;
  NEW.charuse_last_modified = CURRENT_TIMESTAMP;

  RETURN NEW;
END
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS charuseBeforeUpsertTrigger ON charuse;
CREATE TRIGGER charuseBeforeUpsertTrigger
        BEFORE INSERT OR UPDATE
            ON charuse
  FOR EACH ROW EXECUTE PROCEDURE _charuseBeforeUpsertTrigger();
