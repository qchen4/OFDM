//////////////////////////////////////////////////////////////
// 功能: (2,1,7)卷积码回溯电路
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module traceback64_unit #(
    parameter C_TRACEBACK_LENGTH = 6'd36,
    parameter C_TRACEBACK_IDX = 6'd0
)(
	input [5:0] I_set_branch,
	input [C_TRACEBACK_LENGTH-1:0] I_branch0,
	input [C_TRACEBACK_LENGTH-1:0] I_branch1,
	input [C_TRACEBACK_LENGTH-1:0] I_branch2,
	input [C_TRACEBACK_LENGTH-1:0] I_branch3,
	input [C_TRACEBACK_LENGTH-1:0] I_branch4,
	input [C_TRACEBACK_LENGTH-1:0] I_branch5,
	input [C_TRACEBACK_LENGTH-1:0] I_branch6,
	input [C_TRACEBACK_LENGTH-1:0] I_branch7,
	input [C_TRACEBACK_LENGTH-1:0] I_branch8,
	input [C_TRACEBACK_LENGTH-1:0] I_branch9,
	input [C_TRACEBACK_LENGTH-1:0] I_branch10,
	input [C_TRACEBACK_LENGTH-1:0] I_branch11,
	input [C_TRACEBACK_LENGTH-1:0] I_branch12,
	input [C_TRACEBACK_LENGTH-1:0] I_branch13,
	input [C_TRACEBACK_LENGTH-1:0] I_branch14,
	input [C_TRACEBACK_LENGTH-1:0] I_branch15,
	input [C_TRACEBACK_LENGTH-1:0] I_branch16,
	input [C_TRACEBACK_LENGTH-1:0] I_branch17,
	input [C_TRACEBACK_LENGTH-1:0] I_branch18,
	input [C_TRACEBACK_LENGTH-1:0] I_branch19,
	input [C_TRACEBACK_LENGTH-1:0] I_branch20,
	input [C_TRACEBACK_LENGTH-1:0] I_branch21,
	input [C_TRACEBACK_LENGTH-1:0] I_branch22,
	input [C_TRACEBACK_LENGTH-1:0] I_branch23,
	input [C_TRACEBACK_LENGTH-1:0] I_branch24,
	input [C_TRACEBACK_LENGTH-1:0] I_branch25,
	input [C_TRACEBACK_LENGTH-1:0] I_branch26,
	input [C_TRACEBACK_LENGTH-1:0] I_branch27,
	input [C_TRACEBACK_LENGTH-1:0] I_branch28,
	input [C_TRACEBACK_LENGTH-1:0] I_branch29,
	input [C_TRACEBACK_LENGTH-1:0] I_branch30,
	input [C_TRACEBACK_LENGTH-1:0] I_branch31,
	input [C_TRACEBACK_LENGTH-1:0] I_branch32,
	input [C_TRACEBACK_LENGTH-1:0] I_branch33,
	input [C_TRACEBACK_LENGTH-1:0] I_branch34,
	input [C_TRACEBACK_LENGTH-1:0] I_branch35,
	input [C_TRACEBACK_LENGTH-1:0] I_branch36,
	input [C_TRACEBACK_LENGTH-1:0] I_branch37,
	input [C_TRACEBACK_LENGTH-1:0] I_branch38,
	input [C_TRACEBACK_LENGTH-1:0] I_branch39,
	input [C_TRACEBACK_LENGTH-1:0] I_branch40,
	input [C_TRACEBACK_LENGTH-1:0] I_branch41,
	input [C_TRACEBACK_LENGTH-1:0] I_branch42,
	input [C_TRACEBACK_LENGTH-1:0] I_branch43,
	input [C_TRACEBACK_LENGTH-1:0] I_branch44,
	input [C_TRACEBACK_LENGTH-1:0] I_branch45,
	input [C_TRACEBACK_LENGTH-1:0] I_branch46,
	input [C_TRACEBACK_LENGTH-1:0] I_branch47,
	input [C_TRACEBACK_LENGTH-1:0] I_branch48,
	input [C_TRACEBACK_LENGTH-1:0] I_branch49,
	input [C_TRACEBACK_LENGTH-1:0] I_branch50,
	input [C_TRACEBACK_LENGTH-1:0] I_branch51,
	input [C_TRACEBACK_LENGTH-1:0] I_branch52,
	input [C_TRACEBACK_LENGTH-1:0] I_branch53,
	input [C_TRACEBACK_LENGTH-1:0] I_branch54,
	input [C_TRACEBACK_LENGTH-1:0] I_branch55,
	input [C_TRACEBACK_LENGTH-1:0] I_branch56,
	input [C_TRACEBACK_LENGTH-1:0] I_branch57,
	input [C_TRACEBACK_LENGTH-1:0] I_branch58,
	input [C_TRACEBACK_LENGTH-1:0] I_branch59,
	input [C_TRACEBACK_LENGTH-1:0] I_branch60,
	input [C_TRACEBACK_LENGTH-1:0] I_branch61,
	input [C_TRACEBACK_LENGTH-1:0] I_branch62,
	input [C_TRACEBACK_LENGTH-1:0] I_branch63,
	output reg [5:0] O_set_branch,
	output O_dec_bits
);

