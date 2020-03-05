create schema omf;

create table omf.client (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  code text not null unique,
  name text
);


create table country (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  cou_code char(2) not null default '' UNIQUE,
  name varchar(80) not null default '',
  cou_name varchar(80) not null default '',
  iso3 char(3) default null,
  numcode int default null
);

create table currency_type (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  code int not null default '0',
  currency_id char(3) not null default '' UNIQUE,
  currency_name varchar(70) not null default ''
);

create table province (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  seq int UNIQUE,
  province_name varchar(40) not null default '',
  province_code char(2) not null default '',
  cou_code char(2) not null default 'uk'
);

create table nationality (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  seq int not null UNIQUE,
  name varchar(100) not null
);

create type omf.mime_type as enum(
  'application/xml',
  'application/json',
  'application/xhtml+xml',
  'application/pdf',
  'text/html'
);


create table omf.attachment (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  mime_type omf.mime_type,
  body text,
  created_at timestamp default now(),
  updated_at timestamp default now()
);

create table omf.org (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  client_id uuid REFERENCES omf.client (id),
  parent_id uuid REFERENCES omf.org (id),
  kind text,
  name text,
  code text,
  currency text,
  settings text
);

create table omf.user (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  first_name       text not null check (char_length(first_name) < 80),
  last_name        text check (char_length(last_name) < 80),
  about            text,
  created_at       timestamp default now()
);

create table omf.user_account (
  user_id        uuid primary key references omf.person(id) on delete cascade,
  email            text not null unique check (email ~* '^.+@.+\..+$'),
  password_hash    text not null
);

create table omf.dealer (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  org_id uuid REFERENCES omf.org(id),
  number text,
  name text
);

create type omf.application_type as enum(
  'PRIVATE_INDIVIDUAL',
  'SOLE_TRADER',
  'COMPANY',
  'PARTNERSHIP',
  'PARTNERSHIP_GT3'
);

create table omf.application (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  external_id text UNIQUE NOT NULL,
  dealer_reference_num text,
  version int,
  org_id uuid REFERENCES omf.org (id),
  dealer_id uuid REFERENCES omf.dealer (id),
  application_type omf.application_type,
  currency text,
  country text,
  workflow_status text,
  latest_decision text,
  decision_type omf.decision_type,
  decision_stage omf.decision_stage_type,
  app_status omf.app_status_type,
  internal_notes text,
  notes_to_dealer text,
  UNIQUE (country, dealer_reference_num, version),
  created_at timestamp default now(),
  updated_at timestamp default now()
);


comment on table  omf.application is 'credit application for decisioning';
comment on column omf.application.id is 'system generated unique id';
comment on column omf.application.external_id is 'external id by which this application is addressed';

create table omf.application_status_changes (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  application_id uuid REFERENCES omf.application (id),
  from_status text,
  to_status text,
  activity_name text,
  user_id uuid,
  updated_at timestamp
);

create table omf.application_attachment (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  application_id REFERENCES omf.application (id),
  application_input_id uuid REFERENCES omf.attachment (id),
  application_review_id uuid REFERENCES omf.attachment (id),
  decision_body_id uuid REFERENCES omf.attachment (id),
  asset_review_id uuid REFERENCES omf.attachment (id),
  finance_review_id uuid REFERENCES omf.attachment (id),
  summary_review_id uuid REFERENCES omf.attachment (id),
  alerts_review_id uuid REFERENCES omf.attachment (id),
  decision_review_id uuid REFERENCES omf.attachment (id),
  dm1_req_id uuid REFERENCES omf.attachment (id),
  dm1_res_id uuid REFERENCES omf.attachment (id),
  dm2_req_id uuid REFERENCES omf.attachment (id),
  dm2_res_id uuid REFERENCES omf.attachment (id),
  dm3_req_id uuid REFERENCES omf.attachment (id),
  dm3_res_id uuid REFERENCES omf.attachment (id),
  dm4_req_id uuid REFERENCES omf.attachment (id),
  dm4_res_id uuid REFERENCES omf.attachment (id),
  dm5_req_id uuid REFERENCES omf.attachment (id),
  dm5_res_id uuid REFERENCES omf.attachment (id),
  dealer_status_update_req uuid REFERENCES omf.attachment (id),
  dealer_status_update_res uuid REFERENCES omf.attachment (id)

);

