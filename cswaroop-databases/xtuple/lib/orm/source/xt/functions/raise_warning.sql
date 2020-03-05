CREATE OR REPLACE FUNCTION xt.raise_warning(message text) RETURNS void AS $$
BEGIN

  RAISE WARNING '%', message;

END;
$$ LANGUAGE 'plpgsql';
