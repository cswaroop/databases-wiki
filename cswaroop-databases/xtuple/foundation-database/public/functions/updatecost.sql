CREATE OR REPLACE FUNCTION updateCost(pItemcostid INTEGER,
                                      pCost NUMERIC) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  RETURN updateCost(pItemcostid, pCost, baseCurrId());
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION updateCost(pItemcostid INTEGER,
                                      pCost NUMERIC,
                                      pCurrId INTEGER) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  UPDATE itemcost
     SET itemcost_actcost=pCost,
         itemcost_updated=CURRENT_DATE,
         itemcost_curr_id=pCurrId
   WHERE (itemcost_id=pItemcostid);

  RETURN pItemcostid;

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION updateCost(INTEGER, TEXT, BOOLEAN, NUMERIC) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  RETURN updateCost($1, $2, $3, $4, baseCurrId());
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION updateCost(INTEGER, INTEGER, BOOLEAN, NUMERIC) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  RETURN updateCost($1, $2, $3, $4, baseCurrId());
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION updateCost(pItemid INTEGER,
                                      pCosttype TEXT,
                                      pLevel BOOLEAN,
                                      pCost NUMERIC,
                                      pCurrid INTEGER) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _cost NUMERIC;
  _currId INTEGER;
  _p RECORD;
  _itemcostid INTEGER;

BEGIN

  IF (pCost IS NULL) THEN
    _cost = 0;
  ELSE
    _cost = pCost;
  END IF;

  IF (pCurrId IS NULL) THEN
    _currId := baseCurrID();
  ELSE
    _currId := pCurrId;
  END IF;

  SELECT itemcost_id, itemcost_stdcost INTO _p
  FROM itemcost, costelem
  WHERE ( (itemcost_costelem_id=costelem_id)
   AND (itemcost_item_id=pItemid)
   AND (itemcost_lowlevel=pLevel)
   AND (costelem_type=pCosttype) );

  IF (NOT FOUND) THEN
    IF (_cost > 0) THEN
      SELECT NEXTVAL('itemcost_itemcost_id_seq') INTO _itemcostid;
      INSERT INTO itemcost
      ( itemcost_id, itemcost_item_id, itemcost_costelem_id, itemcost_lowlevel,
        itemcost_stdcost, itemcost_posted, itemcost_actcost, itemcost_updated,
        itemcost_curr_id )
      SELECT _itemcostid, pItemid, costelem_id, pLevel,
             0, startOfTime(), _cost, CURRENT_DATE,
             _currId
      FROM costelem
      WHERE (costelem_type=pCosttype);

      RETURN _itemcostid;

    ELSE
      RETURN -1;
    END IF;

  ELSE
    UPDATE itemcost
    SET itemcost_actcost=_cost,
        itemcost_curr_id = _currId,
        itemcost_updated=CURRENT_DATE
    WHERE (itemcost_id=_p.itemcost_id);

    RETURN _p.itemcost_id;
  END IF;

END;
$$ LANGUAGE plpgsql; 


CREATE OR REPLACE FUNCTION updateCost(pItemid INTEGER,
                                      pCostelemid INTEGER,
                                      pLevel BOOLEAN,
                                      pCost NUMERIC,
                                      pCurrid INTEGER) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _cost NUMERIC;
  _currId INTEGER;
  _p RECORD;
  _itemcostid INTEGER;

BEGIN

  IF (pCost IS NULL) THEN
    _cost = 0;
  ELSE
    _cost = pCost;
  END IF;

  IF (pCurrId IS NULL) THEN
    _currId := baseCurrID();
  ELSE
    _currId := pCurrId;
  END IF;

  SELECT itemcost_id, itemcost_stdcost INTO _p
  FROM itemcost
  WHERE ((itemcost_costelem_id=pCostelemid)
   AND (itemcost_item_id=pItemid)
   AND (itemcost_lowlevel=pLevel) );

  IF (NOT FOUND) THEN
    IF (_cost > 0) THEN
      SELECT NEXTVAL('itemcost_itemcost_id_seq') INTO _itemcostid;
      INSERT INTO itemcost
      ( itemcost_id, itemcost_item_id, itemcost_costelem_id, itemcost_lowlevel,
        itemcost_stdcost, itemcost_posted, itemcost_actcost, itemcost_updated,
        itemcost_curr_id )
      SELECT _itemcostid, pItemid, costelem_id, pLevel,
             0, startOfTime(), _cost, CURRENT_DATE,
             _currId
      FROM costelem
      WHERE (costelem_id=pCostelemid);

      RETURN _itemcostid;

    ELSE
      RETURN -1;
    END IF;

  ELSE
    UPDATE itemcost
    SET itemcost_actcost=_cost,
        itemcost_curr_id = _currId,
        itemcost_updated=CURRENT_DATE
    WHERE (itemcost_id=_p.itemcost_id);

    RETURN _p.itemcost_id;
  END IF;

END;
$$ LANGUAGE plpgsql; 
