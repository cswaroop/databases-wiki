export ORACLE_HOME=/u01/oracle/product/11.1.0/db_1
export ORACLE_SID=MY_DB_NAME
export TABLES_TO_EXPORT=production.reservation,production.payment,production.user

/u01/oracle/product/11.1.0/db_1/bin/expdp DB_EXPORT_USER/amazingPassword@//dbserver:1521/MY_DB_NAME dumpfile=etl.dmp logfile=etl.dmp.log content=data_only directory=DMPDIR tables=$TABLES_TO_EXPORT \
"query=production.reservation:\"WHERE creation_time >= '01-JAN-15'\", production.payment:\"WHERE valid = 1\""



impdp production/production "DIRECTORY=downloads" "DUMPFILE=myDumpfile.dmp" "TABLE_EXISTS_ACTION=truncate"