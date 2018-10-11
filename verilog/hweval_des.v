`timescale 1ns / 1ps

`include "des/des_pipelined.v"

module hweval_des(
    input   clk,
    input   rst_n,
    output  data_ok
);

    reg           start;
    reg  [63:0]   message;
    reg  [767:1]  round_keys;
    reg           output_valid;
    reg  [63:0]   result;
       
    // Instantiate the adder    
    des_encryption_pipelined dut (
        .clk            (clk         ),
        .rst_n          (rst_n       ),
        .start          (start       ),
        .message        (message     ),
        .round_keys     (round_keys  ),
        .output_valid   (output_valid),
        .result         (result      ));

    // Assign values to the inputs to the adder
    always @(posedge(clk))
    begin
        if (rst_n==0) begin
            start           <= 0;
            message         <= 0;
            round_keys      <= 0;
        end

        else begin
            message  <= message  ^ {64{1'b1}};
            start    <= start    ^ 1;
        end
    end
    
    assign data_ok = done & (result=={515{1'b0}});
    
endmodule