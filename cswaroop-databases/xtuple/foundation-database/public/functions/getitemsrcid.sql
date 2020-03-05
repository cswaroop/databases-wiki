CREATE OR REPLACE FUNCTION getItemSrcId(pItemNumber TEXT,
                                        pVendNumber TEXT) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _returnVal INTEGER;
BEGIN
  IF ((pItemNumber IS NULL) OR (pVendNumber IS NULL)) THEN
    RETURN NULL;
  END IF;

  SELECT itemsrc_id INTO _returnVal
  FROM itemsrc
  WHERE ((itemsrc_item_id=getItemId(pItemNumber))
  AND (itemsrc_vend_id=getVendId(pVendNumber)));

  IF (_returnVal IS NULL) THEN
	RAISE EXCEPTION 'Item Source Item % Vendor % not found.', pItemNumber,pVendNumber;
  END IF;

  RETURN _returnVal;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getItemSrcId(pItemNumber TEXT,
                                        pVendNumber TEXT,
                                        pEffective DATE,
                                        pExpires DATE) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _returnVal INTEGER;
BEGIN
  IF ((pItemNumber IS NULL) OR (pVendNumber IS NULL) OR
      (pEffective IS NULL) OR (pExpires IS NULL)) THEN
    RETURN NULL;
  END IF;

  SELECT itemsrc_id INTO _returnVal
  FROM itemsrc
  WHERE ((itemsrc_item_id=getItemId(pItemNumber))
  AND (itemsrc_vend_id=getVendId(pVendNumber))
  AND (itemsrc_effective=pEffective)
  AND (itemsrc_expires=pExpires));

  IF (_returnVal IS NULL) THEN
        RAISE EXCEPTION 'Item Source Item % Vendor % Effective % Expires % not found. [xtuple: getItemSrcId, -1]',
          pItemNumber,pVendNumber,pEffective,pExpires;
  END IF;

  RETURN _returnVal;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getItemSrcId(pItemNumber TEXT,
                                        pVendNumber TEXT,
                                        pVendItemNumber TEXT) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _returnVal INTEGER;
BEGIN
  IF ((pItemNumber IS NULL) OR (pVendNumber IS NULL) OR
      (pVendItemNumber IS NULL)) THEN
    RETURN NULL;
  END IF;

  SELECT itemsrc_id INTO _returnVal
  FROM itemsrc
  WHERE ((itemsrc_item_id=getItemId(pItemNumber))
  AND (itemsrc_vend_id=getVendId(pVendNumber))
  AND (itemsrc_vend_item_number=pVendItemNumber));

  IF (_returnVal IS NULL) THEN
        RAISE EXCEPTION 'Item Source Item % Vendor % Vend Item % not found. [xtuple: getItemSrcId, -1]',
          pItemNumber,pVendNumber,pVendItemNumber;
  END IF;

  RETURN _returnVal;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getItemSrcId(pItemNumber TEXT,
                                        pVendNumber TEXT,
                                        pVendItemNumber TEXT,
                                        pEffective DATE,
                                        pExpires DATE) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _returnVal INTEGER;
BEGIN
  IF (pVendItemNumber IS NULL) THEN
    IF((pEffective IS NULL) AND (pExpires IS NULL)) THEN
      RETURN getItemSrcId(pItemNumber, pVendNumber);
    ELSE
      RETURN getItemSrcId(pItemNumber, pVendNumber, pEffective, pExpires);
    END IF;
  ELSIF((pEffective IS NULL) AND (pExpires IS NULL)) THEN 
    RETURN getItemSrcId(pItemNumber, pVendNumber, pVendItemNumber);
  ELSIF((pItemNumber IS NULL) OR (pVendNumber IS NULL) OR
          (pVendItemNumber IS NULL) OR (pEffective IS NULL) OR (pExpires IS NULL)) THEN
    RETURN NULL;
  END IF;

  SELECT itemsrc_id INTO _returnVal
  FROM itemsrc
  WHERE ((itemsrc_item_id=getItemId(pItemNumber))
  AND (itemsrc_vend_id=getVendId(pVendNumber))
  AND (itemsrc_vend_item_number=pVendItemNumber)
  AND (itemsrc_effective=pEffective)
  AND (itemsrc_expires=pExpires));

  IF (_returnVal IS NULL) THEN
        RAISE EXCEPTION 'Item Source Item % Vendor % Vend Item % Effective % Expires % not found. [xtuple: getItemSrcId, -1]',
          pItemNumber,pVendNumber,pVendItemNumber,pEffective,pExpires;
  END IF;

  RETURN _returnVal;
END;
$$ LANGUAGE plpgsql;
