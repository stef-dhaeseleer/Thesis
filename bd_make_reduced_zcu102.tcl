set name "reduced_round_six_cores_axi_" 
set type "reduced_round_six_cores_axi"
set init 0

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.0 zynq_ultra_ps_e_0
apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" }  [get_bd_cells zynq_ultra_ps_e_0]
set_property -dict [list CONFIG.PSU__FPGA_PL1_ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
endgroup

set a $name$init
startgroup
create_bd_cell -type ip -vlnv user.org:user:$type:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" intc_ip "New AXI Interconnect" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk1 (214 MHz)" }  [get_bd_pins $a/des_clk]
endgroup

apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Slave "/reduced_round_six_cores_axi_0/S00_AXI" intc_ip "/ps8_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]
set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {32}] [get_bd_cells ps8_0_axi_periph]
delete_bd_objs [get_bd_intf_nets zynq_ultra_ps_e_0_M_AXI_HPM1_FPD]
 
for {set count 1} {$count < 32} {incr count} {
    set a $name$count
    startgroup
    create_bd_cell -type ip -vlnv user.org:user:$type:1.0 $a
    apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" intc_ip "New AXI Interconnect" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
    apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk1 (214 MHz)" }  [get_bd_pins $a/des_clk]
    #apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Slave "/full_axi_four_cores_zcu102_0/S00_AXI" intc_ip "/ps8_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]
    endgroup
}

startgroup
set_property -dict [list CONFIG.PSU__USE__M_AXI_GP1 {0}] [get_bd_cells zynq_ultra_ps_e_0]
endgroup

#for {set count 64} {$count < 128} {incr count} {
#    set a $name$count
#    startgroup
#    create_bd_cell -type ip -vlnv user.org:user:$type:1.0 $a
#    apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" intc_ip "New AXI Interconnect" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
#    apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk1 (214 MHz)" }  [get_bd_pins $a/des_clk]
#    endgroup
#}

regenerate_bd_layout

# "/full_axi_four_cores_zcu102_0/S00_AXI"
