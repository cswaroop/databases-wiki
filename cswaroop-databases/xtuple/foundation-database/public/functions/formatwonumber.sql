
CREATE OR REPLACE FUNCTION formatWoNumber(pWoid INTEGER) RETURNS TEXT IMMUTABLE AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.

BEGIN

  RETURN formatWoNumber(pWoid, 'wo');

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION formatWoNumber(pId INTEGER,
                                          pType TEXT) RETURNS TEXT IMMUTABLE AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.

BEGIN

  IF (pType = 'womatl') THEN
    RETURN ( SELECT (wo_number::TEXT || '-' || LPAD(wo_subnumber::TEXT, 3, '0'))
             FROM womatl JOIN wo ON (wo_id=womatl_id)
             WHERE (womatl_id=pId) );
  ELSE
    RETURN ( SELECT (wo_number::TEXT || '-' || LPAD(wo_subnumber::TEXT, 3, '0'))
             FROM wo
             WHERE (wo_id=pId) );
  END IF;

END;
$$ LANGUAGE plpgsql;

