//////////////////////////////////////////////////////////////
// 功能: 除法器的shift单元Verilog代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module divider_shift(
	input [2:0] I_k,	
	input [15:0] I_r,
	input [7:0]	 I_x,
	
	output reg		 O_q,
	output reg [15:0] O_r
);

reg [15:0] R_x_shift;
always @(*) begin
	case(I_k)
		3'd7 	: 	begin R_x_shift = I_x << 7; end
		3'd6 	: 	begin R_x_shift = I_x << 6; end
		3'd5 	: 	begin R_x_shift = I_x << 5; end
		3'd4 	: 	begin R_x_shift = I_x << 4; end
		3'd3 	: 	begin R_x_shift = I_x << 3; end
		3'd2 	: 	begin R_x_shift = I_x << 2; end
		3'd1 	: 	begin R_x_shift = I_x << 1; end
		default : 	begin R_x_shift = I_x << 0; end		
	endcase
end

wire [15:0] R_r_diff = I_r - R_x_shift;

always @(*) begin
	if(R_r_diff[15]) begin
		O_q <= 1'b0;
		O_r <= I_r;
	end
	else begin
		O_q <= 1'b1;
		O_r <= R_r_diff;
	end
end

endmodule