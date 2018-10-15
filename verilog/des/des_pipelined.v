//`include "des/des_roundfunction_pipelined.v"
//`include "des/primitives/ip_inverse_permutation.v"
//`include "des/primitives/ip_permutation.v"

module des_encryption_pipelined(
    input clk,                      // clock
    input rst_n,                    // reset, active low signal
    input start,                    // signals the block to start working, valid data is on the input lines
    input [1:64] message,           // the message to be encrypted
    input [1:768] round_keys,       // all roundkeys used in a series (16*48 bits)
    output reg output_valid,   // signals that the operations are done, valid result is on the output lines
    output [1:64] result            // the resulting encrypted version of the input message
    );

    // Nets and regs
    reg output_valid_stage_0;   // This one has to be a reg at this level in the hierarchy
    wire output_valid_stage_1;  // The rest are wires here to connect the valid registers in the rounfunction submodules
    wire output_valid_stage_2;
    wire output_valid_stage_3;
    wire output_valid_stage_4;
    wire output_valid_stage_5;
    wire output_valid_stage_6;
    wire output_valid_stage_7;
    wire output_valid_stage_8;
    wire output_valid_stage_9;
    wire output_valid_stage_10;
    wire output_valid_stage_11;
    wire output_valid_stage_12;
    wire output_valid_stage_13;
    wire output_valid_stage_14;
    wire output_valid_stage_15;    
    wire output_valid_stage_16;

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

    reg [1:64] permuted_message_reg;
    reg [1:64] result_reg;

    // Parameters

    //---------------------------FSM---------------------------------------------------------------

    //---------------------------DATAPATH---------------------------------------------------------------

    // Modules
    // The roundfunction
    des_roundfunction_pipelined round_func1(
            .clk        (clk ),
            .rst_n      (rst_n),
            .i_valid    (output_valid_stage_0),
            .L_in       (permuted_message_reg[1:32]),
            .R_in       (permuted_message_reg[33:64]),
            .Kn         (current_round_key1),
            .o_valid    (output_valid_stage_1),
            .L_out      (L_temp1),
            .R_out      (R_temp1));

    des_roundfunction_pipelined round_func2(
            .clk        (clk ),
            .rst_n      (rst_n),
            .i_valid    (output_valid_stage_1),
            .L_in       (L_temp1),
            .R_in       (R_temp1),
            .Kn         (current_round_key2),
            .o_valid    (output_valid_stage_2),
            .L_out      (L_temp2),
            .R_out      (R_temp2));

    des_roundfunction_pipelined round_func3(
            .clk        (clk ),
            .rst_n      (rst_n),
            .i_valid    (output_valid_stage_2),
            .L_in       (L_temp2),
            .R_in       (R_temp2),
            .Kn         (current_round_key3),
            .o_valid    (output_valid_stage_3),
            .L_out      (L_temp3),
            .R_out      (R_temp3));

    des_roundfunction_pipelined round_func4(
            .clk        (clk ),
            .rst_n      (rst_n),
            .i_valid    (output_valid_stage_3),
            .L_in       (L_temp3),
            .R_in       (R_temp3),
            .Kn         (current_round_key4),
            .o_valid    (output_valid_stage_4),
            .L_out      (L_temp4),
            .R_out      (R_temp4)); 

    des_roundfunction_pipelined round_func5(
            .clk        (clk ),
            .rst_n      (rst_n),
            .i_valid    (output_valid_stage_4),
            .L_in       (L_temp4),
            .R_in       (R_temp4),
            .Kn         (current_round_key5),
            .o_valid    (output_valid_stage_5),
            .L_out      (L_temp5),
            .R_out      (R_temp5));

    des_roundfunction_pipelined round_func6(
            .clk        (clk ),
            .rst_n      (rst_n),
            .i_valid    (output_valid_stage_5),
            .L_in       (L_temp5),
            .R_in       (R_temp5),
            .Kn         (current_round_key6),
            .o_valid    (output_valid_stage_6),
            .L_out      (L_temp6),
            .R_out      (R_temp6));

    des_roundfunction_pipelined round_func7(
            .clk        (clk ),
            .rst_n      (rst_n),
            .i_valid    (output_valid_stage_6),
            .L_in       (L_temp6),
            .R_in       (R_temp6),
            .Kn         (current_round_key7),
            .o_valid    (output_valid_stage_7),
            .L_out      (L_temp7),
            .R_out      (R_temp7));

    des_roundfunction_pipelined round_func8(
            .clk        (clk ),
            .rst_n      (rst_n),
            .i_valid    (output_valid_stage_7),
            .L_in       (L_temp7),
            .R_in       (R_temp7),
            .Kn         (current_round_key8),
            .o_valid    (output_valid_stage_8),
            .L_out      (L_temp8),
            .R_out      (R_temp8));     

    des_roundfunction_pipelined round_func9(
            .clk        (clk ),
            .rst_n      (rst_n),
            .i_valid    (output_valid_stage_8),
            .L_in       (L_temp8),
            .R_in       (R_temp8),
            .Kn         (current_round_key9),
            .o_valid    (output_valid_stage_9),
            .L_out      (L_temp9),
            .R_out      (R_temp9));

    des_roundfunction_pipelined round_func10(
            .clk        (clk ),
            .rst_n      (rst_n),
            .i_valid    (output_valid_stage_9),
            .L_in       (L_temp9),
            .R_in       (R_temp9),
            .Kn         (current_round_key10),
            .o_valid    (output_valid_stage_10),
            .L_out      (L_temp10),
            .R_out      (R_temp10));

    des_roundfunction_pipelined round_func11(
            .clk        (clk ),
            .rst_n      (rst_n),
            .i_valid    (output_valid_stage_10),
            .L_in       (L_temp10),
            .R_in       (R_temp10),
            .Kn         (current_round_key11),
            .o_valid    (output_valid_stage_11),
            .L_out      (L_temp11),
            .R_out      (R_temp11));

    des_roundfunction_pipelined round_func12(
            .clk        (clk ),
            .rst_n      (rst_n),
            .i_valid    (output_valid_stage_11),
            .L_in       (L_temp11),
            .R_in       (R_temp11),
            .Kn         (current_round_key12),
            .o_valid    (output_valid_stage_12),
            .L_out      (L_temp12),
            .R_out      (R_temp12)); 

    des_roundfunction_pipelined round_func13(
            .clk        (clk ),
            .rst_n      (rst_n),
            .i_valid    (output_valid_stage_12),
            .L_in       (L_temp12),
            .R_in       (R_temp12),
            .Kn         (current_round_key13),
            .o_valid    (output_valid_stage_13),
            .L_out      (L_temp13),
            .R_out      (R_temp13));

    des_roundfunction_pipelined round_func14(
            .clk        (clk ),
            .rst_n      (rst_n),
            .i_valid    (output_valid_stage_13),
            .L_in       (L_temp13),
            .R_in       (R_temp13),
            .Kn         (current_round_key14),
            .o_valid    (output_valid_stage_14),
            .L_out      (L_temp14),
            .R_out      (R_temp14));

    des_roundfunction_pipelined round_func15(
            .clk        (clk ),
            .rst_n      (rst_n),
            .i_valid    (output_valid_stage_14),
            .L_in       (L_temp14),
            .R_in       (R_temp14),
            .Kn         (current_round_key15),
            .o_valid    (output_valid_stage_15),
            .L_out      (L_temp15),
            .R_out      (R_temp15));

    des_roundfunction_pipelined round_func16(
            .clk        (clk ),
            .rst_n      (rst_n),
            .i_valid    (output_valid_stage_15),
            .L_in       (L_temp15),
            .R_in       (R_temp15),
            .Kn         (current_round_key16),
            .o_valid    (output_valid_stage_16),
            .L_out      (L_out),
            .R_out      (R_out));       

    // The IP permutation module
    ip_permutation ip(
            .data_i    (message),
            .data_o    (permuted_message));

    // The inverse IP permutation module
    ip_inverse_permutation ip_inv(
            .data_i    ({R_out, L_out}),
            .data_o    (result_wire));

    always @(posedge clk) begin

    end

    always @(posedge clk) begin     // For setting output_valid_stage_0 when start is enabled
        output_valid_stage_0 <= 1'b0;

        if (rst_n == 1'b0) begin
            output_valid_stage_0 <= 1'b0;
        end

        else if (start == 1'b1) begin
            output_valid_stage_0 <= 1'b1;
        end
    end

    always @(posedge clk) begin     // For setting output_validwhen output_valid_stage_16 is enabled  
        output_valid <= 1'b0; 

        if (rst_n == 1'b0) begin
            output_valid <= 1'b0;
        end

        else if (output_valid_stage_16 == 1'b1) begin
            output_valid <= 1'b1;
        end
    end
    
    always @(posedge clk) begin     // Loading the data from the pipeline stages into the register
        permuted_message_reg <= permuted_message;
        result_reg <= result_wire;
    end    

    assign result = result_reg;
    
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
    assign current_round_key12 = round_keys[529:576];
    assign current_round_key13 = round_keys[577:624];
    assign current_round_key14 = round_keys[625:672];
    assign current_round_key15 = round_keys[673:720];
    assign current_round_key16 = round_keys[721:768];

endmodule