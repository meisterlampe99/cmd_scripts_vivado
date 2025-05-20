# Scripts for Command Line use of Vivado

Scripts for executing simulation, bitstream generation and FPGA configuration 
via launching Vivado from a Windows command prompt.
Includes an example usage for both project and non-project modes.

-------------------------------------------------------------------------------

## Overall Concept

The scripts scan the launch folder for all system verilog files (.sv). 
The *TopModuleName* must be handed over to the scripts as an argument.
Filenames should be irrelevant, but modules should be saved with the same 
filename: 
	
The module **myModule** should be saved as **myModule.sv**. 
The *testbench module* of said module must be called **myModule_tb** 
and should be saved as **myModule_tb.sv**.

All constraint files found in the launch folder will also be considered
	during the build! (.xdc)

### Project vs Non-Project mode

Project mode allows you to also open the same project in GUI mode.

Non-project mode should have an overall lower runtime.

### Example Design

A very basic example design is provided with the scripts: 
A 24bit counter where the 8 MSB bits are connected to LEDs on a Basys3 board.

### Compatibility

Tested for 2019.1 and 2024.2 versions, but should work with other versions.
There was major change in tcl commands after 2019.1, which is considered 
when interacting with the hardware manager in the configuration script.

### Linting

For Vivado versions later than 2019.1 a linter is used.
All linter messages of type WARNING and CRITICAL WARNING are set to ERROR.
An additional top_level_wLintErrors.sv is available for testing.

-------------------------------------------------------------------------------

## How to use

TCL scripts are started via batch files to simplify the interface and 
to clean up the working directory before a launch.

Batch files can be launched via their name, with or without their file ending:
config.bat or just config

Available batch scripts:

	- 'clean' 			removes most previously generated output

	- 'runSim TopModuleName'	runs a simulation of TopModuleName_tb,
					opens the GUI and adds some waveforms

	- 'runBit TopModuleName'	synthesizes, implements and generates the 
					bitstream for TopModuleName
							
	- 'config TopModuleName'	connects to the board and configures the
					FPGA via downloading the bitstream generated from TopModuleName

The used FPGA device can be chosen within the settings.tcl script.

### Using the provided example

Navigate to one of the example folders (project_mode, non-project_mode) from a
command prompt in windows and type:

	- runSim top_level 
	- runBit top_level 
	- config top_level 

### Info on clean.bat script

The following files and folders are deleted when clean.bat is executed.
The *runSim.bat* and *runBit.bat* scripts will delete the same files, but 
will delete just their appropriate output folder, outputSim or outputBit 
respectively.

	DEL vivado*.zip
	DEL vivado*.jou
	DEL vivado*.log
	DEL webtalk*.jou
	DEL webtalk*.log
	RMDIR /S /Q outputSim
	RMDIR /S /Q outputBit
	RMDIR /S /Q .Xil

### Manual tcl script usage

project mode:

	- vivado -mode batch -source runSim.tcl -tclarg TopModuleName
	- vivado -mode batch -source runBit.tcl -tclarg TopModuleName
	- vivado -mode batch -source config.tcl -tclarg TopModuleName

non-project mode:

	- vivado -mode tcl -source npm_runSim.tcl -tclarg TopModuleName
	- vivado -mode tcl -source npm_runBit.tcl -tclarg TopModuleName
	- vivado -mode tcl -source npm_config.tcl -tclarg TopModuleName

-------------------------------------------------------------------------------

## Ideas for future improvements

- Add a flag to connect a System ILA debug core to all nets marked as
debug. During configuration, supply the now generated .ltx file to the 
hardware manager before downloading the bitstream.

- launch scripts from an install directory instead of having to copy them
to the directory of the HDL project.

- launch the script from the created output subfolder instead of the 
launch folder, to ensure that Vivado logs are dumped there instead.
Then remove the potentially dangerous delete commands from the batch files.

- add a similar example for a ZYBO board and the ZUBoard 1CG (Zynq US+)
