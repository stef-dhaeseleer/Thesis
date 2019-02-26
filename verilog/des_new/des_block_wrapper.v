`timescale 1ns / 1ps

//`include "des/des_block.v"

module des_block_wrapper(
    input clk,                          // clock
    input rst_n,                        // reset, active low signal
    input [31:0] cmd,                   // input command
    input cmd_valid,                    // input command valid, synchronized in another reg
    input [31:0] data_upper,            // input data to the block, upper part
    input [31:0] data_lower,            // input data to the block, lower part
    output cmd_read,                    // signals that the input command has been read
    output done,                        // signals that the operations are done, output data also valid
    output [63:0] counter               // counter output for the CPU
    );

    // Nets and regs
    reg [STATE_BITS-1:0] state, next_state;        // State variables

    reg load_seed;
    reg load_poly;      
    reg cmd_read_reg;
    reg start_des;
    reg load_counter;
    reg restart_block;
    reg reg_done;

    reg cmd_valid_reg;
    reg cmd_valid_tmp;

    reg [63:0] seed_reg;
    reg [63:0] poly_reg;

    reg [31:0] cmd_read_data_reg;
    reg [63:0] counter_reg;
    
    wire des_finished;

    wire [63-N:0] des_counter;

    // Parameters

    localparam STATE_BITS = 4;

    localparam CMD_READ_SEED    = 4'h1;     // Possible input commands
    localparam CMD_READ_POLY    = 4'h2;
    localparam CMD_START        = 4'h3;
    localparam CMD_RESTART      = 4'h5;

    localparam [STATE_BITS-1:0]    init                = 4'h0;     // Possible states
    localparam [STATE_BITS-1:0]    set_seed            = 4'h1;
    localparam [STATE_BITS-1:0]    set_poly            = 4'h2;
    localparam [STATE_BITS-1:0]    start               = 4'h3;
    localparam [STATE_BITS-1:0]    waiting             = 4'h4;
    localparam [STATE_BITS-1:0]    finishing           = 4'h5;
    localparam [STATE_BITS-1:0]    restart             = 4'h6;
    localparam [STATE_BITS-1:0]    start_init          = 4'h7;
    
    // N should be 32 or lower
    parameter N = 32;
    parameter key = 768'h0;
    
    //defparam des_block.message_counter.N = N;
    defparam des_block.lfsr.N = N;
    defparam des_block.N = N;
    defparam des_block.round_keys = key;
    defparam des_block.mask_i = 64'h2104008000000000;
    defparam des_block.mask_o = 64'h0000000021040080;

    // DES Linear tests:
    // 8 rounds
    //      input   64'h21040008000000000
    //      output  64'h00000000210400080
    //      keys    768'h0
    //      N       22      => 6 hour per region

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
            if (cmd_valid_reg==1'b1) begin
                //Decode the command received on Port1
                case (cmd)
                    CMD_READ_SEED:
                        next_state <= set_seed;
                    CMD_READ_POLY:
                        next_state <= set_poly;
                    CMD_START:                            
                        next_state <= start_init;
                    CMD_RESTART:
                        next_state <= restart;
                    default:
                        next_state <= init;
                endcase
            end
            else begin  // If no new command is received
                next_state <= init;
            end
        end
        set_seed: begin   // Sets the signal to load the seed into a register, then listen for commands again
            next_state <= set_seed;
            if (cmd_valid_reg == 1'b0) begin
                next_state <= init;
            end
        end
        set_poly: begin   // Sets the signal to load the polynomial into a register, then listen for commands again
            next_state <= set_poly;
            if (cmd_valid_reg == 1'b0) begin
                next_state <= init;
            end
        end
        start_init: begin
            next_state <= start_init;
            if (cmd_valid_reg == 1'b0) begin
                next_state <= start;
            end
        end
        start: begin    // Sets the start signal for the des block
            next_state <= waiting;
        end
        waiting: begin
            next_state <= waiting;

            if (des_finished == 1'b1) begin
                next_state <= finishing;
            end

            if (cmd_valid_reg==1'b1) begin
                if (cmd == CMD_RESTART) begin
                    next_state <= restart;
                end
            end
        end
        finishing: begin
            next_state <= finishing;

            if (cmd_valid_reg==1'b1) begin
                if (cmd == CMD_RESTART) begin
                    next_state <= restart;
                end
            end 
        end
        restart: begin
            next_state <= restart;
            if (cmd_valid_reg == 1'b0) begin
                next_state <= init;
            end
        end
        default: begin
            next_state <= init;
        end
        endcase

    end

    always @(*) begin   // Output logic

        load_seed <= 1'b0;
        load_poly <= 1'b0;
        load_counter <= 1'b0;
        cmd_read_reg <= 1'b0;
        start_des <= 1'b0;
        reg_done <= 1'b0;

        restart_block <= 1'b0;

        case (state)
        init: begin

        end
        set_seed: begin
            load_seed <= 1'b1;
            cmd_read_reg <= 1'b1;
        end
        set_poly: begin
            load_poly <= 1'b1;
            cmd_read_reg <= 1'b1;
        end
        start_init: begin
            cmd_read_reg <= 1'b1;
        end
        start: begin
            start_des <= 1'b1;
        end
        waiting: begin

        end
        finishing: begin
            reg_done <= 1'b1;
            load_counter <= 1'b1;
        end
        restart: begin
            cmd_read_reg <= 1'b1;
            restart_block <= 1'b1;
        end
        endcase

    end

    //---------------------------DATAPATH----------------------------------------------------------   

    des_block des_block (
        .clk            (clk          ),
        .rst_n          (rst_n        ),
        .start          (start_des    ),
        .restart_block  (restart_block),
        .seed           (seed_reg     ),
        .polynomial     (poly_reg     ),
        .counter        (des_counter  ),
        .done           (des_finished ));

    assign cmd_read = cmd_read_reg;
    assign counter = {{N{1'b0}}, counter_reg};
    assign done = reg_done;
    assign cmd_read_data = cmd_read_data_reg;

    always @(posedge clk) begin     // Load the seed into the register
        if (load_seed == 1'b1) begin
            seed_reg <= {data_upper, data_lower};
        end
    end

    always @(posedge clk) begin     // Load the polynomial into the register
        if (load_poly == 1'b1) begin
            poly_reg <= {data_upper, data_lower};
        end
    end

    always @(posedge clk) begin     // Load the region into the register
        if (load_counter == 1'b1) begin
            counter_reg <= des_counter;
        end
    end

    // Register for the output, last executed command
    always @(posedge clk) begin
        if (rst_n == 1'b0) begin   // Synchronous reset
            cmd_read_data_reg <= 32'h0;
        end
        else begin
            case (state)
            set_seed: begin
                cmd_read_data_reg <= CMD_READ_SEED;
            end
            set_poly: begin
                cmd_read_data_reg <= CMD_READ_POLY;
            end
            start_init: begin
                cmd_read_data_reg <= CMD_START;
            end
            restart: begin
                cmd_read_data_reg <= CMD_RESTART;
            end
            default: begin
                cmd_read_data_reg <= cmd_read_data_reg;
            end
            endcase
        end
    end

    
    // Synchronization logic for cmd_valid
    always @(posedge clk) begin     // Synchronization of incomming values from different clock domain
        
        if (rst_n == 1'b0) begin   // Reset
            cmd_valid_tmp <= 0;
            cmd_valid_reg <= 0;
        end

        cmd_valid_tmp <= cmd_valid;
        cmd_valid_reg <= cmd_valid_tmp;

    end
     
endmodule
