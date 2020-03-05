
CREATE OR REPLACE FUNCTION formatPloNumber(pPlanordid INTEGER) RETURNS TEXT IMMUTABLE AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.

BEGIN

  RETURN ( SELECT (planord_number::TEXT || '-' || LPAD(planord_subnumber::TEXT, 3, '0'))
           FROM planord
           WHERE (planord_id=pPlanordid) );

END;
$$ LANGUAGE plpgsql;

