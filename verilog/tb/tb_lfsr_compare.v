`timescale 1ns / 1ps
`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5
`define EOF 32'hFFFF_FFFF 
`define NULL 0 

`include "des/primitives/lfsr.v"
`include "des/primitives/lfsr_param.v"
`include "des/primitives/lfsr_internal.v"

// iverilog tb/tb_lfsr_compare.v
// vvp a.out
// open -a gtkwave tb/vcd/tb_lfsr_compare.vcd

module tb_lfsr_compare();
    
    reg             clk;
    reg             rst_n;
    reg             start;
    reg             pause;
    reg             reset_counter;
    reg     [N-1:0]  seed;
    reg     [N-1:0]  polynomial;

    wire    [N-1:0]  result_normie;
    wire    [N-1:0]  result_param;
    wire            valid;

    reg     [18:0]  nb_tests, nb_correct;

    //integer file, r; 

    parameter N = 32;
        
    //Instantiating lfsr module
    lfsr lfsr_normie(
        .clk            (clk),
        .rst_n          (rst_n),
        .start          (start),
        .pause          (pause),
        .reset_counter  (reset_counter),
        .message_seed   (seed),
        .lfsr           (result_normie),
        .valid          (valid),
        .done           (done));

    lfsr_param lfsr_param(
        .clk            (clk),
        .rst_n          (rst_n),
        .start          (start),
        .pause          (pause),
        .reset_counter  (reset_counter),
        .polynomial     (polynomial),
        .message_seed   (seed),
        .lfsr           (result_param),
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

        $dumpfile("tb/vcd/tb_lfsr_compare.vcd");
        $dumpvars(0, tb_lfsr_compare);

        #`RESET_TIME

        seed <= 32'h1;
        polynomial <= 32'b10100011000000000000000000000000; // Should be the same polynomial as the non-parameter LFSR

        // Init side parameters
        nb_tests <= 0;
        nb_correct <= 0;
        
        $display("Starting test...");         
        $display("");
                               
        #`CLK_PERIOD;

        start <= 1;

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        wait (valid == 1'b1);

        #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!

        nb_tests <= nb_tests + 1;
        if (result_normie == result_param) begin
            nb_correct <= nb_correct + 1;
        end

        $display("Result normal LFSR   : %d", result_normie);
        $display("Result parameter LFSR: %d", result_param);
                     
        #`CLK_PERIOD;

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;

        #`CLK_PERIOD;
  
        //r = $fcloser(file); 
        
        $finish;

    end
           
endmodule