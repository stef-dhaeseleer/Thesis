`include "e_expansion.v"
`include "s_boxes.v"
`include "p_permutation.v"

module des_roundfunction(
	input clk,				// clock
	input rst_n,			// reset, active low signal
	input start, 			// signales the block to start working, valid data is on the input lines
	input [1:32] L_in, 		// the left part for the roundfunction
	input [1:32] R_in, 		// the right part for the roundfunction
	input [1:48] Kn,		// the incomming key for iteration n
	output reg done,// signals that the output is valid for the current iteration
	output [1:32] L_out,	// the outgoing left part of the roundfunction
	output [1:32] R_out		// the outgoing right part of the roundfunction
	);

	// Nets and regs
	reg [1:0] state, next_state;        // State variables

	reg [1:32] L;	// Registers to buffer the input variables
	reg [1:32] R;

	reg [1:32] L_new;	// Registers to connect to the output
	reg [1:32] R_new;

	wire [1:48] e_out;	// Wire for the output of the expansion module
	wire [1:32] s_out;	// Wire for the output of the S box module
	wire [1:32] p_out;	// Wire for the output of the permutation module

	// Parameters
	localparam [2:0]    init = 3'd0;    // Possible states
	localparam [2:0]	roundfunction = 3'd1;
    localparam [2:0]    finished = 3'd2;

	//---------------------------FSM---------------------------------------------------------------

	always @(posedge clk or negedge rst_n) begin // State register
        if (rst_n == 1'b0) begin   // Asynchronous reset
            state <= init;
        end
        else begin
            state <= next_state;
        end
    end

    always @(*) begin   // Next state logic
        case (state)
        init: begin
            next_state <= init;
            if (start == 1'b1)
            	next_state <= roundfunction;
        end
        roundfunction: begin
            next_state <= finished;
        end
        finished: begin
            next_state <= init;
        end
        default: begin
            next_state <= init;
        end
        endcase
    end

    //---------------------------DATAPATH----------------------------------------------------------

    // Modules
	// The expansion module
	e_expansion E( 
            .data_i    (R     ),
            .data_o    (e_out));

	// The S box module
	s_boxes S(
			.data_i    (e_out ^ Kn),	// EXOR operation as an input
            .data_o    (s_out));

	// The permutation module
	p_permutation P(
			.data_i    (s_out),
            .data_o    (p_out));

    always @(*) begin // Output logic. Signals to set: done
	    done <= 1'b0;
	    case (state)
		    init: begin
		    end

		    roundfunction: begin
		    	L_new <= R;
		    	R_new <= L ^ p_out;
		    end

		    finished: begin
		        done <= 1'b1;
		    end
	    endcase
	end

	always @(posedge clk) begin // Logic for buffering the inputs into a register
        if (start == 1'b1) begin
        	L <= L_in;
        	R <= R_in;
        end
    end

	assign L_out = L_new[1:32];	// Assign the outputs to the registers with the values
	assign R_out = R_new[1:32];	


endmodule
