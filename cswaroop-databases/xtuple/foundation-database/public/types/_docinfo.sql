SELECT dropIfExists('VIEW',     'docinfo',    'public', true);
SELECT dropIfExists('FUNCTION', '_docinfo()', 'public', true); -- Remove old function.
SELECT dropIfExists('FUNCTION', '_docinfo(integer, text)', 'public', true);
SELECT dropIfExists('TYPE',     '_docinfo',   'public', true);

CREATE TYPE _docinfo AS (
  id            integer,
  target_number text,
  target_type   text,
  target_id     integer,
  source_type   text,
  source_id     integer,
  name          text,
  description   text,
  purpose       text
);
