`timescale 1ns / 1ps
`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5
`define EOF 32'hFFFF_FFFF 
`define NULL 0 

`include "des/primitives/lfsr.v"

// iverilog tb/tb_lfsr_automatic.v
// vvp a.out
// open -a gtkwave tb/vcd/tb_lfsr.vcd

module tb_lfsr();
    
    reg             clk;
    reg             rst_n;
    reg             start;
    reg     [63:0]  seed;
    wire    [63:0]  result;
    wire            valid;

    reg     [63:0]  expected;

    reg     [18:0]  nb_tests, nb_correct;

    integer file, r; 
        
    //Instantiating lfsr module
    lfsr lfsr(
        .clk            (clk),
        .rst_n          (rst_n),
        .start          (start),
        .message_seed   (seed),
        .lfsr           (result),
        .valid          (valid));

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

        $dumpfile("tb/vcd/tb_lfsr.vcd");
        $dumpvars(0, tb_lfsr);

        file = $fopenr("../python/testfiles/lfsr_tests.txt"); 
        
        //file = $fopen("lfsr_tests.txt", "r"); 

        #`RESET_TIME

        seed <= 64'b1001000010000100000000000000000010000000100000000000000000000000;

        // Init side parameters
        nb_tests <= 0;
        nb_correct <= 0;
        
        $display("Starting test...");         
        $display("");
                               
        #`CLK_PERIOD;

        while (!$feof(file)) 
            begin 
            // Wait until rising clock, read stimulus 
            @(posedge clk) 
                start <= 1;

                r = $fscanf(file, "%b\n", expected); 

                wait (valid == 1'b1);

                #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

                nb_tests <= nb_tests + 1;
                if (result == expected) begin
                    nb_correct <= nb_correct + 1;
                end
                     
        end // while not EOF 

        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;
        #`CLK_PERIOD;
  
        //r = $fcloser(file); 
        
        $finish;

    end
           
endmodule