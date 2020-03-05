@echo off
set KETTLE_HOME=C:\Kettle60\data-integration
set PATH=%KETTLE_HOME%
call kitchen.bat -file %~dp0syncJob.kjb
pause