assign O_dec_bits = I_set_branch[5];

always @(*) begin
	if(I_set_branch == 0) begin
		if(I_branch0[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 0;
		end
		else begin
			O_set_branch <= 1;
		end
	end
	else if(I_set_branch == 32) begin
		if(I_branch32[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 0;
		end
		else begin
			O_set_branch <= 1;
		end
	end
	else if(I_set_branch == 16) begin
		if(I_branch16[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 32;
		end
		else begin
			O_set_branch <= 33;
		end
	end
	else if(I_set_branch == 48) begin
		if(I_branch48[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 32;
		end
		else begin
			O_set_branch <= 33;
		end
	end
	else if(I_set_branch == 8) begin
		if(I_branch8[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 16;
		end
		else begin
			O_set_branch <= 17;
		end
	end
	else if(I_set_branch == 40) begin
		if(I_branch40[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 16;
		end
		else begin
			O_set_branch <= 17;
		end
	end
	else if(I_set_branch == 24) begin
		if(I_branch24[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 48;
		end
		else begin
			O_set_branch <= 49;
		end
	end
	else if(I_set_branch == 56) begin
		if(I_branch56[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 48;
		end
		else begin
			O_set_branch <= 49;
		end
	end
	else if(I_set_branch == 4) begin
		if(I_branch4[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 8;
		end
		else begin
			O_set_branch <= 9;
		end
	end
	else if(I_set_branch == 36) begin
		if(I_branch36[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 8;
		end
		else begin
			O_set_branch <= 9;
		end
	end
	else if(I_set_branch == 20) begin
		if(I_branch20[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 40;
		end
		else begin
			O_set_branch <= 41;
		end
	end
	else if(I_set_branch == 52) begin
		if(I_branch52[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 40;
		end
		else begin
			O_set_branch <= 41;
		end
	end
	else if(I_set_branch == 12) begin
		if(I_branch12[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 24;
		end
		else begin
			O_set_branch <= 25;
		end
	end
	else if(I_set_branch == 44) begin
		if(I_branch44[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 24;
		end
		else begin
			O_set_branch <= 25;
		end
	end
	else if(I_set_branch == 28) begin
		if(I_branch28[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 56;
		end
		else begin
			O_set_branch <= 57;
		end
	end
	else if(I_set_branch == 60) begin
		if(I_branch60[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 56;
		end
		else begin
			O_set_branch <= 57;
		end
	end
	else if(I_set_branch == 2) begin
		if(I_branch2[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 4;
		end
		else begin
			O_set_branch <= 5;
		end
	end
	else if(I_set_branch == 34) begin
		if(I_branch34[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 4;
		end
		else begin
			O_set_branch <= 5;
		end
	end
	else if(I_set_branch == 18) begin
		if(I_branch18[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 36;
		end
		else begin
			O_set_branch <= 37;
		end
	end
	else if(I_set_branch == 50) begin
		if(I_branch50[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 36;
		end
		else begin
			O_set_branch <= 37;
		end
	end
	else if(I_set_branch == 10) begin
		if(I_branch10[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 20;
		end
		else begin
			O_set_branch <= 21;
		end
	end
	else if(I_set_branch == 42) begin
		if(I_branch42[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 20;
		end
		else begin
			O_set_branch <= 21;
		end
	end
	else if(I_set_branch == 26) begin
		if(I_branch26[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 52;
		end
		else begin
			O_set_branch <= 53;
		end
	end
	else if(I_set_branch == 58) begin
		if(I_branch58[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 52;
		end
		else begin
			O_set_branch <= 53;
		end
	end
	else if(I_set_branch == 6) begin
		if(I_branch6[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 12;
		end
		else begin
			O_set_branch <= 13;
		end
	end
	else if(I_set_branch == 38) begin
		if(I_branch38[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 12;
		end
		else begin
			O_set_branch <= 13;
		end
	end
	else if(I_set_branch == 22) begin
		if(I_branch22[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 44;
		end
		else begin
			O_set_branch <= 45;
		end
	end
	else if(I_set_branch == 54) begin
		if(I_branch54[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 44;
		end
		else begin
			O_set_branch <= 45;
		end
	end
	else if(I_set_branch == 14) begin
		if(I_branch14[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 28;
		end
		else begin
			O_set_branch <= 29;
		end
	end
	else if(I_set_branch == 46) begin
		if(I_branch46[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 28;
		end
		else begin
			O_set_branch <= 29;
		end
	end
	else if(I_set_branch == 30) begin
		if(I_branch30[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 60;
		end
		else begin
			O_set_branch <= 61;
		end
	end
	else if(I_set_branch == 62) begin
		if(I_branch62[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 60;
		end
		else begin
			O_set_branch <= 61;
		end
	end
	else if(I_set_branch == 1) begin
		if(I_branch1[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 2;
		end
		else begin
			O_set_branch <= 3;
		end
	end
	else if(I_set_branch == 33) begin
		if(I_branch33[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 2;
		end
		else begin
			O_set_branch <= 3;
		end
	end
	else if(I_set_branch == 17) begin
		if(I_branch17[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 34;
		end
		else begin
			O_set_branch <= 35;
		end
	end
	else if(I_set_branch == 49) begin
		if(I_branch49[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 34;
		end
		else begin
			O_set_branch <= 35;
		end
	end
	else if(I_set_branch == 9) begin
		if(I_branch9[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 18;
		end
		else begin
			O_set_branch <= 19;
		end
	end
	else if(I_set_branch == 41) begin
		if(I_branch41[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 18;
		end
		else begin
			O_set_branch <= 19;
		end
	end
	else if(I_set_branch == 25) begin
		if(I_branch25[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 50;
		end
		else begin
			O_set_branch <= 51;
		end
	end
	else if(I_set_branch == 57) begin
		if(I_branch57[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 50;
		end
		else begin
			O_set_branch <= 51;
		end
	end
	else if(I_set_branch == 5) begin
		if(I_branch5[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 10;
		end
		else begin
			O_set_branch <= 11;
		end
	end
	else if(I_set_branch == 37) begin
		if(I_branch37[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 10;
		end
		else begin
			O_set_branch <= 11;
		end
	end
	else if(I_set_branch == 21) begin
		if(I_branch21[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 42;
		end
		else begin
			O_set_branch <= 43;
		end
	end
	else if(I_set_branch == 53) begin
		if(I_branch53[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 42;
		end
		else begin
			O_set_branch <= 43;
		end
	end
	else if(I_set_branch == 13) begin
		if(I_branch13[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 26;
		end
		else begin
			O_set_branch <= 27;
		end
	end
	else if(I_set_branch == 45) begin
		if(I_branch45[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 26;
		end
		else begin
			O_set_branch <= 27;
		end
	end
	else if(I_set_branch == 29) begin
		if(I_branch29[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 58;
		end
		else begin
			O_set_branch <= 59;
		end
	end
	else if(I_set_branch == 61) begin
		if(I_branch61[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 58;
		end
		else begin
			O_set_branch <= 59;
		end
	end
	else if(I_set_branch == 3) begin
		if(I_branch3[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 6;
		end
		else begin
			O_set_branch <= 7;
		end
	end
	else if(I_set_branch == 35) begin
		if(I_branch35[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 6;
		end
		else begin
			O_set_branch <= 7;
		end
	end
	else if(I_set_branch == 19) begin
		if(I_branch19[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 38;
		end
		else begin
			O_set_branch <= 39;
		end
	end
	else if(I_set_branch == 51) begin
		if(I_branch51[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 38;
		end
		else begin
			O_set_branch <= 39;
		end
	end
	else if(I_set_branch == 11) begin
		if(I_branch11[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 22;
		end
		else begin
			O_set_branch <= 23;
		end
	end
	else if(I_set_branch == 43) begin
		if(I_branch43[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 22;
		end
		else begin
			O_set_branch <= 23;
		end
	end
	else if(I_set_branch == 27) begin
		if(I_branch27[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 54;
		end
		else begin
			O_set_branch <= 55;
		end
	end
	else if(I_set_branch == 59) begin
		if(I_branch59[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 54;
		end
		else begin
			O_set_branch <= 55;
		end
	end
	else if(I_set_branch == 7) begin
		if(I_branch7[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 14;
		end
		else begin
			O_set_branch <= 15;
		end
	end
	else if(I_set_branch == 39) begin
		if(I_branch39[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 14;
		end
		else begin
			O_set_branch <= 15;
		end
	end
	else if(I_set_branch == 23) begin
		if(I_branch23[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 46;
		end
		else begin
			O_set_branch <= 47;
		end
	end
	else if(I_set_branch == 55) begin
		if(I_branch55[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 46;
		end
		else begin
			O_set_branch <= 47;
		end
	end
	else if(I_set_branch == 15) begin
		if(I_branch15[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 30;
		end
		else begin
			O_set_branch <= 31;
		end
	end
	else if(I_set_branch == 47) begin
		if(I_branch47[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 30;
		end
		else begin
			O_set_branch <= 31;
		end
	end
	else if(I_set_branch == 31) begin
		if(I_branch31[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 62;
		end
		else begin
			O_set_branch <= 63;
		end
	end
	else if(I_set_branch == 63) begin
		if(I_branch63[C_TRACEBACK_IDX] == 1) begin
			O_set_branch <= 62;
		end
		else begin
			O_set_branch <= 63;
		end
	end
end

endmodule
