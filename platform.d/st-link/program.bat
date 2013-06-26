@echo off

rem Arguments:
rem		%1: Path to ST-LINK_cli.exe
rem		%2: Connection mode
rem		%3: Path to new firmware

call %1 -Q -C %2 -P %3 -V -Rst -Run
