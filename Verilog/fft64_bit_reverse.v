//////////////////////////////////////////////////////////////
// 功能: 64点FFT Verilog代码，输出为倒位输出(bit reversed order)
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
//////////////////////////////////////////////////////////////
module fft64_bit_reverse(
	input			I_clk, 
	input			I_clk_en, 
	input			I_rst_n, 
	
	input			I_fft_in_valid, 
	input	[7 : 0]	I_fft_in_i,  // 8S7
	input	[7 : 0]	I_fft_in_q,  // 8S7
	
	output			 O_fft_out_valid,
	output	 [5:0]   O_fft_out_idx,
	output	 [13: 0] O_fft_out_i, // 14S7
	output	 [13: 0] O_fft_out_q  // 14S7
);

parameter C_FFT_ORDER = 6 ;
parameter C_FFT_IN_NUM = 64 ; // = 2^(C_FFT_ORDER)

// Butterfly Stage 0 
wire [5:0] W_stage0_wn_addr;
reg	[8:0] R_stage0_wn_i;
reg	[8:0] R_stage0_wn_q;
always @(*) begin
	case(W_stage0_wn_addr[4:0])
		0:begin R_stage0_wn_i = 128; R_stage0_wn_q = 0; end
		1:begin R_stage0_wn_i = 127; R_stage0_wn_q = -13; end
		2:begin R_stage0_wn_i = 126; R_stage0_wn_q = -25; end
		3:begin R_stage0_wn_i = 122; R_stage0_wn_q = -37; end
		4:begin R_stage0_wn_i = 118; R_stage0_wn_q = -49; end
		5:begin R_stage0_wn_i = 113; R_stage0_wn_q = -60; end
		6:begin R_stage0_wn_i = 106; R_stage0_wn_q = -71; end
		7:begin R_stage0_wn_i = 99; R_stage0_wn_q = -81; end
		8:begin R_stage0_wn_i = 91; R_stage0_wn_q = -91; end
		9:begin R_stage0_wn_i = 81; R_stage0_wn_q = -99; end
		10:begin R_stage0_wn_i = 71; R_stage0_wn_q = -106; end
		11:begin R_stage0_wn_i = 60; R_stage0_wn_q = -113; end
		12:begin R_stage0_wn_i = 49; R_stage0_wn_q = -118; end
		13:begin R_stage0_wn_i = 37; R_stage0_wn_q = -122; end
		14:begin R_stage0_wn_i = 25; R_stage0_wn_q = -126; end
		15:begin R_stage0_wn_i = 13; R_stage0_wn_q = -127; end
		16:begin R_stage0_wn_i = 0; R_stage0_wn_q = -128; end
		17:begin R_stage0_wn_i = -13; R_stage0_wn_q = -127; end
		18:begin R_stage0_wn_i = -25; R_stage0_wn_q = -126; end
		19:begin R_stage0_wn_i = -37; R_stage0_wn_q = -122; end
		20:begin R_stage0_wn_i = -49; R_stage0_wn_q = -118; end
		21:begin R_stage0_wn_i = -60; R_stage0_wn_q = -113; end
		22:begin R_stage0_wn_i = -71; R_stage0_wn_q = -106; end
		23:begin R_stage0_wn_i = -81; R_stage0_wn_q = -99; end
		24:begin R_stage0_wn_i = -91; R_stage0_wn_q = -91; end
		25:begin R_stage0_wn_i = -99; R_stage0_wn_q = -81; end
		26:begin R_stage0_wn_i = -106; R_stage0_wn_q = -71; end
		27:begin R_stage0_wn_i = -113; R_stage0_wn_q = -60; end
		28:begin R_stage0_wn_i = -118; R_stage0_wn_q = -49; end
		29:begin R_stage0_wn_i = -122; R_stage0_wn_q = -37; end
		30:begin R_stage0_wn_i = -126; R_stage0_wn_q = -25; end
		default:begin R_stage0_wn_i = -127; R_stage0_wn_q = -13; end
	endcase
end

