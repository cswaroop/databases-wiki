DROP FUNCTION IF EXISTS insertItemCost(INTEGER, INTEGER, INTEGER, NUMERIC, BOOLEAN) CASCADE;
CREATE OR REPLACE FUNCTION insertItemCost(pItemId INTEGER, pCostElemId INTEGER, pCurrId INTEGER, pCost NUMERIC, pPostToStandard BOOLEAN) RETURNS INTEGER AS $BODY$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
_itemcost_id INTEGER;

--This function is used with the api.itemcost View for updating and inserting
--into the itemcosts table

BEGIN
  IF (pCost IS NULL OR pCost < 0) THEN
    RAISE EXCEPTION 'itemcost Actual Cost % Invalid [xtuple: insertItemCost, -4, %, %, %]',
                    pCost, pItemId, pCostElemId, pCost;
  END IF;

-- Check for uniqueness
  SELECT itemcost_id INTO _itemcost_id
  FROM itemcost
  WHERE ( (itemcost_item_id = pItemId)
    AND   (itemcost_costelem_id = pCostElemId)
    AND   (NOT itemcost_lowlevel) );
  IF (FOUND) THEN
    RAISE EXCEPTION 'itemcost already exists for this Item and Cost Element [xtuple: insertItemCost, -3, %, %]',
                     pItemId, pCostElemId;
  END IF;

-- Check for valid combination of item_type and costelem_type
  IF (SELECT (COUNT(*) > 0)
      FROM item, costelem
      WHERE (item_id=pItemId)
        AND (costelem_id=pCostElemId)
        AND (item_type IN ('M', 'F', 'B', 'C', 'T'))
        AND (costelem_type IN ('Material'))) THEN
    RAISE EXCEPTION 'itemcost of this type is invalid for Manufactured Item [xtuple: insertItemCost, -5, %, %]',
                    pItemId, pCostElemId;
  END IF;

  IF (SELECT (COUNT(*) > 0)
      FROM item, costelem
      WHERE (item_id=pItemId)
        AND (costelem_id=pCostElemId)
        AND (item_type IN ('O', 'P'))
        AND (costelem_type IN ('Direct Labor', 'Overhead', 'Machine Overhead'))) THEN
    RAISE EXCEPTION 'itemcost of this type is invalid for Purchased Item [xtuple: insertItemCost, -6, %, %]',
                    pItemId, pCostElemId;
  END IF;

  SELECT NEXTVAL('itemcost_itemcost_id_seq') INTO _itemcost_id;
  INSERT INTO itemcost
    ( itemcost_id, itemcost_item_id, itemcost_costelem_id, itemcost_lowlevel,
      itemcost_stdcost, itemcost_posted, itemcost_actcost, itemcost_updated, itemcost_curr_id )
  VALUES
    ( _itemcost_id, pItemId, pCostElemId, FALSE,
      0, startOfTime(), pCost, CURRENT_DATE, pCurrId );

  --Only Post Cost to standard if the parameter is set to true
  IF (pPostToStandard) THEN
    IF (NOT checkPrivilege('PostStandardCosts')) THEN
      RAISE EXCEPTION 'You do not have privileges to post standard itemcosts. Set api.itemcost post_to_standard to false [xtuple: insertItemCost, -7]';
    END IF;
    IF NOT postcost(_itemcost_id) THEN
      RAISE EXCEPTION 'Posting standard cost failed [xtuple: insertItemCost, -2, %, %]', pItemId, pCostElemId;
    END IF;
  END IF;

  RETURN _itemcost_id;

END;
$BODY$
  LANGUAGE plpgsql;
