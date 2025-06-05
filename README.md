# Scripts for Command Line use of Vivado

Scripts for executing simulation, bitstream generation and FPGA configuration 
via launching Vivado from a Windows Command Prompt.
Includes an example usage for both Project and Non-Project modes.

-------------------------------------------------------------------------------

## Overall Concept

The scripts scan the launch folder for all SystemVerilog files (.sv). 
The **TopModuleName** must be handed over to the scripts as an argument.
Actual filenames should be irrelevant, but modules should be saved with the 
module name in the filename: 
	
The module **myModule** should be saved as **myModule.sv**. 
The *testbench module* of said module must be called **myModule_tb** 
and should be saved as **myModule_tb.sv**.

All **constraint files (.xdc)** found in the launch folder will be included	during 
the build process. After Synthesis and Implementation **design checkpoint (.dcp)**
files are created in the output folder *outputBit*, as well as **utilization and 
timing reports**.

### Project vs Non-Project mode

- Project mode allows you to also open the same project in GUI mode.

- Non-Project mode should have an overall lower runtime.

### Example Design

A very basic example design is provided with the scripts: A 24-bit counter 
where the eight MSB bits are connected to LEDs on a Basys3 board.

### Compatibility

Tested for 2019.1 and 2024.2 versions, but should work with other versions.
There was a major change in TCL commands after 2019.1, which is considered 
when interacting with the hardware manager in the configuration script.

### Linting

For Vivado versions later than 2019.1 a linter is used. All linter messages of 
type WARNING and CRITICAL WARNING are set to ERROR. An additional file, 
top_level_wLintErrors.sv is available for testing linter behaviour.

-------------------------------------------------------------------------------

## How to use

TCL scripts are started via batch files to simplify the interface and 
to clean up the working directory before a launch.

Batch files can be launched via their name, with or without their file ending:
e.g.: *config.bat* or just *config*

Available batch scripts:

	- clean 			removes most previously generated output

	- runSim <TopModuleName>	launches the simulation of <TopModuleName>_tb,
					and pre-loads a waveform configuration.

	- runBit <TopModuleName>	synthesizes, implements and generates the 
					bitstream for <TopModuleName>
							
	- config <TopModuleName>	connects to the board and configures the FPGA
					by downloading the bitstream generated from 
					<TopModuleName>

The targeted FPGA device can be chosen within the settings.tcl script.

### Using the provided example

Navigate to one of the example folders (project_mode, non-project_mode) from a
Command Prompt in Windows and type:

	runSim top_level 
	runBit top_level 
	config top_level 

### Info on clean.bat script

The following files and folders are deleted when clean.bat is executed.
The *runSim.bat* and *runBit.bat* scripts will delete the same files, but 
only their respective output folders, outputSim or outputBit.

	DEL vivado*.zip
	DEL vivado*.jou
	DEL vivado*.log
	DEL webtalk*.jou
	DEL webtalk*.log
	RMDIR /S /Q outputSim
	RMDIR /S /Q outputBit
	RMDIR /S /Q .Xil

### Manual TCL script usage

Project Mode:

	vivado -mode batch -source runSim.tcl -tclarg <TopModuleName>
	vivado -mode batch -source runBit.tcl -tclarg <TopModuleName>
	vivado -mode batch -source config.tcl -tclarg <TopModuleName>

Non-project Mode:

	vivado -mode tcl -source npm_runSim.tcl -tclarg <TopModuleName>
	vivado -mode tcl -source npm_runBit.tcl -tclarg <TopModuleName>
	vivado -mode tcl -source npm_config.tcl -tclarg <TopModuleName>

-------------------------------------------------------------------------------

## Ideas for future improvements

- [ ] Add synchronizer for reset input.
- [ ] Add only one .xdc file to each run, named <module>.xdc
- [ ] Add warning to readme, that all .sv files in the launch location must be 
free of syntax errors.
- [ ] Pass name of DUT down to runSim.bat (for adding signals to waveform viewer)
- [ ] Convert mode individual readme files to markdown files.
- [ ] Add a flag to connect a System ILA debug core to all nets marked as
debug. During configuration, supply the now generated .ltx file to the 
hardware manager before downloading the bitstream.
- [ ] Launch scripts from an install directory instead of having to copy them
to the directory of the HDL project.
- [ ] Launch the script from the created output subfolder instead of the 
launch folder, to ensure that Vivado logs are dumped there instead.
Then remove the potentially dangerous delete commands from the batch files.
- [ ] Add a similar example for a ZYBO board and the ZUBoard 1CG (Zynq US+)
