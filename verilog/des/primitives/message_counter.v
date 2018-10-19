`timescale 1ns / 1ps

module message_counter(
    input clk,                      // clock
    input rst_n,                    // reset, active low signal
    input start,                    // signals the block to start working, valid data is on the input lines
    input [63:0] message_seed,      // input message seed to start the counter with
    output [63:0] counter,          // output register containing the current counter values
    output reg valid                // signals that a valid result is on the output lines
    );

    // Nets and regs
    reg [1:0] state, next_state;        // State variables
    
    reg [63:0] counter_reg;

    reg load_seed;
    reg load_counter;

    // Parameters
    localparam [1:0]    init = 2'h0;    // Possible states
    localparam [1:0]    first = 2'h1;
    localparam [1:0]    working = 2'h2;

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
            if (start == 1'b0) begin
                next_state <= init;
            end
        end
        default: begin
            next_state <= init;
        end
        endcase
    end

    always @(*) begin   // output logic, signals to set: load_seed, load_counter, valid
        load_seed <= 1'b0;
        load_counter <= 1'b0;
        valid <= 1'b0;

        case (state)
        init: begin
            load_seed <= 1'b1;
        end
        first: begin
            load_counter <= 1'b1;
        end
        working: begin
            load_counter <= 1'b1;
            valid <= 1'b1;
        end
        endcase
    end

    //---------------------------DATAPATH----------------------------------------------------------   

    always @(posedge clk) begin     // Buffer the input message seed into the LFSR or load the LFSR feedback
        if (load_seed == 1'b1) begin    
            counter_reg <= message_seed;
        end
        else if (load_counter == 1'b1) begin    
            counter_reg <= counter_reg + 1;
        end
    end
    
    assign counter = counter_reg[63:0];

endmodule