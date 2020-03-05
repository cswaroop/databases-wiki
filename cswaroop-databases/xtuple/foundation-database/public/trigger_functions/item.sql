CREATE OR REPLACE FUNCTION _itemTrigger () RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

-- Override values to avoid invalid data combinations
  IF (NEW.item_type IN ('R','S','O','L','B')) THEN
    NEW.item_picklist := FALSE;
  END IF;

  IF (NEW.item_type IN ('F','S','O','L','B')) THEN
    NEW.item_picklist := FALSE;
    NEW.item_sold := FALSE;
    NEW.item_prodcat_id := -1;
    NEW.item_exclusive := false;
    NEW.item_listprice := 0;
    NEW.item_upccode := '';
    NEW.item_prodweight := 0;
    NEW.item_packweight := 0;
  END IF;

  IF (NEW.item_type NOT IN ('M','R')) THEN
    NEW.item_config := false;
  END IF;

  -- Timestamps
  IF (TG_OP = 'INSERT') THEN
    NEW.item_created := now();
  ELSIF (TG_OP = 'UPDATE') THEN
    NEW.item_lastupdated := now();
  END IF;

  RETURN NEW;

END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS itemTrigger ON item;
CREATE TRIGGER itemTrigger
  BEFORE INSERT OR UPDATE
  ON item
  FOR EACH ROW
  EXECUTE PROCEDURE _itemTrigger();

CREATE OR REPLACE FUNCTION _itemAfterTrigger () RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.

BEGIN
-- Privilege Checks
   IF (NOT checkPrivilege('MaintainItemMasters')) THEN
     RAISE EXCEPTION 'You do not have privileges to maintain Items.';
   END IF;

-- Integrity checks
  IF (TG_OP = 'UPDATE') THEN
    IF ((OLD.item_type <> NEW.item_type) AND (NEW.item_type = 'L')) THEN
      IF (SELECT COUNT(*) != 0 FROM bomitem WHERE (bomitem_item_id = OLD.item_id)) THEN
        RAISE EXCEPTION 'This item is part of one or more Bills of Materials and cannot be a Planning Item.';
      END IF;
    END IF;

    IF ((OLD.item_type <> NEW.item_type) AND
       (NEW.item_type IN ('R','S','T'))) THEN
      IF (SELECT COUNT(*) != 0
        FROM itemsite
        WHERE ((itemsite_item_id=OLD.item_id)
        AND (itemsite_qtyonhand + qtyallocated(itemsite_id,startoftime(),endoftime()) +
	   qtyordered(itemsite_id,startoftime(),endoftime()) > 0 ))) THEN
          RAISE EXCEPTION 'Item type not allowed when there are itemsites with quantities with on hand quantities or pending inventory activity for this item.';
      END IF;
    END IF;
