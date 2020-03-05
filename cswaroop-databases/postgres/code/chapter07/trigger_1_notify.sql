CREATE OR REPLACE FUNCTION notify_on_call()
  RETURNS TRIGGER
AS $$
plpy.notice('I was called!')
$$ LANGUAGE plpythonu;

CREATE TABLE ttable(id int);

CREATE TRIGGER ttable_notify BEFORE INSERT ON ttable EXECUTE PROCEDURE notify_on_call();

