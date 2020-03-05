CREATE OR REPLACE FUNCTION _invcheadBeforeTrigger() RETURNS "trigger" AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _recurid     INTEGER;
  _newparentid INTEGER;

BEGIN
  IF (TG_OP = 'UPDATE') THEN
    IF (OLD.invchead_posted
      AND ((OLD.invchead_invcnumber != NEW.invchead_invcnumber)
        OR (OLD.invchead_invcdate != NEW.invchead_invcdate)
        OR (OLD.invchead_terms_id != NEW.invchead_terms_id)
        OR (OLD.invchead_salesrep_id != NEW.invchead_salesrep_id)
        OR (OLD.invchead_commission != NEW.invchead_commission)
        OR (OLD.invchead_taxzone_id != NEW.invchead_taxzone_id)
        OR (OLD.invchead_shipchrg_id != NEW.invchead_shipchrg_id)
        OR (OLD.invchead_prj_id != NEW.invchead_prj_id)
        OR (OLD.invchead_misc_accnt_id != NEW.invchead_misc_accnt_id)
        OR (OLD.invchead_misc_amount != NEW.invchead_misc_amount)
        OR (OLD.invchead_freight != NEW.invchead_freight))) THEN
      RAISE EXCEPTION 'Edit not allow on Posted Invoice.';
    END IF;
  END IF;

  IF TG_OP IN ('INSERT', 'UPDATE') THEN
    NEW.invchead_billto_address1 := COALESCE(NEW.invchead_billto_address1, '');
    NEW.invchead_billto_address2 := COALESCE(NEW.invchead_billto_address2, '');
    NEW.invchead_billto_address3 := COALESCE(NEW.invchead_billto_address3, '');
    NEW.invchead_billto_city     := COALESCE(NEW.invchead_billto_city, '');
    NEW.invchead_billto_state    := COALESCE(NEW.invchead_billto_state, '');
    NEW.invchead_billto_zipcode  := COALESCE(NEW.invchead_billto_zipcode, '');
    NEW.invchead_shipto_address1 := COALESCE(NEW.invchead_shipto_address1, '');
    NEW.invchead_shipto_address2 := COALESCE(NEW.invchead_shipto_address2, '');
    NEW.invchead_shipto_address3 := COALESCE(NEW.invchead_shipto_address3, '');
    NEW.invchead_shipto_city     := COALESCE(NEW.invchead_shipto_city, '');
    NEW.invchead_shipto_state    := COALESCE(NEW.invchead_shipto_state, '');
    NEW.invchead_shipto_zipcode  := COALESCE(NEW.invchead_shipto_zipcode, '');
    NEW.invchead_billto_country  := COALESCE(NEW.invchead_billto_country, '');
    NEW.invchead_shipto_country  := COALESCE(NEW.invchead_shipto_country, '');
  END IF;

  IF (TG_OP = 'DELETE') THEN
    DELETE FROM invcheadtax
    WHERE (taxhist_parent_id=OLD.invchead_id);

    SELECT recur_id INTO _recurid
      FROM recur
     WHERE ((recur_parent_id=OLD.invchead_id)
        AND (recur_parent_type='I'));
    IF (_recurid IS NOT NULL) THEN
      SELECT invchead_id INTO _newparentid
        FROM invchead
       WHERE ((invchead_recurring_invchead_id=OLD.invchead_id)
          AND (invchead_id!=OLD.invchead_id))
       ORDER BY invchead_invcdate
       LIMIT 1;

      IF (_newparentid IS NULL) THEN
        DELETE FROM recur WHERE recur_id=_recurid;
      ELSE
        UPDATE recur SET recur_parent_id=_newparentid
         WHERE recur_id=_recurid;
        UPDATE invchead SET invchead_recurring_invchead_id=_newparentid
         WHERE invchead_recurring_invchead_id=OLD.invchead_id
           AND invchead_id!=OLD.invchead_id;
      END IF;
    END IF;

    RETURN OLD;
  END IF;

  -- Timestamps
  IF (TG_OP = 'INSERT') THEN
    NEW.invchead_created := now();
  ELSIF (TG_OP = 'UPDATE') THEN
    NEW.invchead_lastupdated := now();
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'invcheadBeforeTrigger');
CREATE TRIGGER invcheadBeforeTrigger
  BEFORE INSERT OR UPDATE OR DELETE
  ON invchead
  FOR EACH ROW
  EXECUTE PROCEDURE _invcheadBeforeTrigger();

