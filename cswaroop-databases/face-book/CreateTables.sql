-- This is a sample facebook database
-- https://developers.facebook.com/docs/graph-api/reference/

DROP schema IF EXISTS fb CASCADE;
CREATE schema fb;

set search_path=fb;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE OR REPLACE FUNCTION uuid_generate_v1mc()
  RETURNS uuid AS
'$libdir/uuid-ossp', 'uuid_generate_v1mc'
  LANGUAGE c VOLATILE STRICT
  COST 1;

CREATE TABLE page (
    id char(38) DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    about text,
    access_token text,
    ad_campaign text,
    affiliation text,
    app_id text,
    app_links text,
    artistis_we_like text,
    attire text,
    awards text,
    band_members text
    
);



CREATE TABLE "user"(
    id char(38) DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    about text,
    age_range int

);

CREATE TABLE page_admin_note
(
    id char(38) DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    body text,
    user_id text REFERENCES "user" (id),
    from_page text
    
);

CREATE TABLE achievement (
    id char(38) DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    user_id text,
    publish_time timestamp,
    app_id text,
    data jsonb,
    type text DEFAULT 'game.achievement',
    no_feed_story boolean
);

CREATE TABLE permission (
    id char(38) DEFAULT uuid_generate_v1mc()::text NOT NULL PRIMARY KEY,
    entity text,
    name text,
    user_id text REFERENCES "user" (id)
);
