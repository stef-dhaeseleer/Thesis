`timescale 1ns / 1ps

//`include "des/des_block.v"

module des_block_wrapper(
    input clk,                          // clock
    input rst_n,                        // reset, active low signal
    input [31:0] cmd,                   // input command
    input cmd_valid_in,                 // input command valid, synchronized in another reg
    input advance_test_cmd_in,          // synchronized in another reg
    input [31:0] region,                // input data to set the region of the DES block
    output cmd_read,                    // signals that the input command has been read
    output [31:0] cmd_read_data,        // the value of the CMD that was just executed
    output test_res_ready,      
    output done,                        // signals that the operations are done, output data also valid
    output [63:0] counter,              // counter output for the CPU
    output [63:0] ciphertext            // ciphertext output for the CPU
    );

    // Nets and regs
    reg [3:0] state, next_state;        // State variables

    reg load_region;
    reg cmd_read_reg;
    reg start_des;
    reg load_counter;
    reg restart_block;
    reg test_enabled;
    reg test_advance;
    reg reg_test_res_ready;
    reg reg_done;

    reg cmd_valid;          // 2nd synchro register
    reg advance_test_cmd;   // 2nd synchro register

    reg [N-1:0] region_reg;

    reg [31:0] cmd_read_data_reg;
    reg [63:0] counter_reg;
    reg [63:0] ciphertext_reg;
    
    wire des_finished;
    wire des_test_data_valid;

    wire [63-N:0] des_counter;
    wire [63:0] ciphertext_out;

    // Parameters

    localparam CMD_READ_REGION  = 4'h1;     // Possible input commands
    localparam CMD_START        = 4'h2;
    localparam CMD_TEST_MODE    = 4'h3;
    localparam CMD_RESTART      = 4'h4;

    localparam [3:0]    init                = 4'h0;     // Possible states
    localparam [3:0]    set_region          = 4'h1;
    localparam [3:0]    start               = 4'h2;
    localparam [3:0]    waiting             = 4'h3;
    localparam [3:0]    finishing           = 4'h4;
    localparam [3:0]    restart             = 4'h5;
    localparam [3:0]    test_init           = 4'h6;
    localparam [3:0]    test_mode           = 4'h7;
    localparam [3:0]    advance_test        = 4'h8;
    localparam [3:0]    advance_test_wait   = 4'h9;
    localparam [3:0]    start_init          = 4'ha;
    localparam [3:0]    test_start          = 4'hb;
    
    // N should be 32 or lower
    parameter N = 32;
    parameter key = 768'h0;
    
    defparam des_block.message_counter.N = N;
    //defparam des_block.lfsr.N = N;
    // TODO: add a parameter for setting the lfsr polynomial (1)
    defparam des_block.N = N;
    defparam des_block.round_keys = key;
    defparam des_block.mask_i = 64'h2104008000000000;
    defparam des_block.mask_o = 64'h0000000021040080;

    // DES Linear tests:
    // 8 rounds
    //      input   64'h21040008000000000
    //      output  64'h00000000210400080
    //      keys    768'h0
    //      N       22      => 6 hour per region

    // Functions

    //---------------------------FSM---------------------------------------------------------------

    always @(posedge clk) begin // State register
        if (rst_n == 1'b0) begin   // Synchronous reset
            state <= init;
        end
        else begin
            state <= next_state;
        end
    end

    always @(*) begin   // Next state logic
        case (state)
        init: begin
            if (cmd_valid==1'b1) begin
                //Decode the command received on Port1
                case (cmd)
                    CMD_READ_REGION:
                        next_state <= set_region;
                    CMD_START:                            
                        next_state <= start_init;
                    CMD_TEST_MODE: 
                        next_state <= test_init;
                    CMD_RESTART:
                        next_state <= restart;
                    default:
                        next_state <= init;
                endcase
            end
            else begin  // If no new command is received
                next_state <= init;
            end
        end
        set_region: begin   // Sets the signal to load the region into a register, than listen for commands again
            next_state <= set_region;
            if (cmd_valid == 1'b0) begin
                next_state <= init;
            end
        end
        start_init: begin
            next_state <= start_init;
            if (cmd_valid == 1'b0) begin
                next_state <= start;
            end
        end
        start: begin    // Sets the start signal for the des block
            next_state <= waiting;
        end
        waiting: begin
            next_state <= waiting;

            if (des_finished == 1'b1) begin
                next_state <= finishing;
            end

            if (cmd_valid==1'b1) begin
                if (cmd == CMD_RESTART) begin
                    next_state <= restart;
                end
            end
        end
        finishing: begin
            next_state <= finishing;

            if (cmd_valid==1'b1) begin
                if (cmd == CMD_RESTART) begin
                    next_state <= restart;
                end
            end 
        end
        test_init: begin
            next_state <= test_init;
            if (cmd_valid == 1'b0) begin
                next_state <= test_start;
            end
        end
        test_start: begin
            next_state <= test_mode;
        end
        test_mode: begin
            next_state <= test_mode;

            if (cmd_valid==1'b1) begin
                if (cmd == CMD_RESTART) begin
                    next_state <= restart;
                end
            end 

            if (advance_test_cmd == 1'b1) begin
                next_state <= advance_test;
            end
        end
        advance_test: begin
            next_state <= advance_test_wait;
        end
        advance_test_wait: begin
            next_state <= advance_test_wait;
            
            if (advance_test_cmd == 1'b0) begin
                next_state <= test_mode;
            end
        end
        restart: begin
            next_state <= restart;
            if (cmd_valid == 1'b0) begin
                next_state <= init;
            end
        end
        default: begin
            next_state <= init;
        end
        endcase

    end

    always @(*) begin   // Output logic

        load_region <= 1'b0;
        load_counter <= 1'b0;
        cmd_read_reg <= 1'b0;
        start_des <= 1'b0;
        reg_done <= 1'b0;

        restart_block <= 1'b0;
        test_enabled <= 1'b0;
        test_advance <= 1'b0;
        reg_test_res_ready <= 1'b0;

        cmd_read_data_reg <= cmd_read_data_reg; // Not really initialised...

        case (state)
        init: begin
            cmd_read_data_reg <= 1'b0;
        end
        set_region: begin
            load_region <= 1'b1;
            cmd_read_reg <= 1'b1;
            cmd_read_data_reg <= CMD_READ_REGION;
        end
        start_init: begin
            cmd_read_reg <= 1'b1;
            cmd_read_data_reg <= CMD_START;
        end
        start: begin
            start_des <= 1'b1;
        end
        waiting: begin

        end
        finishing: begin
            reg_done <= 1'b1;
            load_counter <= 1'b1;
        end
        test_init: begin
            cmd_read_reg <= 1'b1;
            cmd_read_data_reg <= CMD_TEST_MODE;
        end
        test_start: begin
            test_enabled <= 1'b1;
            start_des <= 1'b1;
        end
        test_mode: begin
            test_enabled <= 1'b1;
            load_counter <= 1'b1;

            if (des_test_data_valid == 1'b1) begin
                reg_test_res_ready <= 1'b1;
            end
        end
        advance_test: begin
            test_enabled <= 1'b1;
            test_advance <= 1'b1;
        end
        advance_test_wait: begin
            test_enabled <= 1'b1;
        end
        restart: begin
            cmd_read_reg <= 1'b1;
            cmd_read_data_reg <= CMD_RESTART;
            restart_block <= 1'b1;
        end
        endcase

    end

    //---------------------------DATAPATH----------------------------------------------------------   

    des_block des_block (
        .clk            (clk          ),
        .rst_n          (rst_n        ),
        .start          (start_des    ),
        .restart_block  (restart_block),
        .test_enabled   (test_enabled),
        .test_advance   (test_advance),
        .region_select  (region_reg   ),
        .test_data_valid(des_test_data_valid),
        .counter        (des_counter  ),
        .ciphertext_out (ciphertext_out),
        .done           (des_finished ));

    assign cmd_read = cmd_read_reg;
    assign counter = {{N{1'b0}}, counter_reg};
    assign ciphertext = ciphertext_reg;
    assign test_res_ready = reg_test_res_ready;
    assign done = reg_done;
    assign cmd_read_data = cmd_read_data_reg;

    always @(posedge clk) begin     // Load the region into the register
        if (load_region == 1'b1) begin
            region_reg <= region[N-1:0];
        end
    end

    always @(posedge clk) begin     // Load the region into the register
        if (load_counter == 1'b1) begin
            counter_reg <= des_counter;
        end
    end

    always @(posedge clk) begin     // Load the ciphertext into the register
        ciphertext_reg <= ciphertext_out;
    end

    always @(posedge clk) begin     // Synchronization of incomming values from different clock domain
        cmd_valid <= cmd_valid_in;
        advance_test_cmd <= advance_test_cmd_in;
    end
     
endmodule
