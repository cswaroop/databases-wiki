CREATE OR REPLACE FUNCTION soHoldType(pCoheadid INTEGER) RETURNS TEXT STABLE AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _coholdtype           TEXT := 'N';
  _balance              NUMERIC := 0.0;

BEGIN
  SELECT cohead_holdtype,
         calcSalesOrderAmt(cohead_id) -
         COALESCE(SUM(currToCurr(aropenalloc_curr_id, cohead_curr_id,
                                 aropenalloc_amount, cohead_orderdate)),0)
  INTO _coholdtype, _balance
  FROM cohead LEFT OUTER JOIN aropenalloc ON (aropenalloc_doctype='S' AND
                                              aropenalloc_doc_id=cohead_id)
  WHERE (cohead_id=pCoheadid)
  GROUP BY cohead_holdtype, cohead_id;

  IF ( (_coholdtype = 'C') AND (_balance <= 0.0) ) THEN
    RETURN 'N';
  END IF;

  RETURN _coholdtype;

END;
$$ LANGUAGE plpgsql;
