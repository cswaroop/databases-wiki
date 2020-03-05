CREATE OR REPLACE FUNCTION getwoid(text)
  RETURNS integer AS
$$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pWONumber ALIAS FOR $1;
  _returnVal INTEGER;
BEGIN
  IF (pWONumber IS NULL) THEN
    RETURN NULL;
  END IF;

  SELECT wo_id INTO _returnVal
  FROM wo
  WHERE (wo_number = split_part(pWONumber,'-',1)::INTEGER
    AND wo_subnumber = split_part(pWONumber,'-',2)::INTEGER);


  IF (_returnVal IS NULL) THEN
    RAISE EXCEPTION 'Work Order Number % not found. [xtuple: getwoid, -1]', pWONumber;
  END IF;

  RETURN _returnVal;
END;
$$ LANGUAGE plpgsql;
