# Postgres SQL Development Notes
This is meant for Postgres SQL development notes sourced from varies postgres resources
## Getting started with postgres
### Init postgres instance (initdb)
Goto `bin` directory
`initdb -D data -U postgres -W`

`initdb --locale en_US.UTF-8 -E UTF8 -D '/var/lib/postgres/data' -D postgres -W`
### Create database (create database)
```
psql postgres postgres
CREATE ROLE pacman PASSWORD 'pacman';
CREATE DATABASE pacman OWNER pacman;
\q
```
### CREATE/UPDATE/DELETE/SELECT
```
psql pacman pacman
CREATE TABLE a (id int NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY, data text, length numeric);
INSERT INTO a VALUES (DEFAULT, 'a', 100) RETURNING id;
\q
```
```
SELECT * FROM a;
SELECT 
    id AS aid
  , data AS content
  , length AS length
FROM
  a
WHERE
  a.id=1
  
```
