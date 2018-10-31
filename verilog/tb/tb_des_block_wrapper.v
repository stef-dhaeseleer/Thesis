`timescale 1ns / 1ps
`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5
`define EOF 32'hFFFF_FFFF 
`define NULL 0 

// iverilog tb/tb_des_block.v
// vvp a.out
// open -a gtkwave tb/vcd/tb_des_block.vcd

module tb_des_block_wrapper();
    
    reg             clk;
    reg             rst_n;
    reg     [31:0]  cmd;
    reg             cmd_valid;
    reg             advance_test_cmd;
    reg     [31:0]  region;
    wire             cmd_read;
    wire             test_res_ready;
    wire    [63:0]  counter;
    wire    [63:0]  ciphertext;
    wire            done;
        
    //Instantiating lfsr module
    des_block_wrapper des_block_wrapper(
        .clk            (clk   ),
        .rst_n          (rst_n ),
        .cmd            (cmd),
        .cmd_valid          (cmd_valid ),
        .advance_test_cmd    (advance_test_cmd),
        .region         (region),
        //////////////
        .cmd_read   (cmd_read),
        .test_res_ready   (test_res_ready),
        .done           (done),
        .counter        (counter),
        .ciphertext (ciphertext));

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
        
        #`RESET_TIME
        
        cmd <= 32'h0;
        cmd_valid <= 32'h0;
        advance_test_cmd <= 32'h0;
        region <= 32'h0;
        
        $display("Starting test...");         
        $display("");
                               
        #`CLK_PERIOD;
        
        cmd <= 32'h0;
        cmd_valid <= 32'h1;
        
        wait(cmd_read == 1'b1);
        #`CLK_PERIOD;
        cmd_valid <= 32'h0;
        #`CLK_PERIOD;
        
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        
        cmd <= 32'h2;
        cmd_valid <= 32'h1;
        
        wait(cmd_read == 1'b1);
        #`CLK_PERIOD;
        cmd_valid <= 32'h0;
        #`CLK_PERIOD;
        
        wait(test_res_ready == 1'b1)
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        
        advance_test_cmd <= 32'h1;
        #`CLK_PERIOD;
        advance_test_cmd <= 32'h0;
        
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