create table omf.application_x(
  id uuid,
  dealer_reference_number text,
  application_type text,
  version_number int,
  gif_submission_date date,
  gif_submission_time text,
  dfe_submission_ts timestamp,
  dfe_status text,
  input_source text,
  dealer_comments text,
  record_transmission_type text,
  country_code text,
  update_application_number text,
  dealer_name text,
  dealer_number text,
  dealer_telephone_number text,
  currency text

);

create table omf.previous_application (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  application_id uuid REFERENCES omf.application(id),
  prev_application_id uuid REFERENCES omf.application(id)
);


create type omf.bureau_type as enum(
  'UK_EQUIFAX_CONSUMER',
  'UK_EQUIFAX_COMMERCIAL',
  'UK_EXPERIAN_CONSUMER'
);

create table omf.bureau(
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  bureau_type omf.bureau_type,
  first_name text,
  middle_name text,
  last_name text,
  birth_date date,
  current_post_code text,
  company_reg_number text,
  pulled_at timestamp,
  created_at timestamp default now(),
  updated_at timestamp default now()
);

create table omf.bureau_attachment(
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  bureau_id uuid REFERENCES omf.bureau (id),
  request_id uuid REFERENCES omf.attachment (id),
  response_id uuid REFERENCES omf.attachment (id),
  bureau_image uuid REFERENCES omf.attachment (id),
  recent_searches_id uuid REFERENCES omf.attachment (id),
  historic_searches_id uuid REFERENCES omf.attachment (id),
  trade_lines_id uuid REFERENCES omf.attachment (id),
  flags_id uuid REFERENCES omf.attachment (id),
  created_at timestamp default now(),
  updated_at timestamp default now()
);


create table omf.bureau_x (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  bureau_id uuid REFERENCES omf.bureau (id),
  credit_lines_current_count int,
  credit_lines_settled_count int,
  credit_lines_worst_current int
);

create table omf.contract(
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  customer_name text,
  experience text,
  dob date,
  additional_buyers int,
  contract_date date,
  vehicle_name text,
  body_id uuid REFERENCES omf.attachment (id),
  created_at timestamp default now(),
  updated_at timestamp default now()
);

create type omf.credit_line_party_type as enum (
'CONSUMER',
'BUSINESS',
'DEALER'
);

create table omf.credit_line(
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  org_id uuid REFERENCES omf.org (id),
  party_type omf.credit_line_party_type
  consumer_first_name text,
  consumer_middle_name text,
  consumer_last_name text,
  consumer_dob date,
  consumer_gender text,
  business_company_reg_num text,
  business_company_name text,
  business_vat_num text,
  dealer_number text,
  dealer_name text,
  dealer_vat text,
  dealer_fleet text,
  dealer_product text
  addr1 text,
  addr2 text,
  addr3 text,
  addr4 text,
  addr5 text,
  credit_limit_amt numeric,
  credit_expiry_date date,
  srs_multi_user_num text  
  potential_true_customer boolean,
  expiry_date date,
  is_active boolean,
  last_review_date date,
  retrieved_at timestamp,
  created_at timestamp default now(),
  updated_at timestamp default now()
);

create type omf.applicant_type as enum (
  'MAIN_APPLICANT',
  'CO_APPLICANT',
  'GUARANTOR',
  'DIRECTOR',
  'BUSINESS_PARTNER',
  'EFFECTIVE_OWNER'
);

create type omf.applicant_category as enum (
  'PERSON_APPLICANT',
  'BUSINESS_APPLICANT'
);

