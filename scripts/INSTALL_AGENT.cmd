@echo off
chcp 866 > nul
set /P CLIENT="Client NAME: "
set /P PSKID="PSKIdentity: "
set /P PSKkey="Enter PSKkey: "
set /p Server="Enter Zabbix Server IP: "
set /p ServerActive="Enter Zabbix Server Active IP: "
cls

rem Устанавливаем smartmontools в тихом режиме
C:\zabbix\smartmontools\smartmontools-6.6-0-20161023-r4357.win32-setup.exe /S

rem Открывает порт 10050 в брандмауэре
set localportname=10050
set rulename=zabbix
set dirrname=in
set protocolname=TCP
set actionname=allow
netsh advfirewall firewall add rule name=%rulename% dir=%dirrname% action=%actionname% protocol=%protocolname% localport=%localportname%
echo "port %localportname% was open on host %hostname%"

rem создание конфига
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
rem Добавляем пользовательские параметры
type C:\zabbix\scripts\UserParameters.txt>> C:\zabbix\conf\zabbix_agentd.conf

rem Создание списка дисков
@echo off
echo @echo off > c:\zabbix\disks\disks.cmd
echo echo {"data": >> c:\zabbix\disks\disks.cmd
echo echo    [ >> c:\zabbix\disks\disks.cmd
for /F "tokens=1,3" %%a in ('C:\"Program Files"\smartmontools\bin\smartctl.exe --scan') ^
do (for %%s in ("Device Model" "Product") ^
do (for /F "tokens=2*" %%c in ('C:\"Program Files"\smartmontools\bin\smartctl.exe -i %%a -d %%b ^| find %%s ') ^
do (for %%i in ("Serial Number") do (for /F "tokens=3*" %%k in ('C:\"Program Files"\smartmontools\bin\smartctl.exe -i %%a -d %%b ^| find %%i ') ^
do echo echo      {"{#DISKPORT}":"%%a","{#DISKTYPE}":"%%b","{#DISKMODEL}":"%%d","{#DISKSN}":"%%k"},>> c:\zabbix\disks\disks.cmd))))
echo echo      {"{#SMARTV}":"Smartctl 6.6"}>> c:\zabbix\disks\disks.cmd
echo echo    ] >> c:\zabbix\disks\disks.cmd
echo echo } >> c:\zabbix\disks\disks.cmd

rem Включение смарт на всех дисках
for /F "tokens=1" %%a in ('C:\"Program Files"\smartmontools\bin\smartctl.exe --scan') ^
do "C:\Program Files\smartmontools\bin\smartctl.exe" --smart=on --offlineauto=on --saveauto=on %%a

rem Установка службы Zabbix Agent
if DEFINED ProgramFiles(x86) (goto :x64) else (goto :x86)
:x64
C:\zabbix\bin\win64-ssl\zabbix_agentd.exe -i -c C:\zabbix\conf\zabbix_agentd.conf
goto :NEXT
:x86
C:\zabbix\bin\win32-ssl\zabbix_agentd.exe -i -c C:\zabbix\conf\zabbix_agentd.conf
goto :NEXT

:NEXT
rem Запуск службы Zabbix Agent
net start "Zabbix Agent"
echo.
echo OK!

@echo ------------------------------------
@echo Hostname: %CLIENT%.%COMPUTERNAME%
@echo ------------------------------------
@echo.
Pause