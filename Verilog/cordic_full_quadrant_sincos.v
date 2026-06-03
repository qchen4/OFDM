//////////////////////////////////////////////////////////////
// 功能: CORDIC算法求整个坐标平面的sin和cos值
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
//////////////////////////////////////////////////////////////
module cordic_full_quadrant_sincos #(
	parameter C_DATA_WIDTH = 16,
	parameter C_ANGLE_WIDTH = 16,
	parameter C_ITER_NUM = 11
)(
	input [C_ANGLE_WIDTH - 1 : 0] I_theta, //16S13
	
	output reg [C_DATA_WIDTH - 1 : 0] O_sin,
	output reg [C_DATA_WIDTH - 1 : 0] O_cos
);

localparam C_PI = 16'd25736; // 16S13
localparam C_PI_DIV2 = 16'd12868; // 16S13

// 角度预处理
reg [C_ANGLE_WIDTH-1:0] R_cordic_in_theta;
always @(*) begin
	// 第二象限 theta>pi/2 && theta<pi
	if((I_theta>C_PI_DIV2)&&(I_theta<C_PI)) begin 
		R_cordic_in_theta <= I_theta - C_PI_DIV2; // theta - pi/2
	end
	// 第三象限  theta<-pi/2 && theta>-pi
	else if((I_theta<(-C_PI_DIV2))&&(I_theta>(-C_PI))) begin 
		R_cordic_in_theta <= I_theta + C_PI_DIV2; // theta + pi/2
	end
	else begin
		R_cordic_in_theta <= I_theta; // theta
	end
end

wire [C_DATA_WIDTH-1:0] W_cordic_out_sin;
wire [C_DATA_WIDTH-1:0] W_cordic_out_cos;
cordic_sincos #(
	.C_DATA_WIDTH(16),
	.C_ANGLE_WIDTH(16),
	.C_ITER_NUM(11)
)u(
	.I_theta(R_cordic_in_theta), //16S13
	
	.O_sin(W_cordic_out_sin),	
	.O_cos(W_cordic_out_cos)
);

always @(*) begin
	if(I_theta == 16'd0) begin // X轴正半轴 角度=0
		O_sin <= 'd0;     // sin0 = 0
		O_cos <= 'd8192;  // cos0 = 1
	end
	else if(I_theta == C_PI_DIV2) begin // Y轴正半轴 角度=90
		O_sin <= 'd8192;     // sin(pi/2) = 1
		O_cos <= 'd0;        // cos(pi/2) = 0
	end
	else if(I_theta == C_PI) begin // X轴负半轴 角度=180或者-180
		O_sin <= 'd0;         // sin(pi) = 0
		O_cos <= -16'd8192;   // cos(pi) = -1
	end
	else if(I_theta == -C_PI_DIV2) begin // Y轴负半轴 角度=-90
		O_sin <= -16'd8192;         // sin(-pi/2) = -1
		O_cos <= 'd0;   // cos(-pi/2) = 0
	end
	// 第二象限 theta>pi/2 && theta<pi
	else if((I_theta>C_PI_DIV2)&&(I_theta<C_PI)) begin 
		O_sin <=  W_cordic_out_cos ; // sin(theta+pi/2) = cos(theta)
		O_cos <= -W_cordic_out_sin;  // cos(theta+pi/2) = -sin(theta)
	end
	// 第三象限 theta<-pi/2 && theta>-pi
	else if((I_theta<(-C_PI_DIV2))&&(I_theta>(-C_PI))) begin 
		O_sin <= -W_cordic_out_cos ; // sin(theta-pi/2) = -cos(theta)
		O_cos <=  W_cordic_out_sin;  // cos(theta-pi/2) = sin(theta)
	end
	else begin
		O_sin <=  W_cordic_out_sin ;    
		O_cos <=  W_cordic_out_cos;    
	end
end

endmodule
