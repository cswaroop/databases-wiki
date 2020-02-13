-- A multitenant Data Model (System-of-Record) for Build-Your-Own-App Platform (Force.com) 

-- Essentially it would be a polyglot persistence for such platform-at-scale

-- https://developer.salesforce.com/page/Multi_Tenant_Architecture
-- https://www.youtube.com/watch?v=jrKA3cJmoms

-- Goals:
-- 1. Support declarative point-and-click rapid application development
-- 2. Bulk processing
-- 3. Recycle Bin
-- 4. Full Text Search
-- 5. Smart Bulk Data Manipulation Language
-- 6. Web Service APIs

-- Non-Multi tenant data

CREATE TABLE org (
	orgid text PRIMARY_KEY
	name text
);

-- Multitenant model is based on three focus areas: Metadata, Data, Indexdata

-- MetaData (should be cached across in app layer)

-- metadata for custom objects

CREATE TABLE mt_objects (
	objid text PRIMARY_KEY,
	orgid text,
	objname text
);

-- metadata for custom fields
CREATE TABLE mt_fields (
	fieldid text PRIMARY_KEY,
	orgid int,
	objid int,
	fieldname text,
	datatype text, -- text, number, date, datetime, richtext, picklist, auto-number, formula, checkbox, email, url, master-detail-fk
	fieldnum int,
	isindexed boolean
);

-- Data

-- Large Heap storage for structured data of custom objects (instances)
CREATE TABLE mt_data (
	guid text PRIMARY_KEY,
	orgid int,
	objid int,
	name text,
	val0 text,
	val1 text,
	val2 text,
	val3 text,
	val500 text,
	-- audit
	createdbyid int,
	createdat timestamptz,
	modifiedbyid int,
	modifiedat timestamptz,
	isdeleted boolean DEFAULT false
);

-- Large heap storage for unstructured text data of custom objects
CREATE TABLE mt_clobs (
	id int PRIMARY_KEY,
	orgid text,
	objid text,
	guid text
	val bytea
);


-- Index tables / Pivot tables / Derived Tables



-- Pivot table for non-unique indexes
CREATE TABLE MT_Indexes (
	orgid int,
	objid int,
	fieldnum int,
	guid text,
	stringvalue text,
	numvalue numeric,
	datevalue date,
	datetimevalue timestamptz,
	PRIMARY_KEY (orgid, objid, fieldnum)
);
-- Pivot table for unique indexes
CREATE TABLE MT_Unique_Indexes (
	orgid int,
);
-- when you need list of records in a parent/child relationship
CREATE TABLE MT_Name_Denorm (
	obj_id int,
	name text
);
-- Pivot table for most-recently-used objects
CREATE TABLE MT_MRU_Index (
	orgid int,
	objid int,
	guid int
);
-- Pivot table for Name field Index
CREATE TABLE MT_Fallback_Indexes (
	orgid int,
);

-- Pivot table for foreign keys
CREATE TABLE MT_Relationships (
	orgid int,
	relationid text, -- Master-Detail, Lookup
	fromobjid int,
	targetobj int
);
CREATE INDEX ON MT_Relationships USING (fromobjid, targetobjid);
CREATE INDEX ON MT_Relationships USING (targetobjid, fromobjid);
-- audit

CREATE TABLE MT_Data_Hist (

)