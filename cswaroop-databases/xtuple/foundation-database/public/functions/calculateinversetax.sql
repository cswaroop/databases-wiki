CREATE OR REPLACE FUNCTION calculateinversetax(
    pTaxZoneId integer,
    pTaxTypeId integer,
    pDate date,
    pCurrId integer,
    pAmount numeric)
  RETURNS numeric AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license
BEGIN

  IF (pTaxZoneid < 0 OR pTaxTypeid < 0) THEN
    RETURN 0.00;
  END IF;  

  RETURN (pAmount - calculatepretaxtotal(pTaxZoneId,pTaxTypeId,pDate, pCurrId, pAmount));
  
END;
$$ LANGUAGE plpgsql;
