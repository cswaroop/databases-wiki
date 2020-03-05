CREATE OR REPLACE FUNCTION releaseNumber(psequence TEXT,
                                         pnumber INTEGER) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _isManual     BOOLEAN;
  _test   INTEGER;
  _number INTEGER;
  _table  TEXT;
  _numcol TEXT;
  _select TEXT;

BEGIN
  IF (fetchMetricBool('EnableGaplessNumbering')) THEN
    -- drop the number back into the pool if it was not committed
    PERFORM clearNumberIssue(psequence, pnumber);

    UPDATE orderseq SET
      orderseq_number = LEAST(pnumber, orderseq_number)
    WHERE (orderseq_name=psequence);
  ELSE
    -- get the current state of the sequence
    SELECT orderseq_number::integer, orderseq_table, orderseq_numcol
        INTO _number, _table, _numcol
    FROM orderseq
    WHERE (orderseq_name=psequence);
    IF (NOT FOUND) THEN
      RAISE EXCEPTION 'Invalid orderseq_name %', psequence;
    END IF;

    -- check if an order exists with the given order number
    -- Have to factor in scenario where Quotes are set to use SO Numbering
    IF (psequence = 'SoNumber' AND fetchmetrictext('QUNumberGeneration') = 'S') THEN
      _select := 'SELECT ' || quote_ident(_numcol) ||
	         ' FROM '  || _table ||
	         ' WHERE (' || quote_ident(_numcol) || '=' || quote_literal(_number - 1) || ') ' ||
	         ' UNION SELECT quhead_number FROM quhead WHERE (quhead_number = ' || quote_literal(_number - 1) || ');';
    ELSE
      _select := 'SELECT ' || quote_ident(_numcol) ||
	         ' FROM '  || _table ||
	         ' WHERE (' || quote_ident(_numcol) || '=' || quote_literal(_number - 1) || ');';
    END IF;

    EXECUTE _select INTO _test;

    -- Check if order seq has been incremented past the given order number
    -- Problem occurred with open but not saved orders (i.e. open by two or more people
    -- at the same time) so need to check for that as well.
    IF ((FOUND AND (_test > pnumber))
          OR ((_test IS NULL) AND ((_number - 1) > pnumber))
          OR (_number = pnumber)) THEN
      RETURN 0;
    END IF;

    SELECT metric_value = 'M' INTO _isManual
    FROM metric
    WHERE (metric_name = CASE WHEN psequence='CmNumber' THEN 'CMNumberGeneration'
                              WHEN psequence='SoNumber' THEN 'CONumberGeneration'
                              WHEN psequence='InvcNumber' THEN 'InvcNumberGeneration'
                              WHEN psequence='PoNumber' THEN 'PONumberGeneration'
                              WHEN psequence='PrNumber' THEN 'PrNumberGeneration'
                              WHEN psequence='QuNumber' THEN 'QUNumberGeneration'
                              WHEN psequence='RaNumber' THEN 'RANumberGeneration'
                         --   WHEN psequence='??Number' THEN 'ShipmentNumberGeneration'
                              WHEN psequence='ToNumber' THEN 'TONumberGeneration'
                              WHEN psequence='VcNumber' THEN 'VoucherNumberGeneration'
                              WHEN psequence='WoNumber' THEN 'WONumberGeneration'
                              ELSE NULL
                         END);

    -- release the given order number for reuse
    IF (NOT FOUND OR NOT _isManual) THEN
      UPDATE orderseq
      SET orderseq_number = (_number - 1)
      WHERE (orderseq_name=psequence);
    ELSE
      RAISE WARNING 'cannot update orderseq';
    END IF;
  END IF;

  RETURN 1;
END;
$$
  LANGUAGE plpgsql;
