`timescale 1ns / 1ps

//`include "des/primitives/e_expansion.v"
//`include "des/primitives/s_boxes.v"
//`include "des/primitives/p_permutation.v"

module des_roundfunction(
    input clk,              // clock
    input rst_n,            // reset, active low signal
    input start,            // signals the block to start working, valid data is on the input lines
    input [1:32] L_in,      // the left part for the roundfunction
    input [1:32] R_in,      // the right part for the roundfunction
    input [1:48] Kn,        // the incomming key for iteration n
    output wire done,       // signals that the output is valid for the current iteration
    output [1:32] L_out,    // the outgoing left part of the roundfunction
    output [1:32] R_out     // the outgoing right part of the roundfunction
    );

    // Nets and regs
    wire [1:48] e_out;  // Wire for the output of the expansion module
    wire [1:32] s_out;  // Wire for the output of the S box module
    wire [1:32] p_out;  // Wire for the output of the permutation module

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
            .data_i    (e_out ^ Kn),    // EXOR operation as an input
            .data_o    (s_out     ));

    // The permutation module
    p_permutation P(
            .data_i    (s_out),
            .data_o    (p_out));

    //assign L_out = L_new[1:32];   // Assign the outputs to the registers with the values
    //assign R_out = R_new[1:32];   

    assign L_out = R_in[1:32];  // Assign the outputs to the registers with the values
    assign R_out = L_in[1:32] ^ p_out;  

    assign done = 1'b1;


endmodule
