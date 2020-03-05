CREATE OR REPLACE FUNCTION doUpdateCosts(plowerMaterial      BOOLEAN,
                                         pdirectLabor        BOOLEAN,
                                         plowerDirectLabor   BOOLEAN,
                                         poverhead           BOOLEAN,
                                         plowerOverhead      BOOLEAN,
                                         pmachOverhead       BOOLEAN,
                                         plowerMachOverhead  BOOLEAN,
                                         plowerUser          BOOLEAN,
                                         prollUp             BOOLEAN)
  RETURNS INTEGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  RETURN doUpdateCosts(plowerMaterial, pdirectLabor, plowerDirectLabor,
		       poverhead, plowerOverhead, pmachOverhead,
		       plowerMachOverhead, plowerUser, prollUp, TRUE);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION doUpdateCosts(plowerMaterial      BOOLEAN,
                                         pdirectLabor        BOOLEAN,
                                         plowerDirectLabor   BOOLEAN,
                                         poverhead           BOOLEAN,
                                         plowerOverhead      BOOLEAN,
                                         pmachOverhead       BOOLEAN,
                                         plowerMachOverhead  BOOLEAN,
                                         plowerUser          BOOLEAN,
                                         prollUp             BOOLEAN,
                                         pActual             BOOLEAN)
  RETURNS INTEGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _item RECORD;
  _bom RECORD;
  _result INTEGER := 0;

BEGIN

  PERFORM resetLowLevelCode(-1);

  FOR _item IN SELECT costUpdate_item_id
            FROM costUpdate
            ORDER BY costUpdate_lowlevel_code DESC LOOP
    PERFORM doUpdateCosts(_item.costUpdate_item_id, false, plowerMaterial,
		  pdirectLabor, plowerDirectLabor, poverhead, plowerOverhead,
		  pmachOverhead, plowerMachOverhead, plowerUser, prollUp,
		  pActual);
  END LOOP;

  RETURN _result;

END;
 $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION doUpdateCosts(pItemId             INTEGER,
                                         pResetLowLevel      BOOLEAN,
                                         plowerMaterial      BOOLEAN,
                                         pdirectLabor        BOOLEAN,
                                         plowerDirectLabor   BOOLEAN,
                                         poverhead           BOOLEAN,
                                         plowerOverhead      BOOLEAN,
                                         pmachOverhead       BOOLEAN,
                                         plowerMachOverhead  BOOLEAN,
                                         plowerUser          BOOLEAN,
                                         prollUp             BOOLEAN)
   RETURNS INTEGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
    RETURN doUpdateCosts(pItemId, pResetLowLevel, plowerMaterial, pdirectLabor,
			 plowerDirectLabor, poverhead, plowerOverhead,
			 pmachOverhead, plowerMachOverhead, plowerUser, prollUp,
			 TRUE);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION doUpdateCosts(pItemId             INTEGER,
                                         pResetLowLevel      BOOLEAN,
                                         plowerMaterial      BOOLEAN,
                                         pdirectLabor        BOOLEAN,
                                         plowerDirectLabor   BOOLEAN,
                                         poverhead           BOOLEAN,
                                         plowerOverhead      BOOLEAN,
                                         pmachOverhead       BOOLEAN,
                                         plowerMachOverhead  BOOLEAN,
                                         plowerUser          BOOLEAN,
                                         prollUp             BOOLEAN,
                                         pUpdateActual       BOOLEAN)
  RETURNS INTEGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE

  _item RECORD;
  _bom RECORD;
  _result INTEGER := 0;
  _resultFromReset INTEGER;
  _counterNum INTEGER;
  _feedBackNum INTEGER;
  _hasMfg      BOOLEAN := packageIsEnabled('xtmfg');

BEGIN

    IF (pResetLowLevel) THEN
	PERFORM resetLowLevelCode(pItemId);
    END IF;

    SELECT costUpdate_item_id AS item_id, costUpdate_item_type AS item_type
	INTO _item
    FROM costUpdate
    WHERE costUpdate_item_id = pItemId;

    IF ((plowerMaterial) AND ((_item.item_type <> 'P') AND (_item.item_type <> 'O'))) THEN
      PERFORM updateSorACost(_item.item_id, 'Material', TRUE, lowerCost(_item.item_id, 'Material', pUpdateActual), pUpdateActual);
    END IF;

    IF (pdirectLabor AND _hasMfg) THEN
      PERFORM updateSorACost(_item.item_id, 'Direct Labor', FALSE, xtmfg.directLaborCost(_item.item_id), pUpdateActual);
    END IF;

    IF (plowerDirectLabor) THEN
      PERFORM updateSorACost(_item.item_id, 'Direct Labor', TRUE, lowerCost(_item.item_id, 'Direct Labor', pUpdateActual), pUpdateActual);
    END IF;

    IF (poverhead AND _hasMfg) THEN
      PERFORM updateSorACost(_item.item_id, 'Overhead', FALSE, xtmfg.overheadCost(_item.item_id), pUpdateActual);
    END IF;

    IF (plowerOverhead) THEN
      PERFORM updateSorACost(_item.item_id, 'Overhead', TRUE, lowerCost(_item.item_id, 'Overhead', pUpdateActual), pUpdateActual);
    END IF;

    IF (pmachOverhead AND _hasMfg) THEN
      PERFORM updateSorACost(_item.item_id, 'Machine Overhead', FALSE, xtmfg.machineOverheadCost(_item.item_id), pUpdateActual);
    END IF;

    IF (plowerMachOverhead) THEN
      PERFORM updateSorACost(_item.item_id, 'Machine Overhead', TRUE, lowerCost(_item.item_id, 'Machine Overhead', pUpdateActual), pUpdateActual);
    END IF;

    IF (plowerUser) THEN
      PERFORM updateLowerUserCosts(_item.item_id, pUpdateActual);
    END IF;

    IF (prollUp) THEN
      PERFORM rollUpSorACost(_item.item_id, pUpdateActual);
    END IF;

    RETURN _result;

END;
$$ LANGUAGE plpgsql;

