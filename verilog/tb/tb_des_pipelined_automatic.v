`timescale 1ns / 1ps
`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5
`define EOF 32'hFFFF_FFFF 
`define NULL 0 

`include "des/des_pipelined.v"

// iverilog tb/tb_des_pipelined_automatic.v
// vvp a.out
// open -a gtkwave tb/vcd/tb_des_pipelined.vcd

module tb_des_pipelined();
    
    reg     clk;
    reg     rst_n;
    reg     start;
    reg [1:64] message;
    reg [1:768] round_keys;
    wire output_valid;
    wire [1:64] result;

    reg [1:64] expected;

    reg [14:0] nb_tests, nb_correct;

    integer file, r, file2, r2; 
        
    //Instantiating montgomery module
    des_encryption_pipelined des_encryption_instance( 
            .clk        (clk       ),
            .rst_n      (rst_n     ),
            .start      (start     ),
            .message    (message   ),
            .round_keys (round_keys),
            .output_valid       (output_valid      ),
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

        $dumpfile("tb/vcd/tb_des_pipelined.vcd");
        $dumpvars(0, tb_des_pipelined);

        file = $fopenr("../python/testfiles/des_tests_pipeline_input.txt"); 
        file2 = $fopenr("../python/testfiles/des_tests_pipeline_expected.txt"); 


        #`RESET_TIME

        round_keys <= 768'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

        // Init side parameters
        nb_tests <= 0;
        nb_correct <= 0;
                               
        #`CLK_PERIOD;

        // TODO: Finish this automatic test (1)
        // The idea is to read the input messages (key stays fixed), fill the pipeline
        // Then start writing the output to a new file and compare this to the expected file!
        // Files are buffered at start and end, so just subtract these false tests from the total amount of tests!

        while (!$feof(file)) 
            begin 
            // Wait until rising clock, read stimulus 
            @(posedge clk) 
                start <= 1;

                r = $fscanf(file, "%b\n", message); 
                r2 = $fscanf(file2, "%b\n", expected); 

                nb_tests <= nb_tests + 1;
                if (result == expected) begin
                    nb_correct <= nb_correct + 1;
                end

                #`CLK_PERIOD;   // need this to check the result at the end of the output_valid cycle and not at the start!
                     
        end // while not EOF 

        nb_tests <= nb_tests - 19;  // To counter the offset of false measurments when filling the pipeline
        #`CLK_PERIOD;

        $display("");
        $display("Correct tests: %d/%d", nb_correct, nb_tests);

        #`CLK_PERIOD;
        #`CLK_PERIOD;
  
        //r = $fcloser(file); 
        
        $finish;

    end
           
endmodule