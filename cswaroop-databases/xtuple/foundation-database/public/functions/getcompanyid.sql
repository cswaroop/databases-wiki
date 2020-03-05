CREATE OR REPLACE FUNCTION getcompanyid(pglaccnt integer)
  RETURNS integer AS
$BODY$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _returnVal INTEGER;
BEGIN
  IF (pGlAccnt IS NULL) THEN
    RETURN -1;
  END IF;

  SELECT company_id INTO _returnVal
  FROM accnt
  JOIN company ON (company_number=accnt_company)
  WHERE (accnt_id=pGlAccnt);

  IF (_returnVal IS NULL) THEN
    RETURN -1;
  END IF;

  RETURN _returnVal;
END;
$BODY$
  LANGUAGE plpgsql;
