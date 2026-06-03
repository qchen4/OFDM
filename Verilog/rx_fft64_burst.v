//////////////////////////////////////////////////////////////
// 功能: 64点FFT定点算法
// 作者: 柳井刚
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计》随书代码，所有代码均由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
//////////////////////////////////////////////////////////////
module rx_fft64_burst(
	input			I_clk, 
	input			I_clk_en, 
	input			I_rst_n, 
	
	input [10:0] I_rx_ofdm_symbol_idx,	
	input			I_fft_in_valid, 
	input	[7 : 0]	I_fft_in_i,  // 8S7
	input	[7 : 0]	I_fft_in_q,  // 8S7
	
	output reg [10:0] O_rx_ofdm_symbol_idx,
	output	reg		O_fft_out_valid,
	output	reg [5: 0]  O_fft_out_idx,
	output  reg [13: 0] O_fft_out_i, // 14S7
	output  reg [13: 0] O_fft_out_q  // 14S7	
);

reg R_fft_in_valid_d;
reg [7:0] R_fft_in_i_dly;
reg [7:0] R_fft_in_q_dly;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		R_fft_in_valid_d <= 1'b0;
		R_fft_in_i_dly <= 8'd0;
		R_fft_in_q_dly <= 8'd0;
	end
	else if(I_clk_en)begin
		R_fft_in_valid_d <= I_fft_in_valid;
		R_fft_in_i_dly <= I_fft_in_i;
		R_fft_in_q_dly <= I_fft_in_q;
	end
end

wire W_fft_start = ~R_fft_in_valid_d & I_fft_in_valid;

