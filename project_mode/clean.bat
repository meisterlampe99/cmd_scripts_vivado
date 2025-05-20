
@echo off
REM Check if an argument was provided
if "%~1"=="" (
    echo Usage: runBit.bat TopModuleName
    exit /b 1
)

set TopModuleName=%~1

REM clean up working directory
DEL vivado*.zip
DEL vivado*.jou
DEL vivado*.log
DEL webtalk*.jou
DEL webtalk*.log
RMDIR /S /Q outputSim
RMDIR /S /Q outputBit
RMDIR /S /Q .Xil

ECHO all output files, folders and vivado logs removed
