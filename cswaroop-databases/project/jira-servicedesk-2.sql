CREATE TABLE ORGANIZATION (
    ID integer NOT NULL,
    LOWER_NAME varchar(255) NOT NULL,
    NAME varchar(255) NOT NULL,
    SEARCH_NAME varchar(255) NOT NULL
);


CREATE TABLE ORGANIZATION_MEMBER (
    DEFAULT_ORGANIZATION boolean DEFAULT false NOT NULL,
    ID integer NOT NULL,
    ORGANIZATION_ID integer,
    USER_KEY varchar(255) NOT NULL
);

CREATE TABLE ORGANIZATION_PROJECT (
    ID integer NOT NULL,
    ORGANIZATION_ID integer,
    PROJECT_ID bigint NOT NULL
);

CREATE TABLE QUEUE (
    ID integer NOT NULL,
    JQL text,
    NAME varchar(255) NOT NULL,
    PROJECT_ID bigint NOT NULL,
    PROJECT_KEY varchar(255) NOT NULL,
    QUEUE_ORDER integer
);

CREATE TABLE QUEUE_COLUMN (
    COLUMN_ID varchar(255),
    COLUMN_ORDER integer,
    ID integer NOT NULL,
    QUEUE_ID integer
);

CREATE TABLE REPORT (
    CREATED_DATE timestamp without time zone,
    ID integer NOT NULL,
    NAME varchar(255),
    REPORT_ORDER integer,
    REPORT_TYPE varchar(63),
    SERVICE_DESK_ID integer,
    TARGET bigint,
    UPDATED_DATE timestamp without time zone
);


CREATE TABLE SERVICE_DESK (
    CREATED_BY_USER_KEY varchar(255),
    CREATED_DATE timestamp without time zone,
    CREATED_WITH_EMPTY_PROJECT boolean,
    DISABLED boolean,
    ID integer NOT NULL,
    LEGACY_TRANSITION_DISABLED boolean,
    OPEN_CUSTOMER_ACCESS integer,
    PROJECT_ID bigint,
    PROJECT_KEY varchar(255) DEFAULT 'N/A'::varchar NOT NULL,
    PUBLIC_SIGNUP integer,
    VERSION_CREATED_AT varchar(255)
);

CREATE TABLE SLA_AUDITLOG (
    EVENT_TIME bigint,
    ID bigint NOT NULL,
    ISSUE_ID bigint,
    REASON varchar(255),
    SLA_ID bigint
);

CREATE TABLE SLA_AUDITLOG_DATA (
    ID bigint NOT NULL,
    KEY varchar(255),
    SLA_AUDIT_LOG_ID bigint NOT NULL,
    VALUE varchar(255)
);

CREATE TABLE STATUS_MAPPING (
    FORM_ID integer,
    ID integer NOT NULL,
    STATUS_ID varchar(255),
    STATUS_NAME varchar(255)
);

CREATE TABLE SUBSCRIPTION (
    ID integer NOT NULL,
    ISSUE_ID bigint NOT NULL,
    SUBSCRIBED boolean NOT NULL,
    USER_KEY varchar(255) NOT NULL
);

CREATE TABLE SYNC_UPGRADE_RECORD (
    ACTION varchar(255) NOT NULL,
    CREATED_DATE timestamp without time zone NOT NULL,
    EXCEPTION text,
    ID integer NOT NULL,
    MESSAGE text,
    SERVICE_DESK_VERSION varchar(255) NOT NULL,
    UPGRADE_TASK_NAME varchar(255) NOT NULL
);

CREATE TABLE THRESHOLD (
    ID integer NOT NULL,
    REMAINING_TIME bigint NOT NULL,
    TIME_METRIC_ID integer NOT NULL
);

CREATE TABLE TIME_METRIC (
    CREATED_DATE bigint,
    CUSTOM_FIELD_ID bigint,
    DEFINITION_CHANGE_DATE timestamp without time zone,
    DEFINITION_CHANGE_MS_EPOCH bigint,
    GOALS_CHANGE_DATE timestamp without time zone,
    GOALS_CHANGE_MS_EPOCH bigint,
    ID integer NOT NULL,
    NAME varchar(255) NOT NULL,
    SERVICE_DESK_ID integer NOT NULL,
    THRESHOLDS_CHANGE_MS_EPOCH bigint,
    THRESHOLDS_CONFIG_CHANGE_DATE timestamp without time zone
);

CREATE TABLE VIEWPORT (
    DESCRIPTION text,
    ID integer NOT NULL,
    KEY varchar(255) NOT NULL,
    LOGO_ID integer,
    NAME varchar(255) NOT NULL,
    PROJECT_ID bigint NOT NULL,
    SEND_EMAIL_NOTIFICATIONS boolean,
    THEME_ID integer
);

CREATE TABLE VIEWPORT_FIELD (
    DESCRIPTION text,
    DISPLAYED boolean,
    FIELD_ID varchar(255) NOT NULL,
    FIELD_ORDER integer,
    FIELD_TYPE varchar(255) NOT NULL,
    FORM_ID integer,
    ID integer NOT NULL,
    LABEL varchar(255),
    REQUIRED boolean
);

CREATE TABLE VIEWPORT_FIELD_VALUE (
    FIELD_ID integer,
    FIELD_NAME varchar(255),
    ID integer NOT NULL,
    VALUE text,
    VALUE_ORDER integer
);

CREATE TABLE VIEWPORT_FORM (
    CALL_TO_ACTION text,
    DESCRIPTION text,
    FORM_ORDER integer,
    ICON integer,
    ICON_ID bigint,
    ID integer NOT NULL,
    INTRO text,
    ISSUE_TYPE_ID bigint NOT NULL,
    KEY varchar(255) NOT NULL,
    NAME varchar(255) NOT NULL,
    VIEWPORT_ID integer
);

CREATE TABLE SHORTCUT (
    ID integer NOT NULL,
    NAME varchar(255),
    PROJECT_ID bigint,
    SHORTCUT_URL text,
    URL varchar(255),
    ICON varchar(255)
);

CREATE TABLE ACTIVITY_ENTITY (
    ACTIVITY_ID bigint NOT NULL,
    ACTOR_ID integer,
    CONTENT text,
    GENERATOR_DISPLAY_NAME varchar(255),
    GENERATOR_ID varchar(450),
    ICON_ID integer,
    ID varchar(450),
    ISSUE_KEY varchar(255),
    OBJECT_ID integer,
    POSTER varchar(255),
    PROJECT_KEY varchar(255),
    PUBLISHED timestamp without time zone,
    TARGET_ID integer,
    TITLE varchar(255),
    URL varchar(450),
    USERNAME varchar(255),
    VERB varchar(450)
);


CREATE TABLE ACTOR_ENTITY (
    FULL_NAME varchar(255),
    ID integer NOT NULL,
    PROFILE_PAGE_URI varchar(450),
    PROFILE_PICTURE_URI varchar(450),
    USERNAME varchar(255)
);

CREATE TABLE MEDIA_LINK_ENTITY (
    DURATION integer,
    HEIGHT integer,
    ID integer NOT NULL,
    URL varchar(450),
    WIDTH integer
);

CREATE TABLE OBJECT_ENTITY (
    CONTENT varchar(255),
    DISPLAY_NAME varchar(255),
    ID integer NOT NULL,
    IMAGE_ID integer,
    OBJECT_ID varchar(450),
    OBJECT_TYPE varchar(450),
    SUMMARY varchar(255),
    URL varchar(450)
);

CREATE TABLE TARGET_ENTITY (
    CONTENT varchar(255),
    DISPLAY_NAME varchar(255),
    ID integer NOT NULL,
    IMAGE_ID integer,
    OBJECT_ID varchar(450),
    OBJECT_TYPE varchar(450),
    SUMMARY varchar(255),
    URL varchar(450)
);

