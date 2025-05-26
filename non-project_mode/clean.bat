
@echo off
<<<<<<< HEAD
=======
REM Check if an argument was provided
if "%~1"=="" (
    echo Usage: runBit.bat TopModuleName
    exit /b 1
)

set TopModuleName=%~1
>>>>>>> 9755c2349aa89c852daea603d0abcb43e06c75c1

REM clean up working directory
DEL vivado*.zip
DEL vivado*.jou
DEL vivado*.log
DEL webtalk*.jou
DEL webtalk*.log
RMDIR /S /Q outputSim
RMDIR /S /Q outputBit
RMDIR /S /Q .Xil
ECHO ------------------------------------
ECHO CMDscripts4Vivado: all (or most) output files, folders and vivado logs removed
