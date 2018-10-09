
module s_boxes(
    input wire [1:48] data_i,           // input data for the S boxes
    output reg [1:32] data_o            // output data for the S boxes
    );

    // Look up tables for the S boxes

    // S1
    always @(*) begin
        case (data_i[1:6])

            // Row 0
            6'b000000: begin
                data_o[1:4] <= 4'd14; 
            end
            6'b000010: begin
                data_o[1:4] <= 4'd4; 
            end
            6'b000100: begin
                data_o[1:4] <= 4'd13; 
            end
            6'b000110: begin
                data_o[1:4] <= 4'd1; 
            end
            6'b001000: begin
                data_o[1:4] <= 4'd2; 
            end
            6'b001010: begin
                data_o[1:4] <= 4'd15; 
            end
            6'b001100: begin
                data_o[1:4] <= 4'd11; 
            end
            6'b001110: begin
                data_o[1:4] <= 4'd8; 
            end
            6'b010000: begin
                data_o[1:4] <= 4'd3; 
            end
            6'b010010: begin
                data_o[1:4] <= 4'd10; 
            end
            6'b010100: begin
                data_o[1:4] <= 4'd6; 
            end
            6'b010110: begin
                data_o[1:4] <= 4'd12; 
            end
            6'b011000: begin
                data_o[1:4] <= 4'd5; 
            end
            6'b011010: begin
                data_o[1:4] <= 4'd9; 
            end
            6'b011100: begin
                data_o[1:4] <= 4'd0; 
            end
            6'b011110: begin
                data_o[1:4] <= 4'd7; 
            end

            // Row 1
            6'b000001: begin
                data_o[1:4] <= 4'd0; 
            end
            6'b000011: begin
                data_o[1:4] <= 4'd15; 
            end
            6'b000101: begin
                data_o[1:4] <= 4'd7; 
            end
            6'b000111: begin
                data_o[1:4] <= 4'd4; 
            end
            6'b001001: begin
                data_o[1:4] <= 4'd14; 
            end
            6'b001011: begin
                data_o[1:4] <= 4'd2; 
            end
            6'b001101: begin
                data_o[1:4] <= 4'd13; 
            end
            6'b001111: begin
                data_o[1:4] <= 4'd1; 
            end
            6'b010001: begin
                data_o[1:4] <= 4'd10; 
            end
            6'b010011: begin
                data_o[1:4] <= 4'd6; 
            end
            6'b010101: begin
                data_o[1:4] <= 4'd12; 
            end
            6'b010111: begin
                data_o[1:4] <= 4'd11; 
            end
            6'b011001: begin
                data_o[1:4] <= 4'd9; 
            end
            6'b011011: begin
                data_o[1:4] <= 4'd5; 
            end
            6'b011101: begin
                data_o[1:4] <= 4'd3; 
            end
            6'b011111: begin
                data_o[1:4] <= 4'd8;
            end

            // Row 2
            6'b100000: begin
                data_o[1:4] <= 4'd4; 
            end
            6'b100010: begin
                data_o[1:4] <= 4'd1; 
            end
            6'b100100: begin
                data_o[1:4] <= 4'd14; 
            end
            6'b100110: begin
                data_o[1:4] <= 4'd8; 
            end
            6'b101000: begin
                data_o[1:4] <= 4'd13; 
            end
            6'b101010: begin
                data_o[1:4] <= 4'd6; 
            end
            6'b101100: begin
                data_o[1:4] <= 4'd2; 
            end
            6'b101110: begin
                data_o[1:4] <= 4'd11; 
            end
            6'b110000: begin
                data_o[1:4] <= 4'd15; 
            end
            6'b110010: begin
                data_o[1:4] <= 4'd12; 
            end
            6'b110100: begin
                data_o[1:4] <= 4'd9; 
            end
            6'b110110: begin
                data_o[1:4] <= 4'd7; 
            end
            6'b111000: begin
                data_o[1:4] <= 4'd3; 
            end
            6'b111010: begin
                data_o[1:4] <= 4'd10; 
            end
            6'b111100: begin
                data_o[1:4] <= 4'd5; 
            end
            6'b111110: begin
                data_o[1:4] <= 4'd0;
            end

            // Row 3
            6'b100001: begin
                data_o[1:4] <= 4'd15; 
            end
            6'b100011: begin
                data_o[1:4] <= 4'd12; 
            end
            6'b100101: begin
                data_o[1:4] <= 4'd8; 
            end
            6'b100111: begin
                data_o[1:4] <= 4'd2; 
            end
            6'b101001: begin
                data_o[1:4] <= 4'd4; 
            end
            6'b101011: begin
                data_o[1:4] <= 4'd9; 
            end
            6'b101101: begin
                data_o[1:4] <= 4'd1; 
            end
            6'b101111: begin
                data_o[1:4] <= 4'd7; 
            end
            6'b110001: begin
                data_o[1:4] <= 4'd5; 
            end
            6'b110011: begin
                data_o[1:4] <= 4'd11; 
            end
            6'b110101: begin
                data_o[1:4] <= 4'd3; 
            end
            6'b110111: begin
                data_o[1:4] <= 4'd14; 
            end
            6'b111001: begin
                data_o[1:4] <= 4'd10; 
            end
            6'b111011: begin
                data_o[1:4] <= 4'd0; 
            end
            6'b111101: begin
                data_o[1:4] <= 4'd6; 
            end
            6'b111111: begin
                data_o[1:4] <= 4'd13;
            end
        endcase
    end

    //////////////////////////////////////////////////////////////////////////////////////////

    // S2
    always @(*) begin
        case (data_i[7:12])

            // Row 0
            6'b000000: begin
                data_o[5:8] <= 4'd15; 
            end
            6'b000010: begin
                data_o[5:8] <= 4'd1; 
            end
            6'b000100: begin
                data_o[5:8] <= 4'd8;
            end
            6'b000110: begin
                data_o[5:8] <= 4'd14; 
            end
            6'b001000: begin
                data_o[5:8] <= 4'd6; 
            end
            6'b001010: begin
                data_o[5:8] <= 4'd11; 
            end
            6'b001100: begin
                data_o[5:8] <= 4'd3; 
            end
            6'b001110: begin
                data_o[5:8] <= 4'd4; 
            end
            6'b010000: begin
                data_o[5:8] <= 4'd9; 
            end
            6'b010010: begin
                data_o[5:8] <= 4'd7; 
            end
            6'b010100: begin
                data_o[5:8] <= 4'd2; 
            end
            6'b010110: begin
                data_o[5:8] <= 4'd13; 
            end
            6'b011000: begin
                data_o[5:8] <= 4'd12; 
            end
            6'b011010: begin
                data_o[5:8] <= 4'd0; 
            end
            6'b011100: begin
                data_o[5:8] <= 4'd5; 
            end
            6'b011110: begin
                data_o[5:8] <= 4'd10; 
            end

            // Row 1
            6'b000001: begin
                data_o[5:8] <= 4'd3; 
            end
            6'b000011: begin
                data_o[5:8] <= 4'd13; 
            end
            6'b000101: begin
                data_o[5:8] <= 4'd4; 
            end
            6'b000111: begin
                data_o[5:8] <= 4'd7; 
            end
            6'b001001: begin
                data_o[5:8] <= 4'd15; 
            end
            6'b001011: begin
                data_o[5:8] <= 4'd2; 
            end
            6'b001101: begin
                data_o[5:8] <= 4'd8; 
            end
            6'b001111: begin
                data_o[5:8] <= 4'd14; 
            end
            6'b010001: begin
                data_o[5:8] <= 4'd12; 
            end
            6'b010011: begin
                data_o[5:8] <= 4'd0; 
            end
            6'b010101: begin
                data_o[5:8] <= 4'd1; 
            end
            6'b010111: begin
                data_o[5:8] <= 4'd10; 
            end
            6'b011001: begin
                data_o[5:8] <= 4'd6; 
            end
            6'b011011: begin
                data_o[5:8] <= 4'd9; 
            end
            6'b011101: begin
                data_o[5:8] <= 4'd11; 
            end
            6'b011111: begin
                data_o[5:8] <= 4'd5;
            end

            // Row 2
            6'b100000: begin
                data_o[5:8] <= 4'd0; 
            end
            6'b100010: begin
                data_o[5:8] <= 4'd14; 
            end
            6'b100100: begin
                data_o[5:8] <= 4'd7; 
            end
            6'b100110: begin
                data_o[5:8] <= 4'd11; 
            end
            6'b101000: begin
                data_o[5:8] <= 4'd10; 
            end
            6'b101010: begin
                data_o[5:8] <= 4'd4; 
            end
            6'b101100: begin
                data_o[5:8] <= 4'd13; 
            end
            6'b101110: begin
                data_o[5:8] <= 4'd1; 
            end
            6'b110000: begin
                data_o[5:8] <= 4'd5; 
            end
            6'b110010: begin
                data_o[5:8] <= 4'd8; 
            end
            6'b110100: begin
                data_o[5:8] <= 4'd12; 
            end
            6'b110110: begin
                data_o[5:8] <= 4'd6; 
            end
            6'b111000: begin
                data_o[5:8] <= 4'd9; 
            end
            6'b111010: begin
                data_o[5:8] <= 4'd3; 
            end
            6'b111100: begin
                data_o[5:8] <= 4'd2; 
            end
            6'b111110: begin
                data_o[5:8] <= 4'd15;
            end

            // Row 3
            6'b100001: begin
                data_o[5:8] <= 4'd13; 
            end
            6'b100011: begin
                data_o[5:8] <= 4'd8; 
            end
            6'b100101: begin
                data_o[5:8] <= 4'd10; 
            end
            6'b100111: begin
                data_o[5:8] <= 4'd1; 
            end
            6'b101001: begin
                data_o[5:8] <= 4'd3; 
            end
            6'b101011: begin
                data_o[5:8] <= 4'd15; 
            end
            6'b101101: begin
                data_o[5:8] <= 4'd4; 
            end
            6'b101111: begin
                data_o[5:8] <= 4'd2; 
            end
            6'b110001: begin
                data_o[5:8] <= 4'd11; 
            end
            6'b110011: begin
                data_o[5:8] <= 4'd6; 
            end
            6'b110101: begin
                data_o[5:8] <= 4'd7; 
            end
            6'b110111: begin
                data_o[5:8] <= 4'd12; 
            end
            6'b111001: begin
                data_o[5:8] <= 4'd0; 
            end
            6'b111011: begin
                data_o[5:8] <= 4'd5; 
            end
            6'b111101: begin
                data_o[5:8] <= 4'd14; 
            end
            6'b111111: begin
                data_o[5:8] <= 4'd9;
            end
        endcase
    end

    //////////////////////////////////////////////////////////////////////////////////////////

    // S3
    always @(*) begin
        case (data_i[13:18])

            // Row 0
            6'b000000: begin
                data_o[9:12] <= 4'd10; 
            end
            6'b000010: begin
                data_o[9:12] <= 4'd0; 
            end
            6'b000100: begin
                data_o[9:12] <= 4'd9;
            end
            6'b000110: begin
                data_o[9:12] <= 4'd14; 
            end
            6'b001000: begin
                data_o[9:12] <= 4'd6; 
            end
            6'b001010: begin
                data_o[9:12] <= 4'd3; 
            end
            6'b001100: begin
                data_o[9:12] <= 4'd15; 
            end
            6'b001110: begin
                data_o[9:12] <= 4'd5; 
            end
            6'b010000: begin
                data_o[9:12] <= 4'd1; 
            end
            6'b010010: begin
                data_o[9:12] <= 4'd13; 
            end
            6'b010100: begin
                data_o[9:12] <= 4'd12; 
            end
            6'b010110: begin
                data_o[9:12] <= 4'd7; 
            end
            6'b011000: begin
                data_o[9:12] <= 4'd11; 
            end
            6'b011010: begin
                data_o[9:12] <= 4'd4; 
            end
            6'b011100: begin
                data_o[9:12] <= 4'd2; 
            end
            6'b011110: begin
                data_o[9:12] <= 4'd8; 
            end

            // Row 1
            6'b000001: begin
                data_o[9:12] <= 4'd13; 
            end
            6'b000011: begin
                data_o[9:12] <= 4'd7; 
            end
            6'b000101: begin
                data_o[9:12] <= 4'd0; 
            end
            6'b000111: begin
                data_o[9:12] <= 4'd9; 
            end
            6'b001001: begin
                data_o[9:12] <= 4'd3; 
            end
            6'b001011: begin
                data_o[9:12] <= 4'd4; 
            end
            6'b001101: begin
                data_o[9:12] <= 4'd6; 
            end
            6'b001111: begin
                data_o[9:12] <= 4'd10; 
            end
            6'b010001: begin
                data_o[9:12] <= 4'd2; 
            end
            6'b010011: begin
                data_o[9:12] <= 4'd8; 
            end
            6'b010101: begin
                data_o[9:12] <= 4'd5; 
            end
            6'b010111: begin
                data_o[9:12] <= 4'd14; 
            end
            6'b011001: begin
                data_o[9:12] <= 4'd12; 
            end
            6'b011011: begin
                data_o[9:12] <= 4'd11; 
            end
            6'b011101: begin
                data_o[9:12] <= 4'd15; 
            end
            6'b011111: begin
                data_o[9:12] <= 4'd1;
            end

            // Row 2
            6'b100000: begin
                data_o[9:12] <= 4'd13; 
            end
            6'b100010: begin
                data_o[9:12] <= 4'd6; 
            end
            6'b100100: begin
                data_o[9:12] <= 4'd4; 
            end
            6'b100110: begin
                data_o[9:12] <= 4'd9; 
            end
            6'b101000: begin
                data_o[9:12] <= 4'd8; 
            end
            6'b101010: begin
                data_o[9:12] <= 4'd15; 
            end
            6'b101100: begin
                data_o[9:12] <= 4'd3; 
            end
            6'b101110: begin
                data_o[9:12] <= 4'd0; 
            end
            6'b110000: begin
                data_o[9:12] <= 4'd11; 
            end
            6'b110010: begin
                data_o[9:12] <= 4'd1; 
            end
            6'b110100: begin
                data_o[9:12] <= 4'd2; 
            end
            6'b110110: begin
                data_o[9:12] <= 4'd12; 
            end
            6'b111000: begin
                data_o[9:12] <= 4'd5; 
            end
            6'b111010: begin
                data_o[9:12] <= 4'd10; 
            end
            6'b111100: begin
                data_o[9:12] <= 4'd14; 
            end
            6'b111110: begin
                data_o[9:12] <= 4'd7;
            end

            // Row 3
            6'b100001: begin
                data_o[9:12] <= 4'd1; 
            end
            6'b100011: begin
                data_o[9:12] <= 4'd10; 
            end
            6'b100101: begin
                data_o[9:12] <= 4'd13; 
            end
            6'b100111: begin
                data_o[9:12] <= 4'd0; 
            end
            6'b101001: begin
                data_o[9:12] <= 4'd6; 
            end
            6'b101011: begin
                data_o[9:12] <= 4'd9; 
            end
            6'b101101: begin
                data_o[9:12] <= 4'd8; 
            end
            6'b101111: begin
                data_o[9:12] <= 4'd7; 
            end
            6'b110001: begin
                data_o[9:12] <= 4'd4; 
            end
            6'b110011: begin
                data_o[9:12] <= 4'd15; 
            end
            6'b110101: begin
                data_o[9:12] <= 4'd14; 
            end
            6'b110111: begin
                data_o[9:12] <= 4'd3; 
            end
            6'b111001: begin
                data_o[9:12] <= 4'd11; 
            end
            6'b111011: begin
                data_o[9:12] <= 4'd5; 
            end
            6'b111101: begin
                data_o[9:12] <= 4'd2; 
            end
            6'b111111: begin
                data_o[9:12] <= 4'd12;
            end
        endcase
    end

    //////////////////////////////////////////////////////////////////////////////////////////

    // S4
    always @(*) begin
        case (data_i[19:24])

            // Row 0
            6'b000000: begin
                data_o[13:16] <= 4'd7; 
            end
            6'b000010: begin
                data_o[13:16] <= 4'd13; 
            end
            6'b000100: begin
                data_o[13:16] <= 4'd14;
            end
            6'b000110: begin
                data_o[13:16] <= 4'd3; 
            end
            6'b001000: begin
                data_o[13:16] <= 4'd0; 
            end
            6'b001010: begin
                data_o[13:16] <= 4'd6; 
            end
            6'b001100: begin
                data_o[13:16] <= 4'd9; 
            end
            6'b001110: begin
                data_o[13:16] <= 4'd10; 
            end
            6'b010000: begin
                data_o[13:16] <= 4'd1; 
            end
            6'b010010: begin
                data_o[13:16] <= 4'd2; 
            end
            6'b010100: begin
                data_o[13:16] <= 4'd8; 
            end
            6'b010110: begin
                data_o[13:16] <= 4'd5; 
            end
            6'b011000: begin
                data_o[13:16] <= 4'd11; 
            end
            6'b011010: begin
                data_o[13:16] <= 4'd12; 
            end
            6'b011100: begin
                data_o[13:16] <= 4'd4; 
            end
            6'b011110: begin
                data_o[13:16] <= 4'd15; 
            end

            // Row 1
            6'b000001: begin
                data_o[13:16] <= 4'd13; 
            end
            6'b000011: begin
                data_o[13:16] <= 4'd8; 
            end
            6'b000101: begin
                data_o[13:16] <= 4'd11; 
            end
            6'b000111: begin
                data_o[13:16] <= 4'd5; 
            end
            6'b001001: begin
                data_o[13:16] <= 4'd6; 
            end
            6'b001011: begin
                data_o[13:16] <= 4'd15; 
            end
            6'b001101: begin
                data_o[13:16] <= 4'd0; 
            end
            6'b001111: begin
                data_o[13:16] <= 4'd3; 
            end
            6'b010001: begin
                data_o[13:16] <= 4'd4; 
            end
            6'b010011: begin
                data_o[13:16] <= 4'd7; 
            end
            6'b010101: begin
                data_o[13:16] <= 4'd2; 
            end
            6'b010111: begin
                data_o[13:16] <= 4'd12; 
            end
            6'b011001: begin
                data_o[13:16] <= 4'd1; 
            end
            6'b011011: begin
                data_o[13:16] <= 4'd10; 
            end
            6'b011101: begin
                data_o[13:16] <= 4'd14; 
            end
            6'b011111: begin
                data_o[13:16] <= 4'd9;
            end

            // Row 2
            6'b100000: begin
                data_o[13:16] <= 4'd10; 
            end
            6'b100010: begin
                data_o[13:16] <= 4'd6; 
            end
            6'b100100: begin
                data_o[13:16] <= 4'd9; 
            end
            6'b100110: begin
                data_o[13:16] <= 4'd0; 
            end
            6'b101000: begin
                data_o[13:16] <= 4'd12; 
            end
            6'b101010: begin
                data_o[13:16] <= 4'd11; 
            end
            6'b101100: begin
                data_o[13:16] <= 4'd7; 
            end
            6'b101110: begin
                data_o[13:16] <= 4'd13; 
            end
            6'b110000: begin
                data_o[13:16] <= 4'd15; 
            end
            6'b110010: begin
                data_o[13:16] <= 4'd1; 
            end
            6'b110100: begin
                data_o[13:16] <= 4'd3; 
            end
            6'b110110: begin
                data_o[13:16] <= 4'd14; 
            end
            6'b111000: begin
                data_o[13:16] <= 4'd5; 
            end
            6'b111010: begin
                data_o[13:16] <= 4'd2; 
            end
            6'b111100: begin
                data_o[13:16] <= 4'd8; 
            end
            6'b111110: begin
                data_o[13:16] <= 4'd4;
            end

            // Row 3
            6'b100001: begin
                data_o[13:16] <= 4'd3; 
            end
            6'b100011: begin
                data_o[13:16] <= 4'd15; 
            end
            6'b100101: begin
                data_o[13:16] <= 4'd0; 
            end
            6'b100111: begin
                data_o[13:16] <= 4'd6; 
            end
            6'b101001: begin
                data_o[13:16] <= 4'd10; 
            end
            6'b101011: begin
                data_o[13:16] <= 4'd1; 
            end
            6'b101101: begin
                data_o[13:16] <= 4'd13; 
            end
            6'b101111: begin
                data_o[13:16] <= 4'd8; 
            end
            6'b110001: begin
                data_o[13:16] <= 4'd9; 
            end
            6'b110011: begin
                data_o[13:16] <= 4'd4; 
            end
            6'b110101: begin
                data_o[13:16] <= 4'd5; 
            end
            6'b110111: begin
                data_o[13:16] <= 4'd11; 
            end
            6'b111001: begin
                data_o[13:16] <= 4'd12; 
            end
            6'b111011: begin
                data_o[13:16] <= 4'd7; 
            end
            6'b111101: begin
                data_o[13:16] <= 4'd2; 
            end
            6'b111111: begin
                data_o[13:16] <= 4'd14;
            end
        endcase
    end

    //////////////////////////////////////////////////////////////////////////////////////////

    // S5
    always @(*) begin
        case (data_i[25:30])

            // Row 0
            6'b000000: begin
                data_o[17:20] <= 4'd2; 
            end
            6'b000010: begin
                data_o[17:20] <= 4'd12; 
            end
            6'b000100: begin
                data_o[17:20] <= 4'd4;
            end
            6'b000110: begin
                data_o[17:20] <= 4'd1; 
            end
            6'b001000: begin
                data_o[17:20] <= 4'd7; 
            end
            6'b001010: begin
                data_o[17:20] <= 4'd10; 
            end
            6'b001100: begin
                data_o[17:20] <= 4'd11; 
            end
            6'b001110: begin
                data_o[17:20] <= 4'd6; 
            end
            6'b010000: begin
                data_o[17:20] <= 4'd8; 
            end
            6'b010010: begin
                data_o[17:20] <= 4'd5; 
            end
            6'b010100: begin
                data_o[17:20] <= 4'd3; 
            end
            6'b010110: begin
                data_o[17:20] <= 4'd15; 
            end
            6'b011000: begin
                data_o[17:20] <= 4'd13; 
            end
            6'b011010: begin
                data_o[17:20] <= 4'd0; 
            end
            6'b011100: begin
                data_o[17:20] <= 4'd14; 
            end
            6'b011110: begin
                data_o[17:20] <= 4'd9; 
            end

            // Row 1
            6'b000001: begin
                data_o[17:20] <= 4'd14; 
            end
            6'b000011: begin
                data_o[17:20] <= 4'd11; 
            end
            6'b000101: begin
                data_o[17:20] <= 4'd2; 
            end
            6'b000111: begin
                data_o[17:20] <= 4'd12; 
            end
            6'b001001: begin
                data_o[17:20] <= 4'd4; 
            end
            6'b001011: begin
                data_o[17:20] <= 4'd7; 
            end
            6'b001101: begin
                data_o[17:20] <= 4'd13; 
            end
            6'b001111: begin
                data_o[17:20] <= 4'd1; 
            end
            6'b010001: begin
                data_o[17:20] <= 4'd5; 
            end
            6'b010011: begin
                data_o[17:20] <= 4'd0; 
            end
            6'b010101: begin
                data_o[17:20] <= 4'd15; 
            end
            6'b010111: begin
                data_o[17:20] <= 4'd10; 
            end
            6'b011001: begin
                data_o[17:20] <= 4'd3; 
            end
            6'b011011: begin
                data_o[17:20] <= 4'd9; 
            end
            6'b011101: begin
                data_o[17:20] <= 4'd8; 
            end
            6'b011111: begin
                data_o[17:20] <= 4'd6;
            end

            // Row 2
            6'b100000: begin
                data_o[17:20] <= 4'd4; 
            end
            6'b100010: begin
                data_o[17:20] <= 4'd2; 
            end
            6'b100100: begin
                data_o[17:20] <= 4'd1; 
            end
            6'b100110: begin
                data_o[17:20] <= 4'd11; 
            end
            6'b101000: begin
                data_o[17:20] <= 4'd10; 
            end
            6'b101010: begin
                data_o[17:20] <= 4'd13; 
            end
            6'b101100: begin
                data_o[17:20] <= 4'd7; 
            end
            6'b101110: begin
                data_o[17:20] <= 4'd8; 
            end
            6'b110000: begin
                data_o[17:20] <= 4'd15; 
            end
            6'b110010: begin
                data_o[17:20] <= 4'd9; 
            end
            6'b110100: begin
                data_o[17:20] <= 4'd12; 
            end
            6'b110110: begin
                data_o[17:20] <= 4'd5; 
            end
            6'b111000: begin
                data_o[17:20] <= 4'd6; 
            end
            6'b111010: begin
                data_o[17:20] <= 4'd3; 
            end
            6'b111100: begin
                data_o[17:20] <= 4'd0; 
            end
            6'b111110: begin
                data_o[17:20] <= 4'd14;
            end

            // Row 3
            6'b100001: begin
                data_o[17:20] <= 4'd11; 
            end
            6'b100011: begin
                data_o[17:20] <= 4'd8; 
            end
            6'b100101: begin
                data_o[17:20] <= 4'd12; 
            end
            6'b100111: begin
                data_o[17:20] <= 4'd7; 
            end
            6'b101001: begin
                data_o[17:20] <= 4'd1; 
            end
            6'b101011: begin
                data_o[17:20] <= 4'd14; 
            end
            6'b101101: begin
                data_o[17:20] <= 4'd2; 
            end
            6'b101111: begin
                data_o[17:20] <= 4'd13; 
            end
            6'b110001: begin
                data_o[17:20] <= 4'd6; 
            end
            6'b110011: begin
                data_o[17:20] <= 4'd15; 
            end
            6'b110101: begin
                data_o[17:20] <= 4'd0; 
            end
            6'b110111: begin
                data_o[17:20] <= 4'd9; 
            end
            6'b111001: begin
                data_o[17:20] <= 4'd10; 
            end
            6'b111011: begin
                data_o[17:20] <= 4'd4; 
            end
            6'b111101: begin
                data_o[17:20] <= 4'd5; 
            end
            6'b111111: begin
                data_o[17:20] <= 4'd3;
            end
        endcase
    end

    //////////////////////////////////////////////////////////////////////////////////////////

    // S6
    always @(*) begin
        case (data_i[31:36])

            // Row 0
            6'b000000: begin
                data_o[21:24] <= 4'd12; 
            end
            6'b000010: begin
                data_o[21:24] <= 4'd1; 
            end
            6'b000100: begin
                data_o[21:24] <= 4'd10;
            end
            6'b000110: begin
                data_o[21:24] <= 4'd15; 
            end
            6'b001000: begin
                data_o[21:24] <= 4'd9; 
            end
            6'b001010: begin
                data_o[21:24] <= 4'd2; 
            end
            6'b001100: begin
                data_o[21:24] <= 4'd6; 
            end
            6'b001110: begin
                data_o[21:24] <= 4'd8; 
            end
            6'b010000: begin
                data_o[21:24] <= 4'd0; 
            end
            6'b010010: begin
                data_o[21:24] <= 4'd13; 
            end
            6'b010100: begin
                data_o[21:24] <= 4'd3; 
            end
            6'b010110: begin
                data_o[21:24] <= 4'd4; 
            end
            6'b011000: begin
                data_o[21:24] <= 4'd14; 
            end
            6'b011010: begin
                data_o[21:24] <= 4'd7; 
            end
            6'b011100: begin
                data_o[21:24] <= 4'd5; 
            end
            6'b011110: begin
                data_o[21:24] <= 4'd11; 
            end

            // Row 1
            6'b000001: begin
                data_o[21:24] <= 4'd10; 
            end
            6'b000011: begin
                data_o[21:24] <= 4'd15; 
            end
            6'b000101: begin
                data_o[21:24] <= 4'd4; 
            end
            6'b000111: begin
                data_o[21:24] <= 4'd2; 
            end
            6'b001001: begin
                data_o[21:24] <= 4'd7; 
            end
            6'b001011: begin
                data_o[21:24] <= 4'd12; 
            end
            6'b001101: begin
                data_o[21:24] <= 4'd9; 
            end
            6'b001111: begin
                data_o[21:24] <= 4'd5; 
            end
            6'b010001: begin
                data_o[21:24] <= 4'd6; 
            end
            6'b010011: begin
                data_o[21:24] <= 4'd1; 
            end
            6'b010101: begin
                data_o[21:24] <= 4'd13; 
            end
            6'b010111: begin
                data_o[21:24] <= 4'd14; 
            end
            6'b011001: begin
                data_o[21:24] <= 4'd0; 
            end
            6'b011011: begin
                data_o[21:24] <= 4'd11; 
            end
            6'b011101: begin
                data_o[21:24] <= 4'd3; 
            end
            6'b011111: begin
                data_o[21:24] <= 4'd8;
            end

            // Row 2
            6'b100000: begin
                data_o[21:24] <= 4'd9; 
            end
            6'b100010: begin
                data_o[21:24] <= 4'd14; 
            end
            6'b100100: begin
                data_o[21:24] <= 4'd15; 
            end
            6'b100110: begin
                data_o[21:24] <= 4'd5; 
            end
            6'b101000: begin
                data_o[21:24] <= 4'd2; 
            end
            6'b101010: begin
                data_o[21:24] <= 4'd8; 
            end
            6'b101100: begin
                data_o[21:24] <= 4'd12; 
            end
            6'b101110: begin
                data_o[21:24] <= 4'd3; 
            end
            6'b110000: begin
                data_o[21:24] <= 4'd7; 
            end
            6'b110010: begin
                data_o[21:24] <= 4'd0; 
            end
            6'b110100: begin
                data_o[21:24] <= 4'd4; 
            end
            6'b110110: begin
                data_o[21:24] <= 4'd10; 
            end
            6'b111000: begin
                data_o[21:24] <= 4'd1; 
            end
            6'b111010: begin
                data_o[21:24] <= 4'd13; 
            end
            6'b111100: begin
                data_o[21:24] <= 4'd11; 
            end
            6'b111110: begin
                data_o[21:24] <= 4'd6;
            end

            // Row 3
            6'b100001: begin
                data_o[21:24] <= 4'd4; 
            end
            6'b100011: begin
                data_o[21:24] <= 4'd3; 
            end
            6'b100101: begin
                data_o[21:24] <= 4'd2; 
            end
            6'b100111: begin
                data_o[21:24] <= 4'd12; 
            end
            6'b101001: begin
                data_o[21:24] <= 4'd9; 
            end
            6'b101011: begin
                data_o[21:24] <= 4'd5; 
            end
            6'b101101: begin
                data_o[21:24] <= 4'd15; 
            end
            6'b101111: begin
                data_o[21:24] <= 4'd10; 
            end
            6'b110001: begin
                data_o[21:24] <= 4'd11; 
            end
            6'b110011: begin
                data_o[21:24] <= 4'd14; 
            end
            6'b110101: begin
                data_o[21:24] <= 4'd1; 
            end
            6'b110111: begin
                data_o[21:24] <= 4'd7; 
            end
            6'b111001: begin
                data_o[21:24] <= 4'd6; 
            end
            6'b111011: begin
                data_o[21:24] <= 4'd0; 
            end
            6'b111101: begin
                data_o[21:24] <= 4'd8; 
            end
            6'b111111: begin
                data_o[21:24] <= 4'd13;
            end
        endcase
    end

    //////////////////////////////////////////////////////////////////////////////////////////

    // S7
    always @(*) begin
        case (data_i[37:42])

            // Row 0
            6'b000000: begin
                data_o[25:28] <= 4'd4; 
            end
            6'b000010: begin
                data_o[25:28] <= 4'd11; 
            end
            6'b000100: begin
                data_o[25:28] <= 4'd2;
            end
            6'b000110: begin
                data_o[25:28] <= 4'd14; 
            end
            6'b001000: begin
                data_o[25:28] <= 4'd15; 
            end
            6'b001010: begin
                data_o[25:28] <= 4'd0; 
            end
            6'b001100: begin
                data_o[25:28] <= 4'd8; 
            end
            6'b001110: begin
                data_o[25:28] <= 4'd13; 
            end
            6'b010000: begin
                data_o[25:28] <= 4'd3; 
            end
            6'b010010: begin
                data_o[25:28] <= 4'd12; 
            end
            6'b010100: begin
                data_o[25:28] <= 4'd9; 
            end
            6'b010110: begin
                data_o[25:28] <= 4'd7; 
            end
            6'b011000: begin
                data_o[25:28] <= 4'd5; 
            end
            6'b011010: begin
                data_o[25:28] <= 4'd10; 
            end
            6'b011100: begin
                data_o[25:28] <= 4'd6; 
            end
            6'b011110: begin
                data_o[25:28] <= 4'd1; 
            end

            // Row 1
            6'b000001: begin
                data_o[25:28] <= 4'd13; 
            end
            6'b000011: begin
                data_o[25:28] <= 4'd0; 
            end
            6'b000101: begin
                data_o[25:28] <= 4'd11; 
            end
            6'b000111: begin
                data_o[25:28] <= 4'd7; 
            end
            6'b001001: begin
                data_o[25:28] <= 4'd4; 
            end
            6'b001011: begin
                data_o[25:28] <= 4'd9; 
            end
            6'b001101: begin
                data_o[25:28] <= 4'd1; 
            end
            6'b001111: begin
                data_o[25:28] <= 4'd10; 
            end
            6'b010001: begin
                data_o[25:28] <= 4'd14; 
            end
            6'b010011: begin
                data_o[25:28] <= 4'd3; 
            end
            6'b010101: begin
                data_o[25:28] <= 4'd5; 
            end
            6'b010111: begin
                data_o[25:28] <= 4'd12; 
            end
            6'b011001: begin
                data_o[25:28] <= 4'd2; 
            end
            6'b011011: begin
                data_o[25:28] <= 4'd15; 
            end
            6'b011101: begin
                data_o[25:28] <= 4'd8; 
            end
            6'b011111: begin
                data_o[25:28] <= 4'd6;
            end

            // Row 2
            6'b100000: begin
                data_o[25:28] <= 4'd1; 
            end
            6'b100010: begin
                data_o[25:28] <= 4'd4; 
            end
            6'b100100: begin
                data_o[25:28] <= 4'd11; 
            end
            6'b100110: begin
                data_o[25:28] <= 4'd13; 
            end
            6'b101000: begin
                data_o[25:28] <= 4'd12; 
            end
            6'b101010: begin
                data_o[25:28] <= 4'd3; 
            end
            6'b101100: begin
                data_o[25:28] <= 4'd7; 
            end
            6'b101110: begin
                data_o[25:28] <= 4'd14; 
            end
            6'b110000: begin
                data_o[25:28] <= 4'd10; 
            end
            6'b110010: begin
                data_o[25:28] <= 4'd15; 
            end
            6'b110100: begin
                data_o[25:28] <= 4'd6; 
            end
            6'b110110: begin
                data_o[25:28] <= 4'd8; 
            end
            6'b111000: begin
                data_o[25:28] <= 4'd0; 
            end
            6'b111010: begin
                data_o[25:28] <= 4'd5; 
            end
            6'b111100: begin
                data_o[25:28] <= 4'd9; 
            end
            6'b111110: begin
                data_o[25:28] <= 4'd2;
            end

            // Row 3
            6'b100001: begin
                data_o[25:28] <= 4'd6; 
            end
            6'b100011: begin
                data_o[25:28] <= 4'd11; 
            end
            6'b100101: begin
                data_o[25:28] <= 4'd13; 
            end
            6'b100111: begin
                data_o[25:28] <= 4'd8; 
            end
            6'b101001: begin
                data_o[25:28] <= 4'd1; 
            end
            6'b101011: begin
                data_o[25:28] <= 4'd4; 
            end
            6'b101101: begin
                data_o[25:28] <= 4'd10; 
            end
            6'b101111: begin
                data_o[25:28] <= 4'd7; 
            end
            6'b110001: begin
                data_o[25:28] <= 4'd9; 
            end
            6'b110011: begin
                data_o[25:28] <= 4'd5; 
            end
            6'b110101: begin
                data_o[25:28] <= 4'd0; 
            end
            6'b110111: begin
                data_o[25:28] <= 4'd15; 
            end
            6'b111001: begin
                data_o[25:28] <= 4'd14; 
            end
            6'b111011: begin
                data_o[25:28] <= 4'd2; 
            end
            6'b111101: begin
                data_o[25:28] <= 4'd3; 
            end
            6'b111111: begin
                data_o[25:28] <= 4'd12;
            end
        endcase
    end

    //////////////////////////////////////////////////////////////////////////////////////////

    // S8
    always @(*) begin
        case (data_i[43:48])

            // Row 0
            6'b000000: begin
                data_o[29:32] <= 4'd13; 
            end
            6'b000010: begin
                data_o[29:32] <= 4'd2; 
            end
            6'b000100: begin
                data_o[29:32] <= 4'd8;
            end
            6'b000110: begin
                data_o[29:32] <= 4'd4; 
            end
            6'b001000: begin
                data_o[29:32] <= 4'd6; 
            end
            6'b001010: begin
                data_o[29:32] <= 4'd15; 
            end
            6'b001100: begin
                data_o[29:32] <= 4'd11; 
            end
            6'b001110: begin
                data_o[29:32] <= 4'd1; 
            end
            6'b010000: begin
                data_o[29:32] <= 4'd10; 
            end
            6'b010010: begin
                data_o[29:32] <= 4'd9; 
            end
            6'b010100: begin
                data_o[29:32] <= 4'd3; 
            end
            6'b010110: begin
                data_o[29:32] <= 4'd14; 
            end
            6'b011000: begin
                data_o[29:32] <= 4'd5; 
            end
            6'b011010: begin
                data_o[29:32] <= 4'd0; 
            end
            6'b011100: begin
                data_o[29:32] <= 4'd12; 
            end
            6'b011110: begin
                data_o[29:32] <= 4'd7; 
            end

            // Row 1
            6'b000001: begin
                data_o[29:32] <= 4'd1; 
            end
            6'b000011: begin
                data_o[29:32] <= 4'd15; 
            end
            6'b000101: begin
                data_o[29:32] <= 4'd13; 
            end
            6'b000111: begin
                data_o[29:32] <= 4'd8; 
            end
            6'b001001: begin
                data_o[29:32] <= 4'd10; 
            end
            6'b001011: begin
                data_o[29:32] <= 4'd3; 
            end
            6'b001101: begin
                data_o[29:32] <= 4'd7; 
            end
            6'b001111: begin
                data_o[29:32] <= 4'd4; 
            end
            6'b010001: begin
                data_o[29:32] <= 4'd12; 
            end
            6'b010011: begin
                data_o[29:32] <= 4'd5; 
            end
            6'b010101: begin
                data_o[29:32] <= 4'd6; 
            end
            6'b010111: begin
                data_o[29:32] <= 4'd11; 
            end
            6'b011001: begin
                data_o[29:32] <= 4'd0; 
            end
            6'b011011: begin
                data_o[29:32] <= 4'd14; 
            end
            6'b011101: begin
                data_o[29:32] <= 4'd9; 
            end
            6'b011111: begin
                data_o[29:32] <= 4'd2;
            end

            // Row 2
            6'b100000: begin
                data_o[29:32] <= 4'd7; 
            end
            6'b100010: begin
                data_o[29:32] <= 4'd11; 
            end
            6'b100100: begin
                data_o[29:32] <= 4'd4; 
            end
            6'b100110: begin
                data_o[29:32] <= 4'd1; 
            end
            6'b101000: begin
                data_o[29:32] <= 4'd9; 
            end
            6'b101010: begin
                data_o[29:32] <= 4'd12; 
            end
            6'b101100: begin
                data_o[29:32] <= 4'd14; 
            end
            6'b101110: begin
                data_o[29:32] <= 4'd2; 
            end
            6'b110000: begin
                data_o[29:32] <= 4'd0; 
            end
            6'b110010: begin
                data_o[29:32] <= 4'd6; 
            end
            6'b110100: begin
                data_o[29:32] <= 4'd10; 
            end
            6'b110110: begin
                data_o[29:32] <= 4'd13; 
            end
            6'b111000: begin
                data_o[29:32] <= 4'd15; 
            end
            6'b111010: begin
                data_o[29:32] <= 4'd3; 
            end
            6'b111100: begin
                data_o[29:32] <= 4'd5; 
            end
            6'b111110: begin
                data_o[29:32] <= 4'd8;
            end

            // Row 3
            6'b100001: begin
                data_o[29:32] <= 4'd2; 
            end
            6'b100011: begin
                data_o[29:32] <= 4'd1; 
            end
            6'b100101: begin
                data_o[29:32] <= 4'd14; 
            end
            6'b100111: begin
                data_o[29:32] <= 4'd7; 
            end
            6'b101001: begin
                data_o[29:32] <= 4'd4; 
            end
            6'b101011: begin
                data_o[29:32] <= 4'd10; 
            end
            6'b101101: begin
                data_o[29:32] <= 4'd8; 
            end
            6'b101111: begin
                data_o[29:32] <= 4'd13; 
            end
            6'b110001: begin
                data_o[29:32] <= 4'd15; 
            end
            6'b110011: begin
                data_o[29:32] <= 4'd12; 
            end
            6'b110101: begin
                data_o[29:32] <= 4'd9; 
            end
            6'b110111: begin
                data_o[29:32] <= 4'd0; 
            end
            6'b111001: begin
                data_o[29:32] <= 4'd3; 
            end
            6'b111011: begin
                data_o[29:32] <= 4'd5; 
            end
            6'b111101: begin
                data_o[29:32] <= 4'd6; 
            end
            6'b111111: begin
                data_o[29:32] <= 4'd11;
            end
        endcase
    end

endmodule