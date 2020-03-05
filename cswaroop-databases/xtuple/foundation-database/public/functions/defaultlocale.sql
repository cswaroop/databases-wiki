CREATE OR REPLACE FUNCTION defaultLocale() RETURNS INTEGER IMMUTABLE AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _returnVal RECORD;
BEGIN

  -- The `LOWER(locale_code) = 'default'` is assumed to exist in a xTuple
  -- database, but entirely dependent on the implementation. It really should
  -- be a column flag on the locale table.
  -- @See: Incident #28175
  SELECT
    locale_id,
    1 AS seq
  FROM locale
  WHERE (LOWER(locale_code) = 'default')
  UNION ALL
  SELECT
    MIN(locale_id) AS locale_id,
    2 AS seq
  FROM locale
  ORDER BY seq
  LIMIT 1 INTO _returnVal;

  IF (_returnVal IS NULL) THEN
    RAISE EXCEPTION 'No default Locale found. [xtuple: defaultLocale, -1]';
  END IF;

  RETURN _returnVal.locale_id;
END;
$$ LANGUAGE 'plpgsql';
