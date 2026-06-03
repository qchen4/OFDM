reg [5:0] R_wr_addr;
always @(*) begin
	case(R_rx_bits_cnt)
		0 : begin R_wr_addr <= 0; end
		1 : begin R_wr_addr <= 16; end
		2 : begin R_wr_addr <= 32; end
		3 : begin R_wr_addr <= 1; end
		4 : begin R_wr_addr <= 17; end
		5 : begin R_wr_addr <= 33; end
		6 : begin R_wr_addr <= 2; end
		7 : begin R_wr_addr <= 18; end
		8 : begin R_wr_addr <= 34; end
		9 : begin R_wr_addr <= 3; end
		10 : begin R_wr_addr <= 19; end
		11 : begin R_wr_addr <= 35; end
		12 : begin R_wr_addr <= 4; end
		13 : begin R_wr_addr <= 20; end
		14 : begin R_wr_addr <= 36; end
		15 : begin R_wr_addr <= 5; end
		16 : begin R_wr_addr <= 21; end
		17 : begin R_wr_addr <= 37; end
		18 : begin R_wr_addr <= 6; end
		19 : begin R_wr_addr <= 22; end
		20 : begin R_wr_addr <= 38; end
		21 : begin R_wr_addr <= 7; end
		22 : begin R_wr_addr <= 23; end
		23 : begin R_wr_addr <= 39; end
		24 : begin R_wr_addr <= 8; end
		25 : begin R_wr_addr <= 24; end
		26 : begin R_wr_addr <= 40; end
		27 : begin R_wr_addr <= 9; end
		28 : begin R_wr_addr <= 25; end
		29 : begin R_wr_addr <= 41; end
		30 : begin R_wr_addr <= 10; end
		31 : begin R_wr_addr <= 26; end
		32 : begin R_wr_addr <= 42; end
		33 : begin R_wr_addr <= 11; end
		34 : begin R_wr_addr <= 27; end
		35 : begin R_wr_addr <= 43; end
		36 : begin R_wr_addr <= 12; end
		37 : begin R_wr_addr <= 28; end
		38 : begin R_wr_addr <= 44; end
		39 : begin R_wr_addr <= 13; end
		40 : begin R_wr_addr <= 29; end
		41 : begin R_wr_addr <= 45; end
		42 : begin R_wr_addr <= 14; end
		43 : begin R_wr_addr <= 30; end
		44 : begin R_wr_addr <= 46; end
		45 : begin R_wr_addr <= 15; end
		46 : begin R_wr_addr <= 31; end
		//47 : begin R_wr_addr <= 47; end
		default : begin R_wr_addr <= 47; end
	endcase
end
