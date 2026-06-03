//////////////////////////////////////////////////////////////
// 功能: RX伪MAC模块的Verilog代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module rx_pseudo_mac(
	input I_clk,
	input I_rst_n,
	input I_clk_en_20M,
	input I_clk_en_40M,
	
	input I_rx_bits,
	input I_rx_bits_valid,
		
	output O_mac_start_rx	
);

reg [3:0] R_rx_mac_cnt;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		R_rx_mac_cnt <= 4'd0;
	else if(I_clk_en_20M) begin
		if(R_rx_mac_cnt == 4'd15)
			R_rx_mac_cnt <= 4'd15;
		else
			R_rx_mac_cnt <= R_rx_mac_cnt + 1'b1;
	end
end

assign O_mac_start_rx = (R_rx_mac_cnt == 4'd10) ? 1'b1 : 1'b0;

reg [567:0] R_buff;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		R_buff <= 8'd0;
	else if(I_clk_en_40M & I_rx_bits_valid) 
		R_buff <= {R_buff[566:0],I_rx_bits};
end

//测试pattern
// 76是‘L’的ASCLL码
// 101是‘e’的ASCLL码
// 116是‘t’的ASCLL码
// 32是‘ ’的ASCLL码
//wire [31:0] display_str = {8'd76,8'd101,8'd116,8'd32};
              
endmodule