CREATE TABLE APPROVAL (
    APPROVE_CONDITION_TYPE varchar(255) NOT NULL,
    APPROVE_CONDITION_VALUE varchar(255) NOT NULL,
    COMPLETED_DATE bigint,
    CREATED_DATE bigint NOT NULL,
    DECISION varchar(255),
    ID integer NOT NULL,
    ISSUE_ID bigint NOT NULL,
    NAME varchar(255) NOT NULL,
    STATUS_ID varchar(255)
);

CREATE TABLE APPROVER (
    APPROVAL_ID integer,
    ID integer NOT NULL,
    TYPE varchar(255) NOT NULL,
    VALUE varchar(255) NOT NULL
);

CREATE TABLE APPROVER_DECISION (
    APPROVAL_ID integer,
    DECISION varchar(255) NOT NULL,
    ID integer NOT NULL,
    SENT_DATE bigint NOT NULL,
    USER_KEY varchar(255) NOT NULL
);

CREATE TABLE NOTIFICATION_RECORD (
    APPROVAL_ID integer,
    ID integer NOT NULL,
    SENT_DATE bigint NOT NULL,
    USER_KEY varchar(255) NOT NULL
);

CREATE TABLE GLANCE_CONFIG (
    ROOM_ID bigint DEFAULT 0 NOT NULL,
    STATE varchar(255),
    SYNC_NEEDED boolean,
    JQL varchar(255),
    APPLICATION_USER_KEY varchar(255),
    NAME varchar(255)
);


CREATE TABLE PROJECT_CONFIG (
    CONFIGURATION_GROUP_ID varchar(255) NOT NULL,
    ID integer NOT NULL,
    NAME varchar(255),
    NAME_UNIQUE_CONSTRAINT varchar(255) NOT NULL,
    PROJECT_ID bigint DEFAULT 0 NOT NULL,
    ROOM_ID bigint DEFAULT 0 NOT NULL,
    VALUE varchar(255)
);

CREATE TABLE AOHIP_CHAT_LINK (
    ADDON_TOKEN_EXPIRY timestamp without time zone,
    API_URL varchar(255),
    CONNECT_DESCRIPTOR text,
    GROUP_ID integer DEFAULT 0,
    GROUP_NAME varchar(255),
    ID integer NOT NULL,
    OAUTH_ID varchar(255),
    SECRET_KEY varchar(255),
    SYSTEM_PASSWORD varchar(255),
    SYSTEM_TOKEN_EXPIRY timestamp without time zone,
    SYSTEM_USER varchar(255),
    SYSTEM_USER_TOKEN varchar(255),
    TOKEN varchar(255)
);

CREATE TABLE AOHIP_CHAT_USER (
    HIP_CHAT_LINK_ID integer,
    HIP_CHAT_USER_ID varchar(255),
    HIP_CHAT_USER_NAME varchar(255),
    ID integer NOT NULL,
    REFRESH_CODE varchar(255),
    USER_KEY varchar(255),
    USER_SCOPES varchar(255),
    USER_TOKEN varchar(255),
    USER_TOKEN_EXPIRY timestamp without time zone
);


CREATE TABLE CALENDAR (
    CONTEXT text NOT NULL,
    ID integer NOT NULL,
    NAME varchar(63) NOT NULL,
    TIMEZONE varchar(63) NOT NULL
);


CREATE TABLE HOLIDAY (
    CALENDAR_ID integer,
    DATE_STRING varchar(63) NOT NULL,
    ID integer NOT NULL,
    NAME varchar(63) NOT NULL,
    RECURRING boolean
);

CREATE TABLE WORKING_TIME (
    CALENDAR_ID integer,
    DAY varchar(63) NOT NULL,
    END_TIME bigint NOT NULL,
    ID integer NOT NULL,
    START_TIME bigint NOT NULL
);


CREATE TABLE HEALTH_CHECK_STATUS (
    APPLICATION_NAME varchar(255),
    COMPLETE_KEY varchar(255),
    DESCRIPTION varchar(255),
    FAILED_DATE timestamp without time zone,
    FAILURE_REASON varchar(450),
    ID integer NOT NULL,
    IS_HEALTHY boolean,
    IS_RESOLVED boolean,
    RESOLVED_DATE timestamp without time zone,
    SEVERITY varchar(255),
    STATUS_NAME varchar(255) NOT NULL
);


CREATE TABLE PROPERTIES (
    ID integer NOT NULL,
    PROPERTY_NAME varchar(255) NOT NULL,
    PROPERTY_VALUE varchar(255) NOT NULL
);


CREATE TABLE READ_NOTIFICATIONS (
    ID integer NOT NULL,
    IS_SNOOZED boolean,
    NOTIFICATION_ID integer NOT NULL,
    SNOOZE_COUNT integer,
    SNOOZE_DATE timestamp without time zone,
    USER_KEY varchar(255) NOT NULL
);

CREATE TABLE USER_INVITATION (
    APPLICATION_KEYS varchar(255),
    EMAIL_ADDRESS varchar(255),
    EXPIRY timestamp without time zone,
    ID integer NOT NULL,
    REDEEMED boolean,
    SENDER_USERNAME varchar(255),
    TOKEN varchar(255)
);


CREATE TABLE EXEC_RULE_MSG_ITEM (
    ID bigint NOT NULL,
    RULE_EXECUTION_ID bigint NOT NULL,
    RULE_MESSAGE_KEY varchar(127) NOT NULL,
    RULE_MESSAGE_VALUE text
);


CREATE TABLE IF_CONDITION_CONFIG (
    ID bigint NOT NULL,
    IF_THEN_ID bigint NOT NULL,
    MODULE_KEY varchar(450) NOT NULL,
    ORDINAL integer NOT NULL
);


CREATE TABLE IF_COND_CONF_DATA (
    CONFIG_DATA_KEY varchar(127) NOT NULL,
    CONFIG_DATA_VALUE text,
    ID bigint NOT NULL,
    IF_CONDITION_CONFIG_ID bigint NOT NULL
);

CREATE TABLE IF_COND_EXECUTION (
    FINISH_TIME_MILLIS bigint,
    ID bigint NOT NULL,
    IF_CONDITION_CONFIG_ID bigint NOT NULL,
    IF_EXECUTION_ID bigint NOT NULL,
    MESSAGE text,
    OUTCOME varchar(127) NOT NULL,
    START_TIME_MILLIS bigint
);


CREATE TABLE IF_EXECUTION (
    FINISH_TIME_MILLIS bigint,
    ID bigint NOT NULL,
    IF_THEN_EXECUTION_ID bigint NOT NULL,
    MESSAGE text,
    OUTCOME varchar(127) NOT NULL,
    START_TIME_MILLIS bigint
);


CREATE TABLE IF_THEN (
    ID bigint NOT NULL,
    ORDINAL integer NOT NULL,
    RULE_ID bigint NOT NULL
);


CREATE TABLE IF_THEN_EXECUTION (
    FINISH_TIME_MILLIS bigint,
    ID bigint NOT NULL,
    IF_THEN_ID bigint NOT NULL,
    MESSAGE text,
    OUTCOME varchar(127) NOT NULL,
    RULE_EXECUTION_ID bigint NOT NULL,
    START_TIME_MILLIS bigint
);


CREATE TABLE PROJECT_USER_CONTEXT (
    ID bigint NOT NULL,
    PROJECT_ID bigint NOT NULL,
    STRATEGY varchar(127) NOT NULL,
    USER_KEY varchar(255)
);



CREATE TABLE RSETREV_PROJ_CONTEXT (
    ID bigint NOT NULL,
    PROJECT_ID bigint NOT NULL,
    RULESET_REVISION_ID bigint NOT NULL
);


CREATE TABLE RSETREV_USER_CONTEXT (
    ID bigint NOT NULL,
    RULESET_REVISION_ID bigint NOT NULL,
    STRATEGY varchar(127) NOT NULL,
    USER_KEY varchar(255)
);


CREATE TABLE RULE (
    ENABLED boolean DEFAULT true NOT NULL,
    ID bigint NOT NULL,
    ORDINAL integer NOT NULL,
    RULESET_REVISION_ID bigint NOT NULL
);


