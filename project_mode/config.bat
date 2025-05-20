
@echo off
REM Check if an argument was provided
if "%~1"=="" (
    echo Usage: config.bat TopModuleName
    exit /b 1
)

set TopModuleName=%~1

REM Run Vivado in batch mode with the provided top module name
vivado -mode batch -source config.tcl -tclarg %TopModuleName%
