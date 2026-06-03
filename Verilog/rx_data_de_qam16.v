//////////////////////////////////////////////////////////////
// 功能: DATA域数据16-QAM解调代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module rx_data_de_qam16(
	input I_clk,
	input I_rst_n,
	input I_clk_en,
	
	input [13:0] I_de_qam16_threshold, //14S7
		
	input I_rx_de_qam16_valid,
	input [13:0] I_rx_de_qam16_i, //14S7
	input [13:0] I_rx_de_qam16_q, //14S7
	
	output reg O_rx_de_qam16_out,
	output reg O_rx_de_qam16_out_valid,
	output O_rx_de_qam16_done
);

wire [13:0] W_threshold_pos =  I_de_qam16_threshold;
wire [13:0] W_threshold_neg = -I_de_qam16_threshold;

reg R_rx_de_qam16_valid_d;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_rx_de_qam16_valid_d <= 1'b0;
	else 
		R_rx_de_qam16_valid_d <= I_rx_de_qam16_valid;
end

wire W_de_qam16_start = ~R_rx_de_qam16_valid_d & I_rx_de_qam16_valid;

reg [13:0] R_rx_de_qam16_i_d;
reg [13:0] R_rx_de_qam16_q_d;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		R_rx_de_qam16_i_d <= 'd0;
		R_rx_de_qam16_q_d <= 'd0;
	end
	else if(I_rx_de_qam16_valid) begin
		R_rx_de_qam16_i_d <= I_rx_de_qam16_i;
		R_rx_de_qam16_q_d <= I_rx_de_qam16_q;
	end
end

reg [0:3] R_symbol; //=[b0 b1 b2 b3]
always @(*) begin
	if(R_rx_de_qam16_i_d[13]) begin // I_rx_de_qam16_i是负数
		if(R_rx_de_qam16_i_d < W_threshold_neg) // I<-2
			R_symbol[0:1] <= 2'b00;
		else  //-2<=I<=0
			R_symbol[0:1] <= 2'b01;
	end
	else begin // I_rx_de_qam16_i是正数
		if(R_rx_de_qam16_i_d > W_threshold_pos) // I>2
			R_symbol[0:1] <= 2'b10;
		else  //0<=I<=2
			R_symbol[0:1] <= 2'b11;
	end	
end

always @(*) begin
	if(R_rx_de_qam16_q_d[13]) begin // I_rx_de_qam16_q是负数
		if(R_rx_de_qam16_q_d < W_threshold_neg) // Q<-2
			R_symbol[2:3] <= 2'b00;
		else  //-2<=Q<=0
			R_symbol[2:3] <= 2'b01;
	end
	else begin // I_rx_de_qam16_q是正数
		if(R_rx_de_qam16_q_d > W_threshold_pos) // Q>2
			R_symbol[2:3] <= 2'b10;
		else  //0<=Q<=2
			R_symbol[2:3] <= 2'b11;
	end	
end

reg [1:0] R_de_qam16_cnt;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_de_qam16_cnt <= 2'd0;
	else if(W_de_qam16_start)
		R_de_qam16_cnt <= 2'd0;
	else if(R_rx_de_qam16_valid_d)
		R_de_qam16_cnt <= R_de_qam16_cnt + 1'b1;
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		O_rx_de_qam16_out <= 1'b0;
	else if(W_de_qam16_start)
		O_rx_de_qam16_out <= 1'b0;
	else if(R_rx_de_qam16_valid_d)
		O_rx_de_qam16_out <= R_symbol[R_de_qam16_cnt];
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		O_rx_de_qam16_out_valid <= 1'b0;
	else 
		O_rx_de_qam16_out_valid <= R_rx_de_qam16_valid_d;
end

assign O_rx_de_qam16_done = ~R_rx_de_qam16_valid_d & O_rx_de_qam16_out_valid;

endmodule 
