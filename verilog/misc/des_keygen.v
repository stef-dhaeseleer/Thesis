module des_keygen(
    input clk,              // clock
    input rst_n,            // reset, active low signal
    input start,            // signales the block to start working, valid data is on the input lines
    input [1:64] key,       // the input key for the key schedule
    output reg done,        // signals that the operations are done, valid result is on the output lines
    output reg out_valid,       // The output Kn value is valid currently
    output [1:48] Kn        // the outgoing key for iteration n
    );

    // Nets and regs
    reg [3:0] state, next_state;        // State variables

    reg [1:56] CD;      // Register containing C and D next to eachother (each 28 bits wide)

    reg [3:0] counter;  // Registers needed for the counter
    reg sync_rst, cnt_enable;

    // Parameters
    localparam [2:0]    init = 3'd0,    // Possible states
                        PC_1 = 3'd1,
                        key_gen_stage = 3'd2,
                        finished = 3'd3;

    // Functions
    function apply_PC_1_C;      // Permuted choice 1 for the key schedule, part for C
    input [1:64] data;          // The DES standard used, numbers the block bits from left to right
    reg [1:32] apply_PC_1_C;
    reg [1:32] tmp_data;
    begin
        tmp_data[1] = data[57];
        tmp_data[2] = data[49];
        tmp_data[3] = data[41];
        tmp_data[4] = data[33];
        tmp_data[5] = data[25];
        tmp_data[6] = data[17];
        tmp_data[7] = data[9];

        tmp_data[8] = data[1];
        tmp_data[9] = data[58];
        tmp_data[10] = data[50];
        tmp_data[11] = data[42];
        tmp_data[12] = data[34];
        tmp_data[13] = data[26];
        tmp_data[14] = data[18];

        tmp_data[15] = data[10];
        tmp_data[16] = data[2];
        tmp_data[17] = data[59];
        tmp_data[18] = data[51];
        tmp_data[19] = data[43];
        tmp_data[20] = data[35];
        tmp_data[21] = data[27];

        tmp_data[22] = data[19];
        tmp_data[23] = data[11];
        tmp_data[24] = data[3];
        tmp_data[25] = data[60];
        tmp_data[26] = data[52];
        tmp_data[27] = data[44];
        tmp_data[28] = data[36];

        apply_PC_1_C = tmp_data;    // Assign the permutated data to the output
    end
    endfunction

    function apply_PC_1_D;      // Permuted choice 1 for the key schedule, part for D
    input [1:64] data;          // The DES standard used, numbers the block bits from left to right
    reg [1:32] apply_PC_1_D;
    reg [1:32] tmp_data;
    begin
        tmp_data[1] = data[63];
        tmp_data[2] = data[55];
        tmp_data[3] = data[47];
        tmp_data[4] = data[39];
        tmp_data[5] = data[31];
        tmp_data[6] = data[23];
        tmp_data[7] = data[15];

        tmp_data[8] = data[7];
        tmp_data[9] = data[62];
        tmp_data[10] = data[54];
        tmp_data[11] = data[46];
        tmp_data[12] = data[38];
        tmp_data[13] = data[30];
        tmp_data[14] = data[22];

        tmp_data[15] = data[14];
        tmp_data[16] = data[6];
        tmp_data[17] = data[61];
        tmp_data[18] = data[53];
        tmp_data[19] = data[45];
        tmp_data[20] = data[37];
        tmp_data[21] = data[29];

        tmp_data[22] = data[21];
        tmp_data[23] = data[13];
        tmp_data[24] = data[5];
        tmp_data[25] = data[28];
        tmp_data[26] = data[20];
        tmp_data[27] = data[12];
        tmp_data[28] = data[4];

        apply_PC_1_D = tmp_data;    // Assign the permutated data to the output
    end
    endfunction

    function apply_PC_2;        // Permuted choice 2 for the key schedule
    input [1:56] data;          // The DES standard used, numbers the block bits from left to right
    reg [1:48] apply_PC_2;
    reg [1:48] tmp_data;
    begin
        tmp_data[1] = data[14];
        tmp_data[2] = data[17];
        tmp_data[3] = data[11];
        tmp_data[4] = data[24];
        tmp_data[5] = data[1];
        tmp_data[6] = data[5];

        tmp_data[7] = data[3];
        tmp_data[8] = data[28];
        tmp_data[9] = data[15];
        tmp_data[10] = data[6];
        tmp_data[11] = data[21];
        tmp_data[12] = data[10];

        tmp_data[13] = data[23];
        tmp_data[14] = data[19];
        tmp_data[15] = data[12];
        tmp_data[16] = data[4];
        tmp_data[17] = data[26];
        tmp_data[18] = data[8];

        tmp_data[19] = data[16];
        tmp_data[20] = data[7];
        tmp_data[21] = data[27];
        tmp_data[22] = data[20];
        tmp_data[23] = data[13];
        tmp_data[24] = data[2];

        tmp_data[25] = data[41];
        tmp_data[26] = data[52];
        tmp_data[27] = data[31];
        tmp_data[28] = data[37];
        tmp_data[29] = data[47];
        tmp_data[30] = data[55];

        tmp_data[31] = data[30];
        tmp_data[32] = data[40];
        tmp_data[33] = data[51];
        tmp_data[34] = data[45];
        tmp_data[35] = data[33];
        tmp_data[36] = data[48];

        tmp_data[37] = data[44];
        tmp_data[38] = data[49];
        tmp_data[39] = data[39];
        tmp_data[40] = data[56];
        tmp_data[41] = data[34];
        tmp_data[42] = data[53];

        tmp_data[43] = data[46];
        tmp_data[44] = data[42];
        tmp_data[45] = data[50];
        tmp_data[46] = data[36];
        tmp_data[47] = data[29];
        tmp_data[48] = data[32];

        apply_PC_2 = tmp_data;  // Assign the permutated data to the output
    end
    endfunction

    //---------------------------FSM---------------------------------------------------------------

    always @(posedge clk or negedge rst_n) begin // State register
        if (rst_n == 1'b0) begin   // Asynchronous reset
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
            if (start == 1'b1)
                state <= PC_1;
        end
        PC_1: begin
            next_state <= key_gen_stage;
        end
        key_gen_stage: begin
            next_state <= key_gen_stage;
            if (counter == 4'd15) begin
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

    // Counter
    always @(posedge clk or negedge rst_n) begin
        if (sync_rst == 1'b1 || rst_n == 1'b0) begin
            counter <= 4'd0;
        end
        else if (cnt_enable == 1'b1) begin
            counter <= counter + 1;
        end
    end

    always @(*) begin // Output logic. Signals to set: done, sync_rst, cnt_enable, out_valid
        done <= 1'b0;
        sync_rst <= 1'b0;
        cnt_enable <= 1'b0;
        out_valid <= 1'b0;

        case (state)
            init: begin
                sync_rst <= 1'b1;   // Reset the counter value
            end

            PC_1: begin     // Apply PC_1 to the input key and save in reg CD
                CD[1:28]<= apply_PC_1_C(key); // C part
                CD[29:56]<= apply_PC_1_D(key); // D part
            end

            key_gen_stage: begin
                cnt_enable <= 1'b1;
                out_valid <= 1'b1;

                case(counter)   // Case statement for applying the shifts to the C and D registers
                    4'd0: begin // 1 shift
                        CD <= {CD[2:28], CD[1], CD[30:56], CD[29]};
                    end
                    4'd1: begin // 1 shift
                        CD <= {CD[2:28], CD[1], CD[30:56], CD[29]};
                    end
                    4'd2: begin // 2 shifts
                        CD <= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
                    end
                    4'd3: begin // 2 shifts
                        CD <= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
                    end
                    4'd4: begin // 2 shifts
                        CD <= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
                    end
                    4'd5: begin // 2 shifts
                        CD <= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
                    end
                    4'd6: begin // 2 shifts
                        CD <= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
                    end
                    4'd7: begin // 2 shifts
                        CD <= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
                    end
                    4'd8: begin // 1 shift
                        CD <= {CD[2:28], CD[1], CD[30:56], CD[29]};
                    end
                    4'd9: begin // 2 shifts
                        CD <= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
                    end
                    4'd10: begin // 2 shifts
                        CD <= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
                    end
                    4'd11: begin // 2 shifts
                        CD <= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
                    end
                    4'd12: begin // 2 shifts
                        CD <= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
                    end
                    4'd13: begin // 2 shifts
                        CD <= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
                    end
                    4'd14: begin // 2 shifts
                        CD <= {CD[3:28], CD[1:2], CD[31:56], CD[29:30]};
                    end
                    4'd15: begin // 1 shift
                        CD <= {CD[2:28], CD[1], CD[30:56], CD[29]};
                    end
                endcase;

            end

            finished: begin
                done <= 1'b1;
                
            end
        endcase;
    end

    assign Kn = apply_PC_2(CD); // Assign the key of the current iteration to the output

endmodule