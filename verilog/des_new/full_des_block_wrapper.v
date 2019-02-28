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
    reg [63:0] input_mask_reg;
    reg [63:0] output_mask_reg;
    reg [63:0] counter_limit_reg;

    //reg [31:0] cmd_read_data_reg;
    reg [63:0] counter_reg;
    
    wire des_finished;

    wire [63-N:0] des_counter;

    reg [1:48] round_key1;
    reg [1:48] round_key2; 
    reg [1:48] round_key3; 
    reg [1:48] round_key4;
    reg [1:48] round_key5;
    reg [1:48] round_key6; 
    reg [1:48] round_key7; 
    reg [1:48] round_key8;
    reg [1:48] round_key9;
    reg [1:48] round_key10;    
    reg [1:48] round_key11;    
    reg [1:48] round_key12;
    reg [1:48] round_key13;
    reg [1:48] round_key14;    
    reg [1:48] round_key15;    
    reg [1:48] round_key16;

    wire [767:0] round_keys;

    // Parameters

    localparam STATE_BITS = 6;

    localparam CMD_READ_SEED            = 6'h1;     // Possible input commands
    localparam CMD_READ_POLY            = 6'h2;
    localparam CMD_READ_INPUT_MASK      = 6'h3;
    localparam CMD_READ_OUTPUT_MASK     = 6'h4;
    localparam CMD_READ_COUNTER_LIMIT   = 6'h5;
    localparam CMD_READ_ROUNDKEY        = 6'h6;
    localparam CMD_START                = 6'h7;
    localparam CMD_RESTART              = 6'h8;

    localparam [STATE_BITS-1:0]    init                = 6'h0;     // Possible states
    localparam [STATE_BITS-1:0]    set_seed            = 6'h1;
    localparam [STATE_BITS-1:0]    set_poly            = 6'h2;
    localparam [STATE_BITS-1:0]    start               = 6'h3;
    localparam [STATE_BITS-1:0]    waiting             = 6'h4;
    localparam [STATE_BITS-1:0]    finishing           = 6'h5;
    localparam [STATE_BITS-1:0]    restart             = 6'h6;
    localparam [STATE_BITS-1:0]    start_init          = 6'h7;
    localparam [STATE_BITS-1:0]    set_input_mask      = 6'h8;
    localparam [STATE_BITS-1:0]    set_output_mask     = 6'h9;
    localparam [STATE_BITS-1:0]    set_counter_limit   = 6'hA;
    localparam [STATE_BITS-1:0]    set_roundkey_init   = 6'hB;
    localparam [STATE_BITS-1:0]    set_roundkey_done   = 6'hC;
    
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
                    CMD_READ_INPUT_MASK:
                        next_state <= set_input_mask;
                    CMD_READ_OUTPUT_MASK:
                        next_state <= set_output_mask;
                    CMD_READ_COUNTER_LIMIT:
                        next_state <= set_counter_limit;
                    CMD_READ_ROUNDKEY:
                        next_state <= set_roundkey_init;
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
        set_input_mask: begin   // Sets the signal to load the input mask into a register, then listen for commands again
            next_state <= set_input_mask;
            if (cmd_valid_reg == 1'b0) begin
                next_state <= init;
            end
        end
        set_output_mask: begin   // Sets the signal to load the output mask into a register, then listen for commands again
            next_state <= set_output_mask;
            if (cmd_valid_reg == 1'b0) begin
                next_state <= init;
            end
        end
        set_counter_limit: begin   // Sets the signal to load the counter limit into a register, then listen for commands again
            next_state <= set_counter_limit;
            if (cmd_valid_reg == 1'b0) begin
                next_state <= init;
            end
        end
        set_roundkey_init: begin   // Sets the signal to load the round key into a register and shift the keys around, do this only one cycle
            next_state <= set_roundkey_done;
        end
        set_roundkey_done: begin   // Output cmd_read here and wait untill acked
            next_state <= set_roundkey_done;
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

        load_seed           <= 1'b0;
        load_poly           <= 1'b0;
        load_input_mask     <= 1'b0;
        load_output_mask    <= 1'b0;
        load_counter_limit  <= 1'b0;
        load_roundkey       <= 1'b0;
        load_counter        <= 1'b0;
        cmd_read_reg        <= 1'b0;
        start_des           <= 1'b0;
        reg_done            <= 1'b0;

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
        set_input_mask: begin
            load_input_mask <= 1'b1;
            cmd_read_reg <= 1'b1;
        end
        set_output_mask: begin
            load_output_mask <= 1'b1;
            cmd_read_reg <= 1'b1;
        end
        set_counter_limit: begin
            load_counter_limit <= 1'b1;
            cmd_read_reg <= 1'b1;
        end
        set_roundkey_init: begin    // Load only for one cycle
            load_roundkey <= 1'b1;
        end
        set_roundkey_done: begin    // Then output done for the rest
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
        .clk            (clk               ),
        .rst_n          (rst_n             ),
        .start          (start_des         ),
        .restart_block  (restart_block     ),
        .seed           (seed_reg          ),
        .polynomial     (poly_reg          ),
        .mask_i         (input_mask_reg    ),
        .mask_o         (input_mask_reg    ),
        .counter_limit  (counter_limit_reg ),
        .round_keys     (round_keys        ),
        .counter        (des_counter       ),
        .done           (des_finished      ));

    assign cmd_read = cmd_read_reg;
    assign counter = {{N{1'b0}}, counter_reg};
    assign done = reg_done;
    assign cmd_read_data = cmd_read_data_reg;
    assign round_keys = {round_key1, round_key2, round_key3, round_key4, round_key5, round_key6, round_key7, round_key8, round_key9, round_key10, round_key11, round_key12, round_key13, round_key14, round_key15, round_key16};

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

    always @(posedge clk) begin     // Load the input mask into the register
        if (load_input_mask == 1'b1) begin
            input_mask_reg <= {data_upper, data_lower};
        end
    end

    always @(posedge clk) begin     // Load the output mask into the register
        if (load_output_mask == 1'b1) begin
            output_mask_reg <= {data_upper, data_lower};
        end
    end

    always @(posedge clk) begin     // Load the counter limit into the register
        if (load_counter_limit == 1'b1) begin
            counter_limit_reg <= {data_upper, data_lower};
        end
    end

    always @(posedge clk) begin     // Load the counter into the register
        if (load_counter == 1'b1) begin
            counter_reg <= des_counter;
        end
    end

    always @(posedge clk) begin     // Load the counter limit into the register
        if (load_roundkey == 1'b1) begin
            //round_key1 <= {data_upper[15:0], data_lower}; // This loads key16 first
            //round_key2 <= round_key1;
            //round_key3 <= round_key2;
            //round_key4 <= round_key3;
            //round_key5 <= round_key4;
            //round_key6 <= round_key5;
            //round_key7 <= round_key6;
            //round_key8 <= round_key7;
            //round_key9 <= round_key8;
            //round_key10 <= round_key9;
            //round_key11 <= round_key10;
            //round_key12 <= round_key11;
            //round_key13 <= round_key12;
            //round_key14 <= round_key13;
            //round_key15 <= round_key14;
            //round_key16 <= round_key15;

            round_key16 <= {data_upper[15:0], data_lower};  // This loads key1 first (more logical order)
            round_key15 <= round_key16;
            round_key14 <= round_key15;
            round_key13 <= round_key14;
            round_key12 <= round_key13;
            round_key11 <= round_key12;
            round_key10 <= round_key11;
            round_key9 <= round_key10;
            round_key8 <= round_key9;
            round_key7 <= round_key8;
            round_key6 <= round_key7;
            round_key5 <= round_key6;
            round_key4 <= round_key5;
            round_key3 <= round_key4;
            round_key2 <= round_key3;
            round_key1 <= round_key2;
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
