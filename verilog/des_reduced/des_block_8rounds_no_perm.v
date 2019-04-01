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
    input [63:0] seed,              // input value for the LFSR seed
    input [63:0] polynomial,        // input value for the LFSR polynomial
    input [63:0] mask_i,            // input value for the input mask
    input [63:0] mask_o,            // input value for the output mask
    input [63:0] counter_limit,     // input value for the counter limit
    input [767:0] round_keys,       // input value for the round keys concatenated
    output [63:0] counter,          // output counter to keep track of the amounts of 1's
    output reg done                 // signals that the output are valid results
    );

    // Nets and regs
    reg [3:0] state, next_state;            // State variables

    reg [9:0] mask_i_bit_buffer;           // Used to buffer the mask bits, needed due to the pipeline delay
    reg [63:0] counter_reg;

    reg enable;
    reg counter_enable;
    reg start_des;
    reg pause_des;
    reg start_message;

    wire [63:0] message;
    wire [63:0] ciphertext;

    wire message_valid;     // Set when LFSR output is valid, used as start signal for the DES encryption
    wire counter_done;
    wire ciphertext_valid;
    wire mask_i_bit;
    wire mask_o_bit;
    wire mask_result;

    // Parameters
    localparam [3:0]    init        = 3'h0;    // Possible states
    localparam [3:0]    working     = 3'h1;    
    localparam [3:0]    finishing   = 3'h2;
    localparam [3:0]    finished    = 3'h3;

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
                next_state <= working;
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

    // The message generator
    lfsr_internal lfsr(  // Used to generate the messages for the encryption
        .clk            (clk          ),
        .rst_n          (rst_n        ),
        .start          (start_message),        // Start the message generation when this module receives a start signal
        .pause          (pause_des    ),
        .reset_counter  (restart_block),
        .seed           (seed         ),        // Stored in a reg inside this block
        .polynomial     (polynomial   ),        // Stored in a reg inside this block
        .counter_limit  (counter_limit),
        .lfsr           (message      ),
        .valid          (message_valid),        // signals when the output of this module contains valid messages every cycle
        .done           (counter_done ));

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
            mask_i_bit_buffer <= 10'h0;
        end

        else if (restart_block == 1'b1) begin
            mask_i_bit_buffer <= 10'h0;
        end

        if (message_valid == 1'b1) begin
            mask_i_bit_buffer <= {mask_i_bit, mask_i_bit_buffer[9:1]};
        end

        else if (ciphertext_valid == 1'b1) begin
            mask_i_bit_buffer <= {1'b0, mask_i_bit_buffer[9:1]};   // keep shifting for the last operations in the pipeline, fill register with zeros
        end
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
            counter_reg <= {64-N{1'b0}};
        end
        else if (restart_block == 1'b1) begin
            counter_reg <= {64-N{1'b0}};
        end
        else if (mask_result == 1'b1 & counter_enable == 1'b1) begin    // Only count new values when enabled
            counter_reg <= counter_reg + 1;
        end
    end

    assign counter = counter_reg[63:0];
    assign mask_result = mask_o_bit ^ mask_i_bit_buffer[0];
     
endmodule