CREATE TABLE RULESET (
    ACTIVE_REVISION_ID bigint,
    ID bigint NOT NULL
);


CREATE TABLE RULESET_REVISION (
    CREATED_BY varchar(127) NOT NULL,
    CREATED_TIMESTAMP_MILLIS bigint,
    DESCRIPTION varchar(450),
    ID bigint NOT NULL,
    IS_SYSTEM_RULE_SET boolean DEFAULT false NOT NULL,
    NAME varchar(127) NOT NULL,
    RULE_SET_ID bigint NOT NULL,
    TRIGGER_FROM_OTHER_RULES boolean
);


CREATE TABLE RULE_EXECUTION (
    EXECUTOR_USER_KEY varchar(127),
    FINISH_TIME_MILLIS bigint,
    ID bigint NOT NULL,
    MESSAGE text,
    OUTCOME varchar(127) NOT NULL,
    RULE_ID bigint NOT NULL,
    START_TIME_MILLIS bigint
);


CREATE TABLE THEN_ACTION_CONFIG (
    ID bigint NOT NULL,
    IF_THEN_ID bigint NOT NULL,
    MODULE_KEY varchar(450) NOT NULL,
    ORDINAL integer NOT NULL
);


CREATE TABLE THEN_ACT_CONF_DATA (
    CONFIG_DATA_KEY varchar(127) NOT NULL,
    CONFIG_DATA_VALUE text,
    ID bigint NOT NULL,
    THEN_ACTION_CONFIG_ID bigint NOT NULL
);


CREATE TABLE THEN_ACT_EXECUTION (
    FINISH_TIME_MILLIS bigint,
    ID bigint NOT NULL,
    MESSAGE text,
    OUTCOME varchar(127) NOT NULL,
    START_TIME_MILLIS bigint,
    THEN_ACTION_CONFIG_ID bigint NOT NULL,
    THEN_EXECUTION_ID bigint NOT NULL
);


CREATE TABLE THEN_EXECUTION (
    FINISH_TIME_MILLIS bigint,
    ID bigint NOT NULL,
    IF_THEN_EXECUTION_ID bigint NOT NULL,
    MESSAGE text,
    OUTCOME varchar(127) NOT NULL,
    START_TIME_MILLIS bigint
);



CREATE TABLE WHEN_HANDLER_CONFIG (
    ID bigint NOT NULL,
    MODULE_KEY varchar(450) NOT NULL,
    ORDINAL integer NOT NULL,
    RULE_ID bigint NOT NULL
);



CREATE TABLE WHEN_HAND_CONF_DATA (
    CONFIG_DATA_KEY varchar(127) NOT NULL,
    CONFIG_DATA_VALUE text,
    ID bigint NOT NULL,
    WHEN_HANDLER_CONFIG_ID bigint NOT NULL
);


CREATE TABLE WEB_HOOK_LISTENER_AO (
    DESCRIPTION text,
    ENABLED boolean,
    EVENTS text,
    EXCLUDE_BODY boolean,
    FILTERS text,
    ID integer NOT NULL,
    LAST_UPDATED timestamp without time zone NOT NULL,
    LAST_UPDATED_USER varchar(255),
    NAME text NOT NULL,
    PARAMETERS text,
    REGISTRATION_METHOD varchar(255) NOT NULL,
    URL text NOT NULL
);

CREATE TABLE HEALTH_CHECK_ENTITY (
    ID integer NOT NULL
);


CREATE TABLE APPLIED_TEMPLATE (
    ID integer NOT NULL,
    PROJECT_ID bigint DEFAULT 0,
    PROJECT_TEMPLATE_MODULE_KEY varchar(255),
    PROJECT_TEMPLATE_WEB_ITEM_KEY varchar(255)
);


CREATE TABLE LINGO (
    CATEGORY varchar(255),
    CREATED_TIMESTAMP bigint NOT NULL,
    ID bigint NOT NULL,
    LOGICAL_ID varchar(255),
    PROJECT_ID bigint,
    SYSTEM_I18N varchar(255)
);



CREATE TABLE LINGO_REVISION (
    CREATED_TIMESTAMP bigint NOT NULL,
    ID bigint NOT NULL,
    LINGO_ID bigint
);



CREATE TABLE LINGO_TRANSLATION (
    CONTENT text NOT NULL,
    CREATED_TIMESTAMP bigint NOT NULL,
    ID bigint NOT NULL,
    LANGUAGE varchar(63) NOT NULL,
    LINGO_REVISION_ID bigint,
    LOCALE varchar(63) NOT NULL
);


CREATE TABLE PROJECT_LANGUAGE (
    ACTIVE boolean,
    ID bigint NOT NULL,
    LOCALE varchar(63),
    PROJECT_LANG_REV_ID bigint
);


CREATE TABLE PROJECT_LANG_CONFIG (
    CREATED_TIMESTAMP bigint,
    ID bigint NOT NULL,
    PROJECT_ID bigint
);


CREATE TABLE PROJECT_LANG_REV (
    AUTHOR_USER_KEY varchar(255),
    CREATED_TIMESTAMP bigint,
    DEFAULT_LANGUAGE varchar(63),
    ID bigint NOT NULL,
    PROJECT_LANG_CONFIG_ID bigint
);


CREATE TABLE SEEN_ASSERTIONS (
    ASSERTION_ID varchar(255) NOT NULL,
    EXPIRY_TIMESTAMP bigint DEFAULT 0 NOT NULL,
    ID integer NOT NULL
);


CREATE TABLE _HISTORY_RECORD (
    EVENT_TIME_MILLIS bigint,
    EVENT_TYPE varchar(63) NOT NULL,
    ID integer NOT NULL,
    MESSAGE varchar(450) NOT NULL,
    TARGET_TIME_MILLIS bigint,
    TIMED_PROMISE_HISTORY_KEY_HASH varchar(255) NOT NULL
);


CREATE TABLE KEY_COMPONENT (
    ID integer NOT NULL,
    KEY varchar(450) NOT NULL,
    TIMED_PROMISE_ID integer NOT NULL,
    VALUE varchar(450) NOT NULL
);


CREATE TABLE KEY_COMP_HISTORY (
    ID integer NOT NULL,
    KEY varchar(450) NOT NULL,
    TIMED_PROMISE_ID integer NOT NULL,
    VALUE varchar(450) NOT NULL
);


CREATE TABLE PROMISE (
    CLASSIFICATION varchar(127) NOT NULL,
    CONTENT text,
    CREATED_TIME_MILLIS bigint,
    ID integer NOT NULL,
    KEY_HASH varchar(255) NOT NULL,
    MIME_TYPE varchar(127),
    STATUS varchar(63) NOT NULL,
    TARGET_TIME_MILLIS bigint,
    TASK_KEY varchar(255) NOT NULL,
    UPDATED_TIME_MILLIS bigint
);


CREATE TABLE PROMISE_HISTORY (
    CLASSIFICATION varchar(127) NOT NULL,
    ID integer NOT NULL,
    KEY_HASH varchar(255) NOT NULL,
    TASK_KEY varchar(255) NOT NULL
);


CREATE TABLE app_user (
    id numeric(18,0) NOT NULL,
    user_key varchar(255),
    lower_user_name varchar(255)
);



CREATE TABLE audit_changed_value (
    id numeric(18,0) NOT NULL,
    log_id numeric(18,0),
    name varchar(255),
    delta_from text,
    delta_to text
);


CREATE TABLE audit_item (
    id numeric(18,0) NOT NULL,
    log_id numeric(18,0),
    object_type varchar(60),
    object_id varchar(255),
    object_name varchar(255),
    object_parent_id varchar(255),
    object_parent_name varchar(255)
);


CREATE TABLE audit_log (
    id numeric(18,0) NOT NULL,
    remote_address varchar(60),
    created timestamp with time zone,
    author_key varchar(255),
    summary varchar(255),
    category varchar(255),
    object_type varchar(60),
    object_id varchar(255),
    object_name varchar(255),
    object_parent_id varchar(255),
    object_parent_name varchar(255),
    author_type numeric(9,0),
    event_source_name varchar(255),
    description varchar(255),
    long_description text,
    search_field text
);


