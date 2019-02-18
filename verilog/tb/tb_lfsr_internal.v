`timescale 1ns / 1ps
`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5
`define EOF 32'hFFFF_FFFF 
`define NULL 0 

`include "des/primitives/lfsr.v"
`include "des/primitives/lfsr_param.v"
`include "des/primitives/lfsr_internal.v"

// iverilog tb/tb_lfsr_internal.v
// vvp a.out
// open -a gtkwave tb/vcd/tb_lfsr_internal.vcd

module tb_lfsr_internal();
    
    reg             clk;
    reg             rst_n;
    reg             start;
    reg             pause;
    reg             reset_counter;
    reg     [N-1:0] seed;
    reg     [N-1:0] polynomial;

    wire    [N-1:0] result;
    wire            valid;

    reg     [18:0]  nb_tests, nb_correct;
    reg     [33:0]  i;

    //integer file, r; 

    parameter N = 32;
        
    //Instantiating lfsr module
    lfsr_internal lfsr_internal(
        .clk            (clk),
        .rst_n          (rst_n),
        .start          (start),
        .pause          (pause),
        .reset_counter  (reset_counter),
        .polynomial     (polynomial),
        .message_seed   (seed),
        .lfsr           (result),
        .valid          (valid),
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

        $dumpfile("tb/vcd/tb_lfsr_internal.vcd");
        $dumpvars(0, tb_lfsr_internal);

        #`RESET_TIME

        seed <= 32'h1;
        polynomial <= 32'b10100011000000000000000000000000;

        // Init side parameters
        nb_tests <= 0;
        nb_correct <= 0;
        
        $display("Starting test...");         
        $display("");

        // All unique up untill 2^10 first values. 
        for (i = 0; i < {10{1'b1}}; i=i+1) begin
                                   
            #`CLK_PERIOD;

            start <= 1;

            #`CLK_PERIOD;

            wait (valid == 1'b1);

            #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

            nb_tests <= nb_tests + 1;
            nb_correct <= nb_correct + 1;

            $display("Result internal LFSR   : %d", result);

            #`CLK_PERIOD;

        end

        #`CLK_PERIOD;
  
        //r = $fcloser(file); 
        
        $finish;

    end
           
endmodule