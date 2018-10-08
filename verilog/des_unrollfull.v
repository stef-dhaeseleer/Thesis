`include "des_roundfunction.v"
`include "ip_inverse_permutation.v"
`include "ip_permutation.v"

module des_encryption_unrollfull(
	input clk,					// clock
	input rst_n,				// reset, active low signal
	input start, 				// signales the block to start working, valid data is on the input lines
	input [1:64] message, 		// the message to be encrypted
	input [1:768] round_keys,	// all roundkeys used in a series (16*48 bits)
	output reg done,			// signals that the operations are done, valid result is on the output lines
	output [1:64] result		// the resulting encrypted version of the input message
	);

	// Nets and regs
	reg [1:0] state, next_state;        // State variables

    reg [1:768] temp_key;

    reg start_roundfunction;

    wire roundfunction_done;
    wire roundfunction_done_temp1;
    wire roundfunction_done_temp2;
    wire roundfunction_done_temp3;
    wire roundfunction_done_temp4;
    wire roundfunction_done_temp5;
    wire roundfunction_done_temp6;
    wire roundfunction_done_temp7;
    wire roundfunction_done_temp8;
    wire roundfunction_done_temp9;
    wire roundfunction_done_temp10;
    wire roundfunction_done_temp11;
    wire roundfunction_done_temp12;
    wire roundfunction_done_temp13;
    wire roundfunction_done_temp14;
    wire roundfunction_done_temp15;    

    wire [1:32] L_out;
    wire [1:32] R_out;
    wire [1:32] L_temp1;
    wire [1:32] R_temp1;
    wire [1:32] L_temp2;
    wire [1:32] R_temp2;
    wire [1:32] L_temp3;
    wire [1:32] R_temp3;
    wire [1:32] L_temp4;
    wire [1:32] R_temp4;
    wire [1:32] L_temp5;
    wire [1:32] R_temp5;
    wire [1:32] L_temp6;
    wire [1:32] R_temp6;
    wire [1:32] L_temp7;
    wire [1:32] R_temp7;
    wire [1:32] L_temp8;
    wire [1:32] R_temp8;
    wire [1:32] L_temp9;
    wire [1:32] R_temp9;
    wire [1:32] L_temp10;
    wire [1:32] R_temp10;
    wire [1:32] L_temp11;
    wire [1:32] R_temp11;
    wire [1:32] L_temp12;
    wire [1:32] R_temp12;
    wire [1:32] L_temp13;
    wire [1:32] R_temp13;
    wire [1:32] L_temp14;
    wire [1:32] R_temp14;
    wire [1:32] L_temp15;
    wire [1:32] R_temp15;        

    wire [1:48] current_round_key1;
    wire [1:48] current_round_key2;	
    wire [1:48] current_round_key3;	
    wire [1:48] current_round_key4;
    wire [1:48] current_round_key5;
    wire [1:48] current_round_key6;	
    wire [1:48] current_round_key7;	
    wire [1:48] current_round_key8;
    wire [1:48] current_round_key9;
    wire [1:48] current_round_key10;	
    wire [1:48] current_round_key11;	
    wire [1:48] current_round_key12;
    wire [1:48] current_round_key13;
    wire [1:48] current_round_key14;	
    wire [1:48] current_round_key15;	
    wire [1:48] current_round_key16;    	

    wire [1:64] permuted_message;
    wire [1:64] result_wire;

	// Parameters
		// Possible states
	localparam [1:0]    init = 2'd0;   // Init will also already do the IP 
    localparam [1:0]    finished = 2'd2;	// Finished will output the inverse permuted version of the M reg

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
            if (start == 1'b1) begin
            	next_state <= finished;
            end
        end
        finished: begin
        	if (roundfunction_done == 1'b1) begin
		    	next_state <= init;
		    end
        end
        default: begin
            next_state <= init;
        end
        endcase
    end

	//---------------------------DATAPATH---------------------------------------------------------------

	// Modules
	// The roundfunction
	des_roundfunction round_func1(
			.clk    (clk ),
			.rst_n	(rst_n),
			.start  (start_roundfunction),
			.L_in   (permuted_message[1:32]),
			.R_in   (permuted_message[33:64]),
			.Kn     (current_round_key1),
			.done   (roundfunction_done_temp1),
			.L_out  (L_temp1),
            .R_out  (R_temp1));

	des_roundfunction round_func2(
			.clk    (clk ),
			.rst_n	(rst_n),
			.start  (roundfunction_done_temp1),
			.L_in   (L_temp1),
			.R_in   (R_temp1),
			.Kn     (current_round_key2),
			.done   (roundfunction_done_temp2),
			.L_out  (L_temp2),
            .R_out  (R_temp2));

	des_roundfunction round_func3(
			.clk    (clk ),
			.rst_n	(rst_n),
			.start  (roundfunction_done_temp2),
			.L_in   (L_temp2),
			.R_in   (R_temp2),
			.Kn     (current_round_key3),
			.done   (roundfunction_done_temp3),
			.L_out  (L_temp3),
            .R_out  (R_temp3));

	des_roundfunction round_func4(
			.clk    (clk ),
			.rst_n	(rst_n),
			.start  (roundfunction_done_temp3),
			.L_in   (L_temp3),
			.R_in   (R_temp3),
			.Kn     (current_round_key4),
			.done   (roundfunction_done_temp4),
			.L_out  (L_temp4),
            .R_out  (R_temp4));	

	des_roundfunction round_func5(
			.clk    (clk ),
			.rst_n	(rst_n),
			.start  (roundfunction_done_temp4),
			.L_in   (L_temp4),
			.R_in   (R_temp4),
			.Kn     (current_round_key5),
			.done   (roundfunction_done_temp5),
			.L_out  (L_temp5),
            .R_out  (R_temp5));

	des_roundfunction round_func6(
			.clk    (clk ),
			.rst_n	(rst_n),
			.start  (roundfunction_done_temp5),
			.L_in   (L_temp5),
			.R_in   (R_temp5),
			.Kn     (current_round_key6),
			.done   (roundfunction_done_temp6),
			.L_out  (L_temp6),
            .R_out  (R_temp6));

	des_roundfunction round_func7(
			.clk    (clk ),
			.rst_n	(rst_n),
			.start  (roundfunction_done_temp6),
			.L_in   (L_temp6),
			.R_in   (R_temp6),
			.Kn     (current_round_key7),
			.done   (roundfunction_done_temp7),
			.L_out  (L_temp7),
            .R_out  (R_temp7));

	des_roundfunction round_func8(
			.clk    (clk ),
			.rst_n	(rst_n),
			.start  (roundfunction_done_temp7),
			.L_in   (L_temp7),
			.R_in   (R_temp7),
			.Kn     (current_round_key8),
			.done   (roundfunction_done),
			.L_out  (L_out),
            .R_out  (R_out));		

	// The IP permutation module
	ip_permutation ip(
			.data_i    (message),
            .data_o    (permuted_message));

	// The inverse IP permutation module
	ip_inverse_permutation ip_inv(
			.data_i    ({R_out, L_out}),
            .data_o    (result_wire));

	always @(*) begin // Output logic. Signals to set: done, sync_rst, cnt_enable, start_roundfunction, load_regs
	    done <= 1'b0;
	    start_roundfunction <= 1'b0;

	    case (state)
		    init: begin
		    	start_roundfunction <= 1'b1;
		    end
		    finished: begin
		    	if (roundfunction_done == 1'b1) begin
		    	  	done <= 1'b1;
		    	end
		    end
	    endcase
	end

    assign result = result_wire;
    
    assign current_round_key1 = round_keys[1:48];
    assign current_round_key2 = round_keys[49:96];
    assign current_round_key3 = round_keys[97:144];
    assign current_round_key4 = round_keys[145:192];
    assign current_round_key5 = round_keys[193:240];
    assign current_round_key6 = round_keys[241:288];
    assign current_round_key7 = round_keys[289:336];
    assign current_round_key8 = round_keys[337:384];
    assign current_round_key9 = round_keys[385:432];
    assign current_round_key10 = round_keys[433:480];
    assign current_round_key11 = round_keys[481:528];
    assign current_round_key12 = round_keys[529:567];
    assign current_round_key13 = round_keys[568:624];
    assign current_round_key14 = round_keys[625:672];
    assign current_round_key15 = round_keys[673:720];
    assign current_round_key16 = round_keys[721:768];

endmodule