`timescale 1ns / 1ps

//`include "des/primitives/e_expansion.v"
//`include "des/primitives/s_boxes.v"
//`include "des/primitives/p_permutation.v"

module des_roundfunction_pipelined_2(
    input clk,              // clock
    input rst_n,            // reset, active low signal
    input wire i_valid,     // signals that the input to this block is valid
    input enable,           // signal to see if we enable the roundfunction, stop in state when not enabled
    input restart_block,    // restart this block, set o_valid to zero
    input [1:32] L_in,      // the left part for the roundfunction
    input [1:32] R_in,      // the right part for the roundfunction
    input [1:48] Kn,        // the incomming key for this roundfunction instance
    output reg o_valid,     // signals that the output is valid for the next block to use
    output [1:32] L_out,    // the outgoing left part of the roundfunction
    output [1:32] R_out     // the outgoing right part of the roundfunction
    );

    // Nets and regs
    wire [1:48] e_out;  // Wire for the output of the expansion module
    wire [1:32] s_out;  // Wire for the output of the S box module
    wire [1:32] p_out;  // Wire for the output of the permutation module

    reg intern_valid;   // Internal valid signal between the 2 internal pipeline stages

    reg [1:48] S_in_reg;
    reg [1:32] S_out_reg;
    reg [1:32] R_1_reg;
    reg [1:32] L_1_reg;
    reg [1:32] R_2_reg;
    reg [1:32] L_2_reg;

    // Parameters

    //---------------------------FSM---------------------------------------------------------------

    //---------------------------DATAPATH----------------------------------------------------------   

    // Modules
    // The expansion module
    e_expansion E( 
            .data_i    (R_in ),
            .data_o    (e_out));

    // The S box module
    s_boxes S(
            .data_i    (S_in_reg),    // EXOR operation as an input
            .data_o    (s_out   ));

    // The permutation module
    p_permutation P(
            .data_i    (S_out_reg),
            .data_o    (p_out    ));

    // Logic for setting o_valid when intern_valid is true
    always @(posedge clk) begin // Signals to set: o_valid

        if (restart_block == 1'b1) begin
            o_valid <= 1'b0;
        end
        
        else if (enable == 1'b1) begin
            o_valid <= 1'b0;

            if (rst_n == 1'b0) begin
                o_valid <= 1'b0;
            end

            else if (intern_valid == 1'b1) begin
                o_valid <= 1'b1;
            end
        end
    end

     // Logic for setting intern_valid when i_valid is true
    always @(posedge clk) begin // Signals to set: intern_valid

        if (restart_block == 1'b1) begin
            intern_valid <= 1'b0;
        end
        
        else if (enable == 1'b1) begin
            intern_valid <= 1'b0;

            if (rst_n == 1'b0) begin
                intern_valid <= 1'b0;
            end

            else if (i_valid == 1'b1) begin
                intern_valid <= 1'b1;
            end
        end
    end
    
    // Logic for loading the pipeline registers
    always @(posedge clk) begin
        if (enable == 1'b1) begin
            if (i_valid == 1'b1) begin
                S_in_reg <= e_out ^ Kn;
                R_1_reg <= R_in;
                L_1_reg <= L_in;
            end

            if (intern_valid == 1'b1) begin
                S_out_reg <= s_out;
                R_2_reg <= R_1_reg;
                L_2_reg <= L_1_reg;
            end
        end
    end

    assign L_out = R_2_reg[1:32];  // Assign the outputs to the registers with the values
    assign R_out = L_2_reg[1:32] ^ p_out;
     

endmodule
