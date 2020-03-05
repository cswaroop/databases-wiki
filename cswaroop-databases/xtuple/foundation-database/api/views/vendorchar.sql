-- Vendor Characteristic

SELECT dropIfExists('VIEW', 'vendorchar', 'api');
CREATE VIEW api.vendorchar
AS 
   SELECT 
     vend_number::varchar AS vendor_number,
     char_name::varchar AS characteristic,
     charass_value AS value
   FROM vendinfo, char, charass
   WHERE (('V'=charass_target_type)
   AND (vend_id=charass_target_id)
   AND (charass_char_id=char_id));

GRANT ALL ON TABLE api.vendorchar TO xtrole;
COMMENT ON VIEW api.vendorchar IS 'Vendor Characteristics';

--Rules

CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.vendorchar DO INSTEAD

  INSERT INTO charass (
    charass_target_type,
    charass_target_id,
    charass_char_id,
    charass_value,
    charass_default
    )
  VALUES (
    'V',
    getvendId(NEW.vendor_number),
    getCharId(NEW.characteristic,'V'),
    NEW.value,
    false);

CREATE OR REPLACE RULE "_UPDATE" AS 
    ON UPDATE TO api.vendorchar DO INSTEAD

  UPDATE charass SET
    charass_value=NEW.value
  WHERE ((charass_target_type='V')
  AND (charass_target_id=getvendid(OLD.vendor_number))
  AND (charass_char_id=getCharId(OLD.characteristic,'V')));
           
CREATE OR REPLACE RULE "_DELETE" AS 
    ON DELETE TO api.vendorchar DO INSTEAD

  DELETE FROM charass
  WHERE ((charass_target_type='V')
  AND (charass_target_id=getvendid(OLD.vendor_number))
  AND (charass_char_id=getCharId(OLD.characteristic,'V')));
