
module mask_xor(
    input [63:0] message,   // input message value
    input [63:0] mask,      // input mask value
    output result           // ouput bit
    );

    // Nets and regs
    wire [63:0] mask_result;

    wire res_1;
    wire res_2;
    wire res_3;
    wire res_4;
    wire res_5;
    wire res_6;
    wire res_7;
    wire res_8;
    wire res_9;
    wire res_10;
    wire res_11;
    wire res_12;
    wire res_13;
    wire res_14;

    // Parameters

    // Functions

    //---------------------------FSM---------------------------------------------------------------

    //---------------------------DATAPATH----------------------------------------------------------   

    assign mask_result = message & mask;    // And the message and the mask to only keep the necessary values

    assign res_1 = ^mask_result[63:58]; // First stage of 6 bit XORs of bits
    assign res_2 = ^mask_result[57:52];
    assign res_3 = ^mask_result[51:46];
    assign res_4 = ^mask_result[45:40];
    assign res_5 = ^mask_result[39:34];
    assign res_6 = ^mask_result[33:28];
    assign res_7 = ^mask_result[27:22];
    assign res_8 = ^mask_result[21:16];
    assign res_9 = ^mask_result[15:10];
    assign res_10 = ^mask_result[9:4];
    assign res_11 = ^mask_result[3:0];

    assign res_12 = res_1 ^ res_2 ^ res_3 ^ res_4 ^ res_5  ^ res_6;
    assign res_13 = res_7 ^ res_8 ^ res_9 ^ res_10 ^ res_11;

    assign res_14 = res_12 ^ res_13;

    assign result = res_14;

endmodule