-- If type changed remove costs and deactivate item sites
    IF (NEW.item_type <> OLD.item_type) THEN
      PERFORM updateCost(itemcost_id, 0) FROM itemcost WHERE (itemcost_item_id=OLD.item_id);
      UPDATE itemsite SET itemsite_active=false WHERE (itemsite_item_id=OLD.item_id);
      IF (NEW.item_type = 'R') THEN
        UPDATE itemsite SET itemsite_controlmethod='N' WHERE (itemsite_item_id=OLD.item_id);
      END IF;
    END IF;
  END IF;

  IF (fetchMetricBool('ItemChangeLog')) THEN
    IF (TG_OP = 'INSERT') THEN
      PERFORM postComment('ChangeLog', 'I', NEW.item_id, 'Created');

    ELSIF (TG_OP = 'UPDATE') THEN
      IF (OLD.item_active <> NEW.item_active) THEN
        IF (NEW.item_active) THEN
          PERFORM postComment('ChangeLog', 'I', NEW.item_id, 'Activated');
        ELSE
          PERFORM postComment('ChangeLog', 'I', NEW.item_id, 'Deactivated');
        END IF;
      END IF;

      IF (OLD.item_descrip1 <> NEW.item_descrip1) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id, 'Description 1',
                            OLD.item_descrip1, NEW.item_descrip1);
      END IF;

      IF (OLD.item_descrip2 <> NEW.item_descrip2) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id, 'Description 2',
                            OLD.item_descrip2, NEW.item_descrip2);
      END IF;

      IF (OLD.item_inv_uom_id <> NEW.item_inv_uom_id) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id, 'Inventory UOM',
                            (SELECT uom_name FROM uom WHERE uom_id=OLD.item_inv_uom_id),
                            (SELECT uom_name FROM uom WHERE uom_id=NEW.item_inv_uom_id));
      END IF;

      IF (OLD.item_sold <> NEW.item_sold) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id,
                            CASE WHEN (NEW.item_sold) THEN 'Sold Changed from FALSE to TRUE'
                                 ELSE 'Sold Changed from TRUE to FALSE'
                            END);
      END IF;

      IF (OLD.item_picklist <> NEW.item_picklist) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id,
                            CASE WHEN (NEW.item_picklist) THEN 'Pick List Changed from FALSE to TRUE'
                                 ELSE 'Pick List Changed from TRUE to FALSE'
                            END );
      END IF;

      IF (OLD.item_fractional <> NEW.item_fractional) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id,
                            CASE WHEN (NEW.item_fractional) THEN 'Fractional Changed from FALSE to TRUE'
                                 ELSE 'Fractional Changed from TRUE to FALSE'
                            END );
      END IF;

      IF (OLD.item_exclusive <> NEW.item_exclusive) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id,
                            CASE WHEN (NEW.item_exclusive) THEN 'Exclusive Changed from FALSE to TRUE'
                                 ELSE 'Exclusive Changed from TRUE to FALSE'
                            END );
      END IF;
      IF (OLD.item_config <> NEW.item_config) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id,
                            CASE WHEN (NEW.item_config) THEN 'Configured Changed from FALSE to TRUE'
                                 ELSE 'Configured Changed from TRUE to FALSE'
                            END );
      END IF;

      IF (OLD.item_listprice <> NEW.item_listprice) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id, 'List Price',
                            formatSalesPrice(OLD.item_listprice), formatSalesPrice(NEW.item_listprice));
      END IF;

      IF (OLD.item_type <> NEW.item_type) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id, 'Type',
                            OLD.item_type, NEW.item_type);
      END IF;

      IF (OLD.item_price_uom_id <> NEW.item_price_uom_id) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id, 'Price UOM',
                            (SELECT uom_name FROM uom WHERE uom_id=OLD.item_price_uom_id),
                            (SELECT uom_name FROM uom WHERE uom_id=NEW.item_price_uom_id));
      END IF;

      IF (OLD.item_classcode_id <> NEW.item_classcode_id) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id, 'Class Code',
                            (SELECT classcode_code || '-' || classcode_descrip
                             FROM classcode WHERE classcode_id=OLD.item_classcode_id),
                            (SELECT classcode_code || '-' || classcode_descrip
                             FROM classcode WHERE classcode_id=NEW.item_classcode_id));
      END IF;

      IF (OLD.item_freightclass_id <> NEW.item_freightclass_id) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id, 'Freight Class',
                            (SELECT freightclass_code || '-' || freightclass_descrip
                             FROM freightclass WHERE freightclass_id=OLD.item_freightclass_id),
                            (SELECT freightclass_code || '-' || freightclass_descrip
                             FROM freightclass WHERE freightclass_id=NEW.item_freightclass_id));
      END IF;

      IF (OLD.item_prodcat_id <> NEW.item_prodcat_id) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id, 'Product Category',
                            (SELECT prodcat_code || '-' || prodcat_descrip
                             FROM prodcat WHERE prodcat_id=OLD.item_prodcat_id),
                            (SELECT prodcat_code || '-' || prodcat_descrip
                             FROM prodcat WHERE prodcat_id=NEW.item_prodcat_id));
      END IF;

      IF (OLD.item_upccode <> NEW.item_upccode) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id, 'UPC Code',
                            OLD.item_upccode, NEW.item_upccode);
      END IF;

      IF (OLD.item_prodweight <> NEW.item_prodweight) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id, 'Product Weight',
                            formatWeight(OLD.item_prodweight), formatWeight(NEW.item_prodweight));
      END IF;

      IF (OLD.item_packweight <> NEW.item_packweight) THEN
          PERFORM postComment('ChangeLog', 'I', NEW.item_id, 'Packaging Weight',
                              formatWeight(OLD.item_packweight), formatWeight(NEW.item_packweight));
      END IF;

      IF (OLD.item_maxcost <> NEW.item_maxcost) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id, 'Maximum Desired Cost',
                            formatCost(OLD.item_maxcost), formatCost(NEW.item_maxcost));
      END IF;

      IF (OLD.item_listcost <> NEW.item_listcost) THEN
        PERFORM postComment('ChangeLog', 'I', NEW.item_id, 'List Cost',
                            formatCost(OLD.item_listcost), formatCost(NEW.item_listcost));
      END IF;
    END IF;
  END IF;

  IF (TG_OP = 'DELETE') THEN
    DELETE FROM imageass WHERE ((imageass_source_id=OLD.item_id) AND (imageass_source='I'));
    DELETE FROM url WHERE ((url_source_id=OLD.item_id) AND (url_source='I'));
    DELETE FROM docass WHERE docass_source_id = OLD.item_id AND docass_source_type = 'I';
    DELETE FROM docass WHERE docass_target_id = OLD.item_id AND docass_target_type = 'I';

    RETURN OLD;
  END IF;

  RETURN NEW;

