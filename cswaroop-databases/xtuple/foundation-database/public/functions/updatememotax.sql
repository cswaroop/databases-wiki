DROP FUNCTION IF EXISTS updatememotax(text, text, integer, integer, date, integer, numeric);

CREATE OR REPLACE FUNCTION updatememotax(
    pDocSource text,
    pDocType text,
    pMemoId integer,
    pTaxZone integer,
    pDate date,
    pCurr integer,
    pAmount numeric,
    pCurrRate NUMERIC DEFAULT NULL
    )
  RETURNS numeric AS $func$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
   _table       text;
   _total 	numeric := 0;
   _sense       integer := 1;
   _taxd	RECORD;
   _taxt	RECORD;
   _taxamount	numeric;
   _tax		numeric;
   _taxamnt	numeric;
   _subtotal	numeric;
   _delSql      text := $$DELETE FROM %s WHERE taxhist_parent_id = %s; $$;
   _sql         text := $$INSERT INTO %s (taxhist_basis, taxhist_percent,
                                          taxhist_amount,taxhist_docdate, 
                                          taxhist_tax_id, taxhist_tax, 
                                          taxhist_taxtype_id, taxhist_parent_id,
                                          taxhist_curr_id, taxhist_curr_rate, taxhist_distdate  )
	                   VALUES (0, 0, 0, '%s'::DATE, %s, %s, %s, %s, %s, %s, '%s'::DATE); $$;
   _revsql      text := $$INSERT INTO %s (taxhist_basis, taxhist_percent,
                                          taxhist_amount,taxhist_docdate, 
                                          taxhist_tax_id, taxhist_tax, 
                                          taxhist_taxtype_id, taxhist_parent_id, 
                                          taxhist_reverse_charge)
	                   VALUES (0, 0, 0, '%s'::DATE, %s, (%s * -1), %s, %s, TRUE); $$;
BEGIN
-- A/P memos
   IF (pDocSource = 'AP') THEN
     _table = 'apopentax';
     IF (pDocType = 'D') THEN
       _sense = -1;
     END IF;  
-- A/R memos
   ELSIF (pDocSource = 'AR') THEN
     _table = 'aropentax';
     IF (pDocType = 'C') THEN
       _sense = -1;
     END IF;  
   ELSE
     RAISE EXCEPTION 'Invalid memo type %', pDocSource;
   END IF;

   EXECUTE format(_delSql, _table, pMemoid);   

   -- Get Tax Adjustment Type(s) from configuration (auto-tax only)
   <<taxtypes>>
   FOR _taxt IN
     SELECT DISTINCT COALESCE(taxass_taxtype_id, getadjustmenttaxtypeid()) AS taxass_taxtype_id
     FROM tax
     JOIN taxass ON (tax_id=taxass_tax_id)
     WHERE ((taxass_memo_apply)
       AND (taxass_taxtype_id = getadjustmenttaxtypeid()
              OR taxass_taxtype_id IS NULL)
      AND  (taxass_taxzone_id = ptaxzone))
   LOOP  

     -- Determine pre-tax subtotal
     _subtotal := (SELECT calculatepretaxtotal(ptaxzone, _taxt.taxass_taxtype_id, pdate, pcurr, pamount));

     -- Determine the Tax details for the Voucher Tax Zone
     <<taxdetail>>
     FOR _taxd IN
	SELECT taxdetail_tax_code, taxdetail_tax_id,taxdetail_taxrate_percent,COALESCE(taxdetail_taxrate_amount,0.00) as taxdetail_taxrate_amount,
	       taxdetail_taxclass_sequence as seq 
	FROM calculatetaxdetail(ptaxzone, _taxt.taxass_taxtype_id, pdate, pcurr, pamount)
	ORDER BY taxdetail_taxclass_sequence DESC
	
     LOOP
     -- Calculate Tax Amount
       _taxamount = ((_subtotal * _taxd.taxdetail_taxrate_percent) + _taxd.taxdetail_taxrate_amount) * _sense;
       
       -- Insert Tax Line
       EXECUTE format(_sql, _table, pDate, _taxd.taxdetail_tax_id, _taxamount, _taxt.taxass_taxtype_id, pMemoid, pCurr,
                      COALESCE(pCurrRate, currrate(pCurr,pDate)), pDate);

       -- Check for and post reverse VAT charges
       IF (EXISTS(SELECT 1 FROM taxass 
                  WHERE ((taxass_reverse_tax) 
                  AND (COALESCE(taxass_taxzone_id, -1) = ptaxzone)
                  AND (COALESCE(taxass_taxtype_id, -1) IN (getAdjustmentTaxTypeId(), -1))))) THEN      
          EXECUTE format(_revsql, _table, pDate, _taxd.taxdetail_tax_id, _taxamount, _taxt.taxass_taxtype_id, pMemoid);
       END IF;
       
       _total = _total + _taxamount;
       -- _subtotal = _subtotal - _taxamount;
       
     END LOOP taxdetail;
   END LOOP taxtypes;

    -- All done   
    RETURN ABS(_total);
    
END;
$func$ LANGUAGE plpgsql;
