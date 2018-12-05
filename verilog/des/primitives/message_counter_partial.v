`timescale 1ns / 1ps

module message_counter_partial(
    input clk,                      // clock
    input rst_n,                    // reset, active low signal
    input start,                    // signals the block to start working, valid data is on the input lines
    input pause,
    input reset_counter,
    input [N-1:0]  region_select,    // used to set the upper bits for region select (N-1)
    output [63:0] counter,          // output register containing the current counter values
    output reg valid,               // signals that a valid result is on the output lines
    output reg done                 // signals that all counter values in the current region have been generated
    );

    // Nets and regs
    reg [3:0] state, next_state;        // State variables
    
    reg [63-N:0] counter_reg;
    reg [N-1:0] region_reg;

    reg load_seed;
    reg load_counter;

    // Parameters
    localparam [2:0]    init        = 3'h0;    // Possible states
    localparam [2:0]    first       = 3'h1;
    localparam [2:0]    working     = 3'h2;
    localparam [2:0]    paused      = 3'h3;
    localparam [2:0]    finished    = 3'h4;

    // TODO: can we pass this parameter from the upper level instead of setting it here and there? (1)
    // NOTE: paramter for region length (1)
    parameter N = 16;   // The amount of bits in the region select

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
		    // NOTE: change this and next for full message generation (1)
            else if (counter_reg == {64-N{1'b1}}) begin
            //else if (counter_reg == 64'h200) begin
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

    always @(*) begin   // output logic, signals to set: load_seed, load_counter, valid, done
        load_seed <= 1'b0;
        load_counter <= 1'b0;
        valid <= 1'b0;
        done <= 1'b0;

        case (state)
        init: begin
            load_seed <= 1'b1;
        end
        first: begin
            load_counter <= 1'b1;
            valid <= 1'b1;  // Already valid here to allow the DES unit to also process the all zero message of the counter
        end
        working: begin
            valid <= 1'b1;
            if (counter_reg == {64-N{1'b1}}) begin
            //if (counter_reg == 64'h200) begin
                load_counter <= 1'b0;
            end
            else begin
                load_counter <= 1'b1;
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

    always @(posedge clk) begin     // Buffer the input message seed into the LFSR or load the LFSR feedback
        if (reset_counter == 1'b1) begin
            counter_reg <= {64-N{1'b0}};
        end
        else if (load_seed == 1'b1) begin    
            counter_reg <= {64-N{1'b0}};  // Load the initial settings
        end
        else if (load_counter == 1'b1) begin    
            counter_reg <= counter_reg + 1;
        end
    end

    always @(posedge clk) begin
        if (load_seed == 1'b1) begin
            region_reg <= region_select;
        end
    end
    
    assign counter = {counter_reg[63-N:0], region_reg};

endmodule
