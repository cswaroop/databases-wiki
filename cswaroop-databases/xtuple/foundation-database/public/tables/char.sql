comment on column public."char".char_addresses is 'DEPRECATED - this column has been replaced by a row in the charuse table with target_type ADDR';
comment on column public."char".char_contacts is 'DEPRECATED - this column has been replaced by a row in the charuse table with target_type CNTCT';
comment on column public."char".char_crmaccounts is 'DEPRECATED - this column has been replaced by a row in the charuse table with target_type CRMA';
comment on column public."char".char_customers is 'DEPRECATED - this column has been replaced by rows in the charuse table with target_types C and CT';
comment on column public."char".char_employees is 'DEPRECATED - this column has been replaced by a row in the charuse table with target_type EMP';
comment on column public."char".char_incidents is 'DEPRECATED - this column has been replaced by a row in the charuse table with target_type INCDT';
comment on column public."char".char_invoices is 'DEPRECATED - this column has been replaced by a row in the charuse table with target_type INV';
comment on column public."char".char_items is 'DEPRECATED - this column has been replaced by a row in the charuse table with target_type I';
comment on column public."char".char_lotserial is 'DEPRECATED - this column has been replaced by rows in the charuse table with target_types LS and LSR';
comment on column public."char".char_opportunity is 'DEPRECATED - this column has been replaced by a row in the charuse table with target_type OPP';
comment on column public."char".char_projects is 'DEPRECATED - this column has been replaced by a row in the charuse table with target_type PROJ';
comment on column public."char".char_purchaseorders is 'DEPRECATED - this column has been replaced by a row in the charuse table with target_type PO';
comment on column public."char".char_quotes is 'DEPRECATED - this column has been replaced by a row in the charuse table with target_type QU';
comment on column public."char".char_salesorders is 'DEPRECATED - this column has been replaced by a row in the charuse table with target_type SO';
comment on column public."char".char_tasks is 'DEPRECATED - this column has been replaced by a row in the charuse table with target_type TASK';
comment on column public."char".char_vendors is 'DEPRECATED - this column has been replaced by a row in the charuse table with target_type V';
comment on column public."char".char_vouchers is 'DEPRECATED - this column has been replaced by a row in the charuse table with target_type VCH';

-- Add unique setting to ensure only single usage per target
select xt.add_column('char','char_unique', 'BOOLEAN', 'DEFAULT false', 'public');
