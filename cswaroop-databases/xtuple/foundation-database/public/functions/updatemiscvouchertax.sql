SELECT dropifexists('FUNCTION', 'updatemiscvouchertax(integer, integer, date, integer, numeric)');

CREATE OR REPLACE FUNCTION updatemiscvouchertax(pvoheadid integer, ptaxzone integer, pdate date, pcurr integer)
  RETURNS numeric AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
   _distid	integer;
   _total 	numeric := 0;
   _taxd	RECORD;
   _taxt	RECORD;
   _taxamount	numeric;
   _tax		numeric;
   _taxamnt	numeric;
   _subtotal	numeric;
   _vonote      TEXT := 'Auto Created Tax - ';
   _revchg	TEXT := 'Reverse Charge - ';
BEGIN
   -- Remove existing VAT tax distributions
   DELETE FROM vodist 
   WHERE ((vodist_vohead_id = pVoheadid)
    AND (vodist_tax_id > 0)
    AND ((vodist_notes ~ _vonote )
         OR (vodist_notes ~ _revchg )) );

   -- Create temporary store for tax codes and amount for summation later
   -- as combinations of tax types could return the same code and we do not
   -- want duplicates
   CREATE TEMPORARY TABLE _vodisttax (vodisttax_vohead_id integer, vodisttax_taxtype_id INTEGER, 
                                      vodisttax_tax_id integer, vodisttax_tax_code text, vodisttax_amount numeric);

   -- Get VAT Tax Type(s) from Distributions
   <<taxtypes>>
   FOR _taxt IN
     SELECT vodist_taxtype_id, SUM(vodist_amount) as vodist_amount
     FROM vodist
     WHERE ((vodist_vohead_id = pVoHeadid)
       AND (vodist_taxtype_id > 0))
     GROUP BY vodist_taxtype_id
   LOOP  
     -- Determine the Tax details for the Voucher Tax Zone/Types returned
     <<taxdetail>>
     FOR _taxd IN
	SELECT taxdetail_tax_id, taxdetail_tax_code, taxdetail_tax
	FROM calculatetaxdetail(ptaxzone, _taxt.vodist_taxtype_id, pdate, pcurr, _taxt.vodist_amount)
	ORDER BY taxdetail_taxclass_sequence DESC
     LOOP
       INSERT INTO _vodisttax (vodisttax_vohead_id, vodisttax_taxtype_id, vodisttax_tax_id, vodisttax_tax_code, vodisttax_amount)
         VALUES (pVoHeadid, _taxt.vodist_taxtype_id, _taxd.taxdetail_tax_id, _taxd.taxdetail_tax_code, _taxd.taxdetail_tax);
       _total = _total + _taxd.taxdetail_tax;
     END LOOP taxdetail;

   -- Insert VODIST Tax Line
     INSERT INTO vodist (vodist_poitem_id, vodist_vohead_id, vodist_costelem_id, vodist_accnt_id, vodist_amount, vodist_taxtype_id, vodist_tax_id, vodist_discountable, vodist_notes)
       SELECT -1, pVoheadid, -1, -1, round(SUM(vodisttax_amount),2), vodisttax_taxtype_id, vodisttax_tax_id, false, _vonote||vodisttax_tax_code
       FROM _vodisttax
       WHERE ((vodisttax_vohead_id = pVoHeadid)
         AND  (vodisttax_taxtype_id = _taxt.vodist_taxtype_id))
       GROUP BY vodisttax_vohead_id, vodisttax_taxtype_id, vodisttax_tax_id, vodisttax_tax_code;

   -- Check for VAT Reverse charge and apply opposing entry if required.
      IF (EXISTS(SELECT 1 FROM taxass
                  WHERE ((taxass_reverse_tax) 
                  AND (COALESCE(taxass_taxzone_id, -1) = ptaxzone)
                  AND (COALESCE(taxass_taxtype_id, -1) IN (_taxt.vodist_taxtype_id, -1))
                  ))) THEN
         INSERT INTO vodist (vodist_poitem_id, vodist_vohead_id, vodist_costelem_id, vodist_accnt_id, vodist_amount, vodist_tax_id, vodist_discountable, vodist_notes)
           SELECT -1, pVoheadid, -1, -1, (round(SUM(vodisttax_amount),2) * -1), vodisttax_tax_id, false, _revchg||vodisttax_tax_code
           FROM _vodisttax
           WHERE ((vodisttax_vohead_id = pVoHeadid)
            AND   (vodisttax_taxtype_id = _taxt.vodist_taxtype_id))
           GROUP BY vodisttax_vohead_id, vodisttax_tax_id, vodisttax_tax_code;
      END IF;

   END LOOP taxtypes;

   -- Tidy up
   DROP TABLE IF EXISTS _vodisttax;
   
   -- All done   
   RETURN _total;
    
END;
$$ LANGUAGE plpgsql;
