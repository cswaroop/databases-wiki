CREATE OR REPLACE FUNCTION getFundsTypeName(pFundsTypeCode text) RETURNS TEXT IMMUTABLE AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _returnVal TEXT;
BEGIN
  IF (pFundsTypeCode IS NULL) THEN
    RETURN pFundsTypeCode;
  END IF;

  SELECT
    fundstype_name INTO _returnVal
  FROM fundstype
  WHERE fundstype_code = pFundsTypeCode;

  IF (_returnVal IS NULL) THEN
    RETURN pFundsTypeCode;
  END IF;

  RETURN _returnVal;
END;
$$ LANGUAGE 'plpgsql';
