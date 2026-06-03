//////////////////////////////////////////////////////////////
// 功能: RX Signal和DATA分离模块
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module rx_signal_data_split(
	input I_clk,
	input I_rst_n,
	input I_clk_en,
	
	input [10:0] I_rx_ofdm_symbol_idx,
	
	input I_rx_split_in_valid,
	input [13:0] I_rx_split_in_i,
	input [13:0] I_rx_split_in_q,	
	
	output reg [13:0] O_rx_signal_ofdm_out_i,
	output reg [13:0] O_rx_signal_ofdm_out_q,
	output reg O_rx_signal_ofdm_out_valid,
	
	output reg [13:0] O_rx_data_ofdm_out_i,
	output reg [13:0] O_rx_data_ofdm_out_q,
	output reg O_rx_data_ofdm_out_valid,
	
	output [10:0] O_rx_ofdm_symbol_idx
);

wire W_signal_out_en = (I_rx_ofdm_symbol_idx == 0) ? 1'b1 : 1'b0;
wire W_data_out_en = (I_rx_ofdm_symbol_idx != 0) ? 1'b1 : 1'b0;

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		O_rx_signal_ofdm_out_i <= 'd0;
		O_rx_signal_ofdm_out_q <= 'd0;
		O_rx_signal_ofdm_out_valid <= 1'b0;
	end
	else if(I_clk_en) begin
		if(W_signal_out_en) begin
			O_rx_signal_ofdm_out_i <= I_rx_split_in_i;
			O_rx_signal_ofdm_out_q <= I_rx_split_in_q;
			O_rx_signal_ofdm_out_valid <= I_rx_split_in_valid;
		end
		else begin
			O_rx_signal_ofdm_out_i <= 'd0;
			O_rx_signal_ofdm_out_q <= 'd0;
			O_rx_signal_ofdm_out_valid <= 1'b0;
		end
	end
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		O_rx_data_ofdm_out_i <= 'd0;
		O_rx_data_ofdm_out_q <= 'd0;
		O_rx_data_ofdm_out_valid <= 1'b0;
	end
	else if(I_clk_en) begin
		if(W_data_out_en) begin
			O_rx_data_ofdm_out_i <= I_rx_split_in_i;
			O_rx_data_ofdm_out_q <= I_rx_split_in_q;
			O_rx_data_ofdm_out_valid <= I_rx_split_in_valid;
		end
		else begin
			O_rx_data_ofdm_out_i <= 'd0;
			O_rx_data_ofdm_out_q <= 'd0;
			O_rx_data_ofdm_out_valid <= 1'b0;
		end
	end
end

assign O_rx_ofdm_symbol_idx = I_rx_ofdm_symbol_idx;

endmodule 
