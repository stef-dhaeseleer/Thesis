`timescale 1ns / 1ps

//`include "des/des_roundfunction.v"
//`include "des/primitives/ip_inverse_permutation.v"
//`include "des/primitives/ip_permutation.v"

module des_encryption_unroll2(
    input clk,                  // clock
    input rst_n,                // reset, active low signal
    input start,                // signals the block to start working, valid data is on the input lines
    input [1:64] message,       // the message to be encrypted
    input [1:768] round_keys,   // all roundkeys used in a series (16*48 bits)
    output reg done,            // signals that the operations are done, valid result is on the output lines
    output [1:64] result        // the resulting encrypted version of the input message
    );

    // Nets and regs
    reg [1:0] state, next_state;        // State variables

    reg [1:64] M;
    reg [1:768] temp_key;

    reg [2:0] counter;  // Registers needed for the counter
    reg sync_rst, cnt_enable;

    reg start_roundfunction;
    reg load_regs;

    wire roundfunction_done;
    wire roundfunction_done_temp;
    wire [1:32] L_out;
    wire [1:32] R_out;
    wire [1:32] L_temp;
    wire [1:32] R_temp;
    wire [1:48] current_round_key1;
    wire [1:48] current_round_key2; 
    wire [1:64] permuted_message;
    wire [1:64] result_wire;

    // Parameters
        // Possible states
    localparam [1:0]    init = 0;   // Init will also already do the IP 
    localparam [1:0]    roundfunction = 1;
    localparam [1:0]    finished = 2;    // Finished will output the inverse permuted version of the M reg

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
                next_state <= roundfunction;
            end
        end
        roundfunction: begin
            next_state <= roundfunction;

            if (counter == 7) begin // Continue roundfunction untill all 16 round have passed
                next_state <= finished;
            end
        end
        finished: begin
            next_state <= init;
        end
        default: begin
            next_state <= init;
        end
        endcase
    end

    //---------------------------DATAPATH---------------------------------------------------------------

    // Modules
    // The roundfunction
    des_roundfunction round_func1(
            .clk    (clk ),
            .rst_n  (rst_n),
            .start  (start_roundfunction),
            .L_in   (M[1:32]),
            .R_in   (M[33:64]),
            .Kn     (current_round_key1),
            .done   (roundfunction_done_temp),
            .L_out  (L_temp),
            .R_out  (R_temp));

    des_roundfunction round_func2(
            .clk    (clk ),
            .rst_n  (rst_n),
            .start  (roundfunction_done_temp),
            .L_in   (L_temp),
            .R_in   (R_temp),
            .Kn     (current_round_key2),
            .done   (roundfunction_done),
            .L_out  (L_out),
            .R_out  (R_out));

    // The IP permutation module
    ip_permutation ip(
            .data_i    (message),
            .data_o    (permuted_message));

    // The inverse IP permutation module
    ip_inverse_permutation ip_inv(
            .data_i    ({R_out, L_out}),
            .data_o    (result_wire));

    always @(*) begin // Output logic. Signals to set: done, sync_rst, cnt_enable, start_roundfunction, load_regs
        done <= 1'b0;
        sync_rst <= 1'b0;
        cnt_enable <= 1'b0;
        start_roundfunction <= 1'b0;
        load_regs <= 1'b0;

        case (state)
            init: begin
                sync_rst <= 1'b1;
                start_roundfunction <= 1'b1;
            end
            roundfunction: begin
                start_roundfunction <= 1'b1;
                if (roundfunction_done == 1'b1) begin
                    cnt_enable <= 1'b1;
                    load_regs <= 1'b1;
                end
                if (counter == 7) begin
                    cnt_enable <= 1'b0;
                    load_regs <= 1'b0;
                end
            end
            finished: begin
                done <= 1'b1;
            end
        endcase
    end

    always @(posedge clk) begin // Logic for buffering the inputs into a register

        if (load_regs == 1'b1) begin
            M <= {L_out, R_out};
            temp_key <= temp_key << 96;
        end

        if (start == 1'b1) begin
            M <= permuted_message;
            temp_key <= round_keys;
        end
    end

    // Counter
    always @(posedge clk) begin
        if (sync_rst == 1'b1 || rst_n == 1'b0) begin
            counter <= 0;
        end
        else if (cnt_enable == 1'b1) begin
            counter <= counter + 1;
        end
    end

    assign result = result_wire;
    assign current_round_key1 = temp_key[1:48];
    assign current_round_key2 = temp_key[49:96];

endmodule