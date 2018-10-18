# First try at my own tcl script
#start_gui

set origin_dir [file dirname [info script]]

# Create the project
create_project thesis_des $origin_dir/thesis_des -part xc7z020clg484-1
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]

# Add design sources
add_files -norecurse -scan_for_includes {/users/start2015/r0583050/Thesis/verilog/hweval_des.v /users/start2015/r0583050/Thesis/verilog/hweval_des_pipelined.v}
add_files -norecurse -scan_for_includes {/users/start2015/r0583050/Thesis/verilog/des/des_pipelined.v /users/start2015/r0583050/Thesis/verilog/des/primitives/s_boxes.v /users/start2015/r0583050/Thesis/verilog/des/des_block.v /users/start2015/r0583050/Thesis/verilog/des/des_roundfunction_pipelined.v /users/start2015/r0583050/Thesis/verilog/des/des.v /users/start2015/r0583050/Thesis/verilog/des/primitives/ip_permutation.v /users/start2015/r0583050/Thesis/verilog/des/primitives/lfsr.v /users/start2015/r0583050/Thesis/verilog/des/primitives/mask_xor.v /users/start2015/r0583050/Thesis/verilog/des/primitives/ip_inverse_permutation.v /users/start2015/r0583050/Thesis/verilog/des/primitives/e_expansion.v /users/start2015/r0583050/Thesis/verilog/des/primitives/p_permutation.v}
add_files /users/start2015/r0583050/Thesis/verilog/hweval_des_block.v
add_files -norecurse -scan_for_includes {/users/start2015/r0583050/Thesis/verilog/des/des_unroll8.v /users/start2015/r0583050/Thesis/verilog/des/des_unroll2.v /users/start2015/r0583050/Thesis/verilog/des/des_unroll4.v /users/start2015/r0583050/Thesis/verilog/des/des_unrollfull.v}
add_files -norecurse -scan_for_includes /users/start2015/r0583050/Thesis/verilog/hweval_des_block.v
add_files -norecurse -scan_for_includes /users/start2015/r0583050/Thesis/verilog/des/des_roundfunction.v

update_compile_order -fileset sources_1

# Disabling source management mode.  This is to allow the top design properties to be set without GUI intervention.
set_property source_mgmt_mode None [current_project]
set_property top hweval_des_block [current_fileset]

# Re-enabling previously disabled source management mode.
set_property source_mgmt_mode All [current_project]
update_compile_order -fileset sources_1

# Add similation sources
add_files -fileset sim_1 -norecurse -scan_for_includes {/users/start2015/r0583050/Thesis/python/testfiles/des_tests_pipeline_input.txt /users/start2015/r0583050/Thesis/python/testfiles/lfsr_tests.txt /users/start2015/r0583050/Thesis/python/testfiles/des_tests_pipeline_expected.txt}
add_files -fileset sim_1 -norecurse -scan_for_includes {/users/start2015/r0583050/Thesis/verilog/tb/tb_lfsr_automatic.v /users/start2015/r0583050/Thesis/verilog/tb/tb_des_block.v /users/start2015/r0583050/Thesis/verilog/tb/tb_des_pipelined_automatic.v}

update_compile_order -fileset sources_1

# Run synthesis
launch_runs synth_1 -jobs 3

start_gui

##########################################################

