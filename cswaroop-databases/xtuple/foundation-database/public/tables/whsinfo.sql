select xt.add_column('whsinfo','warehous_picklist_shipform_id', 'INTEGER', NULL, 'public');
select xt.add_column('whsinfo', 'warehous_created',      'TIMESTAMP WITH TIME ZONE', NULL, 'public');
select xt.add_column('whsinfo', 'warehous_lastupdated',  'TIMESTAMP WITH TIME ZONE', NULL, 'public');

select xt.add_constraint('whsinfo','whsinfo_warehous_picklist_shipform_id_fkey', 'FOREIGN KEY (warehous_picklist_shipform_id)
      REFERENCES shipform (shipform_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION', 'public');
