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
    reg     pause;
    reg     input_valid;
    reg [1:64] message;
    reg [1:768] round_keys;
    wire output_valid;
    wire [1:64] result;

    reg [1:64] expected;

    reg [14:0] nb_tests, nb_correct;

    integer file, r, file2, r2; 
        
    //Instantiating montgomery module
    des_encryption_pipelined des_encryption_instance( 
            .clk                (clk            ),
            .rst_n              (rst_n          ),
            .start              (start          ),
            .pause              (pause          ),
            .input_valid        (input_valid    ),
            .message            (message        ),
            .round_keys         (round_keys     ),
            .output_valid       (output_valid   ),
            .result             (result         ));

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
        
        //file = $fopen("des_tests_pipeline_input.txt", "r"); 
        //file2 = $fopen("des_tests_pipeline_expected.txt", "r");

        #`RESET_TIME

        round_keys <= 768'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

        // Init side parameters
        nb_tests <= 0;
        nb_correct <= 0;

        pause <= 0;
        input_valid <= 0;
        
        $display("Starting test...");         
        $display("");
                               
        #`CLK_PERIOD;

        start <= 1;
        #`CLK_PERIOD;
        start <= 0;

        while (!$feof(file)) 
            begin 
            // Wait until rising clock, read stimulus 
            @(posedge clk) 

                input_valid <= 1;

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

        $display("Correct tests: %d/%d", nb_correct, nb_tests);
        $display("");

        #`CLK_PERIOD;
        #`CLK_PERIOD;
  
        //r = $fcloser(file); 
        
        $finish;

    end
           
endmodule