CREATE TRIGGER notify_trigger 
  AFTER INSERT OR UPDATE OR DELETE 
  ON notify_test 
  FOR EACH ROW 
EXECUTE PROCEDURE notify_trigger();

