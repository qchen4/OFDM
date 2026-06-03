//////////////////////////////////////////////////////////////
// 功能: RX导频扰码器Verilog代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module rx_pilot_scramble(
	input I_clk,
	input I_clk_en,
	input I_rst_n,
	
	input I_pilot_scramble_en,
	input [10:0] I_rx_ofdm_symbol_idx,	
	output O_pilot_scramble_out,
	output O_pilot_scramble_out_start
);
	wire W_load_init_state = I_pilot_scramble_en & (I_rx_ofdm_symbol_idx==11'd0);

	reg [6:0] R_buff;	
	wire W_sftreg_in = R_buff[6] + R_buff[3];
	
	always @(posedge I_clk or negedge I_rst_n) begin
	   if(~I_rst_n)
			R_buff <= 7'd0;   
       else if(W_load_init_state)
			R_buff <= 7'b1111111;
       else if(I_clk_en & I_pilot_scramble_en) 
            R_buff <= {R_buff[5:0], W_sftreg_in};
	end	
	
	assign O_pilot_scramble_out = W_sftreg_in;
	assign O_pilot_scramble_out_start = W_load_init_state;	
endmodule 
