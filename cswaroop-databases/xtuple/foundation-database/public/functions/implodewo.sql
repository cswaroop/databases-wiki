CREATE OR REPLACE FUNCTION implodeWo(pWoid INTEGER,
                                     pImplodeChildren BOOLEAN) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  resultCode INTEGER;
  _routings  BOOLEAN;
  _wo        RECORD;

BEGIN
  _routings := fetchMetricBool('Routings') AND packageIsEnabled('xtmfg');

  SELECT * INTO _wo
  FROM wo
  WHERE (wo_id=pWoid);

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'Cannot find W/O id %  [xtuple: implodeWo, -9]', pWoid;
  END IF;

  IF (_routings) THEN
    IF (EXISTS(SELECT 1
               FROM xtmfg.wotc
               WHERE (wotc_wo_id=pWoid))) THEN
      RAISE EXCEPTION 'Cannot implode W/O % with labor posting [xtuple: implodeWo, -1]', formatWoNumber(pWoid);
    END IF;
  END IF;

  IF (_wo.wo_status != 'E') THEN
    RAISE EXCEPTION 'Cannot implode W/O % with status % [xtuple: implodeWo, -2]', formatWoNumber(pWoid), _wo.wo_status;
  END IF;

--  Delete any created P/R's for this W/O
  PERFORM deletePr('W', womatl_id)
  FROM womatl
  WHERE (womatl_wo_id=pWoid);

  DELETE FROM womatl
  WHERE (womatl_wo_id=pWoid);

  IF _routings THEN
    DELETE FROM xtmfg.wooper
    WHERE (wooper_wo_id=pWoid);
  END IF;

  UPDATE wo
  SET wo_status='O'
  WHERE (wo_id=pWoid);

  IF (pImplodeChildren) THEN
    resultCode := (SELECT MAX(implodeWo(wo_id, TRUE))
                   FROM wo
                   WHERE ((wo_ordtype='W')
                    AND (wo_ordid=pWoid)));

    resultCode := (SELECT MAX(deleteWo(wo_id, TRUE))
                   FROM wo
                   WHERE ((wo_ordtype='W')
                    AND (wo_ordid=pWoid)));
  END IF;

  RETURN 0;
END;
$$ LANGUAGE plpgsql;
