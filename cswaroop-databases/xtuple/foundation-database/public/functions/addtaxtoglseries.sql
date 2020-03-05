-- add tax information to a GL Series
-- return the base currency value of the GL Series records inserted
--	  NULL if there has been an error

CREATE OR REPLACE FUNCTION addTaxToGLSeries(pSequence  INTEGER,
                                            pSource    TEXT,
                                            pDocType   TEXT,
                                            pDocNumber TEXT,
                                            pCurrId    INTEGER,
                                            pExchDate  DATE,
                                            pDistDate  DATE,
                                            pTableName TEXT,
                                            pParentId  INTEGER,
                                            pNotes     TEXT) RETURNS NUMERIC AS $$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _baseTax	NUMERIC := 0;
  _returnVal	NUMERIC := 0;
  _t		RECORD;

BEGIN

-- This is just a fancy select statement on taxhist.
-- Because all tax records tables inherit from taxhist,
-- we can use the same select statement for all.
-- https://www.postgresql.org/docs/8.1/static/ddl-inherit.html
-- pTableName in the where clause narrows down the selection
-- to the correct sub table.

  FOR _t IN SELECT taxhist_id, taxhist_tax, tax_sales_accnt_id
            FROM taxhist JOIN tax ON (tax_id = taxhist_tax_id)
                         JOIN pg_class ON (pg_class.oid = taxhist.tableoid)
            WHERE ( (taxhist_parent_id = pParentId)
              AND   (relname = pTableName) ) LOOP

    _baseTax := currToBase(pCurrId, _t.taxhist_tax, pExchDate);
    _returnVal := _returnVal + _baseTax;
    PERFORM insertIntoGLSeries( pSequence, pSource, pDocType, pDocNumber,
                                _t.tax_sales_accnt_id, _baseTax,
                                pDistDate, pNotes );

    UPDATE taxhist SET
      taxhist_docdate=pExchDate,
      taxhist_distdate=pDistDate,
      taxhist_curr_id=pCurrId,
      taxhist_curr_rate=curr_rate
    FROM curr_rate
    WHERE ((taxhist_id=_t.taxhist_id)
      AND  (pCurrId=curr_id)
      AND  (pExchDate BETWEEN curr_effective AND curr_expires));

  END LOOP;

  RETURN _returnVal;
END;
$$ LANGUAGE plpgsql;
