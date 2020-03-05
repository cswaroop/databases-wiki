CREATE OR REPLACE FUNCTION getRevId(pType       text,
                                    pItemNumber text,
                                    pRevision   text) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _returnVal INTEGER;
BEGIN
  IF (pItemNumber IS NULL) THEN
    RETURN NULL;
  END IF;

  IF (NOT fetchMetricBool('RevControl')) THEN
    RETURN -1;
  ELSIF ( (pRevision IS NULL) OR (LENGTH(pRevision)=0) ) THEN
    SELECT getActiveRevId(pType, getItemId(pItemNumber)) INTO _returnVal;
  ELSE
    IF (pType='BOM') THEN
      SELECT rev_id INTO _returnVal
      FROM item, bomhead, rev
      WHERE ((item_id=bomhead_item_id)
      AND (bomhead_rev_id=rev_id)
      AND (UPPER(item_number)=UPPER(pItemNumber))
      AND (rev_number=pRevision));
    ELSIF pType = 'BOO' AND packageIsEnabled('xtmfg') THEN
      SELECT rev_id INTO _returnVal
      FROM item, xtmfg.boohead, rev
      WHERE ((item_id=boohead_item_id)
      AND (boohead_rev_id=rev_id)
      AND (UPPER(item_number)=UPPER(pItemNumber))
      AND (rev_number=pRevision));   
    ELSE
      RAISE EXCEPTION 'Invalid Revision Type.';
    END IF;
  END IF;
    
  IF (_returnVal IS NULL) THEN
    RAISE EXCEPTION '% revision % for % not found.', pType, pRevision, pItemNumber;
  END IF;

  RETURN _returnVal;
END;
$$ LANGUAGE plpgsql;
