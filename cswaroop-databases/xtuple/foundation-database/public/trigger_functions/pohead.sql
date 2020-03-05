CREATE OR REPLACE FUNCTION _poheadTrigger() RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _check	BOOLEAN;
  _maint        BOOLEAN := TRUE;

BEGIN

-- Check if we are doing maintenance
  IF (TG_OP = 'UPDATE') THEN
    IF ( (OLD.pohead_status           != NEW.pohead_status) OR
         (OLD.pohead_printed          != NEW.pohead_printed) ) THEN
      _maint := FALSE;
    END IF;
  END IF;

  -- Check
  IF ( (NOT _maint) AND (NOT checkPrivilege('MaintainPurchaseOrders'))
                    AND (NOT checkPrivilege('PostPurchaseOrders'))
                    AND (NOT checkPrivilege('PrintPurchaseOrders'))
                    AND (NOT checkPrivilege('PostVouchers')) ) THEN
    RAISE EXCEPTION 'You do not have privileges to alter a Purchase Order.';
  END IF;

  IF ( _maint AND (NOT checkPrivilege('MaintainPurchaseOrders')) ) THEN
    RAISE EXCEPTION 'You do not have privileges to alter a Purchase Order.';
  END IF;

  IF (TG_OP = 'INSERT') THEN
    --- clear the number from the issue cache
    PERFORM clearNumberIssue('PoNumber', NEW.pohead_number);
  END IF;

  IF TG_OP IN ('INSERT', 'UPDATE') THEN
    IF (NOT ISNUMERIC(NEW.pohead_number) AND NEW.pohead_saved) THEN
      RAISE EXCEPTION 'Purchase Order Number must be numeric.';
    END IF;

    NEW.pohead_shiptoaddress1 := COALESCE(NEW.pohead_shiptoaddress1, '');
    NEW.pohead_shiptoaddress2 := COALESCE(NEW.pohead_shiptoaddress2, '');
    NEW.pohead_shiptoaddress3 := COALESCE(NEW.pohead_shiptoaddress3, '');
    NEW.pohead_shiptocity     := COALESCE(NEW.pohead_shiptocity, '');
    NEW.pohead_shiptocountry  := COALESCE(NEW.pohead_shiptocountry, '');
    NEW.pohead_shiptostate    := COALESCE(NEW.pohead_shiptostate, '');
    NEW.pohead_shiptozipcode  := COALESCE(NEW.pohead_shiptozipcode, '');
    NEW.pohead_vendaddress1   := COALESCE(NEW.pohead_vendaddress1, '');
    NEW.pohead_vendaddress2   := COALESCE(NEW.pohead_vendaddress2, '');
    NEW.pohead_vendaddress3   := COALESCE(NEW.pohead_vendaddress3, '');
    NEW.pohead_vendcity       := COALESCE(NEW.pohead_vendcity, '');
    NEW.pohead_vendcountry    := COALESCE(NEW.pohead_vendcountry, '');
    NEW.pohead_vendstate      := COALESCE(NEW.pohead_vendstate, '');
    NEW.pohead_vendzipcode    := COALESCE(NEW.pohead_vendzipcode, '');
  END IF;

  IF (TG_OP = 'UPDATE') THEN
    IF (NEW.pohead_status = 'O' AND OLD.pohead_released IS NULL) THEN
      NEW.pohead_released := CURRENT_DATE;
    END IF;
  END IF;

  IF (fetchMetricBool('POChangeLog')) THEN
    IF (TG_OP = 'INSERT') THEN
      PERFORM postComment('ChangeLog', 'P', NEW.pohead_id, 'Created');

    ELSIF (TG_OP = 'UPDATE') THEN
      IF (OLD.pohead_terms_id <> NEW.pohead_terms_id) THEN
        PERFORM postComment('ChangeLog', 'P', NEW.pohead_id, 'Terms',
                            (SELECT terms_code FROM terms WHERE terms_id=OLD.pohead_terms_id),
                            (SELECT terms_code FROM terms WHERE terms_id=NEW.pohead_terms_id));
      END IF;
    END IF;
  END IF;

  -- Timestamps
  IF (TG_OP = 'INSERT') THEN
    NEW.pohead_created := now();
  ELSIF (TG_OP = 'UPDATE') THEN
    NEW.pohead_lastupdated := now();
  END IF;

  RETURN NEW;

END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS poheadTrigger ON pohead;
CREATE TRIGGER poheadTrigger
  BEFORE INSERT OR UPDATE
  ON pohead
  FOR EACH ROW
  EXECUTE PROCEDURE _poheadTrigger();

CREATE OR REPLACE FUNCTION _poheadTriggerAfter() RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  IF (COALESCE(NEW.pohead_taxzone_id,-1) <> COALESCE(OLD.pohead_taxzone_id,-1)) THEN
    UPDATE poitem SET poitem_taxtype_id=getItemTaxType(itemsite_item_id,NEW.pohead_taxzone_id)
    FROM itemsite
    WHERE ((itemsite_id=poitem_itemsite_id)
     AND (poitem_pohead_id=NEW.pohead_id));
  END IF;

  -- Do not update closed poitems
  IF (TG_OP = 'UPDATE') THEN
    IF (OLD.pohead_status != NEW.pohead_status) THEN
      UPDATE poitem
      SET poitem_status=NEW.pohead_status
      WHERE ( (poitem_pohead_id=NEW.pohead_id)
        AND   (poitem_status <> 'C') );
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

SELECT dropifexists('TRIGGER','poheadTriggerAfter');
CREATE TRIGGER poheadTriggerAfter
  AFTER UPDATE
  ON pohead
  FOR EACH ROW
  EXECUTE PROCEDURE _poheadTriggerAfter();

CREATE OR REPLACE FUNCTION _poheadAfterDeleteTrigger() RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE

BEGIN

  DELETE FROM charass
  WHERE charass_target_type = 'PO'
    AND charass_target_id = OLD.pohead_id;

  DELETE FROM docass WHERE docass_source_id = OLD.pohead_id AND docass_source_type = 'P';
  DELETE FROM docass WHERE docass_target_id = OLD.pohead_id AND docass_target_type = 'P';

  DELETE FROM comment
  WHERE ( (comment_source='P')
   AND (comment_source_id=OLD.pohead_id) );

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'poheadAfterDeleteTrigger');
CREATE TRIGGER poheadAfterDeleteTrigger
  AFTER DELETE
  ON pohead
  FOR EACH ROW
  EXECUTE PROCEDURE _poheadAfterDeleteTrigger();
