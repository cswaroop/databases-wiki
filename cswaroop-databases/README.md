# datbase 1999-01
## postgresql
### How to create a database and user in postgresql?
``` sql
CREATE ROLE redmine LOGIN ENCRYPTED PASSWORD 'my_password' NOINHERIT VALID UNTIL 'infinity';
CREATE DATABASE redmine WITH ENCODING='UTF8' OWNER=redmine;
```
# Whats the typical `create table` best practice?


create schema crm;
set search_path=crm;
create TABLE "order" (
  id SERIAL NOT NULL PRIMARY KEY,
  gid uuid DEFAULT uuid_generate_v1mc() NOT NULL,
  ...
  ...
  created_at timestamp,
  created_by BIGINT,
  updated_at timestamp,
  updated_by BIGINT
);