

drop schema junk cascade;
create schema junk;

set search_path=junk,public;

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
    password text,
    external_id text,
    junk_field text
);

CREATE TABLE doc (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    outputtype text,
    outputxml text,
    created_at timestamp
);

CREATE TYPE address_type AS ENUM (
'Current',
'Previous',
'SecondPrevious'
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




COMMENT ON TABLE tenant IS 'A tenant table to isolate data';

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
    street_type text REFERENCES it_street_type (id),
    street_name text,
    street_number text,
    province text,
    force_town text,
    force_street text,
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
    countrycode text,
    organizationid text REFERENCES org (id),
    applicationtype text REFERENCES app_type (id),
    applicationnumber text NOT NULL UNIQUE,
    dfeid text,
    dealerreferencenumber text,
    versionnumber bigint,
    isversionactive smallint,
    applicationtypecd bigint,
    applicationsubtype bigint,
    application_type_cd text,
    dfestatus text,
    applicationstatusid text REFERENCES application_status (id),
    applicationstatuscd text,
    withdrawapplicationreasonid bigint,
    overrideapplicationreason text REFERENCES override_reason (id),
    isverified boolean,
    decisionpartyid bigint,
    statuschangedatetime timestamp,
    expirationdatetime timestamp,
    gifsubmissiondate timestamp,
    gifsubmissiontime timestamp,
    inputsource bigint,
    srscontractnumber text,
    dealercomments text,
    recordtransmissiontype text,
    dfesubmissiontime timestamp,
    dfesubmissiondate timestamp,
    gifresubmissiondate timestamp,
    gifresubmissiontime timestamp,
    applicationlockedby bigint,
    applicationlockeddatetime timestamp,
    purchasecontractid text,
    isescalated smallint,
    rejectlettersentdatetime timestamp,
    isqualityreviewrequired smallint,
    ismgmtdecisionconcintime smallint,
    ismgmtdecisionconcrequired smallint,
    queueapplicationstatuscd text,
    istruecommercial smallint,
    documentlink1 text,
    documentlink2 text,
    documentlink3 text,
    documentlink4 text,
    documentlink5 text,
    dferesubmissiondate timestamp,
    dferesubmissiontime timestamp,
    updateapplicationnumber text,
    dealername text,
    dealernumber text,
    dealercontactname text,
    dealertelephonenumber text,
    channel text,
    dealerid bigint,
    isbureaulock smallint,
    bureaulockdate timestamp,
    concurrencerandomnumber bigint,
    qualityrandomnumber bigint,
    isouremployee smallint,
    ismanualbureaupulled smallint,
    countofescalations bigint,
    countofmissingdata bigint,
    countofexceptions bigint,
    agreementtypeid bigint,
    dealercomment text,
    queuemapid bigint,
    slatime timestamp,
    dfesubmissiondatetime timestamp,
    disagreewithqualityreview smallint,
    isreprocessed smallint,
    ismatchedbureaupull smallint,
    searchpreviousbureau smallint,
    newdferesubmissiondate timestamp,
    newdferesubmissiontime timestamp,
    newdferesubmissiondate2 timestamp,
    newdferesubmissiontime2 timestamp,
    excludeduserid text,
    iseligibleforrejectletter boolean,
    descisiontakenuserid text,
    externalid text,
    receivedbyuserid text,
    receiveddate timestamp,
    lockedby bigint,
    lockedon timestamp,
    lockexpireon timestamp,
    submittedby bigint,
    submittedon timestamp,
    --IT
    assigned_sales_person text,
    sales_person text,
    iswithdrawalrequest boolean,
    ismissingdocrequest boolean,
    updatedby text
);

COMMENT ON TABLE app IS 'Main Business Entity';

CREATE TYPE applicant_type AS ENUM (
    'Person',
    'Business'
);


CREATE TYPE applicant_role AS ENUM (
    'Applicant',
    'Co-Applicant',
    'Guarantor',
    'EffectiveOwner'
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

CREATE TABLE app_accomodations (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    matched_app_id text REFERENCES app (id),
    updatedby text,
    updatedon timestamp
);


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
    variant text,
    vehicleid text,
    registrationnumber text,
    vin text,
    firstregistrationdate date,
    mileage bigint,
    registrationplate numeric,
    vehiclevaluationsystem numeric,
    vehiclevaluationmanual numeric,
    vehicleusage bigint,
    ffo bigint,
    freeformatentry text,
    vehicleyear text,
    vatqualifying_1 bigint,
    vatqualifyingdisabled text,
    queuemapid bigint,
    registrationplatenumber text,
    created_at timestamp DEFAULT NOW(),
    updated_at timestamp DEFAULT NOW()
);



