function apply_E;		// Initial permutation
	input [1:32] data;	// The DES standard used, numbers the block bits from left to right
	reg [1:48] apply_E;
	reg [1:48] tmp_data;
	begin
		tmp_data[1] = data[32];
		tmp_data[2] = data[1];
		tmp_data[3] = data[2];
		tmp_data[4] = data[3];
		tmp_data[5] = data[4];
		tmp_data[6] = data[5];

		tmp_data[7] = data[4];
		tmp_data[8] = data[5];
		tmp_data[9] = data[6];
		tmp_data[10] = data[7];
		tmp_data[11] = data[8];
		tmp_data[12] = data[9];

		tmp_data[13] = data[8];
		tmp_data[14] = data[9];
		tmp_data[15] = data[10];
		tmp_data[16] = data[11];
		tmp_data[17] = data[12];
		tmp_data[18] = data[13];

		tmp_data[19] = data[12];
		tmp_data[20] = data[13];
		tmp_data[21] = data[14];
		tmp_data[22] = data[15];
		tmp_data[23] = data[16];
		tmp_data[24] = data[17];

		tmp_data[25] = data[16];
		tmp_data[26] = data[17];
		tmp_data[27] = data[18];
		tmp_data[28] = data[19];
		tmp_data[29] = data[20];
		tmp_data[30] = data[21];

		tmp_data[31] = data[20];
		tmp_data[32] = data[21];
		tmp_data[33] = data[22];
		tmp_data[34] = data[23];
		tmp_data[35] = data[24];
		tmp_data[36] = data[25];

		tmp_data[37] = data[24];
		tmp_data[38] = data[25];
		tmp_data[39] = data[26];
		tmp_data[40] = data[27];
		tmp_data[41] = data[28];
		tmp_data[42] = data[29];

		tmp_data[43] = data[28];
		tmp_data[44] = data[29];
		tmp_data[45] = data[30];
		tmp_data[46] = data[31];
		tmp_data[47] = data[32];
		tmp_data[48] = data[1];

		apply_E = tmp_data;	// Assign the permutated data to the output
	end
	endfunction

	function apply_P;		// Initial permutation
	input [1:32] data;	// The DES standard used, numbers the block bits from left to right
	reg [1:32] apply_P;
	reg [1:32] tmp_data;
	begin
		tmp_data[1] = data[16];
		tmp_data[2] = data[7];
		tmp_data[3] = data[20];
		tmp_data[4] = data[21];

		tmp_data[5] = data[29];
		tmp_data[6] = data[12];
		tmp_data[7] = data[28];
		tmp_data[8] = data[17];

		tmp_data[9] = data[1];
		tmp_data[10] = data[15];
		tmp_data[11] = data[23];
		tmp_data[12] = data[26];

		tmp_data[13] = data[5];
		tmp_data[14] = data[18];
		tmp_data[15] = data[31];
		tmp_data[16] = data[10];

		tmp_data[17] = data[2];
		tmp_data[18] = data[8];
		tmp_data[19] = data[24];
		tmp_data[20] = data[14];

		tmp_data[21] = data[32];
		tmp_data[22] = data[27];
		tmp_data[23] = data[3];
		tmp_data[24] = data[9];

		tmp_data[25] = data[19];
		tmp_data[26] = data[13];
		tmp_data[27] = data[30];
		tmp_data[28] = data[6];

		tmp_data[29] = data[22];
		tmp_data[30] = data[11];
		tmp_data[31] = data[4];
		tmp_data[32] = data[25];

		apply_P = tmp_data;	// Assign the permutated data to the output
	end
	endfunction

	function apply_IP;		// Initial permutation
	input [1:64] data;	// The DES standard used, numbers the block bits from left to right
	reg [1:64] apply_IP;
	reg [1:64] tmp_data;
	begin
		tmp_data[1] = data[58];
		tmp_data[2] = data[50];
		tmp_data[3] = data[42];
		tmp_data[4] = data[34];
		tmp_data[5] = data[26];
		tmp_data[6] = data[18];
		tmp_data[7] = data[10];
		tmp_data[8] = data[2];

		tmp_data[9] = data[60];
		tmp_data[10] = data[52];
		tmp_data[11] = data[44];
		tmp_data[12] = data[36];
		tmp_data[13] = data[28];
		tmp_data[14] = data[20];
		tmp_data[15] = data[12];
		tmp_data[16] = data[4];

		tmp_data[17] = data[62];
		tmp_data[18] = data[54];
		tmp_data[19] = data[46];
		tmp_data[20] = data[38];
		tmp_data[21] = data[30];
		tmp_data[22] = data[22];
		tmp_data[23] = data[14];
		tmp_data[24] = data[6];

		tmp_data[25] = data[64];
		tmp_data[26] = data[56];
		tmp_data[27] = data[48];
		tmp_data[28] = data[40];
		tmp_data[29] = data[32];
		tmp_data[30] = data[24];
		tmp_data[31] = data[16];
		tmp_data[32] = data[8];

		tmp_data[33] = data[57];
		tmp_data[34] = data[49];
		tmp_data[35] = data[41];
		tmp_data[36] = data[33];
		tmp_data[37] = data[25];
		tmp_data[38] = data[17];
		tmp_data[39] = data[9];
		tmp_data[40] = data[1];

		tmp_data[41] = data[59];
		tmp_data[42] = data[51];
		tmp_data[43] = data[43];
		tmp_data[44] = data[35];
		tmp_data[45] = data[27];
		tmp_data[46] = data[19];
		tmp_data[47] = data[11];
		tmp_data[48] = data[3];

		tmp_data[49] = data[61];
		tmp_data[50] = data[53];
		tmp_data[51] = data[45];
		tmp_data[52] = data[37];
		tmp_data[53] = data[29];
		tmp_data[54] = data[21];
		tmp_data[55] = data[13];
		tmp_data[56] = data[5];

		tmp_data[57] = data[63];
		tmp_data[58] = data[55];
		tmp_data[59] = data[47];
		tmp_data[60] = data[39];
		tmp_data[61] = data[31];
		tmp_data[62] = data[23];
		tmp_data[63] = data[15];
		tmp_data[64] = data[7];

		apply_IP = tmp_data;	// Assign the permutated data to the output
	end
	endfunction

	function apply_IP_inv;	// Inverse of the initial permutation
	input [1:64] data;	// The DES standard used, numbers the block bits from left to right
	reg [1:64] apply_IP_inv;
	reg [1:64] tmp_data;
	begin
		tmp_data[1] = data[40];
		tmp_data[2] = data[8];
		tmp_data[3] = data[48];
		tmp_data[4] = data[16];
		tmp_data[5] = data[56];
		tmp_data[6] = data[24];
		tmp_data[7] = data[64];
		tmp_data[8] = data[32];

		tmp_data[9] = data[39];
		tmp_data[10] = data[7];
		tmp_data[11] = data[47];
		tmp_data[12] = data[15];
		tmp_data[13] = data[55];
		tmp_data[14] = data[23];
		tmp_data[15] = data[63];
		tmp_data[16] = data[31];

		tmp_data[17] = data[38];
		tmp_data[18] = data[6];
		tmp_data[19] = data[46];
		tmp_data[20] = data[14];
		tmp_data[21] = data[54];
		tmp_data[22] = data[22];
		tmp_data[23] = data[62];
		tmp_data[24] = data[30];

		tmp_data[25] = data[37];
		tmp_data[26] = data[5];
		tmp_data[27] = data[45];
		tmp_data[28] = data[13];
		tmp_data[29] = data[53];
		tmp_data[30] = data[21];
		tmp_data[31] = data[61];
		tmp_data[32] = data[29];

		tmp_data[33] = data[36];
		tmp_data[34] = data[4];
		tmp_data[35] = data[44];
		tmp_data[36] = data[12];
		tmp_data[37] = data[52];
		tmp_data[38] = data[20];
		tmp_data[39] = data[60];
		tmp_data[40] = data[28];

		tmp_data[41] = data[35];
		tmp_data[42] = data[3];
		tmp_data[43] = data[43];
		tmp_data[44] = data[11];
		tmp_data[45] = data[51];
		tmp_data[46] = data[19];
		tmp_data[47] = data[59];
		tmp_data[48] = data[27];

		tmp_data[49] = data[34];
		tmp_data[50] = data[2];
		tmp_data[51] = data[42];
		tmp_data[52] = data[10];
		tmp_data[53] = data[50];
		tmp_data[54] = data[18];
		tmp_data[55] = data[58];
		tmp_data[56] = data[26];

		tmp_data[57] = data[33];
		tmp_data[58] = data[1];
		tmp_data[59] = data[41];
		tmp_data[60] = data[9];
		tmp_data[61] = data[49];
		tmp_data[62] = data[17];
		tmp_data[63] = data[57];
		tmp_data[64] = data[25];

		apply_IP_inv = tmp_data;	// Assign the permutated data to the output
	end
	endfunction

	