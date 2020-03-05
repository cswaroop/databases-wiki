CREATE OR REPLACE FUNCTION grantPrivToAll(TEXT) RETURNS BOOL AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pPrivname ALIAS FOR $1;
  _p RECORD;
	_id INT;

BEGIN
	SELECT	priv_id INTO _id FROM priv WHERE priv_name=pPrivname;

	FOR _p IN SELECT usr_username FROM usr
		LOOP 
			PERFORM grantPriv(_p.usr_username, _id);
		END LOOP;
RETURN TRUE;

END;
$$ LANGUAGE plpgsql;
