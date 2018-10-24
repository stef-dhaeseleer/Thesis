
module des_block_wrapper(
    input clk,              // clock
    input rst_n,            // reset, active low signal
    input cmd,              // input command
    input cmd_valid,        // input command valid
    input [15:0] data_in,   // input data to set the region of the DES block
    output cmd_read,        // signals that the input command has been read, input data also read
    output reg done,        // signals that the operations are done, output data also valid
    output [63:0] data_out  // ouput data for the counter value
    );
    
    // TODO: Add signals (1)
    // Create an enable signal and make start a pulse only
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

    reg [15:0] region_reg;
    reg [63:0] counter_reg;

    wire des_finished;

    wire [63:0] des_counter;

    // Parameters

    localparam CMD_READ_REGION  = 4'h0;     // Possible input commands
    localparam CMD_START        = 4'h1;
    localparam CMD_OUTPUT_READ  = 4'h2;

    localparam [3:0]    init            = 4'h0;     // Possible states
    //localparam [3:0]    receive_data    = 4'h1;
    localparam [3:0]    set_region      = 4'h2;
    localparam [3:0]    start           = 4'h3;
    localparam [3:0]    waiting         = 4'h4;
    localparam [3:0]    finishing       = 4'h5;
    localparam [3:0]    finished        = 4'h6;


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
                    CMD_OUTPUT_READ: 
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
                if (cmd == CMD_OUTPUT_READ) begin
                    next_state <= finished;
                end
            end 
        end
        finished: begin
            next_state <= init;
        end
        endcase

    end

    //---------------------------DATAPATH----------------------------------------------------------   

    des_block des_block (
        .clk            (clk          ),
        .rst_n          (rst_n        ),
        .start          (start_des    ),
        .region_select  (region_reg   ),
        .counter        (des_counter  ),
        .done           (des_finished ));

    assign cmd_read = cmd_read_reg;
    assign data_out = counter_reg;

    always @(*) begin   // Output logic

        load_region <= 1'b0;
        load_counter <= 1'b0;
        cmd_read_reg <= 1'b0;
        start_des <= 1'b0;
        done <= 1'b0;

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
            start_des <= 1'b1;
        end
        finishing: begin     // des block will re-init when we go back to init state here (and drop start value)
            done <= 1'b1;
            start_des <= 1'b1;  // Keep start up or counter will be reset
            load_counter <= 1'b1;
        end
        finished: begin
            done <= 1'b1;
            cmd_read_reg <= 1'b1;
        end
        endcase

    end

    always @(posedge clk) begin     // Load the region into the register
        if (load_region == 1'b1) begin
            region_reg <= data_in;
        end
    end

    always @(posedge clk) begin     // Load the region into the register
        if (load_counter == 1'b1) begin
            counter_reg <= des_counter;
        end
    end
     
endmodule