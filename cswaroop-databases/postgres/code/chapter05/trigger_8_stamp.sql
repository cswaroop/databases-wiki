CREATE OR REPLACE FUNCTION stamp() 
  RETURNS TRIGGER AS $$ 
BEGIN 
    NEW.last_changed_by = SESSION_USER; 
    NEW.last_changed_at = CURRENT_TIMESTAMP; 
    RETURN NEW; 
END; 
$$ LANGUAGE plpgsql; 

CREATE TABLE modify_test( 
     id serial PRIMARY KEY, 
     data text, 
     created_by text default SESSION_USER, 
     created_at timestamp default CURRENT_TIMESTAMP, 
     last_changed_by text default SESSION_USER, 
     last_changed_at timestamp default CURRENT_TIMESTAMP 
); 

CREATE TRIGGER changestamp 
  BEFORE UPDATE ON modify_test 
  FOR EACH ROW  
EXECUTE PROCEDURE changestamp();

