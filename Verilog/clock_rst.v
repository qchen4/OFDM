//////////////////////////////////////////////////////////////
// 功能: OFDM系统的时钟与复位
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
//////////////////////////////////////////////////////////////
module clock_rst(
	input I_clk, //80M时钟
	input I_rst_n,
	
	output	O_clk_en_40M,
	output  O_clk_en_20M,
	output 	O_rst_n	
);

// 异步复位，同步释放
reg [1:0] R_rst_buff;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		R_rst_buff <= 2'd0;
	else
		R_rst_buff <= {R_rst_buff[0],1'b1};
end
assign O_rst_n = R_rst_buff[1];

// 时钟生成逻辑
reg [1:0] R_clk_en_cnt;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		R_clk_en_cnt <= 2'd0;
	else begin
		if(R_rst_buff[1]) begin
			R_clk_en_cnt <= R_clk_en_cnt + 1'd1;
		end
	end
end

assign O_clk_en_40M = (R_clk_en_cnt[0]   == 1'd1) ? 1'b1 : 1'b0;
assign O_clk_en_20M = (R_clk_en_cnt[1:0] == 2'd3) ? 1'b1 : 1'b0;

endmodule