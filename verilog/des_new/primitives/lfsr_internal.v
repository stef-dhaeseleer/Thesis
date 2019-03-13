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
    input pause,                // pauzes the working of the block
    input reset_counter,        // reset the counter
    input [N-1:0] seed,         // input message seed to start the LFSR
    input [N-1:0] polynomial,   // input message seed to start the LFSR
    output [N-1:0] lfsr,        // output register containing the current LFSR values
    output reg valid,           // signals that a valid result is on the output lines
    output reg done             // done, requested number of encryptions (param N_counter) performed           
    );

    // Nets and regs
    reg [2:0] state, next_state;        // State variables
    
    reg [N-1:0] lfsr_reg;       // Stores the LFSR tap values.
    reg [N-1:0] seed_reg;       // Stores the seed the LFSR was initialized with.
    reg [N-1:0] polynomial_reg; // Stores the values for the polynomial used to generate the LFSR feedback bit.

    reg [N_counter-1:0] counter_reg;    // Number of encryptions to be performed.

    reg [N-1:0] i;    // Loop variable

    reg load_seed_poly;  // Loads both the input seed and input polynomial for this LFSR
    reg load_lfsr;

    wire lfsr_feedback;

    // NOTE: paramter for region length, value overridden from toplevel wrapper (1)
    parameter N_counter = 32;   // Parameter for the number of encryptions
    parameter N = 64;           // Length of the LFSR

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
        init: begin     // initial state, go to first/working when the start signal goes high.
            next_state <= init;
            if (start == 1'b1) begin
                next_state <= first;
            end
        end
        first: begin    // Only one cycle here, then to working
            next_state <= working;
        end
        working: begin  // Keep working if not paused, init on reset, finished if the correct number of encryptions have been performed
            next_state <= working;
            if (pause == 1'b1) begin
                // Pause the block
                next_state <= paused;
            end
            else if (reset_counter == 1'b1) begin
                next_state <= init;
            end
            else if (counter_reg == {N_counter{1'b1}}) begin
                // All encryptions have been performed, finish
                next_state <= finished;
            end
        end
        paused: begin   // Back to working if pause goes low, init on reset
            next_state <= paused;
            if (pause == 1'b0) begin
                next_state <= working;
            end
            else if (reset_counter == 1'b1) begin
                next_state <= init;
            end
        end
        finished: begin     // Stay finished untill reset
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

        load_seed_poly <= 1'b0; // Loads the seed and polynomial form the input wires
        load_lfsr <= 1'b0;      // Loads the LFSR to the next value (feedback and shift)
        valid <= 1'b0;          // Output is valid
        done <= 1'b0;           // All requested encryptions have been performed

        case (state)
        init: begin
            load_seed_poly <= 1'b1; // Always load in init so we can start afterwards.
        end
        first: begin
            load_lfsr <= 1'b1;  // Load the  next value after this.
            valid <= 1'b1;  // Already valid here to allow the DES unit to also process the all zero message of the counter
        end
        working: begin
            valid <= 1'b1;  // Output stays valid
            if (counter_reg == {N_counter{1'b1}}) begin     // Stop loading when all has been done
                load_lfsr <= 1'b0;
            end
            else begin
                load_lfsr <= 1'b1;
            end
        end
        paused: begin
            // Don't do anything here
        end
        finished: begin     // Output done
            done <= 1'b1;
        end
        endcase
    end

    //---------------------------DATAPATH----------------------------------------------------------   

    // Value propagated to the internal XORs of the LFSR
    assign lfsr_feedback = lfsr_reg[0];

    always @(posedge clk) begin     // Buffer the input message seed into the LFSR or load the LFSR feedback
        if (reset_counter == 1'b1) begin
            lfsr_reg <= seed;   // Init to seed
        end
        if (load_seed_poly == 1'b1) begin    
            lfsr_reg <= seed;   // Load the seed
        end
        else if (load_lfsr == 1'b1) begin    
            // Should be a conditional load... Want to either just shift, or XOR shift based on values in polynomial_reg

            // This is for the internal LFSR working, where polynomial_reg is one, we XOR with feedback.
            for (i = 0; i < N-1; i=i+1) begin
                lfsr_reg[i] <= polynomial_reg[i] ? lfsr_reg[i+1]^lfsr_feedback : lfsr_reg[i+1];
            end

            // last bit becomes the feedback to complete the shifting.
            lfsr_reg[N-1] <= lfsr_feedback;

        end
    end

    // Counter logic
    always @(posedge clk) begin 
        if (reset_counter == 1'b1) begin
            counter_reg <= {N_counter{1'b0}};   // reset to zero
        end
        else if (load_seed_poly == 1'b1) begin    
            counter_reg <= {N_counter{1'b0}};  // reset to zero on load
        end
        else if (load_lfsr == 1'b1) begin    
            counter_reg <= counter_reg + 1; // count up
        end
    end


    // Load logic for the seed and polynomial reg
    always @(posedge clk) begin
        if (load_seed_poly == 1'b1) begin
            seed_reg <= seed;
            polynomial_reg <= polynomial;
        end
    end
    
    assign lfsr = lfsr_reg[N-1:0];

endmodule
