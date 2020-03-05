
CREATE OR REPLACE FUNCTION deleteCharacteristic(INTEGER) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pCharid ALIAS FOR $1;
  _uses   TEXT;

BEGIN

  IF NOT EXISTS(SELECT 1 FROM char WHERE char_id = pCharid) THEN
    RETURN 0;
  END IF;

  SELECT string_agg(DISTINCT(charass_target_type), ':') INTO _uses
    FROM charass
   WHERE charass_char_id = pCharid;

  IF _uses IS NOT NULL THEN
    RAISE EXCEPTION 'This characteristic cannot be deleted because it is in use [xtuple: deleteCharacteristic, -99, %]',
                    _uses;
  END IF;

  DELETE FROM "char" WHERE (char_id=pCharid);

  RETURN pCharid;

END;
$$ LANGUAGE 'plpgsql';

