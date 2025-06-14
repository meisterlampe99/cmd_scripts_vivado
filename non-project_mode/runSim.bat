
@echo off
REM Check if an argument was provided
if "%~1"=="" (
    echo Usage: runSim.bat TopModuleName [Optional: DUTname]
    exit /b 1
)

set TopModuleName=%~1
set DUTName=%~2

REM clean up working directory
DEL vivado*.zip
DEL vivado*.jou
DEL vivado*.log
DEL webtalk*.jou
DEL webtalk*.log
RMDIR /S /Q outputSim
RMDIR /S /Q .Xil


REM Run Vivado in tcl mode with the provided top module name
vivado -mode tcl -source npm_runSim.tcl -tclarg %TopModuleName% %DUTName%
