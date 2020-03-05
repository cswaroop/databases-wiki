CREATE OR REPLACE FUNCTION checklocation(pLocationid  integer)
  RETURNS integer AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

--  Check to see if any itemsite used the passed location as their default
  IF EXISTS (SELECT itemsite_id FROM itemsite
		WHERE (itemsite_location_id=pLocationid)
	    ) THEN
    RETURN -1;
  END IF;

--  Check to see if any inventory is currently stored at the passed location
  IF EXISTS (SELECT itemloc_id FROM itemloc
		WHERE (itemloc_location_id=pLocationid)
	    ) THEN
    RETURN -2;
  END IF;

--  Check to see if any undistributed inventory transactions are currently posted at the passed location
  IF EXISTS (SELECT itemlocdist_id FROM itemlocdist
		WHERE ( (itemlocdist_source_type='L')
		AND (itemlocdist_source_id=pLocationid) )
            ) THEN
    RETURN -3;
  END IF;

--  Check to see if the passed location has any Inventory Detail posted against it
  IF EXISTS (SELECT invdetail_id FROM invdetail
		WHERE (invdetail_location_id=pLocationid)
             ) THEN
    RETURN -4;
  END IF;

  RETURN pLocationid;

END;
$$ LANGUAGE plpgsql;

