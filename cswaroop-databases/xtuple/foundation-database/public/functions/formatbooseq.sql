
CREATE OR REPLACE FUNCTION formatBooSeq(pItemid       INTEGER,
                                        pBooitemSeqId INTEGER) RETURNS TEXT AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _result TEXT;
  
BEGIN

  IF fetchMetricBool('Routings') AND packageIsEnabled('xtmfg') THEN
    SELECT booitem_seqnumber::text INTO _result
    FROM xtmfg.booitem(pItemid)
    WHERE (booitem_seq_id=pBooitemSeqId);
  END IF;

  RETURN _result;

END;
$$ LANGUAGE plpgsql;

