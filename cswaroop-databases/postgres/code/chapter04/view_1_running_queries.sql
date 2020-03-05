CREATE VIEW running_queries AS
SELECT
   CURRENT_TIMESTAMP - query_start as runtime,
   pid,
   usename,
   waiting,
   query
FROM pg_stat_activity
ORDER BY 1 DESC
LIMIT 10;

