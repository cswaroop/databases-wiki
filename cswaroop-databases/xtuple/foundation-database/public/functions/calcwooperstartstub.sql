CREATE OR REPLACE FUNCTION calcWooperStartStub(pWoId         INTEGER,
                                               pBooitemSeqId INTEGER)
  RETURNS DATE AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  IF (fetchMetricBool('Routings') AND packageIsEnabled('xtmfg')) THEN
    RETURN xtmfg.calcWooperStart(pWoId, pBooitemSeqId);
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

