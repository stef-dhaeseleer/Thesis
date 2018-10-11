`timescale 1ns / 1ps

`include "des/des_pipelined.v"
`include "des/des.v"
`include "des/des_unroll2.v"
`include "des/des_unroll4.v"
`include "des/des_unroll8.v"
`include "des/des_unrollfull.v"

module hweval_des(
    input   clk,
    input   rst_n,
    output  data_ok
);

    reg           start;
    reg  [63:0]   message;
    reg  [767:0]  round_keys;
    wire           output_valid;
    wire  [63:0]   result;
       
    // Instantiate the different DES units to compare them  
    des_encryption_pipelined dut (
        .clk            (clk         ),
        .rst_n          (rst_n       ),
        .start          (start       ),
        .message        (message     ),
        .round_keys     (round_keys  ),
        .output_valid   (output_valid),
        .result         (result      ));

    des_encryption dut (
        .clk            (clk         ),
        .rst_n          (rst_n       ),
        .start          (start       ),
        .message        (message     ),
        .round_keys     (round_keys  ),
        .done           (output_valid),
        .result         (result      ));

    des_encryption_unroll2 dut (
        .clk            (clk         ),
        .rst_n          (rst_n       ),
        .start          (start       ),
        .message        (message     ),
        .round_keys     (round_keys  ),
        .done           (output_valid),
        .result         (result      ));

    des_encryption_unroll4 dut (
        .clk            (clk         ),
        .rst_n          (rst_n       ),
        .start          (start       ),
        .message        (message     ),
        .round_keys     (round_keys  ),
        .done           (output_valid),
        .result         (result      ));

    des_encryption_unroll8 dut (
        .clk            (clk         ),
        .rst_n          (rst_n       ),
        .start          (start       ),
        .message        (message     ),
        .round_keys     (round_keys  ),
        .done           (output_valid),
        .result         (result      ));

    des_encryption_unrollfull dut (
        .clk            (clk         ),
        .rst_n          (rst_n       ),
        .start          (start       ),
        .message        (message     ),
        .round_keys     (round_keys  ),
        .done           (output_valid),
        .result         (result      ));
    
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
    
    assign data_ok = output_valid & (result=={515{1'b0}});
    
endmodule