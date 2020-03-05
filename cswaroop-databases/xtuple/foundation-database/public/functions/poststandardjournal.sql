
CREATE OR REPLACE FUNCTION postStandardJournal(pStdjrnlid INTEGER,
                                               pDate DATE) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  RETURN postStandardJournal(pStdjrnlid, pDate, FALSE, fetchGLSequence());

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION postStandardJournal(pStdjrnlid INTEGER,
                                               pDate DATE,
                                               pReverse BOOLEAN) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  RETURN postStandardJournal(pStdjrnlid, pDate, pReverse, fetchGLSequence());

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION postStandardJournal(pStdjrnlid INTEGER,
                                               pDate DATE,
                                               pGlSequence INTEGER) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  RETURN postStandardJournal(pStdjrnlid, pDate, FALSE, pGlSequence);

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION postStandardJournal(pStdjrnlid INTEGER,
                                               pDate DATE,
                                               pReverse BOOLEAN,
                                               pGlSequence INTEGER) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  INSERT INTO glseries
  ( glseries_sequence, glseries_source, glseries_doctype, glseries_docnumber,
    glseries_notes, glseries_accnt_id, glseries_amount, glseries_distdate )
  SELECT pGlSequence, 'G/L', 'ST', stdjrnl_name,
         (COALESCE(stdjrnl_notes, '') || ' ' || COALESCE(stdjrnlitem_notes, '')),
         stdjrnlitem_accnt_id,
         CASE WHEN (pReverse=TRUE) THEN (stdjrnlitem_amount * -1)
              ELSE stdjrnlitem_amount
         END,
         pDate
  FROM stdjrnl JOIN stdjrnlitem ON (stdjrnlitem_stdjrnl_id=stdjrnl_id)
  WHERE (stdjrnl_id=pStdjrnlid);

  RETURN pGlSequence;

END;
$$ LANGUAGE plpgsql;

