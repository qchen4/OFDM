//////////////////////////////////////////////////////////////
// 功能: Signal数据和DATA域数据合并模块Verilog代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module rx_signal_data_combine(
	input I_clk,
	input I_rst_n,
	
	input [10:0] I_rx_ofdm_symbol_idx,
	input I_decode_en,
	
	input I_rx_signal_bits,
	input I_rx_signal_bits_valid,
	
	input I_rx_data_bits,
	input I_rx_data_bits_valid,
	
	output reg O_rx_signal_data_out,
	output     O_rx_signal_data_out_valid,
	output     O_rx_signal_out_start,
	output     O_rx_data_out_start,
	output reg O_rx_viterbi217_en,
	
	output reg [7:0] O_rx_bits_num,
	output [10:0] O_rx_ofdm_symbol_idx
);

localparam C_SIGNAL_BITS_NUM = 8'd72;
localparam C_DATA_BITS_NUM = 8'd192;

reg R_rx_signal_bits_d;
reg R_rx_signal_bits_valid_d;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		R_rx_signal_bits_d <= 1'b0;
		R_rx_signal_bits_valid_d <= 1'b0;
	end
	else begin
		R_rx_signal_bits_d <= I_rx_signal_bits;
		R_rx_signal_bits_valid_d <= I_rx_signal_bits_valid;
	end
end

wire W_rx_signal_start = ~R_rx_signal_bits_valid_d & I_rx_signal_bits_valid;

reg 	R_rx_signal_cnt_en;
reg [6:0] R_rx_signal_cnt;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_rx_signal_cnt_en <= 1'd0;
	else if(W_rx_signal_start)
		R_rx_signal_cnt_en <= 1'd1;
	else if(R_rx_signal_cnt == (C_SIGNAL_BITS_NUM -1)) 
		R_rx_signal_cnt_en <= 1'd0;
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_rx_signal_cnt <= 7'd0;
	else if(W_rx_signal_start)
		R_rx_signal_cnt <= 7'd0;
	else if(R_rx_signal_cnt_en) begin
		if(R_rx_signal_cnt == (C_SIGNAL_BITS_NUM -1))
			R_rx_signal_cnt <= 7'd0;
		else
			R_rx_signal_cnt <= R_rx_signal_cnt + 1'd1;
	end
end

wire W_rx_signal_out_valid_ext = R_rx_signal_cnt_en;
wire W_rx_signal_out_ext = R_rx_signal_bits_valid_d ? R_rx_signal_bits_d : 1'b0;

wire W_signal_data_out = W_rx_signal_out_valid_ext ? W_rx_signal_out_ext :
						I_rx_data_bits_valid ? I_rx_data_bits : 1'b0;


reg R_rx_signal_out_valid_ext_d;
reg R_rx_data_bits_valid_d;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		R_rx_signal_out_valid_ext_d <= 1'd0;
		R_rx_data_bits_valid_d <= 1'd0;
		O_rx_signal_data_out <= 1'd0;
	end
	else begin
		R_rx_signal_out_valid_ext_d <= W_rx_signal_out_valid_ext;
		R_rx_data_bits_valid_d <= I_rx_data_bits_valid;
		O_rx_signal_data_out <= W_signal_data_out;
	end
end

assign O_rx_signal_data_out_valid = R_rx_signal_out_valid_ext_d | R_rx_data_bits_valid_d;

assign O_rx_signal_out_start = ~R_rx_signal_out_valid_ext_d & W_rx_signal_out_valid_ext;
assign O_rx_data_out_start = ~R_rx_data_bits_valid_d & I_rx_data_bits_valid & (I_rx_ofdm_symbol_idx == 1);

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		O_rx_viterbi217_en <= 1'd0;
	else if(O_rx_signal_out_start & I_decode_en) 
		O_rx_viterbi217_en <= 1'd1;
	else if(I_decode_en == 1'b0) 
		O_rx_viterbi217_en <= 1'd0;
end

assign O_rx_ofdm_symbol_idx = I_rx_ofdm_symbol_idx;

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		O_rx_bits_num <= 8'd0;
	else if(O_rx_signal_out_start) 
		O_rx_bits_num <= C_SIGNAL_BITS_NUM;
	else if(O_rx_data_out_start) 
		O_rx_bits_num <= C_DATA_BITS_NUM;
end

endmodule 