CREATE TABLE avatar (
    id numeric(18,0) NOT NULL,
    filename varchar(255),
    contenttype varchar(255),
    avatartype varchar(60),
    owner varchar(255),
    systemavatar numeric(9,0)
);


CREATE TABLE board (
    id numeric(18,0) NOT NULL,
    jql text
);



CREATE TABLE boardproject (
    board_id numeric(18,0) NOT NULL,
    project_id numeric(18,0) NOT NULL
);



CREATE TABLE changegroup (
    id numeric(18,0) NOT NULL,
    issueid numeric(18,0),
    author varchar(255),
    created timestamp with time zone
);


CREATE TABLE changeitem (
    id numeric(18,0) NOT NULL,
    groupid numeric(18,0),
    fieldtype varchar(255),
    field varchar(255),
    oldvalue text,
    oldstring text,
    newvalue text,
    newstring text
);



CREATE TABLE clusteredjob (
    id numeric(18,0) NOT NULL,
    job_id varchar(255),
    job_runner_key varchar(255),
    sched_type character(1),
    interval_millis numeric(18,0),
    first_run numeric(18,0),
    cron_expression varchar(255),
    time_zone varchar(60),
    next_run numeric(18,0),
    version numeric(18,0),
    parameters bytea
);



CREATE TABLE cluster_lockstatus (
    id numeric(18,0) NOT NULL,
    lock_name varchar(255),
    locked_by_node varchar(60),
    update_time numeric(18,0)
);



CREATE TABLE cluster_message (
    id numeric(18,0) NOT NULL,
    source_node varchar(60),
    destination_node varchar(60),
    claimed_by_node varchar(60),
    message varchar(255),
    message_time timestamp with time zone
);


CREATE TABLE cluster_node (
    node_id varchar(60) NOT NULL,
    node_state varchar(60),
    timestamp numeric(18,0),
    ip varchar(60),
    cache_listener_port numeric(18,0),
    node_build_number numeric(18,0),
    node_version varchar(60)
);



CREATE TABLE cluster_nodeheartbeat (
    node_id varchar(60) NOT NULL,
    heartbeat_time numeric(18,0),
    database_time numeric(18,0)
);



CREATE TABLE cluster_upgradestate (
    id numeric(18,0) NOT NULL,
    database_time numeric(18,0),
    cluster_build_number numeric(18,0),
    cluster_version varchar(60),
    state varchar(60),
    order_number numeric(18,0)
);



CREATE TABLE columnlayout (
    id numeric(18,0) NOT NULL,
    username varchar(255),
    searchrequest numeric(18,0)
);


CREATE TABLE columnlayout_item (
    id numeric(18,0) NOT NULL,
    columnlayout numeric(18,0),
    fieldidentifier varchar(255),
    horizontalposition numeric(18,0)
);



CREATE TABLE component (
    id numeric(18,0) NOT NULL,
    project numeric(18,0),
    cname varchar(255),
    description text,
    url varchar(255),
    lead varchar(255),
    assigneetype numeric(18,0)
);



CREATE TABLE configuration_context (
    id numeric(18,0) NOT NULL,
    projectcategory numeric(18,0),
    project numeric(18,0),
    customfield varchar(255),
    fieldconfigscheme numeric(18,0)
);



CREATE TABLE customfield (
    id numeric(18,0) NOT NULL,
    cfkey varchar(255),
    customfieldtypekey varchar(255),
    customfieldsearcherkey varchar(255),
    cfname varchar(255),
    description text,
    defaultvalue varchar(255),
    fieldtype numeric(18,0),
    project numeric(18,0),
    issuetype varchar(255)
);


CREATE TABLE customfield_option (
    id numeric(18,0) NOT NULL,
    customfield numeric(18,0),
    customfieldconfig numeric(18,0),
    parentoptionid numeric(18,0),
    sequence numeric(18,0),
    customvalue varchar(255),
    optiontype varchar(60),
    disabled varchar(60)
);



CREATE TABLE customfield_value (
    id numeric(18,0) NOT NULL,
    issue numeric(18,0),
    customfield numeric(18,0),
    parentkey varchar(255),
    stringvalue varchar(255),
    numbervalue double precision,
    textvalue text,
    datevalue timestamp with time zone,
    valuetype varchar(255)
);



CREATE TABLE cwd_application (
    id numeric(18,0) NOT NULL,
    application_name varchar(255),
    lower_application_name varchar(255),
    created_date timestamp with time zone,
    updated_date timestamp with time zone,
    active numeric(9,0),
    description varchar(255),
    application_type varchar(255),
    credential varchar(255)
);


CREATE TABLE cwd_application_address (
    application_id numeric(18,0) NOT NULL,
    remote_address varchar(255) NOT NULL,
    encoded_address_binary varchar(255),
    remote_address_mask numeric(9,0)
);



CREATE TABLE cwd_directory (
    id numeric(18,0) NOT NULL,
    directory_name varchar(255),
    lower_directory_name varchar(255),
    created_date timestamp with time zone,
    updated_date timestamp with time zone,
    active numeric(9,0),
    description varchar(255),
    impl_class varchar(255),
    lower_impl_class varchar(255),
    directory_type varchar(60),
    directory_position numeric(18,0)
);



CREATE TABLE cwd_directory_attribute (
    directory_id numeric(18,0) NOT NULL,
    attribute_name varchar(255) NOT NULL,
    attribute_value varchar(255)
);


CREATE TABLE cwd_directory_operation (
    directory_id numeric(18,0) NOT NULL,
    operation_type varchar(60) NOT NULL
);


CREATE TABLE cwd_group (
    id numeric(18,0) NOT NULL,
    group_name varchar(255),
    lower_group_name varchar(255),
    active numeric(9,0),
    local numeric(9,0),
    created_date timestamp with time zone,
    updated_date timestamp with time zone,
    description varchar(255),
    lower_description varchar(255),
    group_type varchar(60),
    directory_id numeric(18,0)
);



CREATE TABLE cwd_group_attributes (
    id numeric(18,0) NOT NULL,
    group_id numeric(18,0),
    directory_id numeric(18,0),
    attribute_name varchar(255),
    attribute_value varchar(255),
    lower_attribute_value varchar(255)
);



CREATE TABLE cwd_membership (
    id numeric(18,0) NOT NULL,
    parent_id numeric(18,0),
    child_id numeric(18,0),
    membership_type varchar(60),
    group_type varchar(60),
    parent_name varchar(255),
    lower_parent_name varchar(255),
    child_name varchar(255),
    lower_child_name varchar(255),
    directory_id numeric(18,0)
);


CREATE TABLE cwd_user (
    id numeric(18,0) NOT NULL,
    directory_id numeric(18,0),
    user_name varchar(255),
    lower_user_name varchar(255),
    active numeric(9,0),
    created_date timestamp with time zone,
    updated_date timestamp with time zone,
    first_name varchar(255),
    lower_first_name varchar(255),
    last_name varchar(255),
    lower_last_name varchar(255),
    display_name varchar(255),
    lower_display_name varchar(255),
    email_address varchar(255),
    lower_email_address varchar(255),
    credential varchar(255),
    deleted_externally numeric(9,0),
    external_id varchar(255)
);


CREATE TABLE cwd_user_attributes (
    id numeric(18,0) NOT NULL,
    user_id numeric(18,0),
    directory_id numeric(18,0),
    attribute_name varchar(255),
    attribute_value varchar(255),
    lower_attribute_value varchar(255)
);


CREATE TABLE deadletter (
    id numeric(18,0) NOT NULL,
    message_id varchar(255),
    last_seen numeric(18,0),
    mail_server_id numeric(18,0),
    folder_name varchar(255)
);


CREATE TABLE draft_workflowscheme (
    id numeric(18,0) NOT NULL,
    name varchar(255),
    description text,
    workflow_scheme_id numeric(18,0),
    last_modified_date timestamp with time zone,
    last_modified_user varchar(255)
);



