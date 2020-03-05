CREATE OR REPLACE FUNCTION getEdition() RETURNS text AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _result       TEXT;
  _pkg          RECORD;
  _hasMFG       BOOLEAN := false;
  _hasXWD       BOOLEAN := false;
BEGIN
  FOR _pkg IN SELECT pkghead_name FROM pkghead
               WHERE pkghead_name IN ('xtmfg', 'xwd')
  LOOP
    CASE _pkg.pkghead_name WHEN 'xtmfg' THEN _hasMFG := true;
                           WHEN 'xwd'   THEN _hasXWD := true;
    END CASE;
  END LOOP;

  _result := CASE WHEN _hasMFG AND _hasXWD THEN 'Enterprise'
                  WHEN _hasMFG             THEN 'Manufacturing'
                  WHEN _hasXWD             THEN 'Distribution'
                  ELSE 'PostBooks' END;
  RETURN _result;
END;
$$ LANGUAGE plpgsql;
