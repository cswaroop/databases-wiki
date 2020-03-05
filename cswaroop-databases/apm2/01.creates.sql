

-- Meta-Model

CREATE TABLE migration (
    id integer NOT NULL,
    name character varying(55) NOT NULL,
    run_at timestamp without time zone DEFAULT now() NOT NULL
);


CREATE TABLE model (
    id integer NOT NULL,
    name character varying(55) NOT NULL,
    slug character varying(55) NOT NULL,
    description text,
    "position" integer DEFAULT 0,
    nested boolean DEFAULT false,
    locked boolean DEFAULT false,
    join_model boolean DEFAULT false,
    abstract boolean DEFAULT false,
    localized boolean DEFAULT false,
    searchable boolean DEFAULT false,
    ancestor_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status_id integer DEFAULT 1,
    status_position integer,
    uuid character varying(255),
    display text
);


CREATE TABLE domain (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying(255),
    description text,
    site_id integer,
    site_position integer,
    status_id integer DEFAULT 1,
    status_position integer
);

CREATE TABLE enumeration (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status_id integer DEFAULT 1,
    status_position integer,
    entry character varying(255),
    field_id integer,
    field_position integer
);

CREATE TABLE field (
    id integer NOT NULL,
    name character varying(55) NOT NULL,
    slug character varying(55) NOT NULL,
    type character varying(256) NOT NULL,
    default_value character varying(256),
    link_id integer,
    model_id integer NOT NULL,
    model_position integer DEFAULT 0,
    target_id integer,
    target_type character varying(55) DEFAULT NULL::character varying,
    description text,
    "position" integer DEFAULT 0,
    required boolean DEFAULT false,
    disjoint boolean DEFAULT false,
    singular boolean DEFAULT false,
    locked boolean DEFAULT false,
    immutable boolean DEFAULT false,
    editable boolean DEFAULT true,
    searchable boolean DEFAULT false,
    dependent boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status_id integer DEFAULT 1,
    status_position integer,
    format character varying(32) DEFAULT NULL::character varying,
    map boolean,
    localized boolean,
    uuid character varying(255)
);



CREATE TABLE i18n (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    resource_key character varying(255),
    value text,
    status_id integer DEFAULT 1,
    status_position integer
);



--
-- Name: locale; Type: TABLE; Schema: public; Owner: taiga
--

CREATE TABLE locale (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    language character varying(255),
    region character varying(255),
    code character varying(255),
    description text,
    status_id integer DEFAULT 1,
    status_position integer
);



-- Master Data

CREATE TABLE country
(
	id text primary key default uuid_generate_v1mc()::text,
	code text,
	details jsonb,
	is_active boolean DEFAULT true
);

INSERT INTO country(code) VALUES (('GB'), ('IT'), ('CO'), ('CL'), ('MX'));

CREATE TABLE currency
(
	id text primary key default uuid_generate_v1mc()::text,
	code text,
	symbol text,
	is_active boolean
);
INSERT INTO currency(code) VALUES (('GBP'), ('EUR'), ('USD'));

CREATE TABLE group
(
	id text primary key default uuid_generate_v1mc()::text,
	details jsonb
);

CREATE TABLE role
(
	id text primary key default uuid_generate_v1mc()::text,
	details jsonb
);

CREATE TABLE role_group
(
	role_id text,
	group_id text
);

CREATE TABLE permission
(
	id text primary key default uuid_generate_v1mc()::text,
	entity text
	details jsonb
);

CREATE TABLE org
(
	id text primary key default uuid_generate_v1mc()::text,
	org_type text,
	parent_id text,
	details jsonb
);

CREATE TABLE user
(
	id text primary key default uuid_generate_v1mc()::text,
	user_id text,
	password text
);

CREATE TABLE user_group 
(
	user_id uuid,
	group_id uuid
);

CREATE TABLE user_role
(
	user_id uuid,
	role_id uuid
);


CREATE TABLE tenant
(
	id text primary key default uuid_generate_v1mc()::text,
	details jsonb,
	updated_at timestamptz default now()

);


CREATE TABLE project
(
	id text primary key default uuid_generate_v1mc()::text,
	name text,
	details jsonb,
	updated_at timestamptz default now()
);

CREATE TABLE project_group
(
	project_id uuid,
	group_id uuid
);


CREATE TABLE product_category
(
	id text primary key default uuid_generate_v1mc()::text,
	name text,
	category text
);

CREATE TABLE product
(
	id text primary key default uuid_generate_v1mc()::text,
	name text,
	category_id text
);


-- Transaction Data

CREATE TABLE channel 
(
	id text primary key default uuid_generate_v1mc()::text,
	name text,
	details jsonb
);

CREATE TYPE app_type as enum
(
	'CONSUMER',
	'COMMERCIAL'
);

CREATE TYPE app_subtype as enum
(
	'SOLE_TRADER',
	'SELF_EMPLOYED'
	'PARTNERSHIP'
);

