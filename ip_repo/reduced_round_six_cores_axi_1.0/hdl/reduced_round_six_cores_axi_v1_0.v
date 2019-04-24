
`timescale 1 ns / 1 ps

	module reduced_round_six_cores_axi_v1_0 #
	(
            // Users to add parameters here
    
            // User parameters ends
            // Do not modify the parameters beyond this line
    
    
            // Parameters of Axi Slave Bus Interface S00_AXI
            parameter integer C_S00_AXI_DATA_WIDTH    = 32,
            parameter integer C_S00_AXI_ADDR_WIDTH    = 5
        )
        (
            // Users to add ports here
    
            input wire des_clk,     // The clock for the DES HW
    
            // User ports ends
            // Do not modify the ports beyond this line
    
    
            // Ports of Axi Slave Bus Interface S00_AXI
            input wire  s00_axi_aclk,
            input wire  s00_axi_aresetn,
            input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
            input wire [2 : 0] s00_axi_awprot,
            input wire  s00_axi_awvalid,
            output wire  s00_axi_awready,
            input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
            input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
            input wire  s00_axi_wvalid,
            output wire  s00_axi_wready,
            output wire [1 : 0] s00_axi_bresp,
            output wire  s00_axi_bvalid,
            input wire  s00_axi_bready,
            input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
            input wire [2 : 0] s00_axi_arprot,
            input wire  s00_axi_arvalid,
            output wire  s00_axi_arready,
            output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
            output wire [1 : 0] s00_axi_rresp,
            output wire  s00_axi_rvalid,
            input wire  s00_axi_rready
        );
    
        // ********************

        // Wires  needed to connect both blocks together
    
        wire [63:0] des_counter_0;
        wire [63:0] des_counter_1;
        wire [63:0] des_counter_2;
        wire [63:0] des_counter_3;
        wire [63:0] des_counter_4;
        wire [63:0] des_counter_5;
        wire [31:0] cmd_data;
        wire [31:0] des_data_upper;
        wire [31:0] des_data_lower;
    
        wire cmd_data_valid;
        wire cmd_data_read_0;
        wire des_done_0;
        wire cmd_data_read_1;
        wire des_done_1;
        wire cmd_data_read_2;
        wire des_done_2;
        wire cmd_data_read_3;
        wire des_done_3;
        wire cmd_data_read_4;
        wire des_done_4;
        wire cmd_data_read_5;
        wire des_done_5;

        wire active_core_0;
        wire active_core_1;
        wire active_core_2;
        wire active_core_3;
        wire active_core_4;
        wire active_core_5;
    
        // ********************
        
// Instantiation of Axi Bus Interface S00_AXI
	reduced_round_six_cores_axi_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) full_axi_four_cores_zcu102_v1_0_S00_AXI_inst (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready),
        // **************************************
        .CMD_DATA(cmd_data),
        .CMD_DATA_VALID(cmd_data_valid),
        .CMD_DATA_READ_0(cmd_data_read_0),
        .DES_DONE_0(des_done_0),
        .CMD_DATA_READ_1(cmd_data_read_1),
        .DES_DONE_1(des_done_1),
        .CMD_DATA_READ_2(cmd_data_read_2),
        .DES_DONE_2(des_done_2),
        .CMD_DATA_READ_3(cmd_data_read_3),
        .DES_DONE_3(des_done_3),
        .CMD_DATA_READ_4(cmd_data_read_4),
        .DES_DONE_4(des_done_4),
        .CMD_DATA_READ_5(cmd_data_read_5),
        .DES_DONE_5(des_done_5),
        .DES_COUNTER_0(des_counter_0),
        .DES_COUNTER_1(des_counter_1),
        .DES_COUNTER_2(des_counter_2),
        .DES_COUNTER_3(des_counter_3),
        .DES_COUNTER_3(des_counter_4),
        .DES_COUNTER_3(des_counter_5),
        .DATA_UPPER(des_data_upper),
        .DATA_LOWER(des_data_lower),
        .ACTIVE_CORE_0(active_core_0),
        .ACTIVE_CORE_1(active_core_1),
        .ACTIVE_CORE_2(active_core_2),
        .ACTIVE_CORE_3(active_core_3),
        .ACTIVE_CORE_3(active_core_4),
        .ACTIVE_CORE_3(active_core_5)
    );
    
    // Add user logic here

    // Instantiation of the 4 DES cores connected to this AXI interface

    // Core 0
    des_block_wrapper des_block_wrapper_0(
        .clk (des_clk),
        .rst_n (s00_axi_aresetn),
        .cmd (cmd_data),
        .cmd_valid (cmd_data_valid & active_core_0),
        // **********************************
        .data_upper (des_data_upper),
        .data_lower (des_data_lower),
        .cmd_read (cmd_data_read_0),
        .done (des_done_0),
        .counter (des_counter_0)
        );

    // Core 1
    des_block_wrapper des_block_wrapper_1(
        .clk (des_clk),
        .rst_n (s00_axi_aresetn),
        .cmd (cmd_data),
        .cmd_valid (cmd_data_valid & active_core_1),
        // **********************************
        .data_upper (des_data_upper),
        .data_lower (des_data_lower),
        .cmd_read (cmd_data_read_1),
        .done (des_done_1),
        .counter (des_counter_1)
        );

    // Core 2
    des_block_wrapper des_block_wrapper_2(
        .clk (des_clk),
        .rst_n (s00_axi_aresetn),
        .cmd (cmd_data),
        .cmd_valid (cmd_data_valid & active_core_2),
        // **********************************
        .data_upper (des_data_upper),
        .data_lower (des_data_lower),
        .cmd_read (cmd_data_read_2),
        .done (des_done_2),
        .counter (des_counter_2)
        );

    // Core 3
    des_block_wrapper des_block_wrapper_3(
        .clk (des_clk),
        .rst_n (s00_axi_aresetn),
        .cmd (cmd_data),
        .cmd_valid (cmd_data_valid & active_core_3),
        // **********************************
        .data_upper (des_data_upper),
        .data_lower (des_data_lower),
        .cmd_read (cmd_data_read_3),
        .done (des_done_3),
        .counter (des_counter_3)
        );

    // Core 4
    des_block_wrapper des_block_wrapper_4(
        .clk (des_clk),
        .rst_n (s00_axi_aresetn),
        .cmd (cmd_data),
        .cmd_valid (cmd_data_valid & active_core_4),
        // **********************************
        .data_upper (des_data_upper),
        .data_lower (des_data_lower),
        .cmd_read (cmd_data_read_4),
        .done (des_done_4),
        .counter (des_counter_4)
        );

    // Core 5
    des_block_wrapper des_block_wrapper_5(
        .clk (des_clk),
        .rst_n (s00_axi_aresetn),
        .cmd (cmd_data),
        .cmd_valid (cmd_data_valid & active_core_5),
        // **********************************
        .data_upper (des_data_upper),
        .data_lower (des_data_lower),
        .cmd_read (cmd_data_read_5),
        .done (des_done_5),
        .counter (des_counter_5)
        );

    // User logic ends

    endmodule
