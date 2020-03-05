create table vtiger_users (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  user_name text,
  user_password text,
  user_hash text,
  cal_color text,
  first_name text,
  last_name text,
  reports_to_id uuid,
  is_admin boolean,
  currency_id uuid
);

create table vtiger_users (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
);
