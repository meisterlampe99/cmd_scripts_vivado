# Check if at least one argument is provided
#if {$argc < 1} {
#puts "error when calling sim.tcl from npm_runSim.tcl :-/"
#exit 1
#}

# Get the first argument (topmodule)
#set topmodule [lindex $argv 0]

# read environment variable because argument passing didn't work in xsim
set topmodule $::env(XSIM_TOPMODULE)

# Log all signals
log_wave [get_objects -r /*]

#run simlation
run all

#add TOP and DUT signals to waveform viewer
add_wave /${topmodule}_tb
add_wave_divider "DUT internal signals"
add_wave /${topmodule}_tb/DUT

# move simulation results to subfolder (just wastes space)
# file copy -force ./${topmodule}_sim.wdb ./${topmodule}_waveform.wdb

#store waveform config so vivado doesn't complain when closing
save_wave_config ./${topmodule}_waveform.wcfg
