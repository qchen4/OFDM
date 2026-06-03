/////////////////////////////////////////////////
// 功能：四乘二加结构的复数乘法器
// 作者：柳井刚（B站/微信公众号：柳同学聊芯片）
// (a+b*j)*(c+d*j) = (ac-bd) + (ad+bc)*j
// 调用范例： 
// complex_mult #(8,4) u_complex_mult(
//	.I_in1_i(a),
//	.I_in1_q(b),
//	.I_in2_i(c),
//	.I_in2_q(d),	
//	.O_out_i(e),	
//	.O_out_q(f));
//////////////////////////////////////////////////
module complex_mult #(
	parameter C_MULT_MODE = 1, // 1:有符号乘法   0:无符号乘法
	parameter C_IN_W1  	= 8, // 第一个输入数据的总位宽
	parameter C_IN_W2  	= 4  // 第二个输入数据的总位宽
)
(
	input		[C_IN_W1  -1 		: 0]	I_in1_i, 
	input		[C_IN_W1  -1 		: 0]	I_in1_q, 
	input		[C_IN_W2  -1 		: 0]	I_in2_i, 
	input		[C_IN_W2  -1 		: 0]	I_in2_q, 
	output		[C_IN_W1 + C_IN_W2 	: 0]	O_out_i, 
	output		[C_IN_W1 + C_IN_W2 	: 0]	O_out_q
);

wire [C_IN_W1  -1 : 0]	a = I_in1_i ; 
wire [C_IN_W1  -1 : 0]	b = I_in1_q ; 
wire [C_IN_W2  -1 : 0]	c = I_in2_i ; 
wire [C_IN_W2  -1 : 0]	d = I_in2_q ; 

wire [C_IN_W1 + C_IN_W2 -1 : 0]	ac ;
wire [C_IN_W1 + C_IN_W2 -1 : 0]	bd ;
wire [C_IN_W1 + C_IN_W2 -1 : 0]	ad ;
wire [C_IN_W1 + C_IN_W2 -1 : 0]	bc ;

real_mult #(C_MULT_MODE,C_IN_W1,C_IN_W2) u1(.I_in1(a),.I_in2(c),.O_out(ac));
real_mult #(C_MULT_MODE,C_IN_W1,C_IN_W2) u2(.I_in1(b),.I_in2(d),.O_out(bd));
real_mult #(C_MULT_MODE,C_IN_W1,C_IN_W2) u3(.I_in1(a),.I_in2(d),.O_out(ad));
real_mult #(C_MULT_MODE,C_IN_W1,C_IN_W2) u4(.I_in1(b),.I_in2(c),.O_out(bc));

//扩展符号位
assign O_out_i = {ac[C_IN_W1+C_IN_W2-1],ac} - {bd[C_IN_W1+C_IN_W2-1],bd} ;
assign O_out_q = {ad[C_IN_W1+C_IN_W2-1],ad} + {bc[C_IN_W1+C_IN_W2-1],bc} ;

endmodule