SELECT dropIfExists('VIEW', 'currencyrate', 'api');
CREATE OR REPLACE VIEW api.currencyrate AS
  SELECT curr_abbr AS currency,
     CASE WHEN (fetchmetricvalue('CurrencyExchangeSense') = 1) THEN
               round((1.0 / curr_rate),5)
          ELSE round(curr_rate,5) END AS exchange_rate,
       curr_effective AS effective,
       curr_expires AS expires
  FROM curr_symbol NATURAL JOIN curr_rate
  WHERE (curr_base = FALSE)
  ORDER BY currency, curr_effective, curr_expires;

GRANT ALL ON TABLE api.currencyrate TO xtrole;
COMMENT ON VIEW api.currencyrate IS 'Currency Exchange Rates';

CREATE OR REPLACE RULE "_DELETE" AS
    ON DELETE TO api.currencyrate DO INSTEAD NOTHING;

CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.currencyrate DO INSTEAD  
  INSERT INTO curr_rate (curr_id, curr_rate, curr_effective, curr_expires)
  VALUES ((SELECT curr_id FROM curr_symbol WHERE curr_abbr = NEW.currency), 
           CASE WHEN (fetchmetricvalue('CurrencyExchangeSense') = 1) THEN 
                (1.0 / NEW.exchange_rate) ELSE NEW.exchange_rate END, NEW.effective, NEW.expires);

CREATE OR REPLACE RULE "_UPDATE" AS
    ON UPDATE TO api.currencyrate DO INSTEAD
  UPDATE curr_rate SET curr_rate = CASE WHEN (fetchmetricvalue('CurrencyExchangeSense') = 1) THEN 
                (1.0 / NEW.exchange_rate) ELSE NEW.exchange_rate END
  WHERE ((curr_id = (SELECT curr_id FROM curr_symbol WHERE curr_abbr = NEW.currency))
  AND (curr_effective = NEW.effective)
  AND (curr_expires =  NEW.expires ));
