`timescale 1ns / 1ps

module ip_inverse_permutation(
    input wire [1:64] data_i,           // input data for the permutation
    output reg [1:64] data_o            // output data for the permutation
    );
    
    always @(*) begin
        // Logic for the permutation
        data_o[1] <= data_i[40];
        data_o[2] <= data_i[8];
        data_o[3] <= data_i[48];
        data_o[4] <= data_i[16];
        data_o[5] <= data_i[56];
        data_o[6] <= data_i[24];
        data_o[7] <= data_i[64];
        data_o[8] <= data_i[32];

        data_o[9] <= data_i[39];
        data_o[10] <= data_i[7];
        data_o[11] <= data_i[47];
        data_o[12] <= data_i[15];
        data_o[13] <= data_i[55];
        data_o[14] <= data_i[23];
        data_o[15] <= data_i[63];
        data_o[16] <= data_i[31];

        data_o[17] <= data_i[38];
        data_o[18] <= data_i[6];
        data_o[19] <= data_i[46];
        data_o[20] <= data_i[14];
        data_o[21] <= data_i[54];
        data_o[22] <= data_i[22];
        data_o[23] <= data_i[62];
        data_o[24] <= data_i[30];

        data_o[25] <= data_i[37];
        data_o[26] <= data_i[5];
        data_o[27] <= data_i[45];
        data_o[28] <= data_i[13];
        data_o[29] <= data_i[53];
        data_o[30] <= data_i[21];
        data_o[31] <= data_i[61];
        data_o[32] <= data_i[29];

        data_o[33] <= data_i[36];
        data_o[34] <= data_i[4];
        data_o[35] <= data_i[44];
        data_o[36] <= data_i[12];
        data_o[37] <= data_i[52];
        data_o[38] <= data_i[20];
        data_o[39] <= data_i[60];
        data_o[40] <= data_i[28];

        data_o[41] <= data_i[35];
        data_o[42] <= data_i[3];
        data_o[43] <= data_i[43];
        data_o[44] <= data_i[11];
        data_o[45] <= data_i[51];
        data_o[46] <= data_i[19];
        data_o[47] <= data_i[59];
        data_o[48] <= data_i[27];

        data_o[49] <= data_i[34];
        data_o[50] <= data_i[2];
        data_o[51] <= data_i[42];
        data_o[52] <= data_i[10];
        data_o[53] <= data_i[50];
        data_o[54] <= data_i[18];
        data_o[55] <= data_i[58];
        data_o[56] <= data_i[26];

        data_o[57] <= data_i[33];
        data_o[58] <= data_i[1];
        data_o[59] <= data_i[41];
        data_o[60] <= data_i[9];
        data_o[61] <= data_i[49];
        data_o[62] <= data_i[17];
        data_o[63] <= data_i[57];
        data_o[64] <= data_i[25];
    end

endmodule