create table omf.applicant (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  application_id uuid REFERENCES omf.application(id),
  applicant_category omf.applicant_category,
  applicant_position int,
  applicant_type omf.applicant_type,
  first_name text,
  middle_name text,
  last_name text,
  prefix_name text,
  suffix_name text,
  birth_date date,
  gender text,
  residential_status text,
  relationship_to_applicant text,
  nationality uuid REFERENCES omf.country (id),
  company_number text,
  current_address_line_1 text,
  current_address_line_2 text,
  current_address_line_3 text,
  current_address_line_4 text,
  current_address_line_5 text,
  current_address_city text,
  current_address_country REFERENCES omf.country (id),
  credit_line_id uuid REFERENCES omf.credit_line(id),
  decision_bureau_id uuid REFERENCES omf.previous_bureau(id),
  created_at timestamp default now(),
  updated_at timestamp default now()
);

create table omf.applicant_it (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  application_id uuid REFERENCES omf.application(id),
  applicant_id uuid REFERENCES omf.applicant (id),
  birth_city text,
  birth_province text,
  fiscal_number text,
  document_code text,
  document_id text,
  document_expiry_date text,
  document_release_authority text,
  politically_exposed text,
  real_estate_check text,
  current_address_street_type text,
  current_address_monthly_rent numeric,
  net_monthly_salary numeric,
  number_of_salary_payments int,
  employment_type text,
  cciaa_number text,

);


create table omf.applicant_attachment (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  application_id uuid REFERENCES omf.application (id),
  applicant_id uuid REFERENCES omf.applicant (id),
  applicant_delta_id uuid REFERENCES omf.attachment (id),
  contact_delta_id uuid REFERENCES omf.attachment (id),
  current_address_delta_id uuid REFERENCES omf.attachment (id),
  current_employment_delta_id uuid REFERENCES omf.attachment (id),
  previous_employment_delta_id uuid REFERENCES omf.attachment (id),
  bank_account_delta_id uuid REFERENCES omf.attachment (id),
  policy_delta_id uuid REFERENCES omf.attachment (id),
  cwa_delta_id uuid REFERENCES omf.attachment (id),
  contract_history_id uuid REFERENCES omf.attachment (id),
  fraud_delta_id uuid REFERENCES omf.attachment (id),
  compliance_delta_id uuid REFERENCES omf.attachment (id),
  potential_accomodation_id uuid REFERENCES omf.attachment (id),
  summary uuid REFERENCES omf.attachment (id),
  created_at timestamp default now(),
  updated_at timestamp default now()
);

create table omf.applicant_x (
  id uuid,
  trading_name text,
  company_phone text,
  nature_of_business text,
  vat text,
  gross_annual_income numeric,
  time_trading_months int,
  time_trading_years int,
  title text,
  first_name text,
  middle_name text,
  last_name text,
  no_of_dependents int,
  home_phone text,
  work_phone text,
  mobile_phone text,
  email text,
  is_primary_contact boolean,
  gender text,
  residential_status text,
  future_obligations boolean,
  use_of_credit_info boolean,
  party_type text,
  existing_customer boolean,
  guarantee_available boolean,
  current_address_house_number text,
  current_address_house_name text,
  current_address_flat_number text,
  current_address_street_address text,
  current_address_postcode text,
  current_address_locality text,
  current_address_town text,
  current_address_years int,
  address_address_months int,
  bank_account_holder text,
  bank_account_years int,
  bank_account_months int,
  bank_account_payment_method text,
  bank_account_number text,
  bank_account_sort_code text,
  bank_name text,
  bank_address_house_number text,
  bank_address_house_name text,
  bank_address_flat_number text,
  bank_address_street_address text,
  bank_address_postcode text,
  bank_address_locality text,
  bank_address_town text
);

create table omf.previous_bureau (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  application_id uuid REFERENCES omf.application(id),
  applicant_id uuid REFERENCES omf.applicant(id),
  bureau_id uuid REFERENCES omf.bureau(id),
  is_manual_pull boolean,
  created_at timestamp default now(),
  updated_at timestamp default now()
);

