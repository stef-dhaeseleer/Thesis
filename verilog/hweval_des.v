`timescale 1ns / 1ps

//`include "des/des_pipelined.v"
//`include "des/des.v"
//`include "des/des_unroll2.v"
//`include "des/des_unroll4.v"
//`include "des/des_unroll8.v"
//`include "des/des_unrollfull.v"

module hweval_des(
    input   clk,
    input   rst_n,
    output  data_ok
);

    reg           start;
    reg  [63:0]   message;
    reg  [767:0]  round_keys;
    wire          output_valid1;
    wire          output_valid2;
    wire          output_valid3;
    wire          output_valid4;
    wire          output_valid5;
    wire          output_valid6;
    wire  [63:0]   result1;
    wire  [63:0]   result2;
    wire  [63:0]   result3;
    wire  [63:0]   result4;
    wire  [63:0]   result5;
    wire  [63:0]   result6;
       
    // Instantiate the different DES units to compare them  
    des_encryption_pipelined des_pipelined (
        .clk            (clk         ),
        .rst_n          (rst_n       ),
        .start          (start       ),
        .message        (message     ),
        .round_keys     (round_keys  ),
        .output_valid   (output_valid1),
        .result         (result1     ));

    des_encryption des (
        .clk            (clk         ),
        .rst_n          (rst_n       ),
        .start          (start       ),
        .message        (message     ),
        .round_keys     (round_keys  ),
        .done           (output_valid2),
        .result         (result2     ));

    des_encryption_unroll2 des_unroll2 (
        .clk            (clk         ),
        .rst_n          (rst_n       ),
        .start          (start       ),
        .message        (message     ),
        .round_keys     (round_keys  ),
        .done           (output_valid3),
        .result         (result3     ));

    des_encryption_unroll4 des_unroll4 (
        .clk            (clk         ),
        .rst_n          (rst_n       ),
        .start          (start       ),
        .message        (message     ),
        .round_keys     (round_keys  ),
        .done           (output_valid4),
        .result         (result4     ));

    des_encryption_unroll8 des_unroll8 (
        .clk            (clk         ),
        .rst_n          (rst_n       ),
        .start          (start       ),
        .message        (message     ),
        .round_keys     (round_keys  ),
        .done           (output_valid5),
        .result         (result5     ));

    des_encryption_unrollfull des_unrollfull (
        .clk            (clk         ),
        .rst_n          (rst_n       ),
        .start          (start       ),
        .message        (message     ),
        .round_keys     (round_keys  ),
        .done           (output_valid6),
        .result         (result6     ));
    
    // Assign values to the inputs to the adder
    always @(posedge(clk))
    begin
        if (rst_n==0) begin
            start           <= 0;
            message         <= 0;
            round_keys      <= {768{1'b0}};
        end

        else begin
            message     <= message      ^ {64{1'b1}};
            start       <= start        ^ 1;
            round_keys  <= round_keys   ^ {768{1'b1}};
        end
    end
    
    assign data_ok = output_valid1 & output_valid2 & output_valid3 & output_valid4 & output_valid5 & output_valid6 & (result1=={515{1'b0}}) & (result2=={515{1'b0}}) & (result3=={515{1'b0}}) & (result4=={515{1'b0}}) & (result5=={515{1'b0}}) & (result6=={515{1'b0}});
    
endmodule