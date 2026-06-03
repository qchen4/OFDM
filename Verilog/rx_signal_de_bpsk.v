//////////////////////////////////////////////////////////////
// 功能: Signal OFDM BPSK解调代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module rx_signal_de_bpsk(
    input I_clk,
	input I_rst_n,
	input I_clk_en,
	 
    input [13:0]I_de_bpsk_in_i,
	input [13:0]I_de_bpsk_in_q,
    input I_de_bpsk_in_valid,
    
    output reg  O_de_bpsk_out_valid,
    output reg	O_de_bpsk_out
);

reg R_de_bpsk_in_valid_d;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_de_bpsk_in_valid_d <= 1'b0;
	else if(I_clk_en) 
		R_de_bpsk_in_valid_d <= I_de_bpsk_in_valid;
end

wire W_de_bpsk_in_start = ~R_de_bpsk_in_valid_d & I_de_bpsk_in_valid;
wire W_de_bpsk_in_end = R_de_bpsk_in_valid_d & (~I_de_bpsk_in_valid);

// BPSK解调的bit数据
wire W_bpsk_dec_bits = ~I_de_bpsk_in_i[13];

reg [47:0] R_buff;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_buff <= 'd0;
	else if(I_clk_en & I_de_bpsk_in_valid)
		R_buff <= {W_bpsk_dec_bits,R_buff[47:1]};
end

reg R_buff_out_en;
reg [5:0] R_buff_out_en_cnt;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_buff_out_en <= 1'd0;
	else if(W_de_bpsk_in_start)
		R_buff_out_en <= 1'd0;
	else if(R_buff_out_en_cnt == 6'd47)
		R_buff_out_en <= 1'd0;
	else if(I_clk_en && W_de_bpsk_in_end)
		R_buff_out_en <= 1'd1;
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_buff_out_en_cnt <= 6'd0;
	else if(W_de_bpsk_in_end)
		R_buff_out_en_cnt <= 6'd0;
	else if(R_buff_out_en_cnt == 6'd47)
		R_buff_out_en_cnt <= 6'd0;
	else if(R_buff_out_en)
		R_buff_out_en_cnt <= R_buff_out_en_cnt + 1'b1;
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		O_de_bpsk_out <= 1'd0;
	else if(W_de_bpsk_in_start)
		O_de_bpsk_out <= 1'd0;
	else if(R_buff_out_en)
		O_de_bpsk_out <= R_buff[R_buff_out_en_cnt];
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		O_de_bpsk_out_valid <= 1'b0;
	else if(W_de_bpsk_in_start)
		O_de_bpsk_out_valid <= 1'b0;
	else 
		O_de_bpsk_out_valid <= R_buff_out_en;
end

endmodule
