`timescale 1ns / 1ps

// Sources for polynomial;
// http://courses.cse.tamu.edu/walker/csce680/lfsr_table.pdf
// https://users.ece.cmu.edu/~koopman/lfsr/index.html
// http://www.eng.auburn.edu/~strouce/class/elec6250/LFSRs.pdf

// The above links can be used to generate the polynomials needed and set them as parameters from the outside
// in the second semester

// Implementation of an internal LFSR (XORs between the registers, no external combining).
// This yields a shorter critical path (only one XOR per path) and thus supports higher clock frequencies.

module lfsr_internal(
    input clk,                  // clock
    input rst_n,                // reset, active low signal
    input start,                // signals the block to start working, valid data is on the input lines
    input pause,                // pause the operation of the block
    input reset_counter,        // reset the block and counter to initial values
    input [63:0] seed,          // input message seed to start the LFSR
    input [63:0] polynomial,    // input message seed to start the LFSR
    input [63:0] counter_limit, // input for the counter limit value
    output [63:0] lfsr,         // output register containing the current LFSR values
    output reg valid,           // signals that a valid result is on the output lines
    output reg done             // done, all encryptions done    
    );

    // Nets and regs
    reg [2:0] state, next_state;        // State variables
    
    // Registers for the LFSR taps, the initial seed and the polynomial used for the LFSR feedback and the counter for the number of encryptions
    reg [63:0] lfsr_reg;
    reg [63:0] seed_reg;
    reg [63:0] polynomial_reg;
    reg [63:0] counter_reg;

    reg [63:0] i;    // Loop variable

    reg load_seed_poly;     // Loads both the input seed and input polynomial for this LFSR
    reg load_lfsr;          // Updates the LFSR taps with the feedback

    wire lfsr_feedback;

    // Parameters
    localparam [2:0]    init     = 3'h0;    // Possible states
    localparam [2:0]    first    = 3'h1;
    localparam [2:0]    working  = 3'h2;
    localparam [2:0]    paused   = 3'h3;
    localparam [2:0]    finished = 3'h4;

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
        init: begin     // Stay in init until start, then first/working
            next_state <= init;
            if (start == 1'b1) begin
                next_state <= first;
            end
        end
        first: begin    // Only stay here one cycle, then go to working
            next_state <= working;
        end
        working: begin // Keep working is the normal operation
            next_state <= working;
            if (pause == 1'b1) begin
                // go to paused state if pause signal goes high
                next_state <= paused;
            end
            else if (reset_counter == 1'b1) begin
                // go to init upon reset
                next_state <= init;
            end
            else if (counter_reg == counter_limit) begin
                // go to finished if the counter limit has been reached
                next_state <= finished;
            end
        end
        paused: begin
            next_state <= paused;
            if (pause == 1'b0) begin
                // go back to working if the pause signal goes low again
                next_state <= working;
            end
            else if (reset_counter == 1'b1) begin
                // go to init on reset
                next_state <= init;
            end
        end
        finished: begin     // Stay finished until the reset signal goes high
            next_state <= finished;
            if (reset_counter == 1'b1) begin
                next_state <= init;
            end
        end
        default: begin
            next_state <= init;
        end
        endcase
    end

    always @(*) begin   // output logic, signals to set: load_seed_poly, load_lfsr, valid, done

        load_seed_poly <= 1'b0; // Load the seed and polynomial into their registers
        load_lfsr <= 1'b0;      // update the taps for the LFSR and the counter
        valid <= 1'b0;          // output is valid
        done <= 1'b0;           // operations are done

        case (state)
        init: begin     // Always load to be able to start directly
            load_seed_poly <= 1'b1;
        end
        first: begin
            load_lfsr <= 1'b1; // update taps
            valid <= 1'b1;  // Already valid here to allow the DES unit to also process the all zero message of the counter
        end
        working: begin
            valid <= 1'b1;  // Always valid while working
            if (counter_reg == counter_limit) begin
                load_lfsr <= 1'b0;  // Stop loading new taps when the number of encryptions has been reached
            end
            else begin
                load_lfsr <= 1'b1;  // Else keep updating taps
            end
        end
        paused: begin
            // Do nothing
        end
        finished: begin
            done <= 1'b1;   // output done
        end
        endcase
    end

    //---------------------------DATAPATH----------------------------------------------------------   

    // Value propagated to the internal XORs of the LFSR
    assign lfsr_feedback = lfsr_reg[0];

    always @(posedge clk) begin     // Buffer the seed into the LFSR or load the LFSR feedback
        if (reset_counter == 1'b1) begin
            lfsr_reg <= seed;   // init to seed on reset
        end
        if (load_seed_poly == 1'b1) begin    
            lfsr_reg <= seed;   // init to seed on load
        end
        else if (load_lfsr == 1'b1) begin    
            // Should be a conditional load... Want to either just shift, or XOR shift based on values in polynomial_reg
            
            // This is for the internal LFSR working, where polynomial_reg is one, we XOR with feedback.
            for (i = 0; i < 63; i=i+1) begin
                lfsr_reg[i] <= polynomial_reg[i] ? lfsr_reg[i+1]^lfsr_feedback : lfsr_reg[i+1];
            end

            lfsr_reg[63] <= lfsr_feedback;  // Complete the shift by feeding the feedback to the last tap

        end
    end

    // Logic for the counter
    always @(posedge clk) begin
        if (reset_counter == 1'b1) begin
            counter_reg <= 64'b0;   // set to zero on reset
        end
        else if (load_seed_poly == 1'b1) begin    
            counter_reg <= 64'b0;  // Load the initial settings of zero
        end
        else if (load_lfsr == 1'b1) begin    
            counter_reg <= counter_reg + 1; // count up
        end
    end

    // Logic for loading the seed and the polynomial
    always @(posedge clk) begin
        if (load_seed_poly == 1'b1) begin
            seed_reg <= seed;
            polynomial_reg <= polynomial;
        end
    end
    
    assign lfsr = lfsr_reg[63:0];

endmodule
