CREATE OR REPLACE FUNCTION setUserPreference(pPrefName TEXT, pPrefValue TEXT) RETURNS BOOLEAN AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  RETURN setUserPreference(getEffectiveXtUser(), pPrefName, pPrefValue);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION setUserPreference(TEXT, TEXT, TEXT) RETURNS BOOLEAN AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pUsername ALIAS FOR $1;
  pPrefName ALIAS FOR $2;
  pPrefValue ALIAS FOR $3;
  _usrprefid INTEGER;

BEGIN

  SELECT usrpref_id INTO _usrprefid
  FROM usrpref
  WHERE ( (usrpref_username=pUsername)
   AND (usrpref_name=pPrefName) );

  IF (FOUND) THEN
    UPDATE usrpref
    SET usrpref_value=pPrefValue
    WHERE (usrpref_id=_usrprefid);

  ELSE
    INSERT INTO usrpref
    (usrpref_username, usrpref_name, usrpref_value)
    VALUES
    (pUsername, pPrefName, pPrefValue);
  END IF;

  RETURN TRUE;

END;
$$ LANGUAGE 'plpgsql';
