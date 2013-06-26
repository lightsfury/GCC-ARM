@echo off

rem Arguments
rem		%1: Path to OpenOCD server binary
rem		%2: OpenOCD relative path(s) to OpenOCD board configuration(s)
rem		%3: Path to new firmware

call %1 -f %2 -c "reset halt" -c "sleep 100" -c "wait_halt 2" -c "flash write_image erase %3" -c "sleep 100" -c "verify_image %3" -c "sleep 100" -c "reset run"
