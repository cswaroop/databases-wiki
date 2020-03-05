CREATE TRIGGER notify_truncate_trigger 
  AFTER TRUNCATE ON notify_test 
  FOR EACH STATEMENT 
EXECUTE PROCEDURE notify_trigger();

