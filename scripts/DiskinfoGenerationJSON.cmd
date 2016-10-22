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