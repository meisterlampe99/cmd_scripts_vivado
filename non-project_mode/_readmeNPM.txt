###############################################
###   Readme for Non-Project Mode Scripts   ###
###############################################
No Vivado project is created with this script.

Only design checkpoints are created and can be opened from Vivado.
Non-Project mode will have a lower runtime.

-------------------------------------------------------------------------------
To launch simulation:
-------------------------------------------------------------------------------
open cmd, navigate to this folder and run

	vivado -mode tcl -source npm_runSim.tcl -tclarg TopModuleName
	
or use the supplied batch file with (old outputs are deleted before launch)
	
	runSim TopModuleName

This then opens the GUI and displays the results.
It automatically adds the TopModule's signals to the waveform window, as well
as the internal signals of the top hierarchy inside the module

You can keep the GUI open and just relaunch the simulation from there, after 
you modified your sources otherwise close the GUI and the script will finish.

-------------------------------------------------------------------------------
To run synthesis, implementation & generate a bitstream
-------------------------------------------------------------------------------
run:

	vivado -mode tcl -source npm_runBit.tcl -tclarg TopModuleName 
	
or use the supplied batch file with (old outputs are deleted before launch)

	runBit TopModuleName

In the folder ./output the generated files can be found.

-------------------------------------------------------------------------------
To deploy a bitstream to the target FPGA
-------------------------------------------------------------------------------
run:

	vivado -mode tcl -source npm_configFPGA.tcl -tclarg TopModuleName
	
or use the supplied batch file with

	config TopModuleName

The done LED should light up on the board once it is configured
+ you should see some blinking LEDs

-------------------------------------------------------------------------------
edit runSettings.tcl to modify the used FPGA device

Design checkpoints .dcp files are generated after synthesis and implementation.
They can be opened with Vivado to inspect schematics, routing and timing