CREATE TABLE draft_workflowschemeentity (
    id numeric(18,0) NOT NULL,
    scheme numeric(18,0),
    workflow varchar(255),
    issuetype varchar(255)
);



CREATE TABLE entity_property (
    id numeric(18,0) NOT NULL,
    entity_name varchar(255),
    entity_id numeric(18,0),
    property_key varchar(255),
    created timestamp with time zone,
    updated timestamp with time zone,
    json_value text
);


CREATE TABLE entity_property_index_document (
    id numeric(18,0) NOT NULL,
    plugin_key varchar(255),
    module_key varchar(255),
    entity_key varchar(255),
    updated timestamp with time zone,
    document text
);


CREATE TABLE entity_translation (
    id numeric(18,0) NOT NULL,
    entity_name varchar(255),
    entity_id numeric(18,0),
    locale varchar(60),
    trans_name varchar(255),
    trans_desc varchar(255)
);

CREATE TABLE external_entities (
    id numeric(18,0) NOT NULL,
    name varchar(255),
    entitytype varchar(255)
);


CREATE TABLE externalgadget (
    id numeric(18,0) NOT NULL,
    gadget_xml text
);


CREATE TABLE favourite_associations (
    id numeric(18,0) NOT NULL,
    username varchar(255),
    entitytype varchar(60),
    entityid numeric(18,0),
    sequence numeric(18,0)
);


CREATE TABLE feature (
    id numeric(18,0) NOT NULL,
    feature_name varchar(255),
    feature_type varchar(10),
    user_key varchar(255)
);


CREATE TABLE field_configscheme (
    id numeric(18,0) NOT NULL,
    configname varchar(255),
    description text,
    fieldid varchar(60),
    customfield numeric(18,0)
);

CREATE TABLE field_configschemeissuetype (
    id numeric(18,0) NOT NULL,
    issuetype varchar(255),
    fieldconfigscheme numeric(18,0),
    fieldconfiguration numeric(18,0)
);

CREATE TABLE field_configuration (
    id numeric(18,0) NOT NULL,
    configname varchar(255),
    description text,
    fieldid varchar(60),
    customfield numeric(18,0)
);

CREATE TABLE field_layout (
    id numeric(18,0) NOT NULL,
    name varchar(255),
    description varchar(255),
    layout_type varchar(255),
    layoutscheme numeric(18,0)
);

CREATE TABLE field_layoutitem (
    id numeric(18,0) NOT NULL,
    fieldlayout numeric(18,0),
    fieldidentifier varchar(255),
    description text,
    verticalposition numeric(18,0),
    ishidden varchar(60),
    isrequired varchar(60),
    renderertype varchar(255)
);

CREATE TABLE field_layoutscheme (
    id numeric(18,0) NOT NULL,
    name varchar(255),
    description text
);


CREATE TABLE field_layoutschemeassociation (
    id numeric(18,0) NOT NULL,
    issuetype varchar(255),
    project numeric(18,0),
    fieldlayoutscheme numeric(18,0)
);


CREATE TABLE field_layoutschemeentity (
    id numeric(18,0) NOT NULL,
    scheme numeric(18,0),
    issuetype varchar(255),
    fieldlayout numeric(18,0)
);


CREATE TABLE field_screen (
    id numeric(18,0) NOT NULL,
    name varchar(255),
    description varchar(255)
);


CREATE TABLE field_screenlayoutitem (
    id numeric(18,0) NOT NULL,
    fieldidentifier varchar(255),
    sequence numeric(18,0),
    fieldscreentab numeric(18,0)
);


CREATE TABLE field_screenscheme (
    id numeric(18,0) NOT NULL,
    name varchar(255),
    description varchar(255)
);

CREATE TABLE field_screenschemeitem (
    id numeric(18,0) NOT NULL,
    operation numeric(18,0),
    fieldscreen numeric(18,0),
    fieldscreenscheme numeric(18,0)
);


CREATE TABLE field_screentab (
    id numeric(18,0) NOT NULL,
    name varchar(255),
    description varchar(255),
    sequence numeric(18,0),
    fieldscreen numeric(18,0)
);


CREATE TABLE file_attachment (
    id numeric(18,0) NOT NULL,
    issueid numeric(18,0),
    mimetype varchar(255),
    filename varchar(255),
    created timestamp with time zone,
    filesize numeric(18,0),
    author varchar(255),
    zip numeric(9,0),
    thumbnailable numeric(9,0)
);


CREATE TABLE filter_subscription (
    id numeric(18,0) NOT NULL,
    filter_i_d numeric(18,0),
    username varchar(60),
    groupname varchar(60),
    last_run timestamp with time zone,
    email_on_empty varchar(10)
);


CREATE TABLE gadget_userpreference (
    id numeric(18,0) NOT NULL,
    portletconfiguration numeric(18,0),
    userprefkey varchar(255),
    userprefvalue text
);


CREATE TABLE generic_configuration (
    id numeric(18,0) NOT NULL,
    datatype varchar(60),
    datakey varchar(60),
    xmlvalue text
);

CREATE TABLE global_permissionentry (
    id numeric(18,0) NOT NULL,
    permission varchar(255),
    group_id varchar(255)
);


CREATE TABLE groupbase (
    id numeric(18,0) NOT NULL,
    groupname varchar(255)
);

CREATE TABLE issue_field_option (
    id numeric(18,0) NOT NULL,
    option_id numeric(18,0),
    field_key varchar(255),
    option_value varchar(255),
    properties text
);


CREATE TABLE issue_field_option_scope (
    id numeric(18,0) NOT NULL,
    option_id numeric(18,0),
    entity_id varchar(255),
    scope_type varchar(255)
);


CREATE TABLE issue_link (
    id numeric(18,0) NOT NULL,
    linktype numeric(18,0),
    source numeric(18,0),
    destination numeric(18,0),
    sequence numeric(18,0)
);


CREATE TABLE issue_linktype (
    id numeric(18,0) NOT NULL,
    linkname varchar(255),
    inward varchar(255),
    outward varchar(255),
    pstyle varchar(60)
);

CREATE TABLE issue_securityscheme (
    id numeric(18,0) NOT NULL,
    name varchar(255),
    description text,
    defaultlevel numeric(18,0)
);


CREATE TABLE issue_status (
    id varchar(60) NOT NULL,
    sequence numeric(18,0),
    pname varchar(60),
    description text,
    iconurl varchar(255),
    statuscategory numeric(18,0)
);



CREATE TABLE issue_type (
    id varchar(60) NOT NULL,
    sequence numeric(18,0),
    pname varchar(60),
    pstyle varchar(60),
    description text,
    iconurl varchar(255),
    avatar numeric(18,0)
);


CREATE TABLE issue_typescreenscheme (
    id numeric(18,0) NOT NULL,
    name varchar(255),
    description varchar(255)
);


CREATE TABLE issue_typescreenschemeentity (
    id numeric(18,0) NOT NULL,
    issuetype varchar(255),
    scheme numeric(18,0),
    fieldscreenscheme numeric(18,0)
);


CREATE TABLE jira_action (
    id numeric(18,0) NOT NULL,
    issueid numeric(18,0),
    author varchar(255),
    actiontype varchar(255),
    actionlevel varchar(255),
    rolelevel numeric(18,0),
    actionbody text,
    created timestamp with time zone,
    updateauthor varchar(255),
    updated timestamp with time zone,
    actionnum numeric(18,0)
);

CREATE TABLE jiradraftworkflows (
    id numeric(18,0) NOT NULL,
    parentname varchar(255),
    descriptor text
);

CREATE TABLE jira_event_type (
    id numeric(18,0) NOT NULL,
    template_id numeric(18,0),
    name varchar(255),
    description text,
    event_type varchar(60)
);


