# Function to handle errors and exit Vivado
proc handle_error {msg} {
    puts "Error: $msg"
    exit 1
}

# try catch block for failing commands
if {[catch {
    # Check if at least one argument is provided
	if {$argc < 1} {
	puts "Usage: vivado -mode batch -source runBit.tcl -tclarg <TopModuleName>"
	exit 1
	}

	# Get the first argument (filename)
	set topmodule [lindex $argv 0]
	# Capture the start time
	set start_time [clock seconds]

	#source settings (part and nr of cores used)
	source settings.tcl

	# Define the project name and directory
	set project_name "${topmodule}"
	set project_dir "./outputBit"

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
	add_files -fileset constrs_1 [glob *.xdc]

	# Set the top module source files
	set_property top $topmodule [current_fileset]
	update_compile_order -fileset sources_1

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
		synth_design -top $topmodule -lint
		
		# Generate linting report
		report_drc -file $project_dir/lint_report.txt
	} else {
		puts "Vivado version is 2019.1 or older - no Linter available"
	}

	# Launch Vivado in batch mode
	launch_runs synth_1 -jobs $threads
	wait_on_run synth_1

	# Open synthesized design
	open_run synth_1

	# Save post synthesis design checkpoint
	write_checkpoint -force $project_dir/${project_name}_synth.dcp

	# Launch implementation
	launch_runs impl_1 -to_step write_bitstream -jobs $threads
	wait_on_run impl_1

	# Open implemented design
	open_run impl_1

	# Save post implementation design checkpoint
	write_checkpoint -force $project_dir/${project_name}_impl.dcp

	# Write the bitstream
	write_bitstream -force $project_dir/${project_name}.bit

	# not tested: write LTX file if an ila core is in design
	# write_debug_probes -force my_debug_probes.ltx

	# Generate reports
	report_timing_summary -file $project_dir/timing_summary.rpt
	report_utilization -file $project_dir/utilization.rpt

	# Capture and print runtime
	set end_time [clock seconds]
	puts "Total script runtime: [expr {$end_time - $start_time}] seconds"
	
	# Exit Vivado console
    exit
} result]} {
    handle_error $result
}