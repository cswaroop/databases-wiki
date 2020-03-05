
CREATE OR REPLACE FUNCTION formatGLAccount(pAccntid INTEGER) RETURNS TEXT IMMUTABLE AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  RETURN formatGlAccount(accnt_company, accnt_profit, accnt_number, accnt_sub)
  FROM accnt
  WHERE (accnt_id=pAccntid);

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION formatGLAccount(pCompany TEXT,
                                           pProfit TEXT,
                                           pNumber TEXT,
                                           pSub TEXT) RETURNS TEXT IMMUTABLE AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _number TEXT := '';

BEGIN

  IF (fetchMetricValue('GLCompanySize') > 0) THEN
    _number := COALESCE(pCompany, '') || '-';
  END IF;

  IF (fetchMetricValue('GLProfitSize') > 0) THEN
    _number := _number || COALESCE(pProfit, '') || '-';
  END IF;

  _number := _number || pNumber;

  IF (fetchMetricValue('GLSubaccountSize') > 0) THEN
    _number := _number || '-' || COALESCE(pSub, '');
  END IF;

  RETURN _number;

END;
$$ LANGUAGE plpgsql;