create table omf.previous_contract (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  application_id uuid REFERENCES omf.application(id),
  applicant_id uuid REFERENCES omf.applicant(id),
  contract_id uuid REFERENCES omf.bureau(id),
  created_at timestamp default now(),
  updated_at timestamp default now()
);

create table omf.previous_experience (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  application_id uuid REFERENCES omf.application(id),
  applicant_id uuid REFERENCES omf.applicant(id),
  application_number text,
  contract_number text,
  contract_date text,
  response_xml uuid REFERENCES omf.attachment (id),
  created_at timestamp default now(),
  updated_at timestamp default now()
);

create table omf.product (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  parent_id uuid REFERENCES omf.product(id),
  org_id uuid REFERENCES omf.org(id),
  name text,
  kind text,
  code text,
  is_active boolean
);

create table omf.finance (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  application_id uuid REFERENCES omf.application(id),
  product_id uuid REFERENCES omf.product(id),
  vehicle_cash_selling_price numeric,
  vaps numeric,
  cash_deposit numeric,
  fda numeric,
  trade_in_equity numeric,
  total_amount_financed numeric,
  term numeric,
  flat_rate numeric,
  apr numeric,
  residual_system numeric,
  residual_manual numeric,
  annual_mileage numeric,
  total_deposit numeric,
  settlement_amount numeric,
  balloon_gfv numeric,
  total_amount_payable numeric,
  initial_payment numeric,
  security_deposit numeric,
  part_exchange numeric,
  advance_payment numeric,
  interest numeric,
  rental numeric,
  payment numeric,
  cost_inc_vat numeric,
  product_code text,
  finance_type text,
  frequency text,
  plan numeric,
  loan_type text,
  settlement_flag text,
  review_finance uuid REFERENCES omf.attachment (id),
  created_at timestamp default now(),
  updated_at timestamp default now()
);



create type omf.asset_condition as enum (
  'NEW',
  'USED'
);

create type omf.asset_category as enum (
  'CAR'
);

create type omf.asset_usage as enum (
  'MAINLY_PRIVATE'
);

create table omf.asset (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  application_id uuid REFERENCES omf.application(id),
  asset_category omf.asset_category,
  asset_condition omf.asset_condition,
  make text,
  model text,
  variant text,
  reg_number text,
  first_reg_date date,
  reg_plate text,
  mileage numeric,
  usage_type omf.asset_usage,
  ffo text,
  vin text,
  vehicle_id text,
  valuation_manual numeric,
  valuation_system numeric,
  review_asset uuid REFERENCES omf.attachments (id),
  created_at timestamp default now(),
  updated_at timestamp default now()
);


create type omf.decision_type as enum(
  'approve',
  'conditional_approve',
  'action',
  'reject'
);

create type omf.app_status_type as enum(
  'submitted'
  'withdrawn',
  'referral',
  'pending_error_resolution',
  'missing_data',
  'completed'
);

create type omf.decision_stage_type as enum(
  'REVIEW'
  'ESCALATED',
  'CONCURRENCE',
  'QUALITY',
  'DEALER'
);



create table omf.application_history (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  sequence int,
  application_id uuid REFERENCES omf.application(id),
  activity text,
  status_name text,
  user_id text,
  creation_date date,
  open_date date,
  close_date date,
  due_date date,
  input_attachment_id uuid REFERENCES omf.attachment(id),
  output_attachment_id uuid REFERENCES omf.attachment(id),
  created_at timestamp default now(),
  updated_at timestamp default now()
);

create or replace function omf.uuid_v1_timestamp (_uuid uuid)
returns timestamp with time zone as $$

    select
        to_timestamp(
            (
                ('x' || lpad(h, 16, '0'))::bit(64)::bigint::double precision -
                122192928000000000
            ) / 10000000
        )
    from (
        select
            substring (u from 16 for 3) ||
            substring (u from 10 for 4) ||
            substring (u from 1 for 8) as h
        from (values (_uuid::text)) s (u)
    ) s
    ;

$$ language sql immutable;


