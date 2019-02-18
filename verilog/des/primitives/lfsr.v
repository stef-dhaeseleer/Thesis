`timescale 1ns / 1ps

// Sources for polynomial;
// http://courses.cse.tamu.edu/walker/csce680/lfsr_table.pdf
// https://users.ece.cmu.edu/~koopman/lfsr/index.html
// http://www.eng.auburn.edu/~strouce/class/elec6250/LFSRs.pdf

// The above links can be used to generate the polynomials needed and set them as parameters from the outside
// in the second semester

// Currently using an external LFSR
// Implement an internal one next semester as this allows for higher clock rates

// New system, to remove a counter from the desing we can use an N bit LFSR and 
// let it run untill it reaches it's initial state again, then we know how many encryptions it did.

module lfsr(
    input clk,                  // clock
    input rst_n,                // reset, active low signal
    input start,                // signals the block to start working, valid data is on the input lines
    input pause,
    input reset_counter,
    input [N-1:0] message_seed,  // input message seed to start the LFSR with
    output [N-1:0] lfsr,     // output register containing the current LFSR values
    output reg valid,                // signals that a valid result is on the output lines
    output reg done                 
    );

    // Nets and regs
    reg [2:0] state, next_state;        // State variables
    
    reg [N-1:0] lfsr_reg;
    reg [N-1:0] seed_reg;

    reg load_seed;
    reg load_lfsr;

    wire lfsr_feedback;

    // NOTE: paramter for region length, value overridden from toplevel wrapper (1)
    parameter N = 32;

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
        init: begin
            next_state <= init;
            if (start == 1'b1) begin
                next_state <= first;
            end
        end
        first: begin
            next_state <= working;
        end
        working: begin
            next_state <= working;
            if (pause == 1'b1) begin
                next_state <= paused;
            end
            else if (reset_counter == 1'b1) begin
                next_state <= init;
            end
            else if (lfsr_reg == seed_reg) begin
                next_state <= finished;
            end
        end
        paused: begin
            next_state <= paused;
            if (pause == 1'b0) begin
                next_state <= working;
            end
            else if (reset_counter == 1'b1) begin
                next_state <= init;
            end
        end
        finished: begin
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

    always @(*) begin   // output logic, signals to set: load_seed, load_lfsr, valid, done
        load_seed <= 1'b0;
        load_lfsr <= 1'b0;
        valid <= 1'b0;
        done <= 1'b0;

        case (state)
        init: begin
            load_seed <= 1'b1;
        end
        first: begin
            load_lfsr <= 1'b1;
            valid <= 1'b1;  // Already valid here to allow the DES unit to also process the all zero message of the counter
        end
        working: begin
            valid <= 1'b1;  // Already valid here to allow the DES unit to also process the all zero message of the counter
            if (lfsr_reg == seed_reg) begin
                load_lfsr <= 1'b0;
            end
            else begin
                load_lfsr <= 1'b1;
            end
        end
        paused: begin

        end
        finished: begin
            done <= 1'b1;
        end
        endcase
    end

    //---------------------------DATAPATH----------------------------------------------------------   

    // Doesn't matter if you add the not operator or not
    assign lfsr_feedback = ~(lfsr[31] ^ lfsr[29] ^ lfsr[25] ^ lfsr[24]);

    // TODO: what to do on reset? reload seed? (1)
    always @(posedge clk) begin     // Buffer the input message seed into the LFSR or load the LFSR feedback
        if (reset_counter == 1'b1) begin
            lfsr_reg <= message_seed;
        end
        if (load_seed == 1'b1) begin    
            lfsr_reg <= message_seed;
        end
        else if (load_lfsr == 1'b1) begin    
            lfsr_reg <= {lfsr_feedback, lfsr_reg[N-1:1]};   // Implemented as a right shift LFSR
        end
    end

    always @(posedge clk) begin
        if (load_seed == 1'b1) begin
            seed_reg <= message_seed;
        end
    end
    
    assign lfsr = lfsr_reg[N-1:0];

endmodule
