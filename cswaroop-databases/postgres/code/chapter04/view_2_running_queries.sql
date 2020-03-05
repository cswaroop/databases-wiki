CREATE OR REPLACE VIEW running_queries AS
SELECT
   CURRENT_TIMESTAMP - query_start as runtime,
   pid,
   usename,
   waiting,
   query,
   application_name as appname
FROM pg_stat_activity
ORDER BY 1 DESC
LIMIT 10;

