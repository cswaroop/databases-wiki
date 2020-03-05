CREATE OR REPLACE FUNCTION postBillingSelections() RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  RAISE WARNING 'postBillingselections() has been deprecated.  Please use createInvoices().';
  RETURN createInvoices();

END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION postBillingSelections(INTEGER) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  RAISE WARNING 'postBillingselections(int) has been deprecated.  Please use createInvoices(int).';
  RETURN createInvoices($1, false);
END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION postBillingSelections(INTEGER, BOOLEAN) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pCustTypeId ALIAS FOR $1;
  pConsolidate ALIAS FOR $2;

BEGIN

  RAISE WARNING 'postBillingselections(int,bool) has been deprecated.  Please use createInvoices(int,bool).';
  RETURN createInvoices(pCustTypeId, pConsolidate);

END;
$$ LANGUAGE 'plpgsql';
