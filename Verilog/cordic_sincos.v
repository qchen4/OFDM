//////////////////////////////////////////////////////////////
// 功能: CORDIC算法求三角函数值(sin&cos)
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
//////////////////////////////////////////////////////////////
module cordic_sincos #(
	parameter C_DATA_WIDTH = 16,
	parameter C_ANGLE_WIDTH = 16,
	parameter C_ITER_NUM = 11
)(
	input [C_ANGLE_WIDTH - 1 : 0] I_theta, //16S13
	
	output [C_DATA_WIDTH - 1 : 0] O_sin,
	output [C_DATA_WIDTH - 1 : 0] O_cos
);

wire [C_ANGLE_WIDTH-1:0] W_arctan_table[0:C_ITER_NUM-1] ;

assign W_arctan_table[0] =  6434;
assign W_arctan_table[1] =  3798;
assign W_arctan_table[2] =  2007;
assign W_arctan_table[3] =  1019;
assign W_arctan_table[4] =   511;
assign W_arctan_table[5] =   256;
assign W_arctan_table[6] =   128;
assign W_arctan_table[7] =    64;
assign W_arctan_table[8] =    32;
assign W_arctan_table[9] =    16;
assign W_arctan_table[10] =    8;

wire [C_DATA_WIDTH-1:0] W_x[0:C_ITER_NUM];
wire [C_DATA_WIDTH-1:0] W_y[0:C_ITER_NUM];
wire [C_ANGLE_WIDTH-1:0] W_z[0:C_ITER_NUM];
wire W_d[0:C_ITER_NUM];

assign W_x[0] = 16'd4975; // 16S13  1/Kn
assign W_y[0] = 16'd0;
assign W_z[0] = I_theta;
assign W_d[0] = ~I_theta[C_DATA_WIDTH - 1];

genvar i;
generate
   for(i = 0; i < C_ITER_NUM; i = i + 1) begin
	   cordic_shift
		#(	.C_DATA_WIDTH(C_DATA_WIDTH),
			.C_ANGLE_WIDTH(C_ANGLE_WIDTH),
			.C_ITER_IDX(i),
			.C_ARCTAN_MODE(0))
		u(
			.I_x(W_x[i]), //16S13
			.I_y(W_y[i]),
			.I_z(W_z[i]),
			.I_d(W_d[i]),
			.I_arctan_table_in(W_arctan_table[i]),
			.O_x(W_x[i+1]),
			.O_y(W_y[i+1]),
			.O_z(W_z[i+1]),
			.O_d(W_d[i+1])
		);
   end
endgenerate 

assign O_cos = W_x[C_ITER_NUM];
assign O_sin = W_y[C_ITER_NUM];

endmodule
