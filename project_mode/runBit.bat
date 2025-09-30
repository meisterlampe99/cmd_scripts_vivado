
@echo off
REM Check if an argument was provided
if "%~1"=="" (
    echo Usage: runBit.bat TopModuleName
    exit /b 1
)

set TopModuleName=%~1

REM clean up working directory
DEL vivado*.zip >nul 2>&1
DEL vivado*.jou >nul 2>&1
DEL vivado*.log >nul 2>&1
DEL webtalk*.jou >nul 2>&1
DEL webtalk*.log >nul 2>&1
RMDIR /S /Q outputBit >nul 2>&1
RMDIR /S /Q .Xil >nul 2>&1


REM Run Vivado in batch mode with the provided top module name
vivado -mode batch -source runBit.tcl -tclarg %TopModuleName%
