set name "full_axi_zcu102_" 

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.0 zynq_ultra_ps_e_0
set_property -dict [list CONFIG.PSU__FPGA_PL1_ENABLE {1} CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {IOPLL} CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {50} CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {220}] [get_bd_cells zynq_ultra_ps_e_0]
apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" }  [get_bd_cells zynq_ultra_ps_e_0]
endgroup

for {set count 0} {$count < 64} {incr count} {
    set a $name$count
    startgroup
    create_bd_cell -type ip -vlnv user.org:user:full_axi_zcu102:1.0 $a
    apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" intc_ip "New AXI Interconnect" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
    apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk1 (214 MHz)" }  [get_bd_pins $a/des_clk]
    endgroup
}

for {set count 64} {$count < 128} {incr count} {
    set a $name$count
    startgroup
    create_bd_cell -type ip -vlnv user.org:user:full_axi_zcu102:1.0 $a
    apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" intc_ip "New AXI Interconnect" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
    apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk1 (214 MHz)" }  [get_bd_pins $a/des_clk]
    endgroup
}

for {set count 128} {$count < 192} {incr count} {
    set a $name$count
    startgroup
    create_bd_cell -type ip -vlnv user.org:user:full_axi_zcu102:1.0 $a
    apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM2_FPD" intc_ip "New AXI Interconnect" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
    apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk1 (214 MHz)" }  [get_bd_pins $a/des_clk]
    endgroup
}

for {set count 192} {$count < 256} {incr count} {
    set a $name$count
    startgroup
    create_bd_cell -type ip -vlnv user.org:user:full_axi_zcu102:1.0 $a
    apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM3_FPD" intc_ip "New AXI Interconnect" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
    apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk1 (214 MHz)" }  [get_bd_pins $a/des_clk]
    endgroup
}


regenerate_bd_layout




