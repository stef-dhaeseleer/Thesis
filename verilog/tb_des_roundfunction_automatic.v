`timescale 1ns / 1ps
`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5
`define EOF 32'hFFFF_FFFF 
`define NULL 0 

`include "des_roundfunction.v"

// iverilog -o des_roundfunction.vvp tb_des_roundfunction_automatic.v
// vvp des_roundfunction.vvp
// open -a gtkwave tb_des_roundfunction.vcd

module tb_des_roundfunction();
    
    reg     clk;
    reg     rst_n;
    reg     start;
    reg     [1:32] L_in;
    reg     [1:32] R_in;
    reg     [1:48] Kn;
    wire    done;
    wire    [1:32] L_out;
    wire    [1:32] R_out;

    reg    [1:32] L_expected;
    reg    [1:32] R_expected;

    reg [14:0] nb_tests, nb_correct;

    integer file, r; 
        
    //Instantiating montgomery module
    des_roundfunction des_roundfunction_instance( 
            .clk    (clk  ),
            .rst_n  (rst_n),
            .start  (start),
            .L_in   (L_in ),
            .R_in   (R_in ),
            .Kn     (Kn   ),
            .done   (done ),
            .L_out  (L_out),
            .R_out  (R_out));

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

        $dumpfile("tb_des_roundfunction.vcd");
        $dumpvars(0, tb_des_roundfunction);

        file = $fopenr("../python/testfiles/roundfunction_tests.txt"); 

        #`RESET_TIME

        // Init side parameters
        nb_tests <= 15'd0;
        nb_correct <= 15'd0;
                               
        #`CLK_PERIOD;

        while (!$feof(file)) 
            begin 
            // Wait until rising clock, read stimulus 
            @(posedge clk) 
                r = $fscanf(file, "%b %b %b %b %b\n", Kn, L_in, R_in, L_expected, R_expected); 

                start<=1;
                #`CLK_PERIOD;
                start<=0;
                
                wait (done==1);

                nb_tests <= nb_tests + 2;
                nb_correct <= nb_correct + (L_expected - L_out == 32'b00000000000000000000000000000000) + (R_expected - R_out == 32'b00000000000000000000000000000000);
                     
            end // while not EOF 

        $display("");
        $display("Correct tests: %d/%d", nb_correct, nb_tests);

        #`CLK_PERIOD;
        #`CLK_PERIOD;
  
        //r = $fcloser(file); 
        
        $finish;

    end
           
endmodule