wire W_fft_start;
wire [9:0] W_stage0_out_i,W_stage0_out_q; //10S7
wire 		W_stage0_out_valid;
butterfly_r2_dif #(
	.C_IN_W1  		(8), 
	.C_IN_W2  		(7), 
	.C_OUT_W1  		(10),
	.C_OUT_W2  		(7), 
	.C_ROT_W1  		(9), 
	.C_ROT_W2  		(7), 
	.C_BF_IDX  		(0), 
	.C_TOTAL_BF_NUM (6))
	u_stage0(
	.I_clk			(I_clk), 
	.I_clk_en		(I_clk_en), 
	.I_rst_n		(I_rst_n), 
	
	.I_bf_in_valid	(I_fft_in_valid), 
	.I_bf_in_i		(I_fft_in_i),  // 8S7
	.I_bf_in_q		(I_fft_in_q),  // 8S7
	
	.O_bf_out_valid	(W_stage0_out_valid),
	.O_bf_start		(W_fft_start),
	.O_bf_out_idx	(),
	.O_bf_out_i		(W_stage0_out_i), // 10S7
	.O_bf_out_q		(W_stage0_out_q), // 10S7
	
	.I_wn_i			(R_stage0_wn_i), 
	.I_wn_q			(R_stage0_wn_q),  
	.O_wn_addr		(W_stage0_wn_addr)  
);

// Butterfly Stage 1 
wire [5:0] W_stage1_wn_addr;
reg	[8:0] R_stage1_wn_i;
reg	[8:0] R_stage1_wn_q;
always @(*) begin
	case(W_stage1_wn_addr[3:0])
		0:begin R_stage1_wn_i = 128; R_stage1_wn_q = 0; end
		1:begin R_stage1_wn_i = 126; R_stage1_wn_q = -25; end
		2:begin R_stage1_wn_i = 118; R_stage1_wn_q = -49; end
		3:begin R_stage1_wn_i = 106; R_stage1_wn_q = -71; end
		4:begin R_stage1_wn_i = 91; R_stage1_wn_q = -91; end
		5:begin R_stage1_wn_i = 71; R_stage1_wn_q = -106; end
		6:begin R_stage1_wn_i = 49; R_stage1_wn_q = -118; end
		7:begin R_stage1_wn_i = 25; R_stage1_wn_q = -126; end
		8:begin R_stage1_wn_i = 0; R_stage1_wn_q = -128; end
		9:begin R_stage1_wn_i = -25; R_stage1_wn_q = -126; end
		10:begin R_stage1_wn_i = -49; R_stage1_wn_q = -118; end
		11:begin R_stage1_wn_i = -71; R_stage1_wn_q = -106; end
		12:begin R_stage1_wn_i = -91; R_stage1_wn_q = -91; end
		13:begin R_stage1_wn_i = -106; R_stage1_wn_q = -71; end
		14:begin R_stage1_wn_i = -118; R_stage1_wn_q = -49; end
		default:begin R_stage1_wn_i = -126; R_stage1_wn_q = -25; end
	endcase
end

wire [10:0] W_stage1_out_i,W_stage1_out_q; //11S7
wire 	   W_stage1_out_valid;
butterfly_r2_dif #(
	.C_IN_W1  		(10),
	.C_IN_W2  		(7), 
	.C_OUT_W1  		(11),
	.C_OUT_W2  		(7), 
	.C_ROT_W1  		(9), 
	.C_ROT_W2  		(7), 
	.C_BF_IDX  		(1), 
	.C_TOTAL_BF_NUM (6))
	u_stage1(
	.I_clk			(I_clk), 
	.I_clk_en		(I_clk_en), 
	.I_rst_n		(I_rst_n), 
	
	.I_bf_in_valid	(W_stage0_out_valid),
	.I_bf_in_i		(W_stage0_out_i),  //10S7
	.I_bf_in_q		(W_stage0_out_q),  //10S7
	
	.O_bf_out_valid	(W_stage1_out_valid),
	.O_bf_start		(),
	.O_bf_out_idx	(),
	.O_bf_out_i		(W_stage1_out_i), //11S7
	.O_bf_out_q		(W_stage1_out_q), //11S7
	
	.I_wn_i			(R_stage1_wn_i), 
	.I_wn_q			(R_stage1_wn_q), 
	.O_wn_addr		(W_stage1_wn_addr) 	
);

