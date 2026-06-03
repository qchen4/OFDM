//////////////////////////////////////////////////////////////
// 功能: 除法器Verilog代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module divider(
	input I_clk,
	input I_clk_en,
	input I_rst_n,
	
	input I_in_valid,
	input [15:0] I_y,
	input [7:0]	 I_x,
	
	output [7:0] O_quot,
	output [7:0] O_rem,
	output O_out_valid
);

wire W_data_check_pass = (I_y[15:8] < I_x) ? 1'b1 : 1'b0;

reg R_cnt_en;
reg [2:0] R_cnt;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		R_cnt_en <= 1'd0;
	else if(I_clk_en) begin
		if(I_in_valid) begin
			if(W_data_check_pass)
				R_cnt_en <= 1'd1;
			else 
				R_cnt_en <= 1'd0;
		end
		else if(R_cnt_en && (R_cnt == 3'd0))
			R_cnt_en <= 1'd0;	
	end
end
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		R_cnt <= 3'd0;
	else if(I_clk_en) begin
		if(I_in_valid && W_data_check_pass)
			R_cnt <= 3'd7;
		else if(R_cnt_en)
			R_cnt <= R_cnt - 1'd1;
	end
end

reg [15:0] 	R_r_in;
reg [7:0] 	R_x_in;
wire [15:0] R_r_out;
wire 		R_q_out;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		R_r_in <= 'd0;
		R_x_in <= 'd0;
	end
	else if(I_clk_en) begin
		if(I_in_valid) begin
			if(W_data_check_pass) begin
				R_r_in <= I_y;
				R_x_in <= I_x;
			end
			else begin
				R_r_in <= 'd0;
				R_x_in <= 'd0;
			end
		end
		else begin
			R_r_in <= R_r_out;
			R_x_in <= R_x_in;
		end
	end
end

divider_shift u0(
	.I_k(R_cnt),	
	.I_r(R_r_in),
	.I_x(R_x_in),
	
	.O_q(R_q_out),
	.O_r(R_r_out)
);

reg [7:0] R_q_out_buff;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_q_out_buff <= 'd0;
	else if(I_clk_en) begin
		if(I_in_valid) 
			R_q_out_buff <= 'd0;
		else 
			R_q_out_buff[R_cnt] <= R_q_out;
	end
end

assign O_quot = R_q_out_buff;
assign O_rem  = R_r_out;

reg R_cnt_en_d;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		R_cnt_en_d <= 1'd0;
	else if(I_clk_en) 
		R_cnt_en_d <= R_cnt_en;	
end
assign O_out_valid = ~R_cnt_en & R_cnt_en_d;

endmodule
