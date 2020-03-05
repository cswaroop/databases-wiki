drop schema los cascade;
create schema los;

set search_path=los,public;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE tenant (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    name text
);

CREATE TABLE "user" (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    tenant_id text,
    is_active int,
    creation_date timestamp,
    last_login timestamp,
    name text,
    mobilephone text,
    email text,
    username text,
    password text

);

CREATE TABLE doc (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    outputtype text,
    outputxml text,
    created_at timestamp
);


CREATE TABLE country (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    name text,
    name2 text,
    iso3 text,
    numcode int
);

CREATE TABLE currency (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean

);

CREATE TABLE language (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    country text REFERENCES country(id),
    position int,
    is_active boolean
);

CREATE TABLE org_type (
    code text,
    label text,
    position int,
    is_active boolean,
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY
);

CREATE TABLE org (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    tenant_id text REFERENCES tenant (id),
    parent_id text REFERENCES org (id),
    org_type text REFERENCES org_type (id),
    org_name text,
    org_config jsonb,
    is_active boolean,
    created_at timestamp,
    updated_at timestamp,
    created_by text,
    updated_by text
);

COMMENT ON TABLE org IS 'A tenant''s organization';

CREATE TABLE it_province
(
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean

);

COMMENT ON TABLE it_province IS 'Provinces';

CREATE TABLE it_street_type
(
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean
);

CREATE TABLE address (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    housenumber text,
    housename text,
    flatnumber text,
    streetaddress text,
    postcode text,
    locality text,
    town text,
    country text REFERENCES  COUNTRY (id),
    state text,
    updatedby text,
    updatedon timestamp
);

COMMENT ON TABLE address IS 'Address';

CREATE TABLE app_type
(
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    country text REFERENCES country(id),
    label text,
    position int,
    is_active boolean
);

CREATE TABLE application_status
(
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean
);

CREATE TABLE override_reason
(
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean
);

CREATE TABLE app (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    org_id text REFERENCES org (id),
    application_type text REFERENCES app_type (id),
    application_number text NOT NULL UNIQUE,
    version_number bigint,
    is_version_active smallint,
    application_status text REFERENCES application_status (id),
    withdraw_reason text,
    override_reason text REFERENCES override_reason (id),
    statuschanged_at timestamp,
    expiration_at timestamp,
    applicationlockedby bigint,
    updatedby text
);

COMMENT ON TABLE app IS 'Top Level Business Entity';

CREATE TYPE applicant_type AS ENUM (
    'PERSON',
    'BUSINESS'
);


CREATE TYPE applicant_role AS ENUM (
    'MAIN_APPLICANT',
    'CO_APPLICANT',
    'GUARANTOR',
    'EFFECTIVE_OWNER',
    'PARTY_1',
    'PARTY_2',
    'PARTY_3',
    'PARTY_4'
);


CREATE TABLE applicant (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    applicant_type applicant_type,
    applicant_role applicant_role,
    position integer,
    created_at timestamp DEFAULT NOW(),
    updated_at timestamp DEFAULT NOW()
);



COMMENT ON TABLE applicant IS 'Every applicant of an Application';

CREATE TABLE collateral_type (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean

);

CREATE TABLE app_collateral (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    "type" text REFERENCES collateral_type (id),
    category text,
    make text,
    model text,
    created_at timestamp DEFAULT NOW(),
    updated_at timestamp DEFAULT NOW()
);

CREATE TYPE decision_type AS ENUM (
    'AUTO',
    'MANUAL'
);

CREATE TYPE decision_stage AS ENUM (
    'REVIEW', 
    'ESCALATED',
    'CONCURRENCE',
    'DEALER',
    'QUALITY'
);

CREATE TYPE underwriter_decision AS ENUM (
     'APPROVE',
     'CONDITIONAL_APPROVE',
     'ACTION',
     'REJECT'
);

CREATE TYPE authority_concurrence AS ENUM (
    'AGREE',
    'DISAGREE'
);

CREATE TABLE decision (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    decision_stage decision_stage,
    updatedby bigint,
    updatedon timestamp
);

CREATE TABLE condition_type (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text, -- GREATER, LESS
    position int,
    is_active boolean

);
CREATE TABLE condition_var (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text, -- MIN_ADV, DEPOSIT, LENGTH
    label text,
    position int,
    is_active boolean
);