// Butterfly Stage 2 
wire [5:0] W_stage2_wn_addr;
reg	[8:0] R_stage2_wn_i;
reg	[8:0] R_stage2_wn_q;
always @(*) begin
	case(W_stage2_wn_addr[2:0])
		0:begin R_stage2_wn_i = 128; R_stage2_wn_q = 0; end
		1:begin R_stage2_wn_i = 118; R_stage2_wn_q = -49; end
		2:begin R_stage2_wn_i = 91; R_stage2_wn_q = -91; end
		3:begin R_stage2_wn_i = 49; R_stage2_wn_q = -118; end
		4:begin R_stage2_wn_i = 0; R_stage2_wn_q = -128; end
		5:begin R_stage2_wn_i = -49; R_stage2_wn_q = -118; end
		6:begin R_stage2_wn_i = -91; R_stage2_wn_q = -91; end
		default:begin R_stage2_wn_i = -118; R_stage2_wn_q = -49; end
	endcase
end

wire [12:0] W_stage2_out_i,W_stage2_out_q; //13S7
wire 		W_stage2_out_valid;
butterfly_r2_dif #(
	.C_IN_W1  		(11),
	.C_IN_W2  		(7), 
	.C_OUT_W1  		(13),
	.C_OUT_W2  		(7), 
	.C_ROT_W1  		(9), 
	.C_ROT_W2  		(7), 
	.C_BF_IDX  		(2), 
	.C_TOTAL_BF_NUM (6))
	u_stage2(
	.I_clk			(I_clk), 
	.I_clk_en		(I_clk_en), 
	.I_rst_n		(I_rst_n), 
	
	.I_bf_in_valid	(W_stage1_out_valid), 
	.I_bf_in_i		(W_stage1_out_i),  //11S7
	.I_bf_in_q		(W_stage1_out_q),  //11S7
	
	.O_bf_out_valid	(W_stage2_out_valid),
	.O_bf_start		(),
	.O_bf_out_idx	(),
	.O_bf_out_i		(W_stage2_out_i), //13S7
	.O_bf_out_q		(W_stage2_out_q), //13S7
	
	.I_wn_i			(R_stage2_wn_i), 
	.I_wn_q			(R_stage2_wn_q), 
	.O_wn_addr		(W_stage2_wn_addr) 
);

// Butterfly Stage 3 
wire [5:0] W_stage3_wn_addr;
reg	[8:0] R_stage3_wn_i;
reg	[8:0] R_stage3_wn_q;
always @(*) begin
	case(W_stage3_wn_addr[1:0])
		0:begin R_stage3_wn_i = 128; R_stage3_wn_q = 0; end
		1:begin R_stage3_wn_i = 91; R_stage3_wn_q = -91; end
		2:begin R_stage3_wn_i = 0; R_stage3_wn_q = -128; end
		default:begin R_stage3_wn_i = -91; R_stage3_wn_q = -91; end
	endcase
end

wire [13:0] W_stage3_out_i,W_stage3_out_q; //14S7
wire 		W_stage3_out_valid;
butterfly_r2_dif #(
	.C_IN_W1  		(13),
	.C_IN_W2  		(7), 
	.C_OUT_W1  		(14),
	.C_OUT_W2  		(7), 
	.C_ROT_W1  		(9), 
	.C_ROT_W2  		(7), 
	.C_BF_IDX  		(3), 
	.C_TOTAL_BF_NUM (6))
	u_stage3(
	.I_clk			(I_clk), 
	.I_clk_en		(I_clk_en), 
	.I_rst_n		(I_rst_n), 
	
	.I_bf_in_valid	(W_stage2_out_valid), 
	.I_bf_in_i		(W_stage2_out_i),  //13S7
	.I_bf_in_q		(W_stage2_out_q),  //13S7
	
	.O_bf_out_valid	(W_stage3_out_valid),
	.O_bf_start		(),
	.O_bf_out_idx	(),
	.O_bf_out_i		(W_stage3_out_i), //14S7
	.O_bf_out_q		(W_stage3_out_q), //14S7
	
	.I_wn_i			(R_stage3_wn_i), 
	.I_wn_q			(R_stage3_wn_q), 
	.O_wn_addr		(W_stage3_wn_addr) 
);

