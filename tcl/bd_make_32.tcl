set count 0 
set name "minimal_des_axi_" 
set end "/des_clk"

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
set_property -dict [list CONFIG.PCW_EN_CLK1_PORT {1}] [get_bd_cells processing_system7_0]
endgroup

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "New AXI Interconnect" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count 
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count 
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count 
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

set a $name$count 
startgroup
create_bd_cell -type ip -vlnv user.org:user:minimal_des_axi:1.0 $a
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "/ps7_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins $a/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK1 (142 MHz)" }  [get_bd_pins $a$end]
endgroup
incr count 

regenerate_bd_layout