CREATE TABLE app (
	id text primary key default uuid_generate_v1mc()::text,
	project_id uuid,
	country_id uuid,
	app_type app_type,
	app_subtype app_subtype,
	ext_id text,
	version int,
	channel_id uuid,
	decision_id uuid,
	decision_due_by timestamptz,
	decision_expiry timestamptz,
	is_locked boolean,
	details jsonb,
	updated_at timestamptz default now()
);

CREATE TYPE app_status AS enum
(
	'SUBMITTED',
	'IN_PROGRESS',
	'COMPLETED'
);

CREATE TYPE app_substatus AS enum
(
	'DRAFT',
	'SUBMITTED',
	'WITHDRAWN',
	'PENDING_DUPLICATE_RESOLUTION',
	'PENDING_REVIEW_RESOLUTION',
	'PENDING_MISSING_DATA',
	'PENDING_ERROR_RESOLUTION',
	'PENDING_CONCURRENCE_REVIEW',
	'PENDING_QUALITY_REVIEW',
	'REFERRAL',
	'PURCHASE_RESCORED'
	'COMPLETED',
	'ESCALATION',

);

CREATE TYPE action_type AS enum 
(
	'DRAFT_CREATED',
	'DRAFT_MODIFIED',
	'SUBMITTED',
	'DUPLICATE_CHECK',
	'INTERNAL_FRAUD_CHECK',
	'CREDIT_LINE_CHECK',
	'PRIOR_EXPERIENCE_CHECK',
	'CONCURRENCE_COMPLETED',
	'QUALITY_REVIEW_COMPLETED'
	'DM1_COMPLETED',
	'DM2_COMPLETED',
	'DM3_COMPLETED',
	'DM4_COMPLETED'

);

CREATE TABLE app_actions (
	id text primary key default uuid_generate_v1mc()::text,
	action_type action_type,
	actioned_party uuid,
	from_status app_substatus,
	to_status app_substatus,
	details jsonb,
	updated_at timestamptz default now()
);


CREATE TYPE applicant_type as enum
(
	'PERSON',
	'COMPANY'
);

CREATE TYPE applicant_role as enum
(
	'MAIN_APPLICANT',
	'CO_APPLICANT',
	'GUARANTOR',
	'DIRECTOR',
	'EFFECTIVE_OWNER',
	'PARTY'
);



CREATE TABLE applicant 
(
	id text primary key default uuid_generate_v1mc()::text,
	"type" applicant_type,
	"role" applicant_role,
	app_id uuid,
	applicant_order int,
	name text,
	details jsonb,
	updated_at timestamptz default now()
);

CREATE TYPE interface_type AS enum
(
	'GB_EQUIFAX_CONSUMER',
	'GB_EQUIFAX_COMMERCIAL'
	'GB_EXPERIAN',
	'IT_CRIF_CONSUMER_INC',
	'IT_CRIF_CONSUMER_IV',
	'IT_CRIF_CONSUMER_IACE',
	'IT_CRIF_COMMERCIAL_INC',
	'IT_CRIF_COMMERCIAL_IV',
	'IT_CRIF_COMMERCIAL_IACE',
	'IT_EXPERIAN_1CCN',
	'IT_EXPERIAN_2CCN',
	'IT_EXPERIAN_3CCN',
	'IT_CRIF_FRAUD_AUTO',
	'IT_CRIF_FRAUD_MANUAL',
	'IT_CRIF_REALESTATE',
	'BRIDGER_CONSUMER',
	'BRIDGER_COMMERCIAL'
	'GB_DM',
	'IT_DM',
	'DEALER_STATUS_UPDATE',
	'EXPERIENCE',
	'FDO'
);

CREATE TABLE interface_config
(
	interface_type interface_type,
	details jsonb
);

CREATE TABLE interface
(
	id text primary key default uuid_generate_v1mc()::text,
	"type" interface_type,
	app_id uuid,
	applicant_id uuid,
	req text,
	res text,
	error text,
	details jsonb,
	updated_at timestamptz default now()
);

CREATE TYPE decision_type as enum
(
	'MANUAL',
	'AUTO'
);

CREATE TYPE decision_subtype as enum
(
	'AUTO_APPROVED',
	'AUTO_REJECTED',
	'AUTO_CONDITIONAL_APPROVED',
	'AUTO_ACTION',
	'AUTO_REVIEW',
	'AUTO_PENDING_MISSING_DATA',
	'AUTO_PENDING_ERROR_RESOLUTION',
	'AUTO_NO_DECISION',
	'AUTO_INVESTIGATE',
	'MANUAL_APPROVED',
	'MANUAL_REJECTED',
	'MANUAL_CONDITIONAL_APPROVED',
	'MANUAL_ACTION'

);

CREATE TABLE decision
(
	id text primary key default uuid_generate_v1mc()::text,
	decision_type decision_type,
	decision_subtype decision_subtype,
	app_id uuid,
	dm_id uuid,
	details jsonb,
	decisioned_party uuid,
	is_active boolean,
	updated_at timestamptz default now()
);

CREATE TABLE queue
(
	id text primary key default uuid_generate_v1mc()::text,
	project_id uuid,
	is_global boolean,
	name text,
	criteria text,
	sla_min int,
);



