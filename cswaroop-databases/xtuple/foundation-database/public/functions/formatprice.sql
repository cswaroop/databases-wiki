CREATE OR REPLACE FUNCTION formatPrice(NUMERIC) RETURNS TEXT IMMUTABLE AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
  SELECT formatNumeric($1, 'salesprice') AS result;
$$ LANGUAGE 'sql';
