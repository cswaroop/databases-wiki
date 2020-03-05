CREATE OR REPLACE FUNCTION notify_trigger() 
  RETURNS TRIGGER AS $$ 
BEGIN 
    RAISE NOTICE 'Hi, I got % invoked FOR % % % on %', 
                               TG_NAME, 
                               TG_LEVEL, 
                               TG_WHEN, 
                               TG_OP, 
                               TG_TABLE_NAME; 
END; 
$$ LANGUAGE plpgsql;

CREATE TABLE notify_test(i int);

CREATE TRIGGER notify_insert_trigger
  AFTER INSERT ON notify_test
  FOR EACH ROW
EXECUTE PROCEDURE notify_trigger();