// Butterfly Stage 4
wire [5:0] W_stage4_wn_addr;
reg	[8:0] R_stage4_wn_i;
reg	[8:0] R_stage4_wn_q;

// 这个stage不需要旋转因子
always @(*) begin
	R_stage4_wn_i <= 9'd0; R_stage4_wn_q <= 9'd0;
end

wire [13:0] W_stage4_out_i,W_stage4_out_q; //14S7
wire 		W_stage4_out_valid;
butterfly_r2_dif #(
	.C_IN_W1  		(14),
	.C_IN_W2  		(7), 
	.C_OUT_W1  		(14),
	.C_OUT_W2  		(7), 
	.C_ROT_W1  		(9), 
	.C_ROT_W2  		(7), 
	.C_BF_IDX  		(4), 
	.C_TOTAL_BF_NUM (6))
	u_stage4(
	.I_clk			(I_clk), 
	.I_clk_en		(I_clk_en), 
	.I_rst_n		(I_rst_n), 
	
	.I_bf_in_valid	(W_stage3_out_valid), 
	.I_bf_in_i		(W_stage3_out_i),  //14S7
	.I_bf_in_q		(W_stage3_out_q),  //14S7
	
	.O_bf_out_valid	(W_stage4_out_valid),
	.O_bf_start		(),     
	.O_bf_out_idx	(),     
	.O_bf_out_i		(W_stage4_out_i), //14S7
	.O_bf_out_q		(W_stage4_out_q), //14S7
							
	.I_wn_i			(R_stage4_wn_i),  
	.I_wn_q			(R_stage4_wn_q), 
	.O_wn_addr		(W_stage4_wn_addr) 
);

// Butterfly Stage 5
wire [5:0] W_stage5_wn_addr;
reg	[8:0] R_stage5_wn_i;
reg	[8:0] R_stage5_wn_q;

// 这个stage也不需要旋转因子
always @(*) begin
	R_stage5_wn_i <= 9'd0; R_stage5_wn_q <= 9'd0;
end

wire [13:0] W_stage5_out_i,W_stage5_out_q; //14S7
wire 		W_stage5_out_valid;
wire [5:0] W_stage5_out_idx;
butterfly_r2_dif #(
	.C_IN_W1  		(14),
	.C_IN_W2  		(7), 
	.C_OUT_W1  		(14),
	.C_OUT_W2  		(7), 
	.C_ROT_W1  		(9), 
	.C_ROT_W2  		(7), 
	.C_BF_IDX  		(5), 
	.C_TOTAL_BF_NUM (6))
	u_stage5(
	.I_clk			(I_clk), 
	.I_clk_en		(I_clk_en),
	.I_rst_n		(I_rst_n), 
	
	.I_bf_in_valid	(W_stage4_out_valid), 
	.I_bf_in_i		(W_stage4_out_i),  //14S7
	.I_bf_in_q		(W_stage4_out_q),  //14S7
	
	.O_bf_out_valid	(W_stage5_out_valid),
	.O_bf_start		(),     
	.O_bf_out_idx	(W_stage5_out_idx),     
	.O_bf_out_i		(W_stage5_out_i), //14S7
	.O_bf_out_q		(W_stage5_out_q), //14S7
							
	.I_wn_i			(R_stage5_wn_i),  
	.I_wn_q			(R_stage5_wn_q),  
	.O_wn_addr		(W_stage5_wn_addr) 
);

assign O_fft_out_valid = W_stage5_out_valid;
assign O_fft_out_idx = W_stage5_out_idx;
assign O_fft_out_i = W_stage5_out_i; // 14S7
assign O_fft_out_q = W_stage5_out_q; // 14S7

endmodule