CREATE TABLE jira_issue (
    id numeric(18,0) NOT NULL,
    pkey varchar(255),
    issuenum numeric(18,0),
    project numeric(18,0),
    reporter varchar(255),
    assignee varchar(255),
    creator varchar(255),
    issuetype varchar(255),
    summary varchar(255),
    description text,
    environment text,
    priority varchar(255),
    resolution varchar(255),
    issuestatus varchar(255),
    created timestamp with time zone,
    updated timestamp with time zone,
    duedate timestamp with time zone,
    resolutiondate timestamp with time zone,
    votes numeric(18,0),
    watches numeric(18,0),
    timeoriginalestimate numeric(18,0),
    timeestimate numeric(18,0),
    timespent numeric(18,0),
    workflow_id numeric(18,0),
    security numeric(18,0),
    fixfor numeric(18,0),
    component numeric(18,0)
);


CREATE TABLE jira_perms (
    id numeric(18,0) NOT NULL,
    permtype numeric(18,0),
    projectid numeric(18,0),
    groupname varchar(255)
);

CREATE TABLE jira_workflows (
    id numeric(18,0) NOT NULL,
    workflowname varchar(255),
    creatorname varchar(255),
    descriptor text,
    islocked varchar(60)
);

CREATE TABLE jira_workflow_statuses (
    id numeric(18,0) NOT NULL,
    status varchar(255),
    parentname varchar(255)
);

CREATE TABLE jquartz_blob_triggers (
    sched_name varchar(120),
    trigger_name varchar(200) NOT NULL,
    trigger_group varchar(200) NOT NULL,
    blob_data bytea
);

CREATE TABLE jquartz_calendars (
    sched_name varchar(120),
    calendar_name varchar(200) NOT NULL,
    calendar bytea
);

CREATE TABLE jquartz_cron_triggers (
    sched_name varchar(120),
    trigger_name varchar(200) NOT NULL,
    trigger_group varchar(200) NOT NULL,
    cron_expression varchar(120),
    time_zone_id varchar(80)
);

CREATE TABLE jquartz_fired_triggers (
    sched_name varchar(120),
    entry_id varchar(95) NOT NULL,
    trigger_name varchar(200),
    trigger_group varchar(200),
    is_volatile boolean,
    instance_name varchar(200),
    fired_time numeric(18,0),
    sched_time numeric(18,0),
    priority numeric(9,0),
    state varchar(16),
    job_name varchar(200),
    job_group varchar(200),
    is_stateful boolean,
    is_nonconcurrent boolean,
    is_update_data boolean,
    requests_recovery boolean
);

CREATE TABLE jquartz_job_details (
    sched_name varchar(120),
    job_name varchar(200) NOT NULL,
    job_group varchar(200) NOT NULL,
    description varchar(250),
    job_class_name varchar(250),
    is_durable boolean,
    is_volatile boolean,
    is_stateful boolean,
    is_nonconcurrent boolean,
    is_update_data boolean,
    requests_recovery boolean,
    job_data bytea
);

CREATE TABLE jquartz_job_listeners (
    job_name varchar(200) NOT NULL,
    job_group varchar(200) NOT NULL,
    job_listener varchar(200) NOT NULL
);

CREATE TABLE jquartz_locks (
    sched_name varchar(120),
    lock_name varchar(40) NOT NULL
);


CREATE TABLE jquartz_paused_trigger_grps (
    sched_name varchar(120),
    trigger_group varchar(200) NOT NULL
);

CREATE TABLE jquartz_scheduler_state (
    sched_name varchar(120),
    instance_name varchar(200) NOT NULL,
    last_checkin_time numeric(18,0),
    checkin_interval numeric(18,0)
);

CREATE TABLE jquartz_simple_triggers (
    sched_name varchar(120),
    trigger_name varchar(200) NOT NULL,
    trigger_group varchar(200) NOT NULL,
    repeat_count numeric(18,0),
    repeat_interval numeric(18,0),
    times_triggered numeric(18,0)
);

CREATE TABLE jquartz_simprop_triggers (
    sched_name varchar(120),
    trigger_name varchar(200) NOT NULL,
    trigger_group varchar(200) NOT NULL,
    str_prop_1 varchar(512),
    str_prop_2 varchar(512),
    str_prop_3 varchar(512),
    int_prop_1 numeric(9,0),
    int_prop_2 numeric(9,0),
    long_prop_1 numeric(18,0),
    long_prop_2 numeric(18,0),
    dec_prop_1 numeric(13,4),
    dec_prop_2 numeric(13,4),
    bool_prop_1 boolean,
    bool_prop_2 boolean
);

CREATE TABLE jquartz_trigger_listeners (
    trigger_name varchar(200),
    trigger_group varchar(200) NOT NULL,
    trigger_listener varchar(200) NOT NULL
);

CREATE TABLE jquartz_triggers (
    sched_name varchar(120),
    trigger_name varchar(200) NOT NULL,
    trigger_group varchar(200) NOT NULL,
    job_name varchar(200),
    job_group varchar(200),
    is_volatile boolean,
    description varchar(250),
    next_fire_time numeric(18,0),
    prev_fire_time numeric(18,0),
    priority numeric(9,0),
    trigger_state varchar(16),
    trigger_type varchar(8),
    start_time numeric(18,0),
    end_time numeric(18,0),
    calendar_name varchar(200),
    misfire_instr numeric(4,0),
    job_data bytea
);


CREATE TABLE label (
    id numeric(18,0) NOT NULL,
    fieldid numeric(18,0),
    issue numeric(18,0),
    label varchar(255)
);

CREATE TABLE license_roles_default (
    id numeric(18,0) NOT NULL,
    license_role_name varchar(255)
);

CREATE TABLE license_roles_group (
    id numeric(18,0) NOT NULL,
    license_role_name varchar(255),
    group_id varchar(255),
    primary_group character(1)
);


CREATE TABLE listener_config (
    id numeric(18,0) NOT NULL,
    clazz varchar(255),
    listenername varchar(255)
);

CREATE TABLE mail_server (
    id numeric(18,0) NOT NULL,
    name varchar(255),
    description text,
    mailfrom varchar(255),
    prefix varchar(60),
    smtp_port varchar(60),
    protocol varchar(60),
    server_type varchar(60),
    servername varchar(255),
    jndilocation varchar(255),
    mailusername varchar(255),
    mailpassword varchar(255),
    istlsrequired varchar(60),
    timeout numeric(18,0),
    socks_port varchar(60),
    socks_host varchar(60)
);



CREATE TABLE managed_configuration_item (
    id numeric(18,0) NOT NULL,
    item_id varchar(255),
    item_type varchar(255),
    managed varchar(10),
    access_level varchar(255),
    source varchar(255),
    description_key varchar(255)
);



CREATE TABLE membershipbase (
    id numeric(18,0) NOT NULL,
    user_name varchar(255),
    group_name varchar(255)
);

CREATE TABLE moved_issue_key (
    id numeric(18,0) NOT NULL,
    old_issue_key varchar(255),
    issue_id numeric(18,0)
);



CREATE TABLE nodeassociation (
    source_node_id numeric(18,0) NOT NULL,
    source_node_entity varchar(60) NOT NULL,
    sink_node_id numeric(18,0) NOT NULL,
    sink_node_entity varchar(60) NOT NULL,
    association_type varchar(60) NOT NULL,
    sequence numeric(9,0)
);


CREATE TABLE nodeindexcounter (
    id numeric(18,0) NOT NULL,
    node_id varchar(60),
    sending_node_id varchar(60),
    index_operation_id numeric(18,0)
);


CREATE TABLE notification (
    id numeric(18,0) NOT NULL,
    scheme numeric(18,0),
    event varchar(60),
    event_type_id numeric(18,0),
    template_id numeric(18,0),
    notif_type varchar(60),
    notif_parameter varchar(60)
);



CREATE TABLE notificationinstance (
    id numeric(18,0) NOT NULL,
    notificationtype varchar(60),
    source numeric(18,0),
    emailaddress varchar(255),
    messageid varchar(255)
);



CREATE TABLE notificationscheme (
    id numeric(18,0) NOT NULL,
    name varchar(255),
    description text
);



