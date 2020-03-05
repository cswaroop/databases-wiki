DROP FUNCTION IF EXISTS createPriv(text, text, text);

CREATE OR REPLACE FUNCTION createPriv(pModule text, pName text, pDesc text, pSeq integer = NULL, pPackage text = NULL) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _id     INTEGER;
BEGIN
  SELECT priv_id INTO _id
    FROM priv
   WHERE (priv_name=pName);

  IF (FOUND) THEN
    UPDATE priv
       SET priv_module  = pModule,
           priv_descrip = pDesc,
           priv_seq     = pSeq
     WHERE priv_id = _id;
  ELSIF (pPackage IS NULL OR pPackage = 'public') THEN
    INSERT INTO priv (priv_module, priv_name, priv_descrip, priv_seq)
      VALUES (pModule, pName, pDesc, pSeq)
      RETURNING priv_id INTO _id;
  ELSE
    EXECUTE format($f$INSERT INTO %I.pkgpriv
                              (priv_module, priv_name, priv_descrip, priv_seq)
                       VALUES (%L, %L, %L, %L)
                       RETURNING priv_id;$f$,
                   LOWER(pPackage), pModule, pName, pDesc, pSeq)
      INTO _id;
  END IF;

  RETURN _id;
END;
$$ LANGUAGE plpgsql;
