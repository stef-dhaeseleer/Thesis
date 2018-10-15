`timescale 1ns / 1ps

//`include "des/des_pipelined.v"
//`include "des/des.v"

module hweval_des_pipelined(
    input   clk,
    input   rst_n,
    output  data_ok
);

    reg           start;
    reg  [63:0]   message;
    reg  [767:0]  round_keys;
    wire          output_valid1;
    wire  [63:0]   result1;
       
    // Instantiate the DES pipelined unit to evaluate
    des_encryption_pipelined des_pipelined (
        .clk            (clk         ),
        .rst_n          (rst_n       ),
        .start          (start       ),
        .message        (message     ),
        .round_keys     (round_keys  ),
        .output_valid   (output_valid1),
        .result         (result1     ));
    
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
    
    assign data_ok = output_valid1 & (result1=={515{1'b0}});
    
endmodule