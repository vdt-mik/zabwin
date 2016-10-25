@echo off
net stop "Zabbix Agent"
TIMEOUT /T 3 /NOBREAK
sc delete "Zabbix Agent"
pause