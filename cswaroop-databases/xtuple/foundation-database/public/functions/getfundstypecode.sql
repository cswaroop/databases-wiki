CREATE OR REPLACE FUNCTION getFundsTypeCode(pFundsTypeName text) RETURNS TEXT IMMUTABLE AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _returnVal TEXT;
BEGIN
  IF (pFundsTypeName IS NULL) THEN
    RETURN pFundsTypeName;
  END IF;

  SELECT
    fundstype_code INTO _returnVal
  FROM fundstype
  WHERE fundstype_name = pFundsTypeName;

  IF (_returnVal IS NULL) THEN
    RETURN pFundsTypeName;
  END IF;

  RETURN _returnVal;
END;
$$ LANGUAGE 'plpgsql';
