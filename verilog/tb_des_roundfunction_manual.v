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

    reg    [1:32] L_next;
    reg    [1:32] R_next;
    reg    [1:32] L_expected;
    reg    [1:32] R_expected;

    reg [7:0] nb_tests, nb_correct;
        
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

        // Init side parameters
        nb_tests <= 8'd0;
        nb_correct <= 8'd0;

        // Input the test data ROUND 0
        L_in    <= 32'b01011010011100110001110101111101;
        R_in    <= 32'b01011111001011100101001000000000;
        Kn      <= 32'b0;

        L_expected <= 32'b01011111001011100101001000000000;
        R_expected <= 32'b00000111010010100110011011000101;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);

        L_next <= L_out;
        R_next <= R_out;
        
        $display("L_out =%b", L_out);
        $display("error =%b", L_expected - L_out);
        $display("R_out =%b", R_out);
        $display("error =%b", R_expected - R_out);
        $display("");

        nb_tests <= nb_tests + 2;
        nb_correct <= nb_correct + (L_expected - L_out == 32'b00000000000000000000000000000000) + (R_expected - R_out == 32'b00000000000000000000000000000000);
                
        #`CLK_PERIOD;

        // Input the test data ROUND 1
        L_in    <= L_next;
        R_in    <= R_next;
        Kn      <= 32'b0;

        L_expected <= 32'b00000111010010100110011011000101;
        R_expected <= 32'b01100100001111011111101011110100;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);

        L_next <= L_out;
        R_next <= R_out;
        
        $display("L_out =%b", L_out);
        $display("error =%b", L_expected - L_out);
        $display("R_out =%b", R_out);
        $display("error =%b", R_expected - R_out);
        $display("");

        nb_tests <= nb_tests + 2;
        nb_correct <= nb_correct + (L_expected - L_out == 32'b00000000000000000000000000000000) + (R_expected - R_out == 32'b00000000000000000000000000000000);
                
        #`CLK_PERIOD;

        // Input the test data ROUND 2
        L_in    <= L_next;
        R_in    <= R_next;
        Kn      <= 32'b0;

        L_expected <= 32'b01100100001111011111101011110100;
        R_expected <= 32'b11101001100010100101110101010111;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);

        L_next <= L_out;
        R_next <= R_out;
        
        $display("L_out =%b", L_out);
        $display("error =%b", L_expected - L_out);
        $display("R_out =%b", R_out);
        $display("error =%b", R_expected - R_out);
        $display("");

        nb_tests <= nb_tests + 2;
        nb_correct <= nb_correct + (L_expected - L_out == 32'b00000000000000000000000000000000) + (R_expected - R_out == 32'b00000000000000000000000000000000);
                
        #`CLK_PERIOD;

        // Input the test data ROUND 3
        L_in    <= L_next;
        R_in    <= R_next;
        Kn      <= 32'b0;

        L_expected <= 32'b11101001100010100101110101010111;
        R_expected <= 32'b01011110001110000101010000011100;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);

        L_next <= L_out;
        R_next <= R_out;
        
        $display("L_out =%b", L_out);
        $display("error =%b", L_expected - L_out);
        $display("R_out =%b", R_out);
        $display("error =%b", R_expected - R_out);
        $display("");

        nb_tests <= nb_tests + 2;
        nb_correct <= nb_correct + (L_expected - L_out == 32'b00000000000000000000000000000000) + (R_expected - R_out == 32'b00000000000000000000000000000000);
                
        #`CLK_PERIOD;

        // Input the test data ROUND 4
        L_in    <= L_next;
        R_in    <= R_next;
        Kn      <= 32'b0;

        L_expected <= 32'b01011110001110000101010000011100;
        R_expected <= 32'b00100100111010000100011010110111;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);

        L_next <= L_out;
        R_next <= R_out;
        
        $display("L_out =%b", L_out);
        $display("error =%b", L_expected - L_out);
        $display("R_out =%b", R_out);
        $display("error =%b", R_expected - R_out);
        $display("");

        nb_tests <= nb_tests + 2;
        nb_correct <= nb_correct + (L_expected - L_out == 32'b00000000000000000000000000000000) + (R_expected - R_out == 32'b00000000000000000000000000000000);
                
        #`CLK_PERIOD;

        // Input the test data ROUND 5
        L_in    <= L_next;
        R_in    <= R_next;
        Kn      <= 32'b0;

        L_expected <= 32'b00100100111010000100011010110111;
        R_expected <= 32'b10101000101001111011001110001000;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);

        L_next <= L_out;
        R_next <= R_out;
        
        $display("L_out =%b", L_out);
        $display("error =%b", L_expected - L_out);
        $display("R_out =%b", R_out);
        $display("error =%b", R_expected - R_out);
        $display("");

        nb_tests <= nb_tests + 2;
        nb_correct <= nb_correct + (L_expected - L_out == 32'b00000000000000000000000000000000) + (R_expected - R_out == 32'b00000000000000000000000000000000);
                
        #`CLK_PERIOD;

        // Input the test data ROUND 6
        L_in    <= L_next;
        R_in    <= R_next;
        Kn      <= 32'b0;

        L_expected <= 32'b10101000101001111011001110001000;
        R_expected <= 32'b10011110001001011100011110001110;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);

        L_next <= L_out;
        R_next <= R_out;
        
        $display("L_out =%b", L_out);
        $display("error =%b", L_expected - L_out);
        $display("R_out =%b", R_out);
        $display("error =%b", R_expected - R_out);
        $display("");

        nb_tests <= nb_tests + 2;
        nb_correct <= nb_correct + (L_expected - L_out == 32'b00000000000000000000000000000000) + (R_expected - R_out == 32'b00000000000000000000000000000000);
                
        #`CLK_PERIOD;

        // Input the test data ROUND 7
        L_in    <= L_next;
        R_in    <= R_next;
        Kn      <= 32'b0;

        L_expected <= 32'b10011110001001011100011110001110;
        R_expected <= 32'b01100110111000110000100001000001;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);

        L_next <= L_out;
        R_next <= R_out;
        
        $display("L_out =%b", L_out);
        $display("error =%b", L_expected - L_out);
        $display("R_out =%b", R_out);
        $display("error =%b", R_expected - R_out);
        $display("");

        nb_tests <= nb_tests + 2;
        nb_correct <= nb_correct + (L_expected - L_out == 32'b00000000000000000000000000000000) + (R_expected - R_out == 32'b00000000000000000000000000000000);
                
        #`CLK_PERIOD;

        // Input the test data ROUND 8
        L_in    <= L_next;
        R_in    <= R_next;
        Kn      <= 32'b0;

        L_expected <= 32'b01100110111000110000100001000001;
        R_expected <= 32'b00111101011111111100000100001011;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);

        L_next <= L_out;
        R_next <= R_out;
        
        $display("L_out =%b", L_out);
        $display("error =%b", L_expected - L_out);
        $display("R_out =%b", R_out);
        $display("error =%b", R_expected - R_out);
        $display("");

        nb_tests <= nb_tests + 2;
        nb_correct <= nb_correct + (L_expected - L_out == 32'b00000000000000000000000000000000) + (R_expected - R_out == 32'b00000000000000000000000000000000);
                
        #`CLK_PERIOD;

        // Input the test data ROUND 9
        L_in    <= L_next;
        R_in    <= R_next;
        Kn      <= 32'b0;

        L_expected <= 32'b00111101011111111100000100001011;
        R_expected <= 32'b00101010101101000111111010100101;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);

        L_next <= L_out;
        R_next <= R_out;
        
        $display("L_out =%b", L_out);
        $display("error =%b", L_expected - L_out);
        $display("R_out =%b", R_out);
        $display("error =%b", R_expected - R_out);
        $display("");

        nb_tests <= nb_tests + 2;
        nb_correct <= nb_correct + (L_expected - L_out == 32'b00000000000000000000000000000000) + (R_expected - R_out == 32'b00000000000000000000000000000000);
                
        #`CLK_PERIOD;

        // Input the test data ROUND 10
        L_in    <= L_next;
        R_in    <= R_next;
        Kn      <= 32'b0;

        L_expected <= 32'b00101010101101000111111010100101;
        R_expected <= 32'b00000011111111001001100101101110;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);

        L_next <= L_out;
        R_next <= R_out;
        
        $display("L_out =%b", L_out);
        $display("error =%b", L_expected - L_out);
        $display("R_out =%b", R_out);
        $display("error =%b", R_expected - R_out);
        $display("");

        nb_tests <= nb_tests + 2;
        nb_correct <= nb_correct + (L_expected - L_out == 32'b00000000000000000000000000000000) + (R_expected - R_out == 32'b00000000000000000000000000000000);
                
        #`CLK_PERIOD;

        // Input the test data ROUND 11
        L_in    <= L_next;
        R_in    <= R_next;
        Kn      <= 32'b0;

        L_expected <= 32'b00000011111111001001100101101110;
        R_expected <= 32'b01100010001101011010100111010100;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);

        L_next <= L_out;
        R_next <= R_out;
        
        $display("L_out =%b", L_out);
        $display("error =%b", L_expected - L_out);
        $display("R_out =%b", R_out);
        $display("error =%b", R_expected - R_out);
        $display("");

        nb_tests <= nb_tests + 2;
        nb_correct <= nb_correct + (L_expected - L_out == 32'b00000000000000000000000000000000) + (R_expected - R_out == 32'b00000000000000000000000000000000);
                
        #`CLK_PERIOD;

        // Input the test data ROUND 12
        L_in    <= L_next;
        R_in    <= R_next;
        Kn      <= 32'b0;

        L_expected <= 32'b01100010001101011010100111010100;
        R_expected <= 32'b10001001011001011011001001101000;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);

        L_next <= L_out;
        R_next <= R_out;
        
        $display("L_out =%b", L_out);
        $display("error =%b", L_expected - L_out);
        $display("R_out =%b", R_out);
        $display("error =%b", R_expected - R_out);
        $display("");

        nb_tests <= nb_tests + 2;
        nb_correct <= nb_correct + (L_expected - L_out == 32'b00000000000000000000000000000000) + (R_expected - R_out == 32'b00000000000000000000000000000000);
                
        #`CLK_PERIOD;

        // Input the test data ROUND 13
        L_in    <= L_next;
        R_in    <= R_next;
        Kn      <= 32'b0;

        L_expected <= 32'b10001001011001011011001001101000;
        R_expected <= 32'b10011100110100011101101110101000;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);

        L_next <= L_out;
        R_next <= R_out;
        
        $display("L_out =%b", L_out);
        $display("error =%b", L_expected - L_out);
        $display("R_out =%b", R_out);
        $display("error =%b", R_expected - R_out);
        $display("");

        nb_tests <= nb_tests + 2;
        nb_correct <= nb_correct + (L_expected - L_out == 32'b00000000000000000000000000000000) + (R_expected - R_out == 32'b00000000000000000000000000000000);
                
        #`CLK_PERIOD;

        // Input the test data ROUND 14
        L_in    <= L_next;
        R_in    <= R_next;
        Kn      <= 32'b0;

        L_expected <= 32'b10011100110100011101101110101000;
        R_expected <= 32'b00000001000000000000000000000000;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);

        L_next <= L_out;
        R_next <= R_out;
        
        $display("L_out =%b", L_out);
        $display("error =%b", L_expected - L_out);
        $display("R_out =%b", R_out);
        $display("error =%b", R_expected - R_out);
        $display("");

        nb_tests <= nb_tests + 2;
        nb_correct <= nb_correct + (L_expected - L_out == 32'b00000000000000000000000000000000) + (R_expected - R_out == 32'b00000000000000000000000000000000);
                
        #`CLK_PERIOD;

        // Input the test data ROUND 15
        L_in    <= L_next;
        R_in    <= R_next;
        Kn      <= 32'b0;

        L_expected <= 32'b00000001000000000000000000000000;
        R_expected <= 32'b00000000000000000000000000000000;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);

        L_next <= L_out;
        R_next <= R_out;
        
        $display("L_out =%b", L_out);
        $display("error =%b", L_expected - L_out);
        $display("R_out =%b", R_out);
        $display("error =%b", R_expected - R_out);
        $display("");

        nb_tests <= nb_tests + 2;
        nb_correct <= nb_correct + (L_expected - L_out == 32'b00000000000000000000000000000000) + (R_expected - R_out == 32'b00000000000000000000000000000000);
                
        #`CLK_PERIOD;

        $display("");
        $display("Correct tests: %d/%d", nb_correct, nb_tests);

        #`CLK_PERIOD;
        #`CLK_PERIOD;
        
        $finish;

    end
           
endmodule