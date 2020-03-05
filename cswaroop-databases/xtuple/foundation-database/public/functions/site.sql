CREATE OR REPLACE FUNCTION site() RETURNS SETOF whsinfo AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _row whsinfo%ROWTYPE;
  _r RECORD;

BEGIN

  IF ( fetchMetricBool('MultiWhs') AND
       EXISTS (SELECT 1
                 FROM usrpref
                WHERE ((usrpref_name='selectedSites')
                  AND  (usrpref_value='t')
                  AND  (usrpref_username=getEffectiveXtUser()))) ) THEN

    FOR _row IN SELECT whsinfo.*
                  FROM whsinfo
                  JOIN usrsite ON (warehous_id=usrsite_warehous_id)
                 WHERE (usrsite_username=getEffectiveXtUser())
    LOOP
      RETURN NEXT _row;
    END LOOP;
  ELSE
    FOR _row IN SELECT * FROM whsinfo LOOP
      RETURN NEXT _row;
    END LOOP;
  END IF;
  
  RETURN;
END;
$$ LANGUAGE plpgsql STABLE;
