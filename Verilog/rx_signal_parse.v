//////////////////////////////////////////////////////////////
// 功能: Signal数据解析模块 Verilog代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module rx_signal_parse(
	input I_clk,
	input I_rst_n,
	input I_clk_en_20M,
	input I_clk_en_40M,

	input I_rx_signal_bits,
	input I_rx_signal_bits_valid,	
	
	output [11:0] O_decode_bytes_num,	
	output reg [10:0] O_decode_data_ofdm_num,
	output reg O_decode_data_ofdm_num_valid,
	
	output O_signal_decode_done	
);

reg R_rx_signal_bits_valid_d;
reg R_rx_signal_bits_d;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		R_rx_signal_bits_valid_d <= 1'b0;
		R_rx_signal_bits_d <= 'd0;
	end
	else if(I_clk_en_40M)begin
		R_rx_signal_bits_valid_d <= I_rx_signal_bits_valid;
		R_rx_signal_bits_d <= I_rx_signal_bits;
	end
end
wire W_rx_signal_start = ~R_rx_signal_bits_valid_d & I_rx_signal_bits_valid;
												
reg R_rx_signal_cnt_en;
reg [4:0] R_rx_signal_cnt;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_rx_signal_cnt_en <= 1'd0;
	else if(I_clk_en_40M && W_rx_signal_start)
		R_rx_signal_cnt_en <= 1'd1;
	else if(I_clk_en_40M &&(R_rx_signal_cnt == 5'd23))
		R_rx_signal_cnt_en <= 1'd0;
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_rx_signal_cnt <= 5'd0;
	else if(I_clk_en_40M && W_rx_signal_start)
		R_rx_signal_cnt <= 5'd0;
	else if(I_clk_en_40M && (R_rx_signal_cnt == 5'd23))
		R_rx_signal_cnt <= 5'd0;
	else if(I_clk_en_40M && R_rx_signal_cnt_en)
		R_rx_signal_cnt <= R_rx_signal_cnt + 1'b1;
end

reg [23:0] R_buff;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_buff <= 24'd0;
	else if(W_rx_signal_start)
		R_buff <= 24'd0;
	else if(I_clk_en_40M & R_rx_signal_cnt_en)
		R_buff[R_rx_signal_cnt] <= R_rx_signal_bits_d;
end
						 
assign O_decode_bytes_num = R_buff[16:5];

wire [15:0] W_src_bits_num = {1'd0,O_decode_bytes_num,3'd0} + 16'd16 + 16'd6;
wire [7:0] W_one_ofdm_bits_num = 8'd96;

reg R_rx_signal_cnt_en_d;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_rx_signal_cnt_en_d <= 1'd0;
	else if(I_clk_en_40M && W_rx_signal_start)
		R_rx_signal_cnt_en_d <= 1'd0;
	else if(I_clk_en_40M)
		R_rx_signal_cnt_en_d <= R_rx_signal_cnt_en;
end
wire W_rx_signal_out_start = ~R_rx_signal_cnt_en & R_rx_signal_cnt_en_d;

wire [7:0] W_divider_quot;
wire [7:0] W_divider_rem;
wire W_divider_out_valid;
divider u0(
	.I_clk(I_clk),
	.I_clk_en(I_clk_en_40M),
	.I_rst_n(I_rst_n),
	
	.I_in_valid(W_rx_signal_out_start),
	.I_y(W_src_bits_num),
	.I_x(W_one_ofdm_bits_num),
	
	.O_quot(W_divider_quot),
	.O_rem(W_divider_rem),
	.O_out_valid(W_divider_out_valid)
);

wire [7:0] W_decode_data_ofdm_num = (W_divider_rem == 0) ? W_divider_quot : (W_divider_quot + 1'b1);
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		O_decode_data_ofdm_num_valid <= 1'd0;
		O_decode_data_ofdm_num <= 11'd0;
	end
	else if(W_rx_signal_start) begin
		O_decode_data_ofdm_num_valid <= 1'd0;
		O_decode_data_ofdm_num <= 11'd0;
	end
	else if(I_clk_en_40M & W_divider_out_valid) begin
		O_decode_data_ofdm_num_valid <= 1'd1;
		O_decode_data_ofdm_num <= W_decode_data_ofdm_num;
	end
end

reg R_decode_data_ofdm_num_valid_d;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_decode_data_ofdm_num_valid_d <= 1'd0;
	else if(I_clk_en_40M && W_rx_signal_start)
		R_decode_data_ofdm_num_valid_d <= 1'd0;
	else if(I_clk_en_20M)
		R_decode_data_ofdm_num_valid_d <= O_decode_data_ofdm_num_valid;
end
assign O_signal_decode_done = ~R_decode_data_ofdm_num_valid_d & O_decode_data_ofdm_num_valid;

endmodule 