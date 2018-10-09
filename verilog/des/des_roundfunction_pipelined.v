module des_roundfunction_pipelined(
    input clk,              // clock
    input rst_n,            // reset, active low signal
    input wire i_valid,     // signals
    input [1:32] L_in,      // the left part for the roundfunction
    input [1:32] R_in,      // the right part for the roundfunction
    input [1:48] Kn,        // the incomming key for this roundfunction instance
    output wire o_valid,    // signals that the output is valid for the current iteration
    output [1:32] L_out,    // the outgoing left part of the roundfunction
    output [1:32] R_out     // the outgoing right part of the roundfunction
    );

    // Nets and regs
    reg [1:0] state, next_state;        // State variables

    // Parameters
    localparam [1:0]    init = 0;    // Possible states
    localparam [1:0]    finished = 1;

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

     

endmodule