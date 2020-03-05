CREATE OR REPLACE FUNCTION cancel_op() 
  RETURNS TRIGGER AS $$ 
BEGIN 
    IF TG_WHEN = 'AFTER' THEN 
        RAISE EXCEPTION 'YOU ARE NOT ALLOWED TO % ROWS IN %.%', 
                          TG_OP, TG_TABLE_SCHEMA, TG_TABLE_NAME; 
    END IF; 
    RAISE NOTICE '% ON ROWS IN %.% WON''T HAPPEN', 
                          TG_OP, TG_TABLE_SCHEMA, TG_TABLE_NAME; 
    RETURN NULL; 
END; 
$$ LANGUAGE plpgsql;

CREATE TABLE delete_test1(i int);

CREATE TRIGGER disallow_delete AFTER DELETE ON delete_test1 FOR EACH ROW  EXECUTE PROCEDURE cancel_op();

CREATE TRIGGER disallow_truncate 
  AFTER TRUNCATE ON delete_test1 
  FOR EACH STATEMENT 
EXECUTE PROCEDURE cancel_op();