create index app_uuid_idx on omf.application (omf.uuid_v1_timestamp(omf.application.id));

CREATE OR REPLACE FUNCTION omf.test_data()
RETURNS BOOLEAN AS $$
DECLARE passed BOOLEAN;
        client_id uuid;
        org_id uuid;
        dealer_id uuid;
	product_id uuid;
	o uuid;
	p uuid;
	i integer;
  j integer;
	country text;
BEGIN
	country := 'uk';

	TRUNCATE omf.client CASCADE;
	TRUNCATE omf.org CASCADE;
	TRUNCATE omf.dealer CASCADE;
	TRUNCATE omf.application CASCADE;
	-- client
	INSERT INTO omf.client (name) VALUES ('omf') RETURNING id INTO client_id;
	-- org
	INSERT INTO omf.org (client_id, parent_id,kind, name, code) VALUES (client_id, NULL, 'ORGANIZATION', 'GM Financial', 'omf') RETURNING id INTO o;
  INSERT INTO omf.org (client_id, parent_id,kind, name, code) VALUES (client_id, o, 'CONTINENT', 'EUROPE','EU') RETURNING id INTO o;
	INSERT INTO omf.org (client_id, parent_id,kind, name, code) VALUES (client_id, o, 'COUNTRY', 'UK_COUNTRY', 'UK_C') RETURNING id INTO o;
	INSERT INTO omf.org (client_id, parent_id,kind, name, code) VALUES (client_id, o, 'REGION', 'UK_REGION', 'UK_R') RETURNING id INTO o;
	INSERT INTO omf.org (client_id, parent_id,kind, name, code) VALUES (client_id, o, 'BRANCH', 'UK_BRANCH', 'UK') RETURNING id INTO org_id;
	-- product
	INSERT INTO omf.product (org_id, parent_id,name,kind,code,is_active) VALUES (org_id, NULL, 'SME','PRODUCT_CATEGORY', 'SME', true) RETURNING id INTO o;
	INSERT INTO omf.product (org_id, parent_id,name,kind,code,is_active) VALUES (org_id, NULL, 'IND','PRODUCT_CATEGORY', 'IND', true) RETURNING id INTO p;
	INSERT INTO omf.product (org_id, parent_id,name,kind,code,is_active) VALUES (org_id, o, 'SME_PCP','PRODUCT', 'PCP', true);
	INSERT INTO omf.product (org_id, parent_id,name,kind,code,is_active) VALUES (org_id, o, 'SME_CSHP','PRODUCT', 'CSHP', true);
	INSERT INTO omf.product (org_id, parent_id,name,kind,code,is_active) VALUES (org_id, o, 'SME_LEASING','PRODUCT', 'LEASING', true);
	INSERT INTO omf.product (org_id, parent_id,name,kind,code,is_active) VALUES (org_id, p, 'IND_PCP','PRODUCT', 'PCP', true) RETURNING id INTO product_id;
	INSERT INTO omf.product (org_id, parent_id,name,kind,code,is_active) VALUES (org_id, p, 'IND_CSHP','PRODUCT', 'CSHP', true);
	INSERT INTO omf.product (org_id, parent_id,name,kind,code,is_active) VALUES (org_id, p, 'IND_LEASING','PRODUCT', 'LEASING', true);
	-- dealer
	FOR i IN 1..10 LOOP
		INSERT INTO omf.dealer (org_id, number, name) VALUES (org_id, 'DEALER-'||i,'DEALER-'||i) RETURNING id INTO dealer_id;
	END LOOP;
	-- application
	FOR i IN 1..100 LOOP
		INSERT INTO omf.application(external_id, version, org_id, dealer_id, application_type) VALUES (country||i, 1, org_id, dealer_id, 'private_individual') RETURNING id INTO o;
	END LOOP;


	RETURN true;
END;
$$  LANGUAGE plpgsql
    SECURITY DEFINER;

COMMENT ON FUNCTION omf.test_data() IS 'function that truncates everything to create test data';

SELECT omf.test_data();
