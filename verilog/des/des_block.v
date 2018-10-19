`timescale 1ns / 1ps

//`include "des/des_pipelined.v"
//`include "des/primitives/lfsr.v"
//`include "des/primitives/mask_xor.v"
//`include "des/primitives/message_counter.v"
//`include "des/primitives/message_counter_partial.v"

module des_block(
    input clk,                  // clock
    input rst_n,                // reset, active low signal
    input start,                // signals the block to start working, valid data is on the input lines
    input [63:0] message_seed,  // input value of the initial message seed for message generation
    //input [3:0] region_select,  // input value to select the region for the counter to operate in
    output [9:0] counter,       // output counter to keep track of the amounts of 1's
    output reg valid            // signals that the output are valid results
    );

    // Nets and regs
    reg [1:0] state, next_state;            // State variables

    reg [767:0] round_keys = 768'h1;        // NOTE: Should this be a reg here or an input?
    reg [17:0] mask_i_bit_buffer;           // Used to buffer the mask bits, needed due to the pipeline delay
    reg [9:0] counter_reg;

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
    localparam [1:0]    finishing = 2'h2;
    localparam [1:0]    finished = 2'h3;


    parameter [63:0] mask_i = 64'h1584458925484615;
    parameter [63:0] mask_o = 64'h49845174789897;

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
            if (start == 1'b0) begin
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
        valid <= 1'b0;

        case (state)
        init: begin
            
        end
        working: begin

        end
        finished: begin
            valid <= 1'b1;
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

    message_counter_partial message_counter(  // Used to generate the messages for the encryption
        .clk            (clk),
        .rst_n          (rst_n),
        .start          (start),            // Start the message generation when this module receives a start signal
        .region_select  (message_seed[3:0]),
        .counter        (message),
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
            counter_reg <= 10'd0;
        end
        else if (mask_result == 1'b1) begin
            counter_reg <= counter_reg + 1;
        end
    end

    assign counter = counter_reg[9:0];
     
endmodule