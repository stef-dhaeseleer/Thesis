`timescale 1ns / 1ps
`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5
`define EOF 32'hFFFF_FFFF 
`define NULL 0 

// iverilog tb/tb_des_block.v
// vvp a.out
// open -a gtkwave tb/vcd/tb_des_block.vcd

module tb_des_block();
    
    reg             clk;
    reg             rst_n;
    reg             start;
    reg             restart_block;
    reg     [63:0]  seed;
    reg     [63:0]  polynomial;
    reg     [63:0]  mask_i;
    reg     [63:0]  mask_o;
    reg     [63:0]  counter_limit;
    reg     [767:0]  round_keys;
    wire    [63:0]  counter;
    wire            valid;
        
    //Instantiating des module
    des_block des_block(
        .clk            (clk   ),
        .rst_n          (rst_n ),
        .start          (start ),
        .restart_block  (restart_block),
        .seed           (seed),
        .polynomial     (polynomial),
        .mask_i         (mask_i),
        .mask_o         (mask_o),
        .counter_limit  (counter_limit),
        .round_keys      (round_keys),
        .counter        (counter),
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

        seed            <= 64'h1;
        polynomial      <= 64'h800000000000000d;
        mask_i          <= 64'h2104008000000000;
        mask_o          <= 64'h0000000021040080;
        //mask_i          <= 64'h1;
        //mask_o          <= 64'h1;
        counter_limit   <= 64'h1000;
        round_keys       <= 768'h0;

        restart_block <= 0;
        
        $display("Starting test...");         
        $display("");
                               
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
          
        $finish;

    end
           
endmodule