CREATE OR REPLACE FUNCTION _sourceBeforeUpsertTrigger () RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  IF TG_OP = 'INSERT' THEN
    NEW.source_created := CURRENT_TIMESTAMP;
  ELSE
    NEW.source_created := OLD.source_created;
    NEW.source_docass_num := COALESCE(NEW.source_docass_num, OLD.source_docass_num);
  END IF;

  IF COALESCE(NEW.source_module, '') = '' THEN
    NEW.source_module = 'System';
  END IF;
  IF COALESCE(NEW.source_docass_num, 0) = 0 THEN      /* 0 == Documents::Uninitialized */
    SELECT max(source_docass_num) + 1 FROM source INTO NEW.source_docass_num;
  END IF;

  NEW.source_last_modified := CURRENT_TIMESTAMP;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'sourceBeforeUpsertTrigger');
CREATE TRIGGER sourceBeforeUpsertTrigger BEFORE INSERT OR UPDATE ON source
   FOR EACH ROW EXECUTE PROCEDURE _sourceBeforeUpsertTrigger();
