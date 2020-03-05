
CREATE OR REPLACE FUNCTION formatPrNumber(pId INTEGER) RETURNS TEXT IMMUTABLE AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.

BEGIN

  RETURN ( SELECT (pr_number::TEXT || '-' || LPAD(pr_subnumber::TEXT, 3, '0'))
           FROM pr
           WHERE (pr_id=pId) );

END;
$$ LANGUAGE plpgsql;

