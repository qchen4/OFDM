//////////////////////////////////////////////////////////////
// 功能: CORDIC算法shift单元
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
//////////////////////////////////////////////////////////////
module cordic_shift #(
	parameter C_DATA_WIDTH = 16,
	parameter C_ANGLE_WIDTH = 16,
	parameter C_ITER_IDX = 0,
	parameter C_ARCTAN_MODE = 1
)(
	input [C_DATA_WIDTH - 1 : 0] I_x, //16S13
	input [C_DATA_WIDTH - 1 : 0] I_y,
	input [C_ANGLE_WIDTH - 1 : 0] I_z,
	input I_d,
	
	input [C_ANGLE_WIDTH - 1 : 0] I_arctan_table_in, //16S13
	
	output reg [C_DATA_WIDTH - 1 : 0] O_x,
	output reg [C_DATA_WIDTH - 1 : 0] O_y,
	output reg [C_ANGLE_WIDTH - 1 : 0] O_z,
	output O_d
);

// 算术右移 C_ITER_IDX 位（C_ITER_IDX=0 时等价于不移位，避免 {0{...}} 在部分工具上出错）
wire [C_DATA_WIDTH-1:0] W_x_shift = $signed(I_x) >>> C_ITER_IDX;
wire [C_DATA_WIDTH-1:0] W_y_shift = $signed(I_y) >>> C_ITER_IDX;

always @(*) begin
	if(I_d == 1'b0) begin //d(i)= -1
		O_x <= I_x + W_y_shift;
		O_y <= I_y - W_x_shift;
		O_z <= I_z + I_arctan_table_in;
	end
	else begin //d(i)= 1
		O_x <= I_x - W_y_shift;
		O_y <= I_y + W_x_shift;
		O_z <= I_z - I_arctan_table_in;
	end
end

generate
	if(C_ARCTAN_MODE == 1) begin : atan_mode
		assign O_d = O_y[C_DATA_WIDTH-1];
	end
	else begin : sin_cos_mode	
		assign O_d = ~O_z[C_ANGLE_WIDTH - 1] ;
	end
endgenerate

endmodule

