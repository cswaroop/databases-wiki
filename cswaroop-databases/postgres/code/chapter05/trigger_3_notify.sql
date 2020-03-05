CREATE TRIGGER notify_update_trigger 
  AFTER UPDATE ON notify_test 
  FOR EACH ROW 
EXECUTE PROCEDURE notify_trigger(); 

CREATE TRIGGER notify_delete_trigger 
  AFTER DELETE ON notify_test 
  FOR EACH ROW 
EXECUTE PROCEDURE notify_trigger();