CREATE TABLE oauthconsumer (
    id numeric(18,0) NOT NULL,
    created timestamp with time zone,
    consumername varchar(255),
    consumer_key varchar(255),
    consumerservice varchar(255),
    public_key text,
    private_key text,
    description text,
    callback text,
    signature_method varchar(60),
    shared_secret text
);


CREATE TABLE oauthconsumertoken (
    id numeric(18,0) NOT NULL,
    created timestamp with time zone,
    token_key varchar(255),
    token varchar(255),
    token_secret varchar(255),
    token_type varchar(60),
    consumer_key varchar(255)
);



CREATE TABLE oauthspconsumer (
    id numeric(18,0) NOT NULL,
    created timestamp with time zone,
    consumer_key varchar(255),
    consumername varchar(255),
    public_key text,
    description text,
    callback text,
    two_l_o_allowed varchar(60),
    executing_two_l_o_user varchar(255),
    two_l_o_impersonation_allowed varchar(60),
    three_l_o_allowed varchar(60)
);

CREATE TABLE oauthsptoken (
    id numeric(18,0) NOT NULL,
    created timestamp with time zone,
    token varchar(255),
    token_secret varchar(255),
    token_type varchar(60),
    consumer_key varchar(255),
    username varchar(255),
    ttl numeric(18,0),
    spauth varchar(60),
    callback text,
    spverifier varchar(255),
    spversion varchar(60),
    session_handle varchar(255),
    session_creation_time timestamp with time zone,
    session_last_renewal_time timestamp with time zone,
    session_time_to_live timestamp with time zone
);


CREATE TABLE optionconfiguration (
    id numeric(18,0) NOT NULL,
    fieldid varchar(60),
    optionid varchar(60),
    fieldconfig numeric(18,0),
    sequence numeric(18,0)
);




CREATE TABLE os_currentstep (
    id numeric(18,0) NOT NULL,
    entry_id numeric(18,0),
    step_id numeric(9,0),
    action_id numeric(9,0),
    owner varchar(60),
    start_date timestamp with time zone,
    due_date timestamp with time zone,
    finish_date timestamp with time zone,
    status varchar(60),
    caller varchar(60)
);


CREATE TABLE os_currentstep_prev (
    id numeric(18,0) NOT NULL,
    previous_id numeric(18,0) NOT NULL
);


CREATE TABLE os_historystep (
    id numeric(18,0) NOT NULL,
    entry_id numeric(18,0),
    step_id numeric(9,0),
    action_id numeric(9,0),
    owner varchar(60),
    start_date timestamp with time zone,
    due_date timestamp with time zone,
    finish_date timestamp with time zone,
    status varchar(60),
    caller varchar(60)
);


CREATE TABLE os_historystep_prev (
    id numeric(18,0) NOT NULL,
    previous_id numeric(18,0) NOT NULL
);


CREATE TABLE os_wfentry (
    id numeric(18,0) NOT NULL,
    name varchar(255),
    initialized numeric(9,0),
    state numeric(9,0)
);



CREATE TABLE permissionscheme (
    id numeric(18,0) NOT NULL,
    name varchar(255),
    description text
);


CREATE TABLE pluginstate (
    pluginkey varchar(255) NOT NULL,
    pluginenabled varchar(60)
);


CREATE TABLE pluginversion (
    id numeric(18,0) NOT NULL,
    pluginname varchar(255),
    pluginkey varchar(255),
    pluginversion varchar(255),
    created timestamp with time zone
);


CREATE TABLE portalpage (
    id numeric(18,0) NOT NULL,
    username varchar(255),
    pagename varchar(255),
    description varchar(255),
    sequence numeric(18,0),
    fav_count numeric(18,0),
    layout varchar(255),
    ppversion numeric(18,0)
);


CREATE TABLE portletconfiguration (
    id numeric(18,0) NOT NULL,
    portalpage numeric(18,0),
    portlet_id varchar(255),
    column_number numeric(9,0),
    positionseq numeric(9,0),
    gadget_xml text,
    color varchar(255),
    dashboard_module_complete_key text
);

CREATE TABLE priority (
    id varchar(60) NOT NULL,
    sequence numeric(18,0),
    pname varchar(60),
    description text,
    iconurl varchar(255),
    status_color varchar(60)
);


CREATE TABLE productlicense (
    id numeric(18,0) NOT NULL,
    license text
);


CREATE TABLE project (
    id numeric(18,0) NOT NULL,
    pname varchar(255),
    url varchar(255),
    lead varchar(255),
    description text,
    pkey varchar(255),
    pcounter numeric(18,0),
    assigneetype numeric(18,0),
    avatar numeric(18,0),
    originalkey varchar(255),
    projecttype varchar(255)
);



CREATE TABLE project_key (
    id numeric(18,0) NOT NULL,
    project_id numeric(18,0),
    project_key varchar(255)
);



CREATE TABLE projectcategory (
    id numeric(18,0) NOT NULL,
    cname varchar(255),
    description text
);

CREATE TABLE projectchangedtime (
    project_id numeric(18,0) NOT NULL,
    issue_changed_time timestamp with time zone
);


CREATE TABLE projectrole (
    id numeric(18,0) NOT NULL,
    name varchar(255),
    description text
);


CREATE TABLE projectroleactor (
    id numeric(18,0) NOT NULL,
    pid numeric(18,0),
    projectroleid numeric(18,0),
    roletype varchar(255),
    roletypeparameter varchar(255)
);



CREATE TABLE projectversion (
    id numeric(18,0) NOT NULL,
    project numeric(18,0),
    vname varchar(255),
    description text,
    sequence numeric(18,0),
    released varchar(10),
    archived varchar(10),
    url varchar(255),
    startdate timestamp with time zone,
    releasedate timestamp with time zone
);


CREATE TABLE propertydata (
    id numeric(18,0) NOT NULL,
    propertyvalue oid
);


CREATE TABLE propertydate (
    id numeric(18,0) NOT NULL,
    propertyvalue timestamp with time zone
);


CREATE TABLE propertydecimal (
    id numeric(18,0) NOT NULL,
    propertyvalue double precision
);


CREATE TABLE propertyentry (
    id numeric(18,0) NOT NULL,
    entity_name varchar(255),
    entity_id numeric(18,0),
    property_key varchar(255),
    propertytype numeric(9,0)
);


CREATE TABLE propertynumber (
    id numeric(18,0) NOT NULL,
    propertyvalue numeric(18,0)
);


CREATE TABLE propertystring (
    id numeric(18,0) NOT NULL,
    propertyvalue text
);


CREATE TABLE propertytext (
    id numeric(18,0) NOT NULL,
    propertyvalue text
);


CREATE TABLE qrtz_calendars (
    id numeric(18,0),
    calendar_name varchar(255) NOT NULL,
    calendar text
);


CREATE TABLE qrtz_cron_triggers (
    id numeric(18,0) NOT NULL,
    trigger_id numeric(18,0),
    cronexperssion varchar(255)
);

CREATE TABLE qrtz_fired_triggers (
    id numeric(18,0),
    entry_id varchar(255) NOT NULL,
    trigger_id numeric(18,0),
    trigger_listener varchar(255),
    fired_time timestamp with time zone,
    trigger_state varchar(255)
);



CREATE TABLE qrtz_job_details (
    id numeric(18,0) NOT NULL,
    job_name varchar(255),
    job_group varchar(255),
    class_name varchar(255),
    is_durable varchar(60),
    is_stateful varchar(60),
    requests_recovery varchar(60),
    job_data varchar(255)
);



CREATE TABLE qrtz_job_listeners (
    id numeric(18,0) NOT NULL,
    job numeric(18,0),
    job_listener varchar(255)
);


CREATE TABLE qrtz_simple_triggers (
    id numeric(18,0) NOT NULL,
    trigger_id numeric(18,0),
    repeat_count numeric(9,0),
    repeat_interval numeric(18,0),
    times_triggered numeric(9,0)
);


