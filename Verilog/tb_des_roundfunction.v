`timescale 1ns / 1ps
`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5

`include "des_roundfunction.v"

// iverilog -o des_roundfunction.vvp tb_des_roundfunction.v
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
        
    //Instantiating montgomery module
    des_roundfunction des_roundfunction_instance( 
            .clk    (clk    ),
            .rst_n  (rst_n ),
            .start  (start  ),
            .L_in   (L_in   ),
            .R_in   (R_in   ),
            .Kn     (Kn   ),
            .done   (done   ),
            .L_out  (L_out ),
            .R_out  (R_out   ));

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

        #`RESET_TIME
        
        // Input the test data
        L_in    <= 32'b10000000000000000000000000000000;
        R_in    <= 32'b1;
        Kn      <= 32'b11111111111111111111111111111111;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);
        
        $display("L_out =%b", L_out);
        $display("R_out =%b", R_out);
        $display("");
                
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        
        $finish;

    end
           
endmodule