`timescale 1ns / 1ps

//`include "des/des_pipelined.v"
//`include "des/primitives/lfsr.v"
//`include "des/primitives/mask_xor.v"
//`include "des/primitives/message_counter.v"
//`include "des/primitives/message_counter_partial.v"

module des_block(
    input clk,                      // clock
    input rst_n,                    // reset, active low signal
    input start,                    // signals the block to start working, valid data is on the input lines
    input restart_block,            // signal used to reset the counter
    input test_enabled,             // signals to run in test mode
    input test_advance,             // signals to advance one step in the test
    input [15:0] region_select,     // input value to select the region for the counter to operate in
    output test_data_valid,         // signals that the output data for test mode is now valid
    output [47:0] counter,          // output counter to keep track of the amounts of 1's
    output [63:0] ciphertext_out,   // ciphertext output for testing
    output reg done                 // signals that the output are valid results
    );

    // Nets and regs
    reg [2:0] state, next_state;            // State variables

    reg [767:0] round_keys = 768'h0;        // NOTE: Should this be a reg here or an input?
    reg [33:0] mask_i_bit_buffer;           // Used to buffer the mask bits, needed due to the pipeline delay
    //reg [17:0] mask_i_bit_buffer;           // Used to buffer the mask bits, needed due to the pipeline delay
    reg [47:0] counter_reg;

    reg enable;
    reg counter_enable;
    reg start_des;
    reg pause_des;
    reg start_message;
    reg reg_test_data_valid;

    wire [63:0] message;
    wire [63:0] ciphertext;

    wire message_valid;     // Set when LFSR output is valid, used as start signal for the DES encryption
    wire counter_done;
    wire ciphertext_valid;
    wire mask_i_bit;
    wire mask_o_bit;
    wire mask_result;

    // Parameters
    localparam [2:0]    init        = 3'h0;    // Possible states
    localparam [2:0]    working     = 3'h1;    
    localparam [2:0]    finishing   = 3'h2;
    localparam [2:0]    finished    = 3'h3;
    localparam [2:0]    test_run    = 3'h4;
    localparam [2:0]    test_pause  = 3'h5;
    localparam [2:0]    test_init   = 3'h6;

    parameter [63:0] mask_i = 64'h1;
    parameter [63:0] mask_o = 64'h1;

    // Functions

    //---------------------------FSM---------------------------------------------------------------

    always @(posedge clk) begin // State register
        if (rst_n == 1'b0) begin   // Synchronous reset
            state <= init;
        end
        else if (restart_block == 1'b1) begin
            state <= init;
        end
        else begin
            state <= next_state;
        end
    end

    always @(*) begin   // Next state logic
        case (state)
        init: begin
            next_state <= init;
            if (start == 1'b1) begin
                if (test_enabled == 1'b1) begin
                    next_state <= test_init;
                end
                else begin
                    next_state <= working;
                end
            end
        end
        working: begin
            next_state <= working;

            if (counter_done == 1'b1) begin
                next_state <= finishing;
            end

        end
        finishing: begin    // First let the pipeline go empty then stop
            next_state <= finishing;
            if (ciphertext_valid == 1'b0) begin
                next_state <= finished;
            end
        end
        finished: begin
            next_state <= finished;
        end
        test_init: begin
            next_state <= test_init;
            if (test_enabled == 1'b0) begin
                next_state <= init;
            end
            else if (ciphertext_valid == 1'b1) begin
                next_state <= test_pause;
            end
        end
        test_run: begin
            next_state <= test_pause;
            if (test_enabled == 1'b0) begin
                next_state <= init;
            end
        end
        test_pause: begin   // In this state, valid ciphertext is on the output lines of this block
                            // Let the CPU check this and then continue
            next_state <= test_pause;
            if (test_enabled == 1'b0) begin
                next_state <= init;
            end
            else if (test_advance == 1'b1) begin
                next_state <= test_run;
            end
        end
        default: begin
            next_state <= init;
        end
        endcase
    end

    always @(*) begin   // Output logic, signals to set: valid
        done <= 1'b0;
        enable <= 1'b0;
        start_des <= 1'b0;
        pause_des <= 1'b0;
        start_message <= 1'b0;
        reg_test_data_valid <= 1'b0;

        case (state)
        init: begin
            pause_des <= 1'b1;

            if (start == 1'b1) begin
                start_des <= 1'b1;
                start_message <= 1'b1;
                pause_des <= 1'b0;
            end
        end    
        working: begin
            enable <= 1'b1;
        end
        finishing: begin

        end
        finished: begin
            done <= 1'b1;
        end
        test_init: begin
            enable <= 1'b1;
            pause_des <= 1'b0;
            if (ciphertext_valid == 1'b1) begin
                enable <= 1'b0;
                pause_des <= 1'b1;
            end
        end
        test_run: begin
            enable <= 1'b1;
            pause_des <= 1'b0;
        end
        test_pause: begin
            enable <= 1'b0;
            pause_des <= 1'b1;
            reg_test_data_valid <= 1'b1;
        end
        endcase
    end

    //---------------------------DATAPATH----------------------------------------------------------   

    des_encryption_pipelined des(
        .clk            (clk),                      
        .rst_n          (rst_n),
        .start          (start_des),
        .pause          (pause_des),
        .input_valid    (message_valid),   
        .restart_block  (restart_block), 
        .message        (message),           
        .round_keys     (round_keys),
        .output_valid   (ciphertext_valid),
        .result         (ciphertext));

    //lfsr lfsr(  // Used to generate the messages for the encryption
    //    .clk            (clk),
    //    .rst_n          (rst_n),
    //    .start          (start),            // Start the LFSR generation when this module receives a start signal
    //    .message_seed   (message_seed),
    //    .lfsr           (message),
    //    .valid          (message_valid));   // signals when the output of this module contains valid messages chaning every cycle

    //message_counter message_counter(  // Used to generate the messages for the encryption
    //    .clk            (clk),
    //    .rst_n          (rst_n),
    //    .start          (start),            // Start the message generation when this module receives a start signal
    //    .message_seed   (message_seed),
    //    .counter        (message),
    //    .valid          (message_valid));   // signals when the output of this module contains valid messages chaning every cycle

    message_counter_partial message_counter(    // Used to generate the messages for the encryption
        .clk            (clk          ),
        .rst_n          (rst_n        ),
        .start          (start_message),        // Start the message generation when this module receives a start signal
        .pause          (pause_des    ),
        .reset_counter  (restart_block  ),
        .region_select  (region_select),        // Stored in a reg inside this block
        .counter        (message      ),
        .valid          (message_valid),        // signals when the output of this module contains valid messages every cycle
        .done           (counter_done ));       // Signals when this unit has gone through all the messages

    mask_xor input_mask(  // Used to generate bit from mask operation in the message register
        .message        (message),
        .mask           (mask_i),
        .result         (mask_i_bit));

    mask_xor output_mask(  // Used to generate bit from mask operation in the ciphertext register
        .message        (ciphertext),
        .mask           (mask_o),
        .result         (mask_o_bit));

    always @(posedge clk) begin     // Logic for buffering mask_i_bit into mask_i_bit_buffer
        
        if (rst_n == 1'b0) begin
            mask_i_bit_buffer <= 34'h0;
            //mask_i_bit_buffer <= 18'h0;
        end
        else if (restart_block == 1'b1) begin
            mask_i_bit_buffer <= 34'h0;
            //mask_i_bit_buffer <= 18'h0;
        end
        //else if (enable == 1'b1) begin  // Only process output when enabled
            if (message_valid == 1'b1) begin
                mask_i_bit_buffer <= {mask_i_bit, mask_i_bit_buffer[33:1]};
                //mask_i_bit_buffer <= {mask_i_bit, mask_i_bit_buffer[17:1]};
            end
            else if (ciphertext_valid == 1'b1) begin
                mask_i_bit_buffer <= {1'b0, mask_i_bit_buffer[33:1]};   // keep shifting for the last operations in the pipeline, fill register with zeros
                //mask_i_bit_buffer <= {1'b0, mask_i_bit_buffer[17:1]};   // keep shifting for the last operations in the pipeline, fill register with zeros
            end
        //end
    end
    
    always @(posedge clk) begin
            if (ciphertext_valid == 1'b1) begin
                counter_enable <= 1'b1;   // This value can be used to activate the counter
            end
            else begin
                counter_enable <= 1'b0;
            end
        end

    always @(posedge clk) begin     // Counter
        if (rst_n == 1'b0) begin
            counter_reg <= 47'h0;
        end
        else if (restart_block == 1'b1) begin
            counter_reg <= 47'h0;
        end
        else if (mask_result == 1'b1 & counter_enable == 1'b1) begin    // Only count new values when enabled
            counter_reg <= counter_reg + 1;
        end
    end

    assign counter = counter_reg[47:0];
    assign ciphertext_out = ciphertext;
    assign test_data_valid = reg_test_data_valid;
    assign mask_result = mask_o_bit ^ mask_i_bit_buffer[0];
     
endmodule
