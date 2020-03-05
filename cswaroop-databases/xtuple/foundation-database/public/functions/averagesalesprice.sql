CREATE OR REPLACE FUNCTION averagesalesprice(pItemsiteid integer,
                                             pStartDate  timestamp with time zone,
                                             pEndDate    timestamp with time zone)
  RETURNS numeric AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
  SELECT averageSalesPrice($1, $2::DATE, $3::DATE);
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION averagesalesprice(pItemsiteid INTEGER,
                                             pStartDate  DATE,
                                             pEndDate    DATE)
  RETURNS numeric AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _p RECORD;

BEGIN
-- Returns value in base currency
-- ToDo: is cohist_shipdate the right DATE to use?
  SELECT SUM(cohist_qtyshipped * currToBase(cohist_curr_id, cohist_unitprice,
                                            cohist_shipdate)) AS totalsales,
         SUM(cohist_qtyshipped) AS totalship INTO _p
  FROM cohist
  WHERE ( (cohist_itemsite_id=pItemsiteid)
   AND (cohist_invcdate BETWEEN pStartDate AND pEndDate) );

  IF ( (_p.totalship IS NULL) OR
       (_p.totalship = 0) ) THEN
    RETURN 0;
  ELSE
    RETURN (_p.totalsales / _p.totalship);
  END IF;

END;
$$ LANGUAGE plpgsql;
