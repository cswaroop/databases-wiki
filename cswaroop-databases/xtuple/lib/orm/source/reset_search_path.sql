-- During install, xt.xt_init() is called because of the postgresql.conf setting,
-- which sets the search_path to xt. We need to set it back to public so the
-- build SQL executes correctly.
set search_path to public;
