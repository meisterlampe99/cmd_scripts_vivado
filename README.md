# Scripts for Command Line use of Vivado

Scripts for executing simulation, bitstream generation and FPGA configuration 
via launching Vivado from a Windows Command Prompt.
Includes an example usage for both Project and Non-Project modes.

-------------------------------------------------------------------------------

## Overall Concept

The scripts scan the launch folder for all SystemVerilog files (.sv). 
The **TopModuleName** must be handed over to the scripts as an argument.
All .sv files in the folder must be free of syntax errors!
Actual filenames should be irrelevant, but modules should be saved with the 
module name as the filename: 
	
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

### Setting up the PATH variable

Verify that Vivado is available in your shell by calling `vivado -version`.

Otherwise, include the \bin folder of the Vivado install location to the PATH variable:

| Shell | Commands | Descriptions |
| ----------- | ----------- | ----------- |
| Command Prompt | `path` <br> `path=%PATH%;C:\Xilinx\Vivado\2024.2\bin` | Display PATH <br> Append to PATH  |
| PowerShell | `$env:Path` <br> `$env:Path+=';C:\Xilinx\Vivado\2024.2\bin'` | Display PATH <br> Append to PATH  |

-------------------------------------------------------------------------------

## How to use

TCL scripts are started via batch files to simplify the interface and 
to clean up the working directory before a launch.

Batch files can be launched via their name, with or without their file ending:
e.g.: *config.bat* or just *config*

Available batch scripts:

	- clean 			Removes most previously generated output
					see also "Info on clean.bat script"

	- runSim <TopModuleName> [<DUTname>]	Launches the simulation of <TopModuleName>_tb,
						and pre-loads a waveform configuration.
						Note: A module called "top_level_tb" must exist!
						[Optional:<DUTname>] Adds a divider in the waveform
						viewer and adds all DUT internal signals below it.

	- runBit <TopModuleName>	Synthesizes, implements and generates the bitstream for 
					<TopModuleName>
							
	- config <TopModuleName>	Connects to the board and configures the FPGA by down-
					loading the bitstream generated from <TopModuleName>
					
	Note: Make sure the module is inside a system verilog file ".sv"
	Note: Use the module name as the argument! Do not use the filename with the .sv ending!
	Note: All .sv files in the launch folder must be free of syntax errors!
	Tipp: To ignore files, remove the .sv ending, or move them out of the folder.

The targeted FPGA device can be chosen within the settings.tcl script.

### Usage of the provided example

Navigate to one of the example folders (project_mode, non-project_mode) from a
Command Prompt or a PowerShell in Windows and type:

| Pommand Prompt | PowerShell | Description |
| ----------- | ----------- | ----------- |
| `runSim top_level DUT` | `./runSim top_level DUT` | Note: "top_level_tb" module must exist! <br> The device under test in the example<br> testbench is called DUT   |
| `runBit top_level` | `./runBit top_level` |         |
| `config top_level` | `./config top_level` | Note: Cable drivers must be installed!      |

 Note: Never include the file ending ".sv" in the \<TopModuleName\> parameter!
 
### Info on clean.bat script

The following files and folders are deleted when clean.bat is executed:

	DEL vivado*.zip >nul 2>&1
	DEL vivado*.jou >nul 2>&1
	DEL vivado*.log >nul 2>&1
	DEL webtalk*.jou >nul 2>&1
	DEL webtalk*.log >nul 2>&1
	RMDIR /S /Q outputSim >nul 2>&1
	RMDIR /S /Q outputBit >nul 2>&1
	RMDIR /S /Q .Xil >nul 2>&1

The *runSim.bat* and *runBit.bat* scripts will do the same, but only delete their respective output folders, outputSim or outputBit, instead of both.

### Manual TCL script usage (or usage under Linux)

Project Mode:

	vivado -mode batch -source runSim.tcl -tclarg <TopModuleName> [<DUTname>]
	vivado -mode batch -source runBit.tcl -tclarg <TopModuleName>
	vivado -mode batch -source config.tcl -tclarg <TopModuleName>

Non-project Mode:

	vivado -mode tcl -source npm_runSim.tcl -tclarg <TopModuleName> [<DUTname>]
	vivado -mode tcl -source npm_runBit.tcl -tclarg <TopModuleName>
	vivado -mode tcl -source npm_config.tcl -tclarg <TopModuleName>

-------------------------------------------------------------------------------

## Ideas for future improvements

- [x] Add table to Readme showing script usage in CMD and Powershell
- [x] Add vivado -version to check if path is setup correcty, show how to do so for cmd and powershell
- [x] Combine IOSTANDARD and LOCATION parameters into single lines in .xdc
- [x] Add synchronizer for reset input.
- [x] Emphasize the strict naming convention for simulation \<module\>\_tb for runSim script.
- [x] Add warning to readme, that all .sv files in the launch location must be 
free of syntax errors.
- [x] Pass name of DUT down to runSim.bat (for adding signals to waveform viewer)
- [x] <s>Convert mode individual readme files to markdown files</s>. <br> Removed outdated mode individual readme files.
- [ ] Add only one .xdc file to each run, named \<module\>.xdc
- [ ] Use Make for build automation?

### Ideas for even further into the future
- [ ] Add a flag to connect a System ILA debug core to all nets marked as
debug. During configuration, supply the now generated .ltx file to the 
hardware manager before downloading the bitstream.
- [ ] Launch the script from the created output subfolder instead of the 
launch folder, to ensure that Vivado logs are dumped there instead.
Then remove the potentially dangerous delete commands from the batch files.
- [ ] Add a similar example for a ZYBO board and the ZUBoard 1CG (Zynq US+)
- [ ] Launch scripts from an install directory instead of having to copy them
to the directory of the HDL project.
- [ ] Make shell scripts for Linux!?
