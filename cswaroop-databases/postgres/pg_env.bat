@ECHO OFF
REM The script sets environment variables helpful for PostgreSQL
@SET PGHOME=C:\Projects\sql\postgres\pgsql
@SET PATH=%PGHOME%\bin;%PATH%
@SET PGDATA=%PGHOME%\data
@SET PGDATABASE=postgres
@SET PGUSER=postgres
@SET PGPORT=5432
@SET PGLOCALEDIR=%PGHOME%\share\locale

                            