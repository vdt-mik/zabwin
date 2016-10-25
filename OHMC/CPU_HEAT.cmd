@echo off
for /F "usebackq tokens=7-10" %%a in (`C:\zabbix\OHMC\OpenHardwareMonitorReport.exe`) do echo %%b %%c %%d| find "/intelcpu/0/temperature/0">nul && set temper=%%a 
echo %temper%