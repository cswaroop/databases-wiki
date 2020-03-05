DROP FUNCTION IF EXISTS updateItemCost(INTEGER, INTEGER, INTEGER, NUMERIC, BOOLEAN) CASCADE;
CREATE OR REPLACE FUNCTION updateItemCost(pItemId INTEGER, pCostElemId INTEGER, pCurrId INTEGER, pCost NUMERIC, pPostToStandard BOOLEAN) RETURNS INTEGER AS $BODY$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
_itemcost_id INTEGER;
_update_return INTEGER;

--This function is used with the api.itemcost View for updating
--the itemcost table

BEGIN
  SELECT itemcost_id INTO _itemcost_id
  FROM itemcost
  WHERE ( (itemcost_item_id = pItemId) AND (itemcost_costelem_id = pCostElemId) );

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'itemcost % not found for % [xtuple: updateItemCost, -3, %, %]',
                    pCostElemId, pItemId, pItemId, pCostElemId;
  END IF;

  IF (pCost IS NULL OR pCost < 0) THEN
    RAISE EXCEPTION 'itemcost Actual Cost Invalid % [xtuple: updateItemCost, -4, %, %]',
                     pCost, pItemId, pCostElemId;
  END IF;

  UPDATE itemcost
  SET itemcost_actcost=pCost,
      itemcost_curr_id = pCurrId
  WHERE (itemcost_id=_itemcost_id);

  --Only Post Cost to standard if the parameter is set to true
  IF (pPostToStandard) THEN
    IF (NOT checkPrivilege('PostStandardCosts')) THEN
      RAISE EXCEPTION 'You do not have privileges to post standard itemcosts. Set api.itemcost post_to_standard to false [xtuple: updateItemCost, -5]';
    END IF;
    IF NOT postcost(_itemcost_id) THEN
      RAISE EXCEPTION 'Posting standard cost failed [xtuple: updateItemCost, -2, %, %]', pItemId, pCostElemId;
    END IF;
  END IF;

  RETURN _itemcost_id;

END;
$BODY$
  LANGUAGE plpgsql;