CREATE TABLE decision_cond (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    decisionid text REFERENCES decision (id) ,
    conditiontype text REFERENCES condition_type (id),
    conditionvar text REFERENCES condition_var (id),
    requested numeric,
    "limit" numeric
);



CREATE TABLE decision_doc (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    decisionid text REFERENCES decision (id),
    documentname text,
    documenttype text,
    documentstatus text
);

CREATE TABLE reason_type (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean

);

CREATE TABLE decision_reasons (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    applicant_id text REFERENCES applicant (id),
    decisionid text REFERENCES decision (id),
    reasontype text REFERENCES reason_type (id)
);


CREATE TABLE decline_reason (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean
);


CREATE TABLE app_decline_reason (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    decline_reason text REFERENCES decline_reason (id)
);



CREATE TABLE ws_dm (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    dmcallsequence int,
    dmrequestid text,
    dmresponseid text

);


CREATE TABLE ws_dm_attachments (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    applicationid text REFERENCES app (id),
    dmcallsequence bigint,
    dmrequestid text,
    dmresponseid text,
    requestxml text REFERENCES doc(id),
    responsexml text REFERENCES doc(id)
);


CREATE TABLE ws_dm_d (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    baseapplicationid text REFERENCES app (id),
    dm1requestid bigint,
    dm2requestid bigint,
    dm3requestid bigint,
    dm4requestid bigint,
    isactive smallint,
    updatedon timestamp
);


CREATE TABLE ws_dm_reasons (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app(id),
    dmreasonid text,
    reasoncode text,
    dmrequestid text
);



CREATE TABLE app_finance (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app(id),
    list_price numeric,
    dealers_extras numeric,
    discount numeric,
    total_vehicle_price numeric,
    teg text,
    finance_fees numeric,
    nominal_rate numeric,
    updatedby bigint,
    updatedon timestamp
);


CREATE TABLE app_workflow (
    id bigint NOT NULL,
    app_id text REFERENCES app (id),
    event_name text,
    status_before text REFERENCES application_status (id),
    status_after text REFERENCES application_status (id),
    time_before timestamp,
    time_after timestamp,
    updatedon timestamp,
    updatedby text
);


CREATE TABLE app_queue (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    queueid bigint,
    entrydatetime timestamp without time zone,
    exitdatetime timestamp without time zone,
    minutesinqueue bigint,
    secondsinqueue bigint
);


CREATE TABLE applicant_business (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    applicant_id text REFERENCES applicant (id),
    vat text
);


CREATE TABLE applicant_business_address (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    applicant_id text REFERENCES applicant (id),
    addresstype  address_type,
    address_id text REFERENCES address (id),
    updatedby text,
    updatedon timestamp
);

CREATE TYPE employer_type AS ENUM (
    'Current',
    'Previous',
    'SecondPrevious'
);

CREATE TABLE employment_type (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean
);

CREATE TABLE occupation (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    employment_type text REFERENCES employment_type (id),
    label text,
    position int,
    is_active boolean

);


CREATE TABLE marital_status (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean

);

CREATE TABLE residential_status (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean

);

CREATE TYPE gender AS ENUM (
    'MALE',
    'FEMALE'
);

CREATE TABLE title (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean
);

CREATE TABLE nationality (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean
);


CREATE TABLE timezone
(
  id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
  timezoneid text,
  displayname text,
  "offset" bigint,
  isindst smallint,
  doesobservedst smallint
);

CREATE TABLE applicant_person (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    applicant_id text REFERENCES applicant (id),
    app_id text REFERENCES app (id),
    prefixname text,
    firstname text,
    middlename text,
    lastname text,
    applicantname text,
    suffixname text,
    birthdate date,
    gender gender,
    maritalstatus text REFERENCES marital_status (id),
    ouremployee boolean
);


CREATE TABLE applicant_person_address (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    applicant_id text REFERENCES applicant (id),
    addresstype address_type,
    address_id text REFERENCES address (id),
    updatedby bigint,
    updatedon timestamp
);

CREATE TABLE profession (    
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean

);


