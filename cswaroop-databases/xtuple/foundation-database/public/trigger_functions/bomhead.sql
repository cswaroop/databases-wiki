SELECT dropIfExists('TRIGGER','bomheadTrigger');
SELECT dropIfExists('FUNCTION','_bomheadTrigger()');

CREATE OR REPLACE FUNCTION _bomheadBeforeTrigger() RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
-- Privilege Checks
  IF (NOT checkPrivilege('MaintainBOMs')) THEN
    RAISE EXCEPTION 'You do not have privileges to maintain Bills of Material.';
  END IF;

  -- Timestamps
  IF (TG_OP = 'INSERT') THEN
    NEW.bomhead_created := now();
  ELSIF (TG_OP = 'UPDATE') THEN
    NEW.bomhead_lastupdated := now();
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS bomheadBeforeTrigger ON bomhead;
CREATE TRIGGER bomheadBeforeTrigger BEFORE INSERT OR UPDATE ON bomhead
 FOR EACH ROW EXECUTE PROCEDURE _bomheadBeforeTrigger();


CREATE OR REPLACE FUNCTION _bomheadAfterTrigger() RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  -- Changelog
  IF (TG_OP = 'INSERT') THEN
    PERFORM postComment('ChangeLog', 'BMH', NEW.bomhead_id, 'Created');
  ELSIF (TG_OP = 'UPDATE') THEN
    IF (OLD.bomhead_revision <> NEW.bomhead_revision) THEN
      PERFORM postComment('ChangeLog', 'BMH', NEW.bomhead_id, 'Revision',
                          OLD.bomhead_revision, NEW.bomhead_revision);
    END IF;  
    IF (OLD.bomhead_docnum <> NEW.bomhead_docnum) THEN
      PERFORM postComment('ChangeLog', 'BMH', NEW.bomhead_id, 'Document #',
                          OLD.bomhead_docnum, NEW.bomhead_docnum);
    END IF;  
    IF (OLD.bomhead_batchsize <> NEW.bomhead_batchsize) THEN
      PERFORM postComment('ChangeLog', 'BMH', NEW.bomhead_id, 'Batch Size',
                          formatQty(OLD.bomhead_batchsize), formatQty(NEW.bomhead_batchsize));
    END IF;  
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS bomheadAfterTrigger ON bomhead;
CREATE TRIGGER bomheadAfterTrigger AFTER INSERT OR UPDATE ON bomhead
 FOR EACH ROW EXECUTE PROCEDURE _bomheadAfterTrigger();


CREATE OR REPLACE FUNCTION _bomheadBeforeDeleteTrigger() RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
BEGIN

  DELETE FROM comment
   WHERE ( (comment_source='BMH')
     AND   (comment_source_id=OLD.bomhead_id) );

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER','bomheadBeforeDeleteTrigger');
CREATE TRIGGER bomheadBeforeDeleteTrigger BEFORE DELETE ON bomhead FOR EACH ROW EXECUTE PROCEDURE _bomheadBeforeDeleteTrigger();
