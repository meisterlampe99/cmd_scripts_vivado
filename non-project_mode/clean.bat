
@echo off

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
