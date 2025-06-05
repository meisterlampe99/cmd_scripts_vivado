# Function to handle errors and exit Vivado
proc handle_error {msg} {
    puts "Error: $msg"
    exit 1
}

# try catch block for failing commands
if {[catch {
 	# Check if at least one argument is provided
	if {$argc < 1} {
	puts "Usage: vivado -mode batch -source runSim.tcl -tclarg <TopModuleName> [Optional:<DUTname>]"
	exit 1
	}

	# Get the first argument (topmodule)
	set topmodule [lindex $argv 0]

	if {$argc == 2} {
	# Get the second argument (dutname)  if available
	set dutname [lindex $argv 1]
	}

	# Capture the start time
	set start_time [clock seconds]

	#source settings (part and nr of cores used)
	source settings.tcl

	# Define the project name and directory
	set project_name "${topmodule}_prj"
	set project_dir "./outputSim"

	# Create the output directory if it doesn't exist
	file mkdir $project_dir

	# Set the maximum number of threads
	set_param general.maxThreads $threads

	# Create a new project
	create_project -force $project_name $project_dir -part xc7a35tcpg236-1

	# Add all SystemVerilog files in the root directory
	foreach file [glob *.sv] {
		add_files $file
	}

	# Add the XDC file
	#add_files -fileset constrs_1 [glob *.xdc]

	# Set the top module source files
	set_property top $topmodule [current_fileset]
	update_compile_order -fileset sources_1

	# Set the top module for simulation sources
	set_property top ${topmodule}_tb [get_filesets sim_1]
	set_property top_lib xil_defaultlib [get_filesets sim_1]

	# Run linting in Vivado 2019.2 or later
	# Get the Vivado version
	set vivado_version [version]

	# Extract the year and release number
	regexp {v(\d+)\.(\d+)} $vivado_version -> year release

	# Convert to integers for comparison
	set year [expr {$year}]
	set release [expr {$release}]

	# Check if the version is newer than 2019.1
	if {($year > 2019) || ($year == 2019 && $release > 1)} {
		# set severity of linter messages
		set_msg_config -id {Synth 37-} -severity {CRITICAL WARNING} -new_severity {ERROR}
		set_msg_config -id {Synth 37-} -severity {WARNING} -new_severity {ERROR}
		
		# Call the line if the version is newer than 2019.1
		puts "Vivado version is newer than 2019.1 - do Linting"
		synth_design -top ${topmodule} -lint
		
		# Generate linting report
		report_drc -file $project_dir/lint_report.txt
	} else {
		puts "Vivado version is 2019.1 or older - no Linter available"
	}

	# Set simulation time to inf. and log all signals
	set_property -name {xsim.simulate.runtime} -value {} -objects [get_filesets sim_1]
	set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]

	# Run simulation
	launch_simulation
	run all

	# Capture the end time
	set end_time [clock seconds]

	# Calculate and print the total runtime
	puts "Total simulation runtime: [expr {$end_time - $start_time}] seconds"

	start_gui
	# add divider and internal signals if DUT name is supplied
	if {$argc == 2} {
		add_wave_divider "${dutname} internal signals"
		add_wave /${topmodule}_tb/${dutname}
	}

	# Copy simulation results (just wastes space)
	#set sim_results_dir $project_dir/${project_name}.sim/sim_1/behav/xsim
	#file copy -force $sim_results_dir/${topmodule}_tb_behav.wdb $project_dir/waveform.wdb

	# Save waveform config so Vivado doesn't complain when closing
	save_wave_config $project_dir/${topmodule}_tb_behav.wcfg
	add_files -fileset sim_1 -norecurse $project_dir/${topmodule}_tb_behav.wcfg
	set_property xsim.view $project_dir/${topmodule}_tb_behav.wcfg [get_filesets sim_1]

} result]} {
    handle_error $result
}
