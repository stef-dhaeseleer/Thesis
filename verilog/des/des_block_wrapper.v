//`include "des/des_block.v"

module des_block_wrapper(
    input clk,                  // clock
    input rst_n,                // reset, active low signal
    input cmd,                  // input command
    input cmd_valid,            // input command valid
    input advance_test_cmd,
    input [15:0] region,       // input data to set the region of the DES block
    output cmd_read,            // signals that the input command has been read, input data also read
    output test_res_ready,      
    output done,            // signals that the operations are done, output data also valid
    output [63:0] counter,      // counter output for the CPU
    output [63:0] ciphertext    // ciphertext output for the CPU
    );
    
    // TODO: Add signals (1)
    // Create an output for the cipher text for testing purposes (routed from the des block output)
    // Will take an input to see if we are in test mode (flag to the des block)
    // Will generate a signal to the des block to advance the test one step when data has been read by the CPU

    // TODO: add more registers to AXI, each piece of data its own (1)
    // Add signals to see if the data has been read by the CPU

    // TODO: should be able to set the key from the CPU: but this will be a lot of bits... (1)

    // Nets and regs
    reg [1:0] state, next_state;        // State variables

    reg load_region;
    reg cmd_read_reg;
    reg start_des;
    reg load_counter;
    reg restart_block;
    reg test_enabled;
    reg test_advance;
    reg reg_test_res_ready;
    reg reg_done;

    reg [15:0] region_reg;
    reg [63:0] counter_reg;

    wire des_finished;
    wire des_test_data_valid;

    wire [47:0] des_counter;
    wire [63:0] ciphertext_out;

    // Parameters

    localparam CMD_READ_REGION  = 4'h0;     // Possible input commands
    localparam CMD_START        = 4'h1;
    localparam CMD_TEST_MODE    = 4'h2;
    localparam CMD_RESTART      = 4'h3;

    localparam [3:0]    init            = 4'h0;     // Possible states
    localparam [3:0]    set_region      = 4'h1;
    localparam [3:0]    start           = 4'h2;
    localparam [3:0]    waiting         = 4'h3;
    localparam [3:0]    finishing       = 4'h4;
    localparam [3:0]    restart         = 4'h5;
    localparam [3:0]    test_mode       = 4'h6;
    localparam [3:0]    advance_test    = 4'h7;

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
            if (cmd_valid==1'b1) begin
                //Decode the command received on Port1
                case (cmd)
                    CMD_READ_REGION:
                        next_state <= set_region;
                    CMD_START:                            
                        next_state <= start;
                    CMD_TEST_MODE: 
                        next_state <= test_mode;
                    CMD_RESTART:
                        next_state <= init;
                    default:
                        next_state <= state;
                endcase
            end
            else begin  // If no new command is received
                next_state <= state;
            end
        end
        set_region: begin   // Sets the signal to load the region into a register, than listen for commands again
            next_state <= init;
        end
        start: begin    // Sets the start signal for the des block
            next_state <= waiting;
        end
        waiting: begin  // Keeps the start signal for the des block up and waits for it to finish
            next_state <= waiting;

            if (des_finished == 1'b1) begin
                next_state <= finishing;
            end
        end
        finishing: begin     // Signal that we are done, set output data and wait for data read
            next_state <= finishing;

            if (cmd_valid==1'b1) begin
                if (cmd == CMD_RESTART) begin
                    next_state <= restart;
                end
            end 
        end
        test_mode: begin     // Signal that we are done, set output data and wait for data read
            next_state <= test_mode;

            if (cmd_valid==1'b1) begin
                if (cmd == CMD_RESTART) begin
                    next_state <= restart;
                end
            end 

            if (advance_test_cmd == 1'b1) begin
                next_state <= advance_test;
            end
        end
        advance_test: begin
            next_state <= test_mode;
        end
        restart: begin
            next_state <= init;
        end
        endcase

    end

    always @(*) begin   // Output logic

        load_region <= 1'b0;
        load_counter <= 1'b0;
        cmd_read_reg <= 1'b0;
        start_des <= 1'b0;
        reg_done <= 1'b0;

        restart_block <= 1'b0;
        test_enabled <= 1'b0;
        test_advance <= 1'b0;
        reg_test_res_ready <= 1'b1;

        case (state)
        init: begin

        end
        set_region: begin
            load_region <= 1'b1;
            cmd_read_reg <= 1'b1;
        end
        start: begin
            start_des <= 1'b1;
            cmd_read_reg <= 1'b1;
        end
        waiting: begin

        end
        finishing: begin
            reg_done <= 1'b1;
            load_counter <= 1'b1;
        end
        test_mode: begin
            test_enabled <= 1'b1;

            if (des_test_data_valid == 1'b1) begin
                reg_test_res_ready <= 1'b1;
            end
        end
        advance_test: begin
            test_enabled <= 1'b1;
            test_advance <= 1'b1;
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
        .test_enabled   (test_enabled),
        .test_advance   (test_advance),
        .region_select  (region_reg   ),
        .test_data_valid(des_test_data_valid),
        .counter        (des_counter  ),
        .ciphertext_out (ciphertext_out),
        .done           (des_finished ));

    assign cmd_read = cmd_read_reg;
    assign counter = counter_reg;
    assign test_res_ready = reg_test_res_ready;
    assign done = reg_done;

    always @(posedge clk) begin     // Load the region into the register
        if (load_region == 1'b1) begin
            region_reg <= region;
        end
    end

    always @(posedge clk) begin     // Load the region into the register
        if (load_counter == 1'b1) begin
            counter_reg <= des_counter;
        end
    end
     
endmodule