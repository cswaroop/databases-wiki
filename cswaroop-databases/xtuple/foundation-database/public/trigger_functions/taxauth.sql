CREATE OR REPLACE FUNCTION _taxauthBeforeTrigger() RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  IF (NOT checkPrivilege('MaintainTaxAuthorities')) THEN
    RAISE EXCEPTION 'You do not have privileges to maintain Tax Authorities.';
  END IF;

  IF (NEW.taxauth_code IS NULL) THEN
    RAISE EXCEPTION 'You must supply a Tax Authority Code.';
  END IF;

  IF (TG_OP = 'INSERT' AND
      fetchMetricText('CRMAccountNumberGeneration') IN ('A','O')) THEN
    PERFORM clearNumberIssue('CRMAccountNumber', NEW.taxauth_code);
  END IF;

  NEW.taxauth_code := UPPER(NEW.taxauth_code);

  -- Timestamps
  IF (TG_OP = 'INSERT') THEN
    NEW.taxauth_created := now();
  ELSIF (TG_OP = 'UPDATE') THEN
    NEW.taxauth_lastupdated := now();
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('trigger', 'taxauthBeforeTrigger');
CREATE TRIGGER taxauthBeforeTrigger BEFORE INSERT OR UPDATE ON taxauth
       FOR EACH ROW EXECUTE PROCEDURE _taxauthBeforeTrigger();

CREATE OR REPLACE FUNCTION _taxauthAfterTrigger () RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  IF (TG_OP = 'INSERT') THEN
    -- http://www.postgresql.org/docs/current/static/plpgsql-control-structures.html#PLPGSQL-UPSERT-EXAMPLE
    LOOP
      UPDATE crmacct SET crmacct_taxauth_id=NEW.taxauth_id,
                         crmacct_name=NEW.taxauth_name
       WHERE crmacct_number=NEW.taxauth_code;
      IF (FOUND) THEN
        EXIT;
      END IF;
      BEGIN
        INSERT INTO crmacct(crmacct_number,   crmacct_name,     crmacct_active,
                            crmacct_type,     crmacct_taxauth_id
                  ) VALUES (NEW.taxauth_code, NEW.taxauth_name, TRUE, 
                            'O',              NEW.taxauth_id);
        EXIT;
      EXCEPTION WHEN unique_violation THEN
            -- do nothing, and loop to try the UPDATE again
      END;
    END LOOP;

    /* TODO: default characteristic assignments based on what? */

  ELSIF (TG_OP = 'UPDATE') THEN
    UPDATE crmacct SET crmacct_number = NEW.taxauth_code
    WHERE ((crmacct_taxauth_id=NEW.taxauth_id)
      AND  (crmacct_number!=NEW.taxauth_code));

    UPDATE crmacct SET crmacct_name = NEW.taxauth_name
    WHERE ((crmacct_taxauth_id=NEW.taxauth_id)
      AND  (crmacct_name!=NEW.taxauth_name));

  END IF;

  IF (fetchMetricBool('TaxAuthChangeLog')) THEN
    IF (TG_OP = 'INSERT') THEN
      PERFORM postComment('ChangeLog', 'TAXAUTH', NEW.taxauth_id, 'Created');

    ELSIF (TG_OP = 'UPDATE') THEN
      IF (OLD.taxauth_code <> NEW.taxauth_code) THEN
        PERFORM postComment('ChangeLog', 'TAXAUTH', NEW.taxauth_id, 'Code',
                            OLD.taxauth_code, NEW.taxauth_code);
      END IF;

      IF (OLD.taxauth_name <> NEW.taxauth_name) THEN
        PERFORM postComment('ChangeLog', 'TAXAUTH', NEW.taxauth_id, 'Name',
                            OLD.taxauth_name, NEW.taxauth_name);
      END IF;

      IF (OLD.taxauth_extref <> NEW.taxauth_extref) THEN
        PERFORM postComment('ChangeLog', 'TAXAUTH', NEW.taxauth_id, 'External Ref.',
                            OLD.taxauth_extref, NEW.taxauth_extref);
      END IF;

      IF (OLD.taxauth_addr_id <> NEW.taxauth_addr_id) THEN
        PERFORM postComment('ChangeLog', 'TAXAUTH', NEW.taxauth_id, 'Address',
                            formatAddr(OLD.taxauth_addr_id), formatAddr(NEW.taxauth_addr_id));
      END IF;

      IF (OLD.taxauth_curr_id <> NEW.taxauth_curr_id) THEN
        PERFORM postComment('ChangeLog', 'TAXAUTH', NEW.taxauth_id, 'Currency',
                            currConcat(OLD.taxauth_curr_id), currConcat(NEW.taxauth_curr_id));
      END IF;

      IF (OLD.taxauth_county <> NEW.taxauth_county) THEN
        PERFORM postComment('ChangeLog', 'TAXAUTH', NEW.taxauth_id, 'County',
                            OLD.taxauth_county, NEW.taxauth_county);
      END IF;

      IF (OLD.taxauth_accnt_id <> NEW.taxauth_accnt_id) THEN
        PERFORM postComment('ChangeLog', 'TAXAUTH', NEW.taxauth_id, 'Account',
                            formatGLAccount(OLD.taxauth_accnt_id), formatGLAccount(NEW.taxauth_accnt_id));
      END IF;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('trigger', 'taxauthAfterTrigger');
CREATE TRIGGER taxauthAfterTrigger AFTER INSERT OR UPDATE ON taxauth
       FOR EACH ROW EXECUTE PROCEDURE _taxauthAfterTrigger();

CREATE OR REPLACE FUNCTION _taxauthBeforeDeleteTrigger() RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  IF (NOT checkPrivilege('MaintainTaxAuthorities')) THEN
    RAISE EXCEPTION 'You do not have privileges to maintain Tax Authorities.';
  END IF;

  UPDATE crmacct SET crmacct_taxauth_id = NULL
   WHERE crmacct_taxauth_id = OLD.taxauth_id;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('trigger', 'taxauthBeforeDeleteTrigger');
CREATE TRIGGER taxauthBeforeDeleteTrigger BEFORE DELETE ON taxauth
       FOR EACH ROW EXECUTE PROCEDURE _taxauthBeforeDeleteTrigger();

CREATE OR REPLACE FUNCTION _taxauthAfterDeleteTrigger () RETURNS TRIGGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN
  IF (EXISTS(SELECT 1
               FROM checkhead
              WHERE checkhead_recip_id = OLD.taxauth_id
                AND checkhead_recip_type='T')) THEN
    RAISE EXCEPTION 'Cannot delete the tax authority % because checks have been written to it [xtuple: deleteTaxAuthority, -7, %]',
                    OLD.taxauth_number, OLD.taxauth_number;
  END IF;

  IF (fetchMetricValue('DefaultTaxAuthority') = OLD.taxauth_id) THEN
    RAISE EXCEPTION 'Cannot delete the default Tax Authority [xtuple: deleteTaxAuthority, -8, %]',
                    OLD.taxauth_code;
  END IF;

  IF (fetchMetricBool('TaxAuthChangeLog')) THEN
    PERFORM postComment('ChangeLog', 'TAXAUTH', OLD.taxauth_id,
                        'Deleted "' || OLD.taxauth_number || '"');
  END IF;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

SELECT dropIfExists('trigger', 'taxauthAfterDeleteTrigger');
CREATE TRIGGER taxauthAfterDeleteTrigger AFTER DELETE ON taxauth
       FOR EACH ROW EXECUTE PROCEDURE _taxauthAfterDeleteTrigger();
