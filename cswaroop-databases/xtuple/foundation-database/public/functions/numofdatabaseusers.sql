CREATE OR REPLACE FUNCTION numOfDatabaseUsers() RETURNS INTEGER AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  RETURN numOfDatabaseUsers(NULL);
END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION numOfDatabaseUsers(pAppName TEXT) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _count INTEGER;

BEGIN

  -- in version 9.2.0 the column "procpid" was changed to just "pid" Incident #21852
  IF (compareversion('9.2.0') <= 0)
  THEN
  SELECT count(DISTINCT pg_locks.pid)
    INTO _count
    FROM pg_locks
    LEFT JOIN pg_stat_activity ON pg_stat_activity.pid = pg_locks.pid
   WHERE     
     (pg_locks.objsubid = 2)
     AND (pg_stat_activity.datname = current_database())
     AND CASE WHEN (trim(coalesce(pAppName, '')) = '') THEN true ELSE application_name = pAppName END;
  ELSE
  SELECT count(DISTINCT pg_locks.pid)
    INTO _count
    FROM pg_locks    
    LEFT JOIN pg_stat_activity ON pg_stat_activity.procpid = pg_locks.pid
   WHERE        
     (pg_locks.objsubid = 2)
     AND (pg_stat_activity.datname = current_database())
     AND CASE WHEN (trim(coalesce(pAppName, '')) = '') THEN true ELSE application_name = pAppName END;
  END IF;

  IF (_count IS NULL) THEN
    _count := 0;
  END IF;

  RETURN _count;

END;
$$ LANGUAGE 'plpgsql';