CREATE OR REPLACE FUNCTION _invcheadTrigger() RETURNS "trigger" AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  IF (TG_OP = 'DELETE') THEN
    -- Something can go here
    RETURN OLD;
  END IF;

-- Insert new row
  IF (TG_OP = 'INSERT') THEN

  -- Calculate Freight Tax
    IF (NEW.invchead_freight <> 0) THEN
      PERFORM calculateTaxHist( 'invcheadtax',
                                NEW.invchead_id,
                                NEW.invchead_taxzone_id,
                                getFreightTaxtypeId(),
                                NEW.invchead_invcdate,
                                NEW.invchead_curr_id,
                                NEW.invchead_freight );
    END IF;

    --- clear the number from the issue cache
    PERFORM clearNumberIssue('InvcNumber', NEW.invchead_invcnumber);
  END IF;

-- Update row
  IF (TG_OP = 'UPDATE') THEN

    IF ( (NEW.invchead_freight <> OLD.invchead_freight) OR
         (COALESCE(NEW.invchead_taxzone_id,-1) <> COALESCE(OLD.invchead_taxzone_id,-1)) OR
         (NEW.invchead_invcdate <> OLD.invchead_invcdate) OR
         (NEW.invchead_curr_id <> OLD.invchead_curr_id) ) THEN
  -- Calculate invchead Tax
      PERFORM calculateTaxHist( 'invcheadtax',
                                NEW.invchead_id,
                                NEW.invchead_taxzone_id,
                                getFreightTaxtypeId(),
                                NEW.invchead_invcdate,
                                NEW.invchead_curr_id,
                                NEW.invchead_freight );
    END IF;

    IF ( (COALESCE(NEW.invchead_taxzone_id,-1) <> COALESCE(OLD.invchead_taxzone_id,-1)) OR
         (NEW.invchead_invcdate <> OLD.invchead_invcdate) OR
         (NEW.invchead_curr_id <> OLD.invchead_curr_id) ) THEN
  -- Calculate invcitem Tax
      IF (COALESCE(NEW.invchead_taxzone_id,-1) <> COALESCE(OLD.invchead_taxzone_id,-1)) THEN

        UPDATE invcitem SET invcitem_taxtype_id=getItemTaxType(invcitem_item_id,NEW.invchead_taxzone_id)
        WHERE (invcitem_invchead_id=NEW.invchead_id);

        PERFORM calculateTaxHist( 'invcitemtax',
                                  invcitem_id,
                                  NEW.invchead_taxzone_id,
                                  invcitem_taxtype_id,
                                  NEW.invchead_invcdate,
                                  NEW.invchead_curr_id,
                                  (invcitem_billed * invcitem_qty_invuomratio) *
                                  (invcitem_price / invcitem_price_invuomratio) )
        FROM invcitem
        WHERE (invcitem_invchead_id = NEW.invchead_id);
      END IF;
    END IF;

  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'invcheadtrigger');
CREATE TRIGGER invcheadtrigger
  AFTER INSERT OR UPDATE OR DELETE
  ON invchead
  FOR EACH ROW
  EXECUTE PROCEDURE _invcheadTrigger();


CREATE OR REPLACE FUNCTION _invcheadaftertrigger()
  RETURNS trigger AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
  DECLARE
    _cohead_id INTEGER;

  BEGIN
--  Create a comment entry when on a Sales Order when an Invoice is Posted for that order
    IF (TG_OP = 'UPDATE') THEN
      IF ((OLD.invchead_posted != NEW.invchead_posted) AND NEW.invchead_posted) THEN
        SELECT cohead_id INTO _cohead_id
        FROM cohead
        WHERE (cohead_number = OLD.invchead_ordernumber);
        IF (FOUND) THEN
          PERFORM postComment('ChangeLog', 'S', _cohead_id,
                              ('Invoice, ' || NEW.invchead_invcnumber || ', posted for this order') );
        END IF;
      END IF;
    END IF;

  RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'invcheadaftertrigger');
CREATE TRIGGER invcheadaftertrigger
  AFTER UPDATE
  ON invchead
  FOR EACH ROW
  EXECUTE PROCEDURE _invcheadaftertrigger();

CREATE OR REPLACE FUNCTION _invcheadAfterDeleteTrigger() RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE

BEGIN

  DELETE
  FROM charass
  WHERE charass_target_type = 'INV'
    AND charass_target_id = OLD.invchead_id;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'invcheadAfterDeleteTrigger');
CREATE TRIGGER invcheadAfterDeleteTrigger
  AFTER DELETE
  ON invchead
  FOR EACH ROW
  EXECUTE PROCEDURE _invcheadAfterDeleteTrigger();
