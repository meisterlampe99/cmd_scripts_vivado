###########################################
###   Readme for Project Mode Scripts   ###
###########################################
A Vivado project is created with these scripts. 

The project can always be opened via Vivado in GUI mode as well.
Project mode will have a higher runtime.

-------------------------------------------------------------------------------
To launch simulation:
-------------------------------------------------------------------------------
open cmd, navigate to this folder and run

	vivado -mode batch -source runSim.tcl -tclarg TopModuleName

This then opens the GUI and displays the results.
It automatically adds the TopModule's signals to the waveform window, as well
as the internal signals of the top hierarchy inside the module

You can keep the GUI open and just relaunch the simulation from there, after 
you modified your sources otherwise close the GUI and the script will finish.

-------------------------------------------------------------------------------
To run synthesis, implementation & generate a bitstream
-------------------------------------------------------------------------------
run:

	vivado -mode batch -source runBit.tcl -tclarg TopModuleName 

In the folder ./output the generated files can be found.

-------------------------------------------------------------------------------
To deploy a bitstream to the target FPGA
-------------------------------------------------------------------------------
run:

	vivado -mode batch -source configFPGA.tcl -tclarg TopModuleName

The done LED should light up on the board once it is configured

-------------------------------------------------------------------------------
edit runSettings.tcl to modify the used FPGA device

Design checkpoints .dcp files are generated after synthesis and implementation.
They can be opened with Vivado to inspect schematics, routing and timing