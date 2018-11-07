# Open the project and set the settings needed

set origin_dir [file dirname [info script]]

# Start the GUI
start_gui

# Open the project
open_project test_axi_2/test_axi_2.xpr
update_compile_order -fileset sources_1

# Report IP status to check for updates
report_ip_status -name ip_status 

# Should make this next command conditional
# Set latches to errors
#set_msg_config -ruleid {1} -id {Synth 8-327} -new_severity {ERROR} -source 2
