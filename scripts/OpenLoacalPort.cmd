@echo off

set localportname=10050
set rulename=zabbix
set dirrname=in
set protocolname=TCP
set actionname=allow
netsh advfirewall firewall add rule name=%rulename% dir=%dirrname% action=%actionname% protocol=%protocolname% localport=%localportname%