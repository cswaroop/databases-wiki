CREATE OR REPLACE FUNCTION xt.raise_debug(message text) RETURNS void AS $$
BEGIN

  RAISE DEBUG '%', message;

END;
$$ LANGUAGE 'plpgsql';
