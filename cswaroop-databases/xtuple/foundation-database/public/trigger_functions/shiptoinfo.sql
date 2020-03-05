CREATE OR REPLACE FUNCTION _shiptoinfoBeforeTrigger () RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _SalesRepId INTEGER;
  _SalesRepComm NUMERIC;
  _ShipViaName TEXT;
  _ShipFormId INTEGER;
  _ShipChargeId INTEGER;
  _PreferredWarehousId INTEGER;

BEGIN
  -- Set all the shiptoinfo defaults.

  IF (NEW.shipto_salesrep_id IS NULL OR NEW.shipto_salesrep_id < 1) THEN
    _SalesRepId = fetchmetricvalue('DefaultSalesRep');
    IF (_SalesRepId IS NOT NULL) THEN
      NEW.shipto_salesrep_id = _SalesRepId;
    END IF;
  END IF;

  IF (NEW.shipto_commission IS NULL OR NEW.shipto_commission < 0) THEN
    IF (NEW.shipto_salesrep_id IS NOT NULL) THEN
      _SalesRepId = NEW.shipto_salesrep_id;
    ELSE
      _SalesRepId = fetchmetricvalue('DefaultSalesRep');
    END IF;

    IF (_SalesRepId IS NOT NULL) THEN
      SELECT salesrep_commission INTO _SalesRepComm FROM salesrep WHERE salesrep_id = _SalesRepId;
      NEW.shipto_commission = _SalesRepComm;
    END IF;
  END IF;

  IF (NEW.shipto_shipvia IS NULL OR NEW.shipto_shipvia = '') THEN
    SELECT shipvia_code INTO _ShipViaName FROM shipvia WHERE shipvia_id = fetchmetricvalue('DefaultShipViaId');
    IF (_ShipViaName IS NOT NULL) THEN
      NEW.shipto_shipvia = _ShipViaName;
    END IF;
  END IF;

  IF (NEW.shipto_shipform_id IS NULL OR NEW.shipto_shipform_id < 1) THEN
    _ShipFormId = fetchmetricvalue('DefaultShipFormId');
    IF (_ShipFormId IS NOT NULL) THEN
      NEW.shipto_shipform_id = _ShipFormId;
    END IF;
  END IF;

  IF (NEW.shipto_shipchrg_id IS NULL OR NEW.shipto_shipchrg_id < 1) THEN
    _ShipChargeId = fetchmetricvalue('DefaultShipChrgId');
    IF (_ShipChargeId IS NOT NULL) THEN
      NEW.shipto_shipchrg_id = _ShipChargeId;
    END IF;
  END IF;

  IF (NEW.shipto_preferred_warehous_id IS NULL OR NEW.shipto_preferred_warehous_id < 1) THEN
    _PreferredWarehousId = fetchmetricvalue('DefaultSellingWarehouseId');
    IF (_PreferredWarehousId IS NOT NULL) THEN
      NEW.shipto_preferred_warehous_id = _PreferredWarehousId;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS shiptoinfoBeforeTrigger ON shiptoinfo;
CREATE TRIGGER shiptoinfoBeforeTrigger BEFORE INSERT OR UPDATE ON shiptoinfo FOR EACH ROW EXECUTE PROCEDURE _shiptoinfoBeforeTrigger();


CREATE OR REPLACE FUNCTION _shiptoinfoAfterTrigger () RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  -- Timestamps
  IF (TG_OP = 'INSERT') THEN
    NEW.shipto_created := now();
  ELSIF (TG_OP = 'UPDATE') THEN
    NEW.shipto_lastupdated := now();
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS shiptoinfoBeforeTrigger ON shiptoinfo;
CREATE TRIGGER shiptoinfoBeforeTrigger BEFORE INSERT OR UPDATE ON shiptoinfo
 FOR EACH ROW EXECUTE PROCEDURE _shiptoinfoBeforeTrigger();

CREATE OR REPLACE FUNCTION _shiptoinfoAfterTrigger () RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

  IF (NEW.shipto_default) THEN
    UPDATE shiptoinfo
    SET shipto_default = false
    WHERE ((shipto_cust_id=NEW.shipto_cust_id)
    AND (shipto_id <> NEW.shipto_id));
  END IF;

  IF (fetchMetricBool('CustomerChangeLog')) THEN
    IF (TG_OP = 'INSERT') THEN
      PERFORM postComment('ChangeLog', 'C', NEW.shipto_cust_id, 'Created');

    ELSIF (TG_OP = 'UPDATE') THEN
      IF (OLD.shipto_name <> NEW.shipto_name) THEN
        PERFORM postComment('ChangeLog', 'C', NEW.shipto_cust_id, (NEW.shipto_name || ': Ship To Name'),
                            COALESCE(OLD.shipto_name, ''), COALESCE(NEW.shipto_name, ''));
      END IF;
      IF (OLD.shipto_shipvia <> NEW.shipto_shipvia) THEN
        PERFORM postComment('ChangeLog', 'C', NEW.shipto_cust_id, (NEW.shipto_name || ': Ship To ShipVia'),
                            COALESCE(OLD.shipto_shipvia, ''), COALESCE(NEW.shipto_shipvia, ''));
      END IF;
      IF (COALESCE(OLD.shipto_taxzone_id, -1) <> COALESCE(NEW.shipto_taxzone_id, -1)) THEN
        PERFORM postComment('ChangeLog', 'C', NEW.shipto_cust_id, (NEW.shipto_name || ': Ship To Tax Zone'),
                            COALESCE((SELECT taxzone_code FROM taxzone WHERE taxzone_id=OLD.shipto_taxzone_id), 'None'), 
                            COALESCE((SELECT taxzone_code FROM taxzone WHERE taxzone_id=NEW.shipto_taxzone_id), 'None'));
      END IF;
      IF (OLD.shipto_shipzone_id <> NEW.shipto_shipzone_id) THEN
        PERFORM postComment('ChangeLog', 'C', NEW.shipto_cust_id, (NEW.shipto_name || ': Ship To Shipping Zone'),
                            COALESCE((SELECT shipzone_name FROM shipzone WHERE shipzone_id=OLD.shipto_shipzone_id), 'None'),
                            COALESCE((SELECT shipzone_name FROM shipzone WHERE shipzone_id=NEW.shipto_shipzone_id), 'None'));
      END IF;
      IF (OLD.shipto_salesrep_id <> NEW.shipto_salesrep_id) THEN
        PERFORM postComment('ChangeLog', 'C', NEW.shipto_cust_id, (NEW.shipto_name || ': Ship To Sales Rep'),
                            (SELECT salesrep_name FROM salesrep WHERE salesrep_id=OLD.shipto_salesrep_id),
                            (SELECT salesrep_name FROM salesrep WHERE salesrep_id=NEW.shipto_salesrep_id));
      END IF;
      IF (OLD.shipto_active <> NEW.shipto_active) THEN
        IF (NEW.shipto_active) THEN
          PERFORM postComment('ChangeLog', 'C', NEW.shipto_cust_id, (NEW.shipto_name || ': Ship To Activated'));
        ELSE
          PERFORM postComment('ChangeLog', 'C', NEW.shipto_cust_id, (NEW.shipto_name || ': Ship To Deactivated'));
        END IF;
      END IF;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS shiptoinfoAfterTrigger ON shiptoinfo;
CREATE TRIGGER shiptoinfoAfterTrigger AFTER INSERT OR UPDATE ON shiptoinfo FOR EACH ROW EXECUTE PROCEDURE _shiptoinfoAfterTrigger();