CREATE TABLE contract (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    crtapplicationnumber text,
    retrieveddatetime timestamp,
    truecountrycode bigint,
    purchasedate timestamp,
    branchnumber bigint,
    accountnumbersrs bigint,
    contractneworused text,
    contractvehicleyear bigint,
    contractvehiclemake text,
    contractvehiclemodel text,
    contractmonthlypaymentamount numeric,
    contractamountfinanced numeric,
    contractvehcashsellingprice numeric,
    contractterm bigint,
    contractedc numeric,
    vehiclemakecode bigint,
    leasingapplicationnumber text,
    leasingindicator bigint,
    contractmsrp numeric,
    updatedby bigint,
    updatedon timestamp
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
    decisionstage decision_stage,
    authorityconcurrence authority_concurrence,
    underwriter_decision underwriter_decision,
    underwriterid text,
    decisiontype decision_type,
    isdecisionsenttodealer boolean,
    isdecisionoverridden boolean,
    isvalid boolean,
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
    documentstatus text,
    comment text,
    applicantindicator boolean,
    coapplicantindicator boolean,
    companyindicator boolean,
    party1indicator boolean,
    party2indicator boolean,
    party3indicator boolean,
    party4indicator boolean
);

CREATE TABLE reason_type (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean

);

CREATE TABLE reason_subtype (
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
    reasontype text REFERENCES reason_type (id),
    reasonsubtype text REFERENCES reason_subtype (id),
    applicantindicator boolean,
    coapplicantindicator boolean,
    companyindicator boolean,
    party1indicator boolean,
    party2indicator boolean,
    party3indicator boolean,
    party4indicator boolean
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
    vehiclecashsellingprice numeric,
    vaps numeric,
    cashdeposit numeric,
    fda numeric,
    tradeinequity numeric,
    totalamountfinanced numeric,
    term bigint,
    financeproduct bigint,
    financeplan text,
    flatrate numeric,
    apr numeric,
    settlementflag text,
    frequency bigint,
    systemresidualvalue numeric,
    manualresidualvalue numeric,
    annualmileage bigint,
    totaldeposit numeric,
    settlementamount numeric,
    balloon_gfv numeric,
    plan text,
    financetype text,
    totalamountpayable numeric,
    initialpayment numeric,
    securitydeposit numeric,
    partexchange numeric,
    advancepayment numeric,
    interest numeric,
    rental numeric,
    payment numeric,
    costincvat numeric,
    endofcontractmileage text,
    -- IT
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


CREATE TABLE app_finance_delta (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    dmrequestid text,
    label text,
    currentvalue text,
    previousvalue text,
    delta bigint,
    bureauvalue text,
    sectionheader bigint,
    deltavalue text
);



CREATE TABLE workflow (
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

CREATE TABLE note_type (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean
);


CREATE TABLE app_notes (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    notetypecd text REFERENCES note_type (id),
    description text,
    subject text,
    updatedby text,
    updatedon timestamp
);


CREATE TABLE app_qc (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app(id),
    dla bigint,
    dlareason1 bigint,
    dlareason2 bigint,
    exceptionsdla bigint,
    exceptionsdlareason1 bigint,
    exceptionsdlareason2 bigint,
    fraudflags bigint,
    fraudflagsreason1 bigint,
    fraudflagsreason2 bigint,
    complianceandsanctions bigint,
    complianceandsanctionsreaso1 bigint,
    complianceandsanctionsreaso2 bigint,
    verificationstipulated bigint,
    verificationstipulatedreaso1 bigint,
    verificationstipulatedreaso2 bigint,
    verificationcompleted bigint,
    verificationcompletedreason1 bigint,
    verificationcompletedreason2 bigint,
    concurrencedecision bigint,
    concurrencedecisionreason1 bigint,
    concurrencedecisionreason2 bigint,
    qualityfeedback text,
    underwriterid bigint,
    underwriterresponse bigint,
    underwritercomments text
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

CREATE TABLE ws_dfe (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    request_id text REFERENCES doc (id),
    response_id text REFERENCES doc(id),
    requested_at timestamp,
    responsed_at timestamp,
    created_at timestamp,
    updated_at timestamp

);

CREATE TABLE ws_experience (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    requested_at timestamp,
    responsed_at timestamp,
    created_at timestamp,
    updated_at timestamp

);

CREATE TABLE app_ws_err (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    interfacetypeid bigint,
    interfacesubtypeid bigint,
    detail text,
    externalerrorcode text,
    data1 text,
    data2 text,
    interfaceerrortypeid bigint,
    errorcode text,
    errormessage text,
    partytype text
);


CREATE TABLE business_type (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean
);

CREATE TABLE company_type (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean
);

CREATE TABLE applicant_business (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    applicant_id text REFERENCES applicant (id),
    company_type text REFERENCES company_type (id),
    businesstype text REFERENCES business_type (id),
    companyname text,
    tradingname text,
    companyregnumber text,
    natureofbusiness text,
    establishdate timestamp,
    noofyearsinbusiness bigint,
    noofmonthsinbusiness bigint,
    vatnumber text,
    numberofemployees bigint,   
    isexistingcustomer bigint,
    phone text,
    phone_type text,
    email text,
    totalnumberofemployees bigint,
    grossannualincome numeric,
    businessstartdate timestamp,
    businesscreditlinesid bigint,
    businessmatchinglistid bigint,
    bureaupullmapforapplicant bigint,
    -- IT
    cciaa_code text,
    constitution_code text,
    no_of_partners int,
    -- OOB
    legalbusinessname text,
    doingbusinessas text,
    contactname text,
    fax text,
    ownershiptypeid bigint,
    priorbusinessexperience bigint,
    businessstructuretypeid bigint
);


CREATE TABLE applicant_business_address (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    applicant_id text REFERENCES applicant (id),
    addresstype  address_type,
    address_id text REFERENCES address (id),
    addressyears bigint,
    addressmonths bigint,
    updatedby text,
    updatedon timestamp
);


CREATE TABLE applicant_business_delta (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    dmrequestid text,
    applicant_id text REFERENCES applicant (id),
    label text,
    currentvalue text,
    previousvalue text,
    delta bigint,
    bureauvalue text,
    sectionheader bigint,
    deltavalue text
);


CREATE TABLE applicant_business_financial (
    id bigint NOT NULL,
    applicant_id text REFERENCES applicant (id) PRIMARY KEY,
    address_id text REFERENCES address (id),
    paymentmethod text,
    accountholder text,
    accountnumber text,
    sortcode text,
    bankname text,
    banktimeyears int,
    banktimemonths int

);


CREATE TABLE applicant_experience (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    applicant_id text REFERENCES applicant (id),
    contractnumber text,
    vehiclemake text,
    vehiclemodel text,
    vehicleyear bigint,
    dealername text,
    dealernumber text,
    financeproduct text,
    totalamountfinanced numeric,
    monthlypayment numeric,
    outstandingbalance numeric,
    pifdate timestamp,
    numberofmissedpaymentslessth bigint,
    numberofmissedpaymentsgreate bigint,
    numberofmissedpaymentslesst2 bigint,
    numberofmissedpaymentsgreat2 bigint,
    latechargedue numeric,
    settlementindicator smallint,
    vtindicator smallint,
    loss_repoindicator text,
    totaldownpayment numeric,
    pifactiveindicator smallint,
    contractdate timestamp,
    missedpaymentslessthan30 bigint,
    missedpaymentsgreaterthan90 bigint,
    missedpaymentsbetween30to59 bigint,
    missedpaymentsbetween60to89 bigint,
    vtindicatorvalue text,
    pifactiveindicatorvalue text,
    retrieveddatetimestamp timestamp,
    isactive boolean default true
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
    'Male',
    'Female'
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

CREATE TABLE creditline_person (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    organizationid text REFERENCES org(id),
    creditlinelimit numeric,
    expirydate timestamp,
    status text,
    lastreviewdate timestamp,
    firstname text,
    initial text,
    lastname text,
    dateofbirth timestamp,
    srsmultiusernumber text,
    bankaccount bigint,
    creditlimit numeric,
    potentialtruecommercialflag smallint,
    retrieveddatetime timestamp,
    flatnumber bigint,
    housename text,
    housenumber text,
    streetaddress text,
    locality text,
    town text,
    postcode text,
    gender gender,
    updatedby bigint,
    updatedon timestamp
);


CREATE TABLE applicant_person (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    applicant_id text REFERENCES applicant (id),
    app_id text REFERENCES app (id),
    partytypecd text, -- not used
    partytype bigint,  -- not used
    partysubtype bigint, -- not used
    prefixname text,
    firstname text,
    middlename text,
    lastname text,
    applicantname text,
    suffixname text,
    birthdate date,
    gender gender,
    maritalstatus text REFERENCES marital_status (id),
    -- employmenttype text REFERENCES employment_type (id),
    ouremployee boolean,
    -- employername text,
    numberofdependents smallint,
    applicantidnumber text,
    applicanthomephone text,
    priorbusinessexperience bigint,
    priormanagementexperience bigint,
    yearsascurrentowner numeric(45,8),
    residentialstatus text REFERENCES residential_status (id),
    hasfutureobligations boolean,
    canuseofcreditinfo boolean,
    isprimarycontact boolean,
    isguaranteeavailable boolean,
    creditlinesid text REFERENCES creditline_person (id),
    isnewbureaurequired smallint,
    bureauvalidationdatetime timestamp,
    bureaupullmapforapplicant bigint,
    existingcustomeryesnoid bigint,
    identificationtypeid bigint,
    identificationvalue text,
    identificationplaceissued text,
    isexistingcustomer boolean,
    -- IT
    title text REFERENCES title (id),
    birth_city text,
    birth_province text,
    id_number text,
    relationship_to_applicant text,
    nationality text,
    doc_id text,
    doc_issue_date date,
    doc_expiry_date date,
    doc_release_authority text,
    is_politically_exposed boolean,
    home_phone text,
    work_phone text,
    mobile_phone text,
    email text
);



CREATE TABLE applicant_person_address (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    applicant_id text REFERENCES applicant (id),
    addresstype address_type,
    address_id text REFERENCES address (id),
    manualbureaupullrecordid bigint,
    addresslocationbureauid text REFERENCES address (id),
    yearsataddress bigint,
    monthsataddress bigint,
    baseresidencetype bigint,
    isprimaryaddress smallint,
    -- IT
    monthly_rent numeric,
    updatedby bigint,
    updatedon timestamp
);



CREATE TABLE applicant_person_delta (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    dmrequestid text,
    applicant_id text REFERENCES applicant (id),
    label text,
    currentvalue text,
    previousvalue text,
    delta bigint,
    bureauvalue text,
    sectionheader bigint,
    displayorder bigint,
    deltavalue text
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
    -- IT
    job_title text,
    net_monthly_salary numeric,
    count_salary_payments int,
    isemploymentcontract boolean,

    updatedby bigint,
    updatedon timestamp
);

CREATE TABLE payment_method (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position int,
    is_active boolean

);

CREATE TABLE applicant_person_financial (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    applicant_id text REFERENCES applicant (id),
    address_id text REFERENCES address (id),
    paymentmethod text REFERENCES payment_method (id),
    accountholder text,
    accountnumber text,
    sortcode text,
    bankname text,
    banktimeyears bigint,
    banktimemonths bigint,
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
    dm2requestid text,
    dm3requestid text,
    isnomatch boolean,
    ismanualbureaupull boolean,
    bureauattachedtoapplication boolean,
    isnewpull boolean,
    isvalid boolean,
    isactive boolean default true,
    isexpired boolean,
    expired_at timestamp
);



CREATE TABLE creditline_business (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    retrieveddatetime timestamp,
    creditlimit numeric,
    expirydate timestamp,
    status text,
    lastreviewdate timestamp,
    companyregistrationnumber text,
    companyname text,
    vat text,
    bankaccount bigint,
    potentialtruecustomerflag smallint,
    flatnumber text,
    housename text,
    housenumber text,
    streetaddress text,
    locality text,
    town text,
    postcode text,
    srsmultiusernumber text,
    updatedby bigint,
    updatedon timestamp
);





CREATE TYPE dealer_service_level AS ENUM (
    'Standard',
    'Priority'
);

CREATE TYPE dealer_verification_strategy AS ENUM (
    'Standard',
    'Enhanced'
);

CREATE TABLE dealer (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    countrycode text REFERENCES country(id),
    organizationid text REFERENCES org (id),
    address_id text REFERENCES address (id),
    dealernumber text,
    dealername text,
    dealergroup text,
    contactphonenumber text,
    companyregnumber text,
    vat text,
    rejectletters bigint,
    servicelevelgrade  dealer_service_level,
    service_level_code text,
    verificationstrategy  dealer_verification_strategy,
    autoaction bigint,
    autoconditionalapproval bigint,
    autoreject bigint,
    autoapproval bigint,
    challengerpolicy text,
    policycategory text,
    dealerchannel text,
    emailaddress text,
    keycontactname text,
    dealergroupnumber text,
    accountmanager text,
    isactive smallint,
    updatedby bigint,
    updatedon timestamp
);

CREATE TABLE dealer_sla (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    countrycode text REFERENCES country (id),
    organizationid text REFERENCES org (id),
    dealerservicelevel dealer_service_level,
    newapplication int,
    resubmission int,
    service_level_code text
);

CREATE TABLE enumerations (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    countrycode text,
    domain_name text,
    parent_id integer,
    key text NOT NULL UNIQUE,
    value text,
    order_val integer DEFAULT 0,
    is_active boolean DEFAULT true,
    is_deleted boolean DEFAULT false,
    src_id bigint
);

CREATE TABLE "role"
(
  id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
  espace_id bigint,
  ss_key text,
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

CREATE TABLE group_ext (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    updatedby bigint,
    updatedon timestamp,
    is_active smallint,
    is_deleted smallint
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

CREATE TABLE it_identification (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    applicant_id text REFERENCES applicant (id),
    type text,
    id_number text,
    issue_date date,
    issue_place text,
    issue_province text,
    issue_country text,
    tax_code_origin text,
    health_insurance_card_number text,
    health_insurance_card_expiry_date text,
    vat text,
    vat_issue_date date,
    authority_release text,
    passport_type text,
    permit_of_stay_no_limit text
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

CREATE TABLE org_role_dla (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    organizationid text,
    countrycode text,
    rolecode text,
    rolename text,
    hierarchy bigint,
    oddsnumericcode bigint,
    odds text,
    cbscoreindividualnumericcode bigint,
    cbscoreindividual text,
    cbscorecompanynumericcode bigint,
    cbscorecompany text,
    ptinumericcode bigint,
    pti text,
    dtinumericcode bigint,
    dti text,
    ltvnumericcode bigint,
    ltvpercentage text,
    ltvamount text,
    chevroletltvnumericcode bigint,
    chevroletltvpercentage text,
    chevroletltvamount text,
    min_term text,
    max_term text,
    max_vehicleage text,
    max_mileage text,
    max_installment text,
    max_dlasingle text,
    max_dlaaggregate text,
    ltv text,
    chevroletltv text,
    term text
);


CREATE TABLE org_sla_slots (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    organizationid text,
    weekdaysid text,
    timeindecimalformat numeric,
    isallowedsla smallint,
    timeslot timestamp
);



CREATE TYPE it_phone_type AS ENUM (
    'Home'
    'Work'
    'Mobile'
);

CREATE TABLE it_phone (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    phone_type  it_phone_type,
    holder_first_name text,
    holder_last_name text,
    area_code text,
    "number" text
);

CREATE TABLE applicant_contact (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    applicant_id text REFERENCES applicant (id),
    it_phone_id  text
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





CREATE TABLE rpt_app_queue (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    baseapplicationid bigint,
    queueid bigint
);



CREATE TABLE rpt_app_status (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    code text,
    label text,
    position bigint,
    is_active boolean
);



CREATE TABLE rpt_app_status_log (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    reportapplicationstatus text,
    updatedon timestamp,
    dealerid text REFERENCES dealer (id),
    financeproductid bigint,
    applicationtypeid bigint,
    assettypeid bigint,
    userid bigint,
    countofmissingdata bigint,
    countofescalations bigint,
    countofexceptions bigint,
    applicationid bigint
);



CREATE TABLE rpt_queue_kpi (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    app_id text REFERENCES app (id),
    queueid text,
    entrydatetime timestamp,
    exitdatetime timestamp,
    secondsinqueue bigint
);



CREATE TABLE rpt_queue_stats (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    queueid bigint,
    queueslaseconds bigint,
    countrycode text,
    queuetype text
);



CREATE TABLE rpt_queue_type (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    label text,
    position bigint,
    is_active smallint,
    queuecode text
);



CREATE TABLE search_index_table (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    organizationid text,
    searchdata text,
    applicationid text
);



CREATE TABLE user_effective_role (
    --id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    role_id text,
    user_id text,
    tenant_id text,
    PRIMARY KEY (role_id, user_id, tenant_id)
);


CREATE TABLE user_ext (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    user_id text,
    firstname text,
    lastname text,
    is_deleted smallint,
    defaultosapplicationid text,
    inuseapplicationid text,
    timezoneid text,
    updatedby bigint,
    updatedon timestamp
);



CREATE TABLE user_recent (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    userid text,
    app_id text,
    label text,
    url text,
    instant timestamp
);



CREATE TABLE user_role (
    id text DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    user_id text,
    role_id text,
    tenant_id text
);