CREATE TABLE qrtz_trigger_listeners (
    id numeric(18,0) NOT NULL,
    trigger_id numeric(18,0),
    trigger_listener varchar(255)
);



CREATE TABLE qrtz_triggers (
    id numeric(18,0) NOT NULL,
    trigger_name varchar(255),
    trigger_group varchar(255),
    job numeric(18,0),
    next_fire timestamp with time zone,
    trigger_state varchar(255),
    trigger_type varchar(60),
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    calendar_name varchar(255),
    misfire_instr numeric(9,0)
);



CREATE TABLE reindex_component (
    id numeric(18,0) NOT NULL,
    request_id numeric(18,0),
    affected_index varchar(60),
    entity_type varchar(60)
);


CREATE TABLE reindex_request (
    id numeric(18,0) NOT NULL,
    type varchar(60),
    request_time timestamp with time zone,
    start_time timestamp with time zone,
    completion_time timestamp with time zone,
    status varchar(60),
    execution_node_id varchar(60),
    query text
);


CREATE TABLE remembermetoken (
    id numeric(18,0) NOT NULL,
    created timestamp with time zone,
    token varchar(255),
    username varchar(255)
);


CREATE TABLE remotelink (
    id numeric(18,0) NOT NULL,
    issueid numeric(18,0),
    globalid varchar(255),
    title varchar(255),
    summary text,
    url text,
    iconurl text,
    icontitle text,
    relationship varchar(255),
    resolved character(1),
    statusname varchar(255),
    statusdescription text,
    statusiconurl text,
    statusicontitle text,
    statusiconlink text,
    statuscategorykey varchar(255),
    statuscategorycolorname varchar(255),
    applicationtype varchar(255),
    applicationname varchar(255)
);


CREATE TABLE replicatedindexoperation (
    id numeric(18,0) NOT NULL,
    index_time timestamp with time zone,
    node_id varchar(60),
    affected_index varchar(60),
    entity_type varchar(60),
    affected_ids text,
    operation varchar(60),
    filename varchar(255)
);



CREATE TABLE resolution (
    id varchar(60) NOT NULL,
    sequence numeric(18,0),
    pname varchar(60),
    description text,
    iconurl varchar(255)
);




CREATE TABLE rundetails (
    id numeric(18,0) NOT NULL,
    job_id varchar(255),
    start_time timestamp with time zone,
    run_duration numeric(18,0),
    run_outcome character(1),
    info_message varchar(255)
);




CREATE TABLE scheme_issue_securities (
    id numeric(18,0) NOT NULL,
    scheme numeric(18,0),
    security numeric(18,0),
    sec_type varchar(255),
    sec_parameter varchar(255)
);


CREATE TABLE schemeissuesecuritylevels (
    id numeric(18,0) NOT NULL,
    name varchar(255),
    description text,
    scheme numeric(18,0)
);


CREATE TABLE scheme_permissions (
    id numeric(18,0) NOT NULL,
    scheme numeric(18,0),
    permission numeric(18,0),
    perm_type varchar(255),
    perm_parameter varchar(255),
    permission_key varchar(255)
);


CREATE TABLE searchrequest (
    id numeric(18,0) NOT NULL,
    filtername varchar(255),
    authorname varchar(255),
    description text,
    username varchar(255),
    groupname varchar(255),
    projectid numeric(18,0),
    reqcontent text,
    fav_count numeric(18,0),
    filtername_lower varchar(255)
);



CREATE TABLE sequence_value_item (
    seq_name varchar(60) NOT NULL,
    seq_id numeric(18,0)
);



CREATE TABLE serviceconfig (
    id numeric(18,0) NOT NULL,
    delaytime numeric(18,0),
    clazz varchar(255),
    servicename varchar(255),
    cron_expression varchar(255)
);


CREATE TABLE sharepermissions (
    id numeric(18,0) NOT NULL,
    entityid numeric(18,0),
    entitytype varchar(60),
    sharetype varchar(10),
    param1 varchar(255),
    param2 varchar(60)
);



CREATE TABLE tempattachmentsmonitor (
    temporary_attachment_id varchar(255) NOT NULL,
    form_token varchar(255),
    file_name varchar(255),
    content_type varchar(255),
    file_size numeric(18,0),
    created_time numeric(18,0)
);



CREATE TABLE trackback_ping (
    id numeric(18,0) NOT NULL,
    issue numeric(18,0),
    url varchar(255),
    title varchar(255),
    blogname varchar(255),
    excerpt varchar(255),
    created timestamp with time zone
);



CREATE TABLE trusted_app (
    id numeric(18,0) NOT NULL,
    application_id varchar(255),
    name varchar(255),
    public_key text,
    ip_match text,
    url_match text,
    timeout numeric(18,0),
    created timestamp with time zone,
    created_by varchar(255),
    updated timestamp with time zone,
    updated_by varchar(255)
);



CREATE TABLE upgrade_history (
    id numeric(18,0),
    upgradeclass varchar(255) NOT NULL,
    targetbuild varchar(255),
    status varchar(255),
    downgradetaskrequired character(1)
);



CREATE TABLE upgrade_task_history (
    id numeric(18,0) NOT NULL,
    upgrade_task_factory_key varchar(255),
    build_number numeric(9,0),
    status varchar(60),
    upgrade_type varchar(10)
);



CREATE TABLE upgrade_taskhistory_auditlog (
    id numeric(18,0) NOT NULL,
    upgrade_task_factory_key varchar(255),
    build_number numeric(9,0),
    status varchar(60),
    upgrade_type varchar(10),
    timeperformed timestamp with time zone,
    action varchar(10)
);




CREATE TABLE upgrade_version_history (
    id numeric(18,0),
    timeperformed timestamp with time zone,
    targetbuild varchar(255) NOT NULL,
    targetversion varchar(255)
);




CREATE TABLE user_association (
    source_name varchar(60) NOT NULL,
    sink_node_id numeric(18,0) NOT NULL,
    sink_node_entity varchar(60) NOT NULL,
    association_type varchar(60) NOT NULL,
    sequence numeric(9,0),
    created timestamp with time zone
);



CREATE TABLE user_base (
    id numeric(18,0) NOT NULL,
    username varchar(255),
    password_hash varchar(255)
);



CREATE TABLE user_historyitem (
    id numeric(18,0) NOT NULL,
    entitytype varchar(10),
    entityid varchar(60),
    username varchar(255),
    lastviewed numeric(18,0),
    data text
);



CREATE TABLE user_pickerfilter (
    id numeric(18,0) NOT NULL,
    customfield numeric(18,0),
    customfieldconfig numeric(18,0),
    enabled varchar(60)
);

CREATE TABLE user_picker_filter_group (
    id numeric(18,0) NOT NULL,
    userpickerfilter numeric(18,0),
    groupname varchar(255)
);



CREATE TABLE user_picker_filter_role (
    id numeric(18,0) NOT NULL,
    userpickerfilter numeric(18,0),
    projectroleid numeric(18,0)
);



CREATE TABLE version_control (
    id numeric(18,0) NOT NULL,
    vcsname varchar(255),
    vcsdescription varchar(255),
    vcstype varchar(255)
);



CREATE TABLE vote_history (
    id numeric(18,0) NOT NULL,
    issueid numeric(18,0),
    votes numeric(18,0),
    timestamp timestamp with time zone
);



CREATE TABLE workflowscheme (
    id numeric(18,0) NOT NULL,
    name varchar(255),
    description text
);




CREATE TABLE workflowschemeentity (
    id numeric(18,0) NOT NULL,
    scheme numeric(18,0),
    workflow varchar(255),
    issuetype varchar(255)
);

CREATE TABLE work_log (
    id numeric(18,0) NOT NULL,
    issueid numeric(18,0),
    author varchar(255),
    grouplevel varchar(255),
    rolelevel numeric(18,0),
    worklogbody text,
    created timestamp with time zone,
    updateauthor varchar(255),
    updated timestamp with time zone,
    startdate timestamp with time zone,
    timeworked numeric(18,0)
);



REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;

