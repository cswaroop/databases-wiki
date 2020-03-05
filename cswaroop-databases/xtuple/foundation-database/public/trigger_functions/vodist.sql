/*
    Logic appears to be duplicated in the AFTER trigger
    Remove this trigger function and check no side-effects found
*/
SELECT dropIfExists('TRIGGER', 'vodistBeforeTrigger');
DROP FUNCTION IF EXISTS _vodistBeforeTrigger();

CREATE OR REPLACE FUNCTION _vodistAfterTrigger() RETURNS "trigger" AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _r RECORD;

BEGIN
  IF ( (TG_OP = 'UPDATE') OR (TG_OP = 'DELETE') ) THEN
    IF (OLD.vodist_tax_id <> -1) THEN
    -- Delete any existing voheadtax records
      DELETE FROM voheadtax
      WHERE ( (taxhist_parent_id=OLD.vodist_vohead_id)
        AND   (taxhist_tax_id=OLD.vodist_tax_id)
        AND   (COALESCE(taxhist_taxtype_id,-1) <> getFreightTaxtypeId()) );
    END IF;
  END IF;

  IF (TG_OP = 'DELETE') THEN
    RETURN OLD;
  END IF;

-- Cache Voucher Head
  SELECT * INTO _r
  FROM vohead
  WHERE (vohead_id=NEW.vodist_vohead_id);
  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'Voucher head not found';
  END IF;

  IF (NEW.vodist_tax_id <> -1) THEN
  -- Insert adjustment voheadtax
    INSERT INTO voheadtax
      ( taxhist_parent_id,
        taxhist_taxtype_id,
        taxhist_tax_id,
        taxhist_basis,
        taxhist_basis_tax_id,
        taxhist_sequence,
        taxhist_percent,
        taxhist_amount,
        taxhist_tax,
        taxhist_docdate,
        taxhist_reverse_charge )
    VALUES
      ( NEW.vodist_vohead_id,
        COALESCE(NEW.vodist_taxtype_id, getAdjustmentTaxTypeid()),
        NEW.vodist_tax_id,
        0,
        NULL,
        1,
        0,
        0,
        (NEW.vodist_amount * -1),
        _r.vohead_docdate,
        CASE WHEN NEW.vodist_amount < 0 THEN true ELSE FALSE END );
            
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

SELECT dropIfExists('TRIGGER', 'vodistAfterTrigger');
CREATE TRIGGER vodistAfterTrigger
  AFTER INSERT OR UPDATE OR DELETE
  ON vodist
  FOR EACH ROW
  EXECUTE PROCEDURE _vodistAfterTrigger();
