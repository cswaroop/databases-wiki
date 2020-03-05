CREATE OR REPLACE FUNCTION getItemsiteId(text, text) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pWarehouseCode ALIAS FOR $1;
  pItemNumber ALIAS FOR $2;
  _returnVal INTEGER;
BEGIN
  SELECT getItemsiteId(pWarehouseCode,pItemNumber,'ALL') INTO _returnVal;

  RETURN _returnVal;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getItemsiteId(text, text, text) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pWarehouseCode ALIAS FOR $1;
  pItemNumber ALIAS FOR $2;
  pType ALIAS FOR $3;
  _type TEXT;
  _p RECORD;
BEGIN
  IF ((pWarehouseCode IS NULL) OR (pItemNumber IS NULL)) THEN
	RETURN NULL;
  END IF;
 
  IF UPPER(pType) NOT IN ('ALL','ACTIVE','SOLD') THEN
    RAISE EXCEPTION 'Invalid Type %. Valid Itemsite types are ALL and SOLD', pType;
  END IF;

  SELECT item_id,     item_active,     item_sold,
         itemsite_id, itemsite_active, itemsite_sold INTO _p
  FROM itemsite join item ON itemsite_item_id = item_id
  WHERE itemsite_warehous_id = getWarehousId(pWarehouseCode,'ALL')
    AND item_number = UPPER(pItemNumber);

  IF NOT (FOUND) THEN
    RAISE EXCEPTION 'Item % not found in Warehouse %', pItemNumber, pWarehouseCode;
  ELSIF ((UPPER(pType)='ACTIVE') OR (UPPER(pType)='SOLD')) THEN
    IF NOT (_p.item_active) THEN
      RAISE EXCEPTION 'Item % is inactive.', pItemNumber;
    ELSE
      IF NOT (_p.itemsite_active) THEN
        RAISE EXCEPTION 'Item % is inactive in Warehouse %', pItemNumber, pWarehouseCode;
      ELSE
        IF ((UPPER(pType)='SOLD') AND NOT _p.item_sold) THEN
          RAISE EXCEPTION 'Item % is not sold', pItemNumber;
        ELSE
          IF ((UPPER(pType)='SOLD') AND NOT _p.itemsite_sold) THEN
            RAISE EXCEPTION 'Item % is not sold from Warehouse %', pItemNumber, pWarehouseCode;
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

  RETURN _p.itemsite_id;
END;
$$ LANGUAGE plpgsql;
