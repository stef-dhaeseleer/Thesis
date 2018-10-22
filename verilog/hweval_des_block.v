`timescale 1ns / 1ps

//`include "des/des_pipelined.v"
//`include "des/des.v"
//`include "des/des_unroll2.v"
//`include "des/des_unroll4.v"
//`include "des/des_unroll8.v"
//`include "des/des_unrollfull.v"

module hweval_des_block(
    input   clk,
    input   rst_n,
    output  data_ok
);

    reg             start;
    reg  [15:0]     region_select;
    wire [9:0]      counter;
    wire            output_valid;
       
    // Instantiate the different DES units to compare them  
    des_block des_block (
        .clk            (clk          ),
        .rst_n          (rst_n        ),
        .start          (start        ),
        .region_select  (region_select),                                  
        .counter        (counter      ),
        .valid          (output_valid ));

    // Assign values to the inputs to the adder
    always @(posedge(clk)) begin
        if (rst_n==0) begin
            start           <= 1'b1;
            message_seed    <= {64{1'b0}};
        end

        else begin
            message_seed    <= message_seed ^ {64{1'b1}};
            start           <= start        ^ 1'b1;
        end
    end
    
    assign data_ok = output_valid & (counter=={10{1'b0}});
    
endmodule