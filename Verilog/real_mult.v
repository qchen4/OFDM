/////////////////////////////////////////////////////////////////
// 功能：实数乘法器
// 作者：柳井刚（B站/微信龚公众号：柳同学聊芯片）
// 本代码是《OFDM无线通信芯片设计实战》一书的随书代码
// 第1个参数用来选择有符号乘法还是无符号乘法  
// 第2和第3个参数用来分别设置两个输入数据的位宽  
// 调用范例：
// real_mult #(1,8,4) u_real_mult(.I_in1(a),.I_in2(b),.O_out(c));
///////////////////////////////////////////////////////////////
module real_mult #(
	parameter C_MULT_MODE = 1, // 1:有符号乘法 0:无符号乘法
	parameter C_IN_W1  	= 8, // 第1个输入总位宽
	parameter C_IN_W2  	= 4  // 第2个输入总位宽
)
(
	input		[C_IN_W1  -1 : 0]	I_in1, 
	input		[C_IN_W2  -1 : 0]	I_in2, 
	output		[C_IN_W1 + C_IN_W2 -1 : 0]	O_out 
);

generate
	if(C_MULT_MODE == 1) begin : signed_multiplier
		wire [C_IN_W1 - 1 : 0] W_in1_abs = I_in1[C_IN_W1 - 1] ? -I_in1 : I_in1;
		wire [C_IN_W2 - 1 : 0] W_in2_abs = I_in2[C_IN_W2 - 1] ? -I_in2 : I_in2;

		wire [C_IN_W1 + C_IN_W2 -1 : 0]	W_mult_out_abs = W_in1_abs * W_in2_abs;

		assign O_out = (I_in1[C_IN_W1-1] == I_in2[C_IN_W2-1]) ? W_mult_out_abs : -W_mult_out_abs;
	end
	else begin : unsigned_multiplier
		assign O_out = I_in1 * I_in2;
	end
endgenerate
 
endmodule 