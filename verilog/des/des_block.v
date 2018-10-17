`include "des/des_pipelined.v"

module des_block(
    input clk,                  // clock
    input rst_n,                // reset, active low signal
    input start,                // signals the block to start working, valid data is on the input lines
    output done                 // signals that the operations are done, valid result is on the output lines
    );

    // Nets and regs
    reg [1:0] state, next_state;        // State variables

    reg [767:0] round_keys;             // NOTE: Should this be a reg here or an input?

    // Parameters
    localparam [1:0]    init = 2'h0;    // Possible states
    localparam [1:0]    finished = 2'h1;

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
        end
        finished: begin
            next_state <= finished;
        end
        default: begin
            next_state <= init;
        end
        endcase
    end

    //---------------------------DATAPATH----------------------------------------------------------   

    des_encryption_pipelined des(
        .clk            (clk),                      
        .rst_n          (rst_n),
        .start          (),     // We can start the encryption module when the messages are being generated
        .message        (),     // Will be generated at random through an LFSR
        .round_keys     (round_keys),
        .output_valid   (),
        .result         ());
     
endmodule