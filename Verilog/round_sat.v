/////////////////////////////////////////////////////////////////
// 功能：对输入数据进行四舍五入与饱和处理(Round&Saturation)
// 作者：柳井刚（B站/微信公众号：柳同学聊芯片）
// 本代码是《OFDM无线通信芯片设计实战》一书的随书代码
// 使用说明：正确使用这个IP必须满足以下三个条件：
// 1.I_in 和 O_out均为mSn数据格式的有符号数
// 2.C_IN_W2 >= C_OUT_W2    Note : input的小数位宽必须大于等于output的小数位宽
// 3.(C_IN_W1 - C_IN_W2) >= (C_OUT_W1 - C_OUT_W2) Note : input的整数位宽必须大于等于output的整数数位宽
// 调用范例： round_sat #(6,4,4,2) u_round_sat(.I_in(a),.O_out(b));
/////////////////////////////////////////////////////////////////
module round_sat#(
	parameter C_IN_W1  = 6, // 输入数据总位宽
	parameter C_IN_W2  = 4, // 输入数据小数位宽
	parameter C_OUT_W1 = 4, // 输出数据总位宽
	parameter C_OUT_W2 = 2  // 输出数据小数位宽
)(
	input		[C_IN_W1  -1 : 0]	I_in, // 6S4
	output	reg	[C_OUT_W1 -1 : 0]	O_out // 4S2
);

////////////// 四舍五入的代码 //////////////////////////
wire W_carry_bit;
generate
	if((C_IN_W2 - C_OUT_W2) == 0) begin : W_carry_bit_case1
		assign W_carry_bit = 1'b0;
	end
	else if((C_IN_W2 - C_OUT_W2) == 1) begin : W_carry_bit_case2
		assign W_carry_bit = I_in[C_IN_W1 - 1] ? 1'b0 : I_in[0];
	end
	else begin : W_carry_bit_case3
		assign W_carry_bit = I_in[C_IN_W1 - 1] ? ( I_in[C_IN_W2  - C_OUT_W2 - 1] & (|I_in[(C_IN_W2  - C_OUT_W2 - 2):0]) ) : I_in[C_IN_W2  - C_OUT_W2 - 1] ;
	end
endgenerate

wire [C_OUT_W1-1 : 0] W_in_round = I_in[((C_IN_W2-C_OUT_W2)+(C_OUT_W1-1)): (C_IN_W2-C_OUT_W2)] + W_carry_bit;

////////////// 饱和处理的代码 //////////////////////////
//将输出数据格式最大值进行符号位扩展为输入数据格式
wire [C_IN_W1-1 : 0] W_out_max = {{((C_IN_W1-C_IN_W2)-(C_OUT_W1-C_OUT_W2)){1'b0}},{1'b0,{(C_OUT_W1-1){1'b1}}},{(C_IN_W2-C_OUT_W2){1'b0}}};	
//将输出数据格式最小值进行符号位扩展为输入数据格式
wire [C_IN_W1-1 : 0] W_out_min = {{((C_IN_W1-C_IN_W2)-(C_OUT_W1-C_OUT_W2)){1'b1}},{1'b1,{(C_OUT_W1-1){1'b0}}},{(C_IN_W2-C_OUT_W2){1'b0}}};

always @(*) begin
	if(I_in[C_IN_W1-1] == 1'b0) begin
		if(I_in >= W_out_max)
			O_out <= {1'b0,{(C_OUT_W1-1){1'b1}}};
		else
			O_out <= W_in_round;
	end
	else begin
		if(I_in <= W_out_min)
			O_out <= {1'b1,{(C_OUT_W1-1){1'b0}}};
		else
			O_out <= W_in_round;
	end
end
 
endmodule