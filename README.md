# Postgres SQL Development Notes
This is meant for Postgres SQL development notes
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
### CREATE/UPDATE/DELETE
```
psql pacman pacman
CREATE TABLE a (id int NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY, data text);
INSERT INTO a VALUES (DEFAULT, 'a') RETURNING id;
\q
```

### READ (SELECT)

