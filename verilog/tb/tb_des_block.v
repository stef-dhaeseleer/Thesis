`timescale 1ns / 1ps
`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5
`define EOF 32'hFFFF_FFFF 
`define NULL 0 

`include "des/des_block.v"

// iverilog tb/tb_des_block.v
// vvp a.out
// open -a gtkwave tb/vcd/tb_des_block.vcd

module tb_des_block();
    
    reg             clk;
    reg             rst_n;
    reg             start;
    reg             restart_block;
    reg             test_enabled;
    reg             test_advance;
    reg     [15:0]  region;
    wire    [47:0]  counter;
    wire    [63:0]  ciphertext_out;
    wire            valid;
        
    //Instantiating lfsr module
    des_block des_block(
        .clk            (clk   ),
        .rst_n          (rst_n ),
        .start          (start ),
        .restart_block    (restart_block),
        .test_enabled   (test_enabled),
        .test_advance   (test_advance),
        .region_select  (region),
        .counter        (counter),
        .ciphertext_out (ciphertext_out),
        .done           (done));

    //Generate a clock
    initial begin
        clk = 0;
        forever #`CLK_HALF clk = ~clk;
    end
    
    //Reset
    initial begin
        rst_n = 0;
        #`RESET_TIME rst_n = 1;
    end
    
    //Test data
    initial begin

        $dumpfile("tb/vcd/tb_des_block.vcd");
        $dumpvars(0, tb_des_block);
        
        #`RESET_TIME

        region <= 16'b0000000000000100;

        restart_block <= 0;
        test_enabled <= 0;
        test_advance <= 0;
        
        $display("Starting test...");         
        $display("");
                               
        #`CLK_PERIOD;
        
        start <= 1;
        test_enabled <= 1;
        #`CLK_PERIOD;
        start <= 0;    
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;

        test_advance <= 1;
        #`CLK_PERIOD;
        test_advance <= 0;

        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;

        test_enabled <= 0;

        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;

        restart_block <= 1;
        #`CLK_PERIOD;
        restart_block <= 0;

        #`CLK_PERIOD;

        start <= 1;
        #`CLK_PERIOD;
        start <= 0; 

        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
          
        $finish;

    end
           
endmodule