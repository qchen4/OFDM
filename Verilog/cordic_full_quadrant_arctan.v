//////////////////////////////////////////////////////////////
// 功能: CORDIC算法求整个坐标平面的角度值
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
//////////////////////////////////////////////////////////////
module cordic_full_quadrant_arctan #(
	parameter C_DATA_WIDTH = 16,
	parameter C_ANGLE_WIDTH = 16,
	parameter C_ITER_NUM = 11
)(
	input [C_DATA_WIDTH - 1 : 0] I_x, //16S13
	input [C_DATA_WIDTH - 1 : 0] I_y,
	
	output reg [C_ANGLE_WIDTH - 1 : 0] O_theta
);

localparam C_PI = 16'd25736; // 16S13
localparam C_PI_DIV2 = 16'd12868; // 16S13

// 角度预处理
reg [C_DATA_WIDTH-1:0] R_arctan_in_x;
reg [C_DATA_WIDTH-1:0] R_arctan_in_y;
always @(*) begin
	// 第二象限 x<0 && y>0
	if((I_x[C_DATA_WIDTH-1] == 1) && (I_y[C_DATA_WIDTH-1] == 0)) begin 
		R_arctan_in_x <= I_y;
		R_arctan_in_y <= -I_x;
	end
	//第三象限  x<0 && y<0
	else if((I_x[C_DATA_WIDTH-1] == 1) && (I_y[C_DATA_WIDTH-1] == 1)) begin 
		R_arctan_in_x <= -I_y;
		R_arctan_in_y <= I_x;
	end
	// 第一、四象限
	else begin
		R_arctan_in_x <= I_x;
		R_arctan_in_y <= I_y;
	end
end

wire [C_ANGLE_WIDTH-1:0] W_arctan_out;
cordic_arctan #(
	.C_DATA_WIDTH(16),
	.C_ANGLE_WIDTH(16),
	.C_ITER_NUM(11)
)u(
	.I_x(R_arctan_in_x), //16S13
	.I_y(R_arctan_in_y),	
	.O_theta(W_arctan_out)
);

always @(*) begin
	if((I_x == 0) && (I_y == 0)) begin // 坐标原点
		O_theta <= 'd0;
	end
	// X轴正半轴 x>0 && y==0
	else if((I_x[C_DATA_WIDTH-1] == 0) && (I_y == 0)) begin 
		O_theta <= 'd0;
	end
	// Y轴正半轴 x==0 && y>0
	else if((I_x == 0) && (I_y[C_DATA_WIDTH-1] == 0)) begin
		O_theta <= C_PI_DIV2; // pi/2
	end
	// X轴负半轴 x<0 && y==0
	else if((I_x[C_DATA_WIDTH-1] == 1) && (I_y == 0)) begin 
		O_theta <= -C_PI; // pi
	end
	// Y轴负半轴 x==0 && y<0
	else if((I_x == 0) && (I_y[C_DATA_WIDTH-1] == 1)) begin 
		O_theta <= -C_PI_DIV2; // -pi/2
	end
	// 第二象限 x<0 && y>0
	else if((I_x[C_DATA_WIDTH-1] == 1) && (I_y[C_DATA_WIDTH-1] == 0)) begin 
		O_theta <= W_arctan_out + C_PI_DIV2; // theta + pi/2
	end
	// 第三象限 x<0 && y<0
	else if((I_x[C_DATA_WIDTH-1] == 1) && (I_y[C_DATA_WIDTH-1] == 1)) begin 
		O_theta <= W_arctan_out - C_PI_DIV2; // theta - pi/2
	end
	// 第一、四象限
	else begin
		O_theta <= W_arctan_out; 
	end
end

endmodule
