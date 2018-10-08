`timescale 1ns / 1ps
`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5
`define EOF 32'hFFFF_FFFF 
`define NULL 0 

`include "des/des_unroll2.v"

// iverilog tb_des_unroll2_automatic.v
// vvp a.out
// open -a gtkwave vcd/tb_des_unroll2.vcd

module tb_des_unroll2();
    
    reg     clk;
    reg     rst_n;
    reg     start;
    reg [1:64] message;
    reg [1:768] round_keys;
    wire done;
    wire [1:64] result;

    reg [1:64] expected;

    reg [14:0] nb_tests, nb_correct;

    integer file, r; 
        
    //Instantiating montgomery module
    des_encryption_unroll2 des_encryption_instance( 
            .clk        (clk       ),
            .rst_n      (rst_n     ),
            .start      (start     ),
            .message    (message   ),
            .round_keys (round_keys),
            .done       (done      ),
            .result     (result    ));

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

        $dumpfile("vcd/tb_des_unroll2.vcd");
        $dumpvars(0, tb_des_unroll2);

        file = $fopenr("../python/testfiles/des_tests.txt"); 

        #`RESET_TIME

        // Init side parameters
        nb_tests <= 15'd0;
        nb_correct <= 15'd0;
                               
        #`CLK_PERIOD;

        while (!$feof(file)) 
            begin 
            // Wait until rising clock, read stimulus 
            @(posedge clk) 
                r = $fscanf(file, "%b %b %b\n", round_keys, message, expected); 

                start<=1;
                #`CLK_PERIOD;
                start<=0;
                
                wait (done==1);

                #`CLK_PERIOD;   // need this to check the result at the end of the done cycle and not at the start!

                nb_tests <= nb_tests + 1;
                nb_correct <= nb_correct + (expected - result == 64'h0);
                     
            end // while not EOF 

        $display("");
        $display("Correct tests: %d/%d", nb_correct, nb_tests);

        #`CLK_PERIOD;
        #`CLK_PERIOD;
  
        //r = $fcloser(file); 
        
        $finish;

    end
           
endmodule