CREATE TABLE applicant_person_employment (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    applicant_id text REFERENCES applicant (id),
    address_id text,
    employertype employer_type,
    employmenttype text REFERENCES employment_type (id),
    profession text REFERENCES profession (id),
    occupation text REFERENCES occupation (id),
    employername text,
    phonenumber text,
    employmentyears bigint,
    employmentmonths bigint,
    annualincome numeric,
    updatedby bigint,
    updatedon timestamp
);

CREATE TABLE cra (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    country text REFERENCES country(id),
    label text,
    position int,
    is_active boolean
);


CREATE TABLE bureau (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    country text REFERENCES country (id),
    product_code text,
    bureaupulltype bigint,
    isnomatchindicator smallint,
    interfaceerror bigint,
    requested_at timestamp with time zone DEFAULT now(),
    responded_at timestamp with time zone DEFAULT now(),
    updatedon timestamp without time zone,
    updatedby text
);

CREATE TABLE bureau_request (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    bureau_id text  REFERENCES  bureau (id),
    firstname text,
    lastname text,
    dob date,
    postcode text,
    companyregnumber text,
    current_address_id text REFERENCES address (id),
    previous_address_id text REFERENCES address (id),
    second_previous_address_id text REFERENCES address (id)
);


CREATE TABLE bureau_attachments (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    bureau_id text  REFERENCES  bureau (id),
    "type" text,
    attachment_id text REFERENCES doc (id)
);

CREATE TABLE applicant_bureau (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    applicant_id text REFERENCES applicant (id),
    bureau_id text,
    expired_at timestamp
);


CREATE TABLE enumerations (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    entity text,
    field text,
    value text,
    order_val integer DEFAULT 0,
    is_active boolean DEFAULT true,
    is_deleted boolean DEFAULT false
);

CREATE TABLE "role"
(
  id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
  name text,
  description text,
  persistent smallint,
  is_active smallint
);

CREATE TABLE "group" (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    name text,
    description text,
    created_by bigint,
    created timestamp,
    tenant_id text,
    has_custom_management smallint
);

CREATE TABLE group_role (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    group_id bigint,
    role_id bigint,
    tenant_id text
);

CREATE TABLE group_user (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    group_id bigint,
    user_id bigint,
    tenant_id text
);

CREATE TABLE locale (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean

);

CREATE TABLE translation(
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL,
    locale text REFERENCES locale (id),
    data text,
    PRIMARY KEY (id, locale)
);

CREATE TABLE org_holidays (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    countrycode text,
    holiday text,
    "date" date
);

CREATE TABLE org_sla_slots (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    organizationid text,
    weekdaysid text,
    timeindecimalformat numeric,
    isallowedsla smallint,
    timeslot timestamp
);


CREATE TABLE product_category_type (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    isactive boolean default true

);

CREATE TABLE product_category (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    categorytype text REFERENCES product_category_type(id),
    label text,
    position int,
    isactive boolean default true

);

CREATE TABLE product (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    country text REFERENCES country (id),
    category text REFERENCES product_category (id),
    label text,
    position int,
    isactive boolean default true
);



CREATE TABLE queue (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    name text,
    description text,
    searchstring text,
    searchstringforquery text,
    groupbyfirstcolumn smallint,
    specialqueue bigint,
    isprioritytype smallint,
    ispersonalqueue smallint,
    personalqueuefield text,
    isenabled boolean,
    isactive boolean default true,
    updatedby bigint,
    updatedon timestamp
);


CREATE TABLE queue_group (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    queueid bigint,
    groupid bigint,
    isactive boolean default true,
    updatedby bigint,
    updatedon timestamp
);


CREATE TABLE queue_sla (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    queueid text NOT NULL,
    queueslainseconds bigint,
    countrycode text
);


CREATE TABLE queue_user (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    queueid text,
    userid text,
    isactive boolean default true,
    updatedby text,
    updatedon timestamp
);


CREATE TABLE queue_user_session (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    userid text,
    queueid text,
    paginationstartindex bigint,
    globalsearch text,
    orderby text
);

CREATE TABLE user_effective_role (
    --id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    role_id text,
    user_id text,
    tenant_id text,
    PRIMARY KEY (role_id, user_id, tenant_id)
);

CREATE TABLE user_role (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    user_id text,
    role_id text,
    tenant_id text
);

