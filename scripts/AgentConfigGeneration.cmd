@echo off
chcp 866 > nul
set /P CLIENT="Enter Organization name: "
set /P PSKID=" Enter PSKIdentity: "
set /P PSKkey="Enter PSKkey: "
set /p Server="Enter Zabbix Server IP"
set /p ServerActive="Enter Zabbix Server Active IP"

rem Генерация конфига
@echo # zabbix_agent 3.2.0> C:\zabbix\conf\zabbix_agentd.conf
@echo. >>C:\zabbix\conf\zabbix_agentd.conf
@echo %PSKkey%>>C:\zabbix\psk\Z_agent.psk
@echo LogFile=C:\zabbix\logs\logs.log >> C:\zabbix\conf\zabbix_agentd.conf
@echo LogFileSize=100 >> C:\zabbix\conf\zabbix_agentd.conf
@echo Server=%Server% >> C:\zabbix\conf\zabbix_agentd.conf
@echo ServerActive=%ServerActive% >> C:\zabbix\conf\zabbix_agentd.conf
@echo StartAgents=3 >> C:\zabbix\conf\zabbix_agentd.conf
@echo Timeout=30 >> C:\zabbix\conf\zabbix_agentd.conf
@echo Hostname=%CLIENT%.%COMPUTERNAME% >> C:\zabbix\conf\zabbix_agentd.conf
@echo. >> C:\zabbix\conf\zabbix_agentd.conf

@echo ##### TLS ###########>> C:\zabbix\conf\zabbix_agentd.conf
@echo TLSConnect=psk>> C:\zabbix\conf\zabbix_agentd.conf
@echo TLSAccept=psk>> C:\zabbix\conf\zabbix_agentd.conf
@echo TLSPSKFile=C:\zabbix\psk\Z_agent.psk>> C:\zabbix\conf\zabbix_agentd.conf
@echo TLSPSKIdentity=%PSKID% >> C:\zabbix\conf\zabbix_agentd.conf
@echo. >> C:\zabbix\conf\zabbix_agentd.conf
type C:\zabbix\scripts\UserParameters.txt>> C:\zabbix\conf\zabbix_agentd.conf
pause