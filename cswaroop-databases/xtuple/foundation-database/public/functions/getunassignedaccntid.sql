DROP FUNCTION IF EXISTS getunassignedaccntid();

CREATE OR REPLACE FUNCTION getunassignedaccntid(pCompanyid INTEGER DEFAULT -1)
  RETURNS integer AS
$BODY$
-- Copyright (c) 1999-2015 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _test INTEGER;
  _returnVal INTEGER;
BEGIN
-- In a Multi-Company scenario we have to check the unassigned accnt for the
-- correct Company.  Otherwise choose the system metric
  
  IF (fetchMetricValue('GLCompanySize') > 0) THEN -- Multi-Company
    IF (pCompanyid = -1) THEN
      RAISE EXCEPTION 'Unassigned G/L Account could not be determined for an unknown Company [xtuple: getunassignedaccntid, -1]';
    ELSE
      SELECT company_unassigned_accnt_id INTO _test
        FROM company
        WHERE company_id = pCompanyid;
    END IF;
  ELSE -- Single Company
    _test := fetchMetricValue('UnassignedAccount');
  END IF;

  IF (_test IS NULL) THEN
    RAISE EXCEPTION 'Metric not found for UnassignedAccount [xtuple: getunassignedaccntid, -2]';
  END IF;

  SELECT accnt_id INTO _returnVal
  FROM accnt
  WHERE (accnt_id=_test);

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'Metric UnassignedAccount is an invalid G/L Account [xtuple: getunassignedaccntid, -3, %1]', _test;
  END IF;

  RETURN _returnVal;
END;
$BODY$
  LANGUAGE plpgsql;
