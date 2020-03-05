CREATE OR REPLACE FUNCTION createItemUOMConv(pItemId INTEGER,
                                             pUomId INTEGER,
                                             pUomType TEXT) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _iteminvuomid INTEGER;
  _itemuomconvid INTEGER;
  _itemuomid INTEGER;
  _uomconvid INTEGER;
  _uomtypeid INTEGER;

BEGIN
  -- Find the item inv uom
  SELECT item_inv_uom_id INTO _iteminvuomid
  FROM item
  WHERE (item_id=pItemId);

  -- Find the corresponding item uom conversion
  SELECT itemuomconv_id INTO _itemuomconvid
  FROM itemuomconv
  WHERE (itemuomconv_item_id=pItemId)
    AND ( (itemuomconv_from_uom_id=_iteminvuomid AND itemuomconv_to_uom_id=pUomId) OR
          (itemuomconv_to_uom_id=_iteminvuomid AND itemuomconv_from_uom_id=pUomId) )
  LIMIT 1;

  IF (NOT FOUND) THEN
    -- Find the corresponding global uom conversion
    SELECT uomconv_id INTO _uomconvid
    FROM uomconv
    WHERE ( (uomconv_from_uom_id=_iteminvuomid AND uomconv_to_uom_id=pUomId) OR
          (uomconv_to_uom_id=_iteminvuomid AND uomconv_from_uom_id=pUomId) )
    LIMIT 1;

    IF (NOT FOUND) THEN
      RAISE EXCEPTION 'Cannot find global uom conversion';
    END IF;

    -- Insert itemuomconv
    INSERT INTO itemuomconv
      (itemuomconv_item_id, itemuomconv_from_uom_id, itemuomconv_from_value,
       itemuomconv_to_uom_id, itemuomconv_to_value, itemuomconv_fractional,
       itemuomconv_active)
    SELECT
       pItemId, uomconv_from_uom_id, uomconv_from_value,
       uomconv_to_uom_id, uomconv_to_value, uomconv_fractional,
       TRUE
    FROM uomconv
    WHERE (uomconv_id=_uomconvid)
    RETURNING itemuomconv_id INTO _itemuomconvid;
  END IF;

  -- Find the uom type
  SELECT uomtype_id INTO _uomtypeid
  FROM uomtype
  WHERE (uomtype_name=pUomType);

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'Cannot find uom type';
  END IF;

  -- Find the corresponding item uom
  SELECT itemuom_id INTO _itemuomid
  FROM itemuom
  WHERE (itemuom_itemuomconv_id=_itemuomconvid)
    AND (itemuom_uomtype_id=_uomtypeid);

  IF (NOT FOUND) THEN
    -- Insert itemuom
    INSERT INTO itemuom
      (itemuom_itemuomconv_id, itemuom_uomtype_id)
    VALUES
      (_itemuomconvid, _uomtypeid);
  END IF;

  RETURN 0;
END;
$$ LANGUAGE plpgsql;
