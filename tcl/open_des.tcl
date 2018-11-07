# Open the project and set the settings needed

set origin_dir [file dirname [info script]]

# Start the GUI
start_gui

# Open the project
open_project thesis_des/thesis_des.xpr
update_compile_order -fileset sources_1

# Set latches to errors
set_msg_config -ruleid {1} -id {Synth 8-327} -new_severity {ERROR} -source 2

