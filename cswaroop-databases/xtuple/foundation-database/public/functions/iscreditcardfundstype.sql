CREATE OR REPLACE FUNCTION isCreditCardFundsType(pFundsTypeCode text) RETURNS BOOLEAN IMMUTABLE AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _returnVal BOOLEAN := FALSE;
BEGIN
  IF (pFundsTypeCode IS NULL) THEN
    RETURN _returnVal;
  END IF;

  SELECT
    fundstype_creditcard INTO _returnVal
  FROM fundstype
  WHERE fundstype_code = pFundsTypeCode;

  RETURN _returnVal;
END;
$$ LANGUAGE 'plpgsql';
