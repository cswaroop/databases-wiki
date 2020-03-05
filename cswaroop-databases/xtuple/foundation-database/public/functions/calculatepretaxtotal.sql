CREATE OR REPLACE FUNCTION calculatepretaxtotal(
    pTaxZoneId integer,
    pTaxTypeId integer,
    pDate date,
    pCurrId integer,
    pAmount numeric)
  RETURNS numeric AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _tax		numeric;
  _taxamnt	numeric;
  _pretax	numeric;
BEGIN

  -- Determine TOTAL Tax percentage (assumes non-hierarchical tax regime)
  SELECT SUM(taxdetail_taxrate_percent), COALESCE(SUM(taxdetail_taxrate_amount),0.00) INTO _tax , _taxamnt
  FROM calculatetaxdetail(pTaxZoneId, pTaxTypeId, pDate, pCurrId, pAmount);

  _pretax = ((pAmount - _taxamnt)/(1 + _tax));
 
  RETURN _pretax;
  
END;
$$ LANGUAGE plpgsql;
