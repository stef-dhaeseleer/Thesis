`include "des_roundfunction.v"
`include "ip_inverse_permutation.v"
`include "ip_permutation.v"

module des_encryption(
	input clk,				// clock
	input rst_n,			// reset, active low signal
	input start, 			// signales the block to start working, valid data is on the input lines
	input [1:64] message, 	// the message to be encrypted
	output done,			// signals that the operations are done, valid result is on the output lines
	output [1:64] result	// the resulting encrypted version of the input message
	);

	// Nets and regs
	reg [2:0] state, next_state;        // State variables

	reg [3:0] counter;	// Registers needed for the counter
    reg sync_rst, cnt_enable;

	// Parameters
	localparam [2:0]    init = 3'd0;    // Possible states
    localparam [2:0]    IP = 3'd1;
    localparam [2:0]    roundfunction = 3'd2;
    localparam [2:0]    IP_inv = 3'd3;
    localparam [2:0]    finished = 3'd4;

	//---------------------------FSM---------------------------------------------------------------

	always @(posedge clk or negedge rst_n) begin // State register
        if (rst_n == 1'b0) begin   // Asynchronous reset
            state <= init;
        end
        else begin
            state <= next_state;
        end
    end

    // TODO: fill in the next state logic of des_encryption (2)
    always @(*) begin   // Next state logic
        case (state)
        init: begin
            next_state <= init;
        end
        roundfunction: begin
            next_state <= roundfunction;
        end
        finished: begin
            next_state <= finished;
        end
        default: begin
            next_state <= init;
        end
        endcase
    end

	//---------------------------DATAPATH---------------------------------------------------------------

	// Modules
	// The roundfunction
	des_roundfunction round_func(
			.clk    (clk ),
			.rst_n	(rst_n),
			.start  (),
			.L_in   (),
			.R_in   (),
			.Kn     (),
			.done   (),
			.L_out  (),
            .R_out  ());

	// The IP permutation module
	ip_permutation ip(
			.data_i    (),
            .data_o    ());

	// The inverse IP permutation module
	ip_inverse_permutation ip_inv(
			.data_i    (),
            .data_o    ());


    // Counter
    always @(posedge clk or negedge rst_n) begin
        if (sync_rst == 1'b1 || rst_n == 1'b0) begin
            counter <= 4'd0;
        end
        else if (cnt_enable == 1'b1) begin
            counter <= counter + 1;
        end
    end

endmodule