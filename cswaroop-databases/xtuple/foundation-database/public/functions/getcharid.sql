CREATE OR REPLACE FUNCTION getCharId(pChar text,
                                     pType text) RETURNS INTEGER STABLE AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _returnVal INTEGER;
BEGIN
  IF (COALESCE(pChar, '') = '') THEN
    RETURN NULL;
  END IF;

  SELECT char_id INTO _returnVal
    FROM char
    JOIN charuse ON char_id = charuse_char_id
   WHERE char_name = pChar
     AND (charuse_target_type = pType
          OR (pType IN ('C', 'CT')               AND charuse_target_type = 'C')
          OR (pType IN ('SI','QI','W','PI','TI') AND charuse_target_type = 'I')
         )
   LIMIT 1;

  IF (_returnVal IS NULL) THEN
    RAISE EXCEPTION 'Characteristic % not found [xtuple: getCharId, -1, %]',
                    pChar, pChar;
  END IF;

  RETURN _returnVal;
END;
$$ LANGUAGE 'plpgsql';
