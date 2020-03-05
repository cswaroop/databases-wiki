CREATE OR REPLACE FUNCTION currExchangeCheckOverlap () RETURNS trigger AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
    numberOfOverlaps INTEGER NOT NULL := 0;
    curr_string VARCHAR(16);
    new_id INTEGER;
BEGIN
  new_id := NEW.curr_id;
  -- ensure that effective date <= expiration date
  IF NEW.curr_effective > NEW.curr_expires THEN
    RAISE EXCEPTION
      'Effective date % must be earlier than expiration date %',
      NEW.curr_effective, NEW.curr_expires;
  END IF;

  -- ensure new exchange rate does not overlap in time with any others
  SELECT count(*) INTO numberOfOverlaps
    FROM curr_rate
    WHERE curr_id = NEW.curr_id
      AND curr_rate_id != NEW.curr_rate_id
      AND (
          (curr_effective BETWEEN
              NEW.curr_effective AND NEW.curr_expires OR
           curr_expires BETWEEN
              NEW.curr_effective AND NEW.curr_expires)
         OR (curr_effective <= NEW.curr_effective AND
             curr_expires   >= NEW.curr_expires)
      );
  IF numberOfOverlaps > 0 THEN
    SELECT currConcat(curr_symbol, curr_abbr)
      INTO curr_string
      FROM curr_symbol
      WHERE curr_id = new_id;
    RAISE EXCEPTION
      'The date range % to % overlaps with another date range.',
      NEW.curr_effective, NEW.curr_expires;
  END IF;

  -- Timestamps
  IF (TG_OP = 'INSERT') THEN
    NEW.curr_created := now();
  ELSIF (TG_OP = 'UPDATE') THEN
    NEW.curr_lastupdated := now();
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS currExchangeCheckOverlap ON curr_rate;
CREATE TRIGGER currExchangeCheckOverlap BEFORE INSERT OR UPDATE ON curr_rate
    FOR EACH ROW EXECUTE PROCEDURE currExchangeCheckOverlap();

SELECT dropifexists('TRIGGER', 'currexchangeaftertrigger');
SELECT dropifexists('FUNCTION', '_currexchangeaftertrigger()');

CREATE OR REPLACE FUNCTION _currexchangeaftertrigger()
  RETURNS trigger AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _currid     INTEGER;
  _curr       TEXT;
  _old_curr_rate   NUMERIC;
  _new_curr_rate   NUMERIC;
  _cmnttext   TEXT;
BEGIN

  IF (fetchMetricBool('FXChangeLog')) THEN

    IF (TG_OP = 'INSERT') THEN
      _curr := (SELECT curr_abbr FROM curr_symbol 
                WHERE (curr_id = NEW.curr_id));
      _currid := NEW.curr_id;  
      _new_curr_rate := CASE WHEN fetchmetricvalue('CurrencyExchangeSense') = 1 
                             THEN round((1.0 / NEW.curr_rate),5)
                             ELSE round(NEW.curr_rate,5) END;
                                  
      _cmnttext := format('%s exchange rate added. Rate: %s, effective: %s, expiry: %s',
                          _curr, _new_curr_rate, NEW.curr_effective, NEW.curr_expires);

    ELSIF (TG_OP = 'UPDATE') THEN
      _curr := (SELECT curr_abbr FROM curr_symbol 
                WHERE (curr_id = NEW.curr_id));
      _currid := NEW.curr_id;
      _old_curr_rate := (SELECT CASE WHEN fetchmetricvalue('CurrencyExchangeSense') = 1 
                                     THEN round((1.0 / OLD.curr_rate),5)
                                     ELSE round(OLD.curr_rate,5) END);
      _new_curr_rate := (SELECT CASE WHEN fetchmetricvalue('CurrencyExchangeSense') = 1 
                                     THEN round((1.0 / NEW.curr_rate),5)
                                     ELSE round(NEW.curr_rate,5) END);
        
      IF (OLD.curr_rate <> NEW.curr_rate) THEN
        _cmnttext := format('%s exchange rate edited. Old Rate: %s, New Rate: %s',
                            _curr, _old_curr_rate, _new_curr_rate);
      END IF;

      IF ((OLD.curr_effective <> NEW.curr_effective) OR
          (OLD.curr_expires <> NEW.curr_expires) ) THEN
        _cmnttext := format('%s exchange rate edited. Old Effective: %s, New Effective: %s, Old Expiry: %s, New Expiry: %s', 
                            _curr, OLD.curr_effective, NEW.curr_effective, OLD.curr_expires, NEW.curr_expires);
      END IF;
    ELSIF (TG_OP = 'DELETE') THEN
      _curr := (SELECT curr_abbr FROM curr_symbol 
                WHERE (curr_id = OLD.curr_id));         
      _currid := OLD.curr_id;
      _old_curr_rate := (SELECT CASE WHEN fetchmetricvalue('CurrencyExchangeSense') = 1 
                                     THEN round((1.0 / OLD.curr_rate),5)
                                     ELSE round(OLD.curr_rate,5) END);

      _cmnttext := format('%s exchange rate deleted. Rate %s, Effective %s, Expiry %s', 
                          _curr, _old_curr_rate, OLD.curr_effective, OLD.curr_expires);
    END IF;
      
    PERFORM postComment('ChangeLog', 'FX', _currid, _cmnttext);
      
  END IF;

  IF (TG_OP = 'DELETE') THEN
    RETURN OLD;
  END IF;

  RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER currexchangeaftertrigger
  BEFORE INSERT OR UPDATE OR DELETE ON curr_rate
  FOR EACH ROW EXECUTE PROCEDURE _currexchangeaftertrigger();



