CREATE OR REPLACE FUNCTION updateItemSiteLeadTime(pItemsiteid INTEGER,
                                                  pPad        INTEGER)
  RETURNS INTEGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _itemtype           TEXT;
  _materialLeadTime   INTEGER;
  _productionLeadTime INTEGER;
  _leadTime           INTEGER;

BEGIN

  SELECT item_type INTO _itemtype
  FROM item JOIN itemsite ON itemsite_item_id = item_id
  WHERE itemsite_id = pitemsiteid;

  IF _itemtype = 'M' THEN
    SELECT MAX(component.itemsite_leadtime) INTO _materialLeadTime
    FROM bomitem, itemsite AS parent, itemsite AS component
    WHERE ( (bomitem_parent_item_id=parent.itemsite_item_id)
     AND (bomitem_rev_id=getActiveRevId('BOM',bomitem_parent_item_id))
     AND (bomitem_item_id=component.itemsite_item_id)
     AND (parent.itemsite_warehous_id=component.itemsite_warehous_id)
     AND (parent.itemsite_id=pItemsiteid) );

    IF packageIsEnabled('xtmfg') THEN
      SELECT COALESCE(MAX(booitem_execday), 0) INTO _productionLeadTime
      FROM xtmfg.booitem, itemsite
      WHERE ( (booitem_item_id=itemsite_item_id)
       AND (booitem_rev_id=getActiveRevId('BOO',booitem_item_id))
       AND (itemsite_id=pItemsiteid) );
    END IF;

    _leadTime := COALESCE(_materialLeadTime, 0)
               + COALESCE(_productionLeadTime, 0) + COALESCE(pPad, 0);

  ELSIF _itemtype IN ('P') THEN
    SELECT COALESCE(MAX(itemsrc_leadtime), 0) INTO _leadTime
    FROM itemsrc, itemsite
    WHERE ( (itemsite_item_id=itemsrc_item_id)
     AND (itemsite_id=pItemsiteid) );

    _leadTime := (_leadTime + pPad);

  ELSE
    _leadTime = pPad;
  END IF;

  UPDATE itemsite
  SET itemsite_leadtime=_leadTime
  WHERE (itemsite_id=pItemsiteid);

  RETURN _leadTime;

END;
$$ LANGUAGE plpgsql;
