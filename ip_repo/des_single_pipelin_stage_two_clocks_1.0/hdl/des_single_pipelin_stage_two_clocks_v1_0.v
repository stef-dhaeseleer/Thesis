
`timescale 1 ns / 1 ps

	module des_single_pipelin_stage_two_clocks_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 6
	)
	(
		// Users to add ports here
		
		input wire des_clk,

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

	wire [63:0] des_counter;
	wire [63:0] des_ciphertext;
	wire [31:0] region_data;
	wire [31:0] cmd_data;
 	wire cmd_data_valid;
    wire cmd_data_read;
    wire des_done;
    wire des_test_advance;
    wire des_test_result_ready;

	// ********************


// Instantiation of Axi Bus Interface S00_AXI
	des_single_pipelin_stage_two_clocks_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) des_single_pipelin_stage_two_clocks_v1_0_S00_AXI_inst (
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
		.CMD_DATA_READ(cmd_data_read),
		.DES_DONE(des_done),
		.DES_COUNTER(des_counter),
		.DES_REGION(region_data),
		.TEST_ADVANCE(des_test_advance),
		.DES_TEST_RESULT_READY(des_test_result_ready),
		.DES_CIPHERTEXT(des_ciphertext)
	);

	// Add user logic here
	
	des_block_wrapper des_block_wrapper(
        .clk (des_clk),
        .rst_n (s00_axi_aresetn),
        .cmd (cmd_data),
        .cmd_valid (cmd_data_valid),
        .advance_test_cmd (des_test_advance),
        .region (region_data),
        // **********************************
        .cmd_read (cmd_data_read),
        .test_res_ready (des_test_result_ready),
        .done (des_done),
        .counter (des_counter),
        .ciphertext (des_ciphertext)
        );

	// User logic ends

	endmodule