END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS itemAfterTrigger ON item;
CREATE TRIGGER itemAfterTrigger
  AFTER INSERT OR UPDATE OR DELETE
  ON item
  FOR EACH ROW
  EXECUTE PROCEDURE _itemAfterTrigger();

CREATE OR REPLACE FUNCTION _itemAfterDeleteTrigger() RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE

BEGIN

  DELETE
  FROM charass
  WHERE charass_target_type = 'I'
    AND charass_target_id = OLD.item_id;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('TRIGGER', 'itemAfterDeleteTrigger');
CREATE TRIGGER itemAfterDeleteTrigger
  AFTER DELETE
  ON item
  FOR EACH ROW
  EXECUTE PROCEDURE _itemAfterDeleteTrigger();

CREATE OR REPLACE FUNCTION public._item_uom_check()
  RETURNS trigger AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.

-- This trigger checks the all item uom_id columns have valid conversion ratios.
BEGIN

  IF (NEW.item_active AND NEW.item_sold) THEN
    IF (NEW.item_inv_uom_id <> NEW.item_price_uom_id) THEN
      BEGIN
        PERFORM itemuomtouomratio(NEW.item_id, NEW.item_inv_uom_id, NEW.item_price_uom_id)
        FROM item
        WHERE TRUE
          AND item_id = NEW.item_id;
      EXCEPTION
        WHEN SQLSTATE 'P0001' THEN
          RAISE EXCEPTION 'An invalid UOM was set on this item. Please verify that the Unit Price UOM has a conversion to the Inventory UOM.';
      END;
    END IF;

  END IF;

  RETURN NEW;

END;
$$ LANGUAGE plpgsql;
ALTER FUNCTION public._item_uom_check() OWNER TO admin;

SELECT dropIfExists('TRIGGER', 'item_uom_check');
CREATE TRIGGER item_uom_check
  BEFORE INSERT OR UPDATE ON public.item
  FOR EACH ROW
  EXECUTE PROCEDURE public._item_uom_check();
