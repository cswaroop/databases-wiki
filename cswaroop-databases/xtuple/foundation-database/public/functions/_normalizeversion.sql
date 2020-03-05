CREATE OR REPLACE FUNCTION public._normalizeVersion(pVersion TEXT) RETURNS SMALLINT[] AS
$$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
-- Convert an arbitrary version number string to an array of integers.
-- Supports the following styles:
--   xTuple   4.5.6Beta2A
--   semver   4.5.6-beta.2.a+buildId
--   postgres 9.3
DECLARE
  _result SMALLINT[];  -- 4.5.6
  _part   TEXT[];
  _debug  BOOLEAN := false;
BEGIN
  -- extract 4.5.6
  _part := regexp_matches(pVersion, --                  v----------- 6 -----------v
             -- capture                v-3-v                         v---- 8 ----v
             --   1          2         4   5            7            9          10
             --   4       .  5         .   6       -    beta         2           a
             E'^([0-9]+)\\.([0-9]+)((\\.)([0-9]+))?-?(([a-z]+)\\.?(([0-9]*)\\.?([a-z]?)?)?)?', 'i');
  IF _debug THEN
    RAISE NOTICE 'M: % N: % dP: % d: % P: % rest: % alpha: % sub: % num: % let: %',
                _part[1], _part[2], _part[3], _part[4], _part[5],
                _part[6], _part[7], _part[8], _part[9], _part[10];
  END IF;
  _result := ARRAY [
               _part[1]::SMALLINT,
               _part[2]::SMALLINT,
               COALESCE(_part[5]::SMALLINT, 0),
               CASE lower(COALESCE(_part[7], '')) 
                    WHEN ''      THEN 50
                    WHEN 'rc'    THEN 40
                    WHEN 'beta'  THEN 30
                    WHEN 'alpha' THEN 20
                    ELSE 10
               END,
               CASE WHEN _part[9] IS NULL THEN 0
                    WHEN _part[9] = ''    THEN 0
                    ELSE _part[9]::SMALLINT             -- beta < beta2
               END,
               ascii(CASE WHEN _part[10] IS NULL THEN '_'
                          WHEN _part[10] = ''    THEN '_'
                          ELSE lower(COALESCE(_part[10], '_'))
                     END)   -- 2 < 2a
             ];
  IF _debug THEN RAISE NOTICE '_part: % -> _result: %', _part, _result; END IF;
  IF _part[1] IS NULL OR _part[2] IS NULL THEN
    RAISE EXCEPTION '% is not recognized as a valid version number', pVersion;
  END IF;
  RETURN _result;
END;
$$ LANGUAGE plpgsql STABLE;
