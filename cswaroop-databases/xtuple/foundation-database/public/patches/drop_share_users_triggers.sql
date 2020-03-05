-- This patch addresses an issue with share_user access triggers on core tables.
-- Those triggers require the view 'xt.share_users' to exist, the supporting
-- XT.ShareUsers JavaScript object and its methods. When we build_app.js, all
-- xt schema views are dropped and later rebuilt. Since foundation-database may
-- contain INSERT/UDPATE/DELETE queries to tables that have xxx_share_users_cache
-- triggers, those INSERT/UDPATE/DELETE queries will fail because the view
-- 'xt.share_users' does not exist yet. To work around this, we drop all of the
-- xxx_share_users_cache triggers before running any other INSERT/UDPATE/DELETE
-- queries. The xxx_share_users_cache triggers will be recreated when we get to
-- the mobileized queries with build_app.js. The share_user cache will be
-- refreshed when the datasource is started, so any access grants for those
-- INSERT/UDPATE/DELETE queries will be created then.
DO $$
DECLARE
  _share_users_triggers RECORD;
  drop_trigger_sql TEXT := '';

BEGIN

  FOR _share_users_triggers IN
    -- Find all xxx_share_users_cache triggers, their schema and table.
    SELECT
      nspname,
      relname,
      tgname
    FROM pg_trigger
    LEFT JOIN pg_class ON pg_trigger.tgrelid = pg_class.oid
    LEFT JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace
    WHERE true
      AND (tgname ILIKE '%_share_users_cache' OR tgname ILIKE 'obj_share_after') -- 'obj_share_after' is on the xt.obj_share table.
      AND pg_class.relkind = 'r'
  LOOP
    drop_trigger_sql := 'DROP TRIGGER IF EXISTS ' || _share_users_triggers.tgname || ' ON ' || _share_users_triggers.nspname || '.' || _share_users_triggers.relname;
    EXECUTE drop_trigger_sql;
  END LOOP;
END;
$$ LANGUAGE plpgsql;