reg [5:0] R_fft_cnt;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_fft_cnt <= 6'd0;
	else if(I_clk_en & W_fft_start)
		R_fft_cnt <= 6'd0;
	else if(I_clk_en & R_fft_in_valid_d) begin
		if(R_fft_cnt == 6'd63)
			R_fft_cnt <= 6'd0;
		else
			R_fft_cnt <= R_fft_cnt + 1'd1;
	end
end

reg [7:0] R_buff0_i[0:63];
reg [7:0] R_buff0_q[0:63];
integer i;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin	
		for(i = 0; i<=63; i = i + 1) begin
			R_buff0_i[i] <= 8'd0;
			R_buff0_q[i] <= 8'd0;
		end
	end
	else if(I_clk_en & R_fft_in_valid_d) begin
		R_buff0_i[R_fft_cnt] <= R_fft_in_i_dly;
		R_buff0_q[R_fft_cnt] <= R_fft_in_q_dly;
	end
end

reg R_buff0_out_en;
reg [5:0] R_buff0_out_en_cnt;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		R_buff0_out_en <= 1'd0;
	else if(R_buff0_out_en & (R_buff0_out_en_cnt == 6'd63))
		R_buff0_out_en <= 1'd0;
	else if(I_clk_en & R_fft_in_valid_d & (R_fft_cnt == 6'd63))
		R_buff0_out_en <= 1'd1;
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		R_buff0_out_en_cnt <= 6'd0;
	else if(R_buff0_out_en) begin
		if(R_buff0_out_en_cnt == 6'd63)
			R_buff0_out_en_cnt <= 6'd0;
		else
			R_buff0_out_en_cnt <= R_buff0_out_en_cnt + 1'd1;
	end
end

reg [7:0] R_buff0_out_i;
reg [7:0] R_buff0_out_q;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		R_buff0_out_i <= 8'd0;
		R_buff0_out_q <= 8'd0;
	end
	else if(R_buff0_out_en) begin
		R_buff0_out_i <= R_buff0_i[R_buff0_out_en_cnt];
		R_buff0_out_q <= R_buff0_q[R_buff0_out_en_cnt];
	end
end

reg R_buff0_out_valid;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_buff0_out_valid <= 1'd0;
	else 
		R_buff0_out_valid <= R_buff0_out_en;
end

wire R_buff0_out_start = R_buff0_out_en & (~R_buff0_out_valid);

reg [10:0] R_rx_pre_fft_ofdm_symbol_idx;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		R_rx_pre_fft_ofdm_symbol_idx <= 1'd0;
	else if(R_buff0_out_start)
		R_rx_pre_fft_ofdm_symbol_idx <= I_rx_ofdm_symbol_idx;
end

wire W_fft_out_valid;
wire [5:0] W_fft_out_idx;
wire [13:0] W_fft_out_i;// 14S7
wire [13:0] W_fft_out_q;// 14S7
fft64_bit_reverse u0(
	.I_clk(I_clk), 
	.I_clk_en(1'b1), 
	.I_rst_n(I_rst_n), 
	
	.I_fft_in_valid(R_buff0_out_valid), 
	.I_fft_in_i(R_buff0_out_i),  // 8S7
	.I_fft_in_q(R_buff0_out_q),  // 8S7
	
	.O_fft_out_valid(W_fft_out_valid),
	.O_fft_out_idx(W_fft_out_idx),
	.O_fft_out_i(W_fft_out_i), // 14S7
	.O_fft_out_q(W_fft_out_q)  // 14S7	
);

wire [5:0] W_buff1_wr_addr = W_fft_out_idx;

reg [13:0] R_buff1_i[0:63];
reg [13:0] R_buff1_q[0:63];
integer j;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin	
		for(j = 0; j<=63; j = j + 1) begin
			R_buff1_i[j] <= 'd0;
			R_buff1_q[j] <= 'd0;
		end
	end
	else if(W_fft_out_valid) begin
		R_buff1_i[W_buff1_wr_addr] <= W_fft_out_i;
		R_buff1_q[W_buff1_wr_addr] <= W_fft_out_q;
	end
end

reg R_buff1_out_en;
reg [5:0] R_buff1_out_en_cnt;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		R_buff1_out_en <= 1'd0;
	else if(I_clk_en & R_buff1_out_en & (R_buff1_out_en_cnt == 6'd63))
		R_buff1_out_en <= 1'd0;
	else if(W_fft_out_valid & (W_fft_out_idx == 6'd63))
		R_buff1_out_en <= 1'd1;
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		R_buff1_out_en_cnt <= 6'd0;
	else if(I_clk_en & R_buff1_out_en) begin
		if(R_buff1_out_en_cnt == 6'd63)
			R_buff1_out_en_cnt <= 6'd0;
		else
			R_buff1_out_en_cnt <= R_buff1_out_en_cnt + 1'd1;
	end
end

wire [5:0] W_buff1_rd_addr = {R_buff1_out_en_cnt[0],R_buff1_out_en_cnt[1],R_buff1_out_en_cnt[2],
							R_buff1_out_en_cnt[3],R_buff1_out_en_cnt[4],R_buff1_out_en_cnt[5]};
							
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		O_fft_out_i <= 16'd0;
		O_fft_out_q <= 16'd0;
	end
	else if(I_clk_en & R_buff1_out_en) begin
		O_fft_out_i <= R_buff1_i[W_buff1_rd_addr];
		O_fft_out_q <= R_buff1_q[W_buff1_rd_addr];
	end
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		O_fft_out_valid <= 1'd0;
	else if(I_clk_en)
		O_fft_out_valid <= R_buff1_out_en;
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		O_fft_out_idx <= 6'd0;
	else if(I_clk_en)
		O_fft_out_idx <= R_buff1_out_en_cnt;
end

assign O_fft_out_done = ~R_buff1_out_en & O_fft_out_valid;

wire W_fft_out_start = R_buff1_out_en & (~O_fft_out_valid);
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		O_rx_ofdm_symbol_idx <= 1'd0;
	else if(W_fft_out_start)
		O_rx_ofdm_symbol_idx <= R_rx_pre_fft_ofdm_symbol_idx;
end

endmodule