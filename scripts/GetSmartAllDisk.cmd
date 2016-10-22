rem включаем СМАРТ у всех дисков которые это позволят:
for /F "tokens=1" %%a in ('C:\zabbix\smartmontools\bin\smartctl.exe --scan') ^
do "C:\Program Files\smartmontools\bin\smartctl.exe" --smart=on --offlineauto=on --saveauto=on %%a