CREATE OR REPLACE FUNCTION explore_trigger()
  RETURNS TRIGGER 
AS $$
import pprint
nice_data = pprint.pformat(
  (
    ('TD["table_schema"]' , TD["table_schema"] ),
    ('TD["event"]'        , TD["event"] ),
    ('TD["when"]'         , TD["when"] ),
    ('TD["level"]'        , TD["level"] ),
    ('TD["old"]'          , TD["old"] ),
    ('TD["new"]'          , TD["new"] ),
    ('TD["name"]'         , TD["name"] ),
    ('TD["table_name"]'   , TD["table_name"] ),
    ('TD["relid"]'        , TD["relid"] ),
    ('TD["args"]'         , TD["args"] ),
  )
)
plpy.notice('explore_trigger:\n' + nice_data)
$$ LANGUAGE plpythonu;

CREATE TABLE test(
    id serial PRIMARY KEY,
    data text,
    ts timestamp DEFAULT clock_timestamp()
);

CREATE TRIGGER test_explore_trigger
 AFTER INSERT OR UPDATE OR DELETE ON test
   FOR EACH ROW
EXECUTE PROCEDURE explore_trigger('one', 2, null);

