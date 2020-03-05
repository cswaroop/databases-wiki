CREATE OR REPLACE FUNCTION deleteItemSite(pItemsiteid INTEGER) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _mfg      BOOLEAN := fetchMetricText('Application')
                       NOT IN ('PostBooks', 'Standard');
  _standard BOOLEAN := (fetchMetricText('Application') = 'Standard');

BEGIN

  IF EXISTS(SELECT 1 FROM itemsite
             WHERE itemsite_id=pItemsiteid
               AND itemsite_qtyonhand <> 0) THEN
    RETURN -9;
  END IF;

  IF EXISTS(SELECT 1 FROM invhist WHERE invhist_itemsite_id = pItemsiteid) THEN
    RETURN -1;
  END IF;

  IF fetchMetricBool('LotSerialControl') AND
     EXISTS(SELECT 1 FROM lsdetail
             WHERE lsdetail_itemsite_id = pItemsiteid) THEN
    RETURN -1;
  END IF;

  IF EXISTS(SELECT 1 FROM wo WHERE wo_itemsite_id = pItemsiteid) THEN
    RETURN -2;
  END IF;

  IF EXISTS(SELECT 1 FROM womatl WHERE womatl_itemsite_id = pItemsiteid) THEN
    RETURN -2;
  END IF;

  IF EXISTS(SELECT 1 FROM womatlvar
             WHERE womatlvar_parent_itemsite_id    = pItemsiteid
                OR womatlvar_component_itemsite_id = pItemsiteid) THEN
    RETURN -2;
  END IF;

  IF fetchMetricBool('BBOM') AND _mfg THEN
    IF EXISTS(SELECT 1 FROM xtmfg.brdvar
               WHERE brdvar_itemsite_id        = pItemsiteid
                  OR brdvar_parent_itemsite_id = pItemsiteid) THEN
      RETURN -2;
    END IF;
  END IF;

  IF EXISTS(SELECT 1 FROM coitem WHERE coitem_itemsite_id = pItemsiteid) THEN
    RETURN -3;
  END IF;

  IF EXISTS(SELECT 1 FROM cohist WHERE cohist_itemsite_id = pItemsiteid) THEN
    RETURN -3;
  END IF;

  IF EXISTS(SELECT 1 FROM quitem WHERE quitem_itemsite_id = pItemsiteid) THEN
    RETURN -3;
  END IF;

  IF EXISTS(SELECT 1 FROM cmitem WHERE cmitem_itemsite_id = pItemsiteid) THEN
    RETURN -3;
  END IF;

  IF EXISTS(SELECT 1 FROM poitem WHERE poitem_itemsite_id = pItemsiteid) THEN
    RETURN -4;
  END IF;

  IF EXISTS(SELECT 1 FROM recv WHERE recv_itemsite_id = pItemsiteid) THEN
    RETURN -4;
  END IF;

  IF EXISTS(SELECT 1 FROM poreject
             WHERE poreject_itemsite_id = pItemsiteid) THEN
    RETURN -4;
  END IF;

  IF EXISTS(SELECT 1 FROM pr WHERE pr_itemsite_id = pItemsiteid) THEN
    RETURN -4;
  END IF;

  IF _mfg OR _standard THEN
    IF EXISTS(SELECT 1 FROM planord
               WHERE planord_itemsite_id = pItemsiteid) THEN
      RETURN -5;
    END IF;

    IF EXISTS(SELECT 1 FROM itemsite
               WHERE itemsite_supply_itemsite_id = pItemsiteid) THEN
      RETURN -7;
    END IF;
  END IF;

  IF _mfg AND packageIsEnabled('xtmfg') THEN
    IF EXISTS(SELECT 1 FROM xtmfg.pschitem
               WHERE pschitem_itemsite_id = pItemsiteid) THEN
      RETURN -6;
    END IF;

    IF EXISTS(SELECT 1 FROM xtmfg.woopervar
               WHERE woopervar_parent_itemsite_id = pItemsiteid) THEN
      RETURN -2;
    END IF;
  END IF;

  DELETE FROM invcnt
  WHERE (invcnt_itemsite_id=pItemsiteid);

  DELETE FROM itemloc
  WHERE (itemloc_itemsite_id=pItemsiteid);
  DELETE FROM itemlocdist
  WHERE (itemlocdist_itemsite_id=pItemsiteid);

  IF fetchMetricBool('BBOM') AND packageIsEnabled('xtmfg') THEN
    DELETE FROM xtmfg.brddist
    WHERE (brddist_itemsite_id=pItemsiteid);
  END IF;

  DELETE FROM itemsite
  WHERE (itemsite_id=pItemsiteid);

  RETURN 0;

END;
$$ LANGUAGE plpgsql;
