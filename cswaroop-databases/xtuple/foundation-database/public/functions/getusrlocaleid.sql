CREATE OR REPLACE FUNCTION getUsrLocaleId() RETURNS INTEGER IMMUTABLE AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _returnVal INTEGER;
BEGIN
  SELECT CAST(usrpref_value AS INTEGER)
  FROM usrpref
  WHERE (usrpref_username=getEffectiveXTUser())
    AND (usrpref_name='locale_id') INTO _returnVal;

  IF (_returnVal IS NULL) THEN
    _returnVal = defaultLocale();
  END IF;

  IF (_returnVal IS NULL) THEN
    RAISE EXCEPTION 'User Locale not found. [xtuple: getUsrLocaleId, -1]';
  END IF;

  RETURN _returnVal;
END;
$$ LANGUAGE 'plpgsql';
