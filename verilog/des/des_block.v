`timescale 1ns / 1ps

//`include "des/des_pipelined.v"
//`include "des/primitives/lfsr.v"
//`include "des/primitives/mask_xor.v"

module des_block(
    input clk,                  // clock
    input rst_n,                // reset, active low signal
    input start,                // signals the block to start working, valid data is on the input lines
    input [63:0] message_seed,  // input value of the initial message seed for LFSR message generation
    output reg [9:0] counter,       // output counter to keep track of the amounts of 1's
    output reg valid            // signals that the output are valid results
    );

    // Nets and regs
    reg [1:0] state, next_state;            // State variables

    reg [767:0] round_keys = 768'h1;        // NOTE: Should this be a reg here or an input?
    reg [17:0] mask_i_bit_buffer;           // Used to buffer the mask bits, needed due to the pipeline delay

    reg mask_result;

    wire [63:0] message;
    wire [63:0] ciphertext;


    wire message_valid;     // Set when LFSR output is valid, used as start signal for the DES encryption
    wire ciphertext_valid;
    wire mask_i_bit;
    wire mask_o_bit;

    // Parameters
    localparam [1:0]    init = 2'h0;    // Possible states
    localparam [1:0]    working = 2'h1;    
    localparam [1:0]    finished = 2'h2;

    parameter [63:0] mask_i = 2'h1;
    parameter [63:0] mask_o = 2'h1;

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
            next_state <= init;
            if (start == 1'b1) begin
                next_state <= working;
            end
        end
        working: begin
            next_state <= working;
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
        valid <= 1'b0;

        case (state)
        init: begin
            
        end
        working: begin

        end
        finished: begin
            
        end
        endcase
    end

    //---------------------------DATAPATH----------------------------------------------------------   

    des_encryption_pipelined des(
        .clk            (clk),                      
        .rst_n          (rst_n),
        .start          (message_valid),     // We can start the encryption module when the messages are being generated
        .message        (message),           // Will be generated at random through an LFSR
        .round_keys     (round_keys),
        .output_valid   (ciphertext_valid),
        .result         (ciphertext));

    lfsr lfsr(  // Used to generate the messages for the encryption
        .clk            (clk),
        .rst_n          (rst_n),
        .start          (start),            // Start the LFSR generation when this module receives a start signal
        .message_seed   (message_seed),
        .lfsr           (message),
        .valid          (message_valid));   // signals when the output of this module contains valid messages chaning every cycle

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
            mask_i_bit_buffer <= 18'h0;
        end
        else if (message_valid == 1'b1) begin
            mask_i_bit_buffer <= {mask_i_bit, mask_i_bit_buffer[17:1]};
        end
    end

    // When ciphertext_valid is set, mask_i_bit_buffer[0] contains the mask_i_bit that is associated with the current mask_o_bit
    always @(posedge clk) begin
        if (ciphertext_valid == 1'b1) begin
            mask_result <= mask_o_bit ^ mask_i_bit_buffer[0];   // This value can be used to activate the counter
        end
    end

    always @(posedge clk) begin     // Counter
        if (rst_n == 1'b0) begin
            counter <= 10'd0;
        end
        else if (mask_result == 1'b1) begin
            counter <= counter + 1;
        end
    end
     
endmodule