//////////////////////////////////////////////////////////////
// 功能: Signal域数据解交织Verilog代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module rx_signal_de_interleave(
	input I_clk,
	input I_rst_n,
	input I_rx_bits,
	input I_rx_bits_valid,
	
	output reg O_de_interleave_out,
	output reg O_de_interleave_out_valid,
	output O_de_interleave_done
);

reg R_rx_bits_dly;
reg R_rx_bits_valid_dly;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		R_rx_bits_dly <= 1'b0;
		R_rx_bits_valid_dly <= 1'b0;
	end
	else begin
		R_rx_bits_dly <= I_rx_bits;
		R_rx_bits_valid_dly <= I_rx_bits_valid;
	end
end

wire W_de_interleave_start = ~R_rx_bits_valid_dly & I_rx_bits_valid;
wire W_rx_bits_valid_neg = R_rx_bits_valid_dly & (~I_rx_bits_valid);

reg [5:0] R_rx_bits_cnt;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_rx_bits_cnt <= 6'd0;
	else if(W_de_interleave_start)
		R_rx_bits_cnt <= 6'd0;
	else if(R_rx_bits_valid_dly) begin
		if(R_rx_bits_cnt == 6'd47)
			R_rx_bits_cnt <= 6'd0;
		else
			R_rx_bits_cnt <= R_rx_bits_cnt + 1'd1;
	end
end

// 地址映射
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

reg [47:0] R_buff0;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_buff0 <= 48'd0;
	else if(R_rx_bits_valid_dly) 
		R_buff0[R_wr_addr] <= R_rx_bits_dly;
end

reg R_out_en;
reg [5:0] R_out_en_cnt;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		R_out_en <= 1'd0;
	else if(R_out_en_cnt == 6'd47)
		R_out_en <= 1'd0;
	else if(W_rx_bits_valid_neg)
		R_out_en <= 1'd1;
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		R_out_en_cnt <= 6'd0;
	else if(R_out_en_cnt == 6'd47)
		R_out_en_cnt <= 6'd0;
	else if(R_out_en)
		R_out_en_cnt <= R_out_en_cnt + 1'd1;
end

wire [5:0] W_rd_addr = R_out_en_cnt;

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		O_de_interleave_out <= 1'd0;
	else if(W_rx_bits_valid_neg) 
		O_de_interleave_out <= 1'd0;
	else if(R_out_en) 
		O_de_interleave_out <= R_buff0[W_rd_addr];
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		O_de_interleave_out_valid <= 1'd0;
	else if(W_rx_bits_valid_neg) 
		O_de_interleave_out_valid <= 1'd0;
	else 
		O_de_interleave_out_valid <= R_out_en;
end

assign O_de_interleave_done = ~R_out_en & O_de_interleave_out_valid;

endmodule 
