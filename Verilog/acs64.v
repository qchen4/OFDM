//////////////////////////////////////////////////////////////
// 功能: (2,1,7)卷积码加比选电路
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module acs64(
	input I_select_upper_branch,
	input [1:0] I_dis0,
	input [1:0] I_dis1,
	input [1:0] I_dis2,
	input [1:0] I_dis3,
	input [31:0] I_dis_acc0,
	output reg [31:0] O_new_dis_acc0,
	output reg O_branch0,
	input [31:0] I_dis_acc1,
	output reg [31:0] O_new_dis_acc1,
	output reg O_branch1,
	input [31:0] I_dis_acc2,
	output reg [31:0] O_new_dis_acc2,
	output reg O_branch2,
	input [31:0] I_dis_acc3,
	output reg [31:0] O_new_dis_acc3,
	output reg O_branch3,
	input [31:0] I_dis_acc4,
	output reg [31:0] O_new_dis_acc4,
	output reg O_branch4,
	input [31:0] I_dis_acc5,
	output reg [31:0] O_new_dis_acc5,
	output reg O_branch5,
	input [31:0] I_dis_acc6,
	output reg [31:0] O_new_dis_acc6,
	output reg O_branch6,
	input [31:0] I_dis_acc7,
	output reg [31:0] O_new_dis_acc7,
	output reg O_branch7,
	input [31:0] I_dis_acc8,
	output reg [31:0] O_new_dis_acc8,
	output reg O_branch8,
	input [31:0] I_dis_acc9,
	output reg [31:0] O_new_dis_acc9,
	output reg O_branch9,
	input [31:0] I_dis_acc10,
	output reg [31:0] O_new_dis_acc10,
	output reg O_branch10,
	input [31:0] I_dis_acc11,
	output reg [31:0] O_new_dis_acc11,
	output reg O_branch11,
	input [31:0] I_dis_acc12,
	output reg [31:0] O_new_dis_acc12,
	output reg O_branch12,
	input [31:0] I_dis_acc13,
	output reg [31:0] O_new_dis_acc13,
	output reg O_branch13,
	input [31:0] I_dis_acc14,
	output reg [31:0] O_new_dis_acc14,
	output reg O_branch14,
	input [31:0] I_dis_acc15,
	output reg [31:0] O_new_dis_acc15,
	output reg O_branch15,
	input [31:0] I_dis_acc16,
	output reg [31:0] O_new_dis_acc16,
	output reg O_branch16,
	input [31:0] I_dis_acc17,
	output reg [31:0] O_new_dis_acc17,
	output reg O_branch17,
	input [31:0] I_dis_acc18,
	output reg [31:0] O_new_dis_acc18,
	output reg O_branch18,
	input [31:0] I_dis_acc19,
	output reg [31:0] O_new_dis_acc19,
	output reg O_branch19,
	input [31:0] I_dis_acc20,
	output reg [31:0] O_new_dis_acc20,
	output reg O_branch20,
	input [31:0] I_dis_acc21,
	output reg [31:0] O_new_dis_acc21,
	output reg O_branch21,
	input [31:0] I_dis_acc22,
	output reg [31:0] O_new_dis_acc22,
	output reg O_branch22,
	input [31:0] I_dis_acc23,
	output reg [31:0] O_new_dis_acc23,
	output reg O_branch23,
	input [31:0] I_dis_acc24,
	output reg [31:0] O_new_dis_acc24,
	output reg O_branch24,
	input [31:0] I_dis_acc25,
	output reg [31:0] O_new_dis_acc25,
	output reg O_branch25,
	input [31:0] I_dis_acc26,
	output reg [31:0] O_new_dis_acc26,
	output reg O_branch26,
	input [31:0] I_dis_acc27,
	output reg [31:0] O_new_dis_acc27,
	output reg O_branch27,
	input [31:0] I_dis_acc28,
	output reg [31:0] O_new_dis_acc28,
	output reg O_branch28,
	input [31:0] I_dis_acc29,
	output reg [31:0] O_new_dis_acc29,
	output reg O_branch29,
	input [31:0] I_dis_acc30,
	output reg [31:0] O_new_dis_acc30,
	output reg O_branch30,
	input [31:0] I_dis_acc31,
	output reg [31:0] O_new_dis_acc31,
	output reg O_branch31,
	input [31:0] I_dis_acc32,
	output reg [31:0] O_new_dis_acc32,
	output reg O_branch32,
	input [31:0] I_dis_acc33,
	output reg [31:0] O_new_dis_acc33,
	output reg O_branch33,
	input [31:0] I_dis_acc34,
	output reg [31:0] O_new_dis_acc34,
	output reg O_branch34,
	input [31:0] I_dis_acc35,
	output reg [31:0] O_new_dis_acc35,
	output reg O_branch35,
	input [31:0] I_dis_acc36,
	output reg [31:0] O_new_dis_acc36,
	output reg O_branch36,
	input [31:0] I_dis_acc37,
	output reg [31:0] O_new_dis_acc37,
	output reg O_branch37,
	input [31:0] I_dis_acc38,
	output reg [31:0] O_new_dis_acc38,
	output reg O_branch38,
	input [31:0] I_dis_acc39,
	output reg [31:0] O_new_dis_acc39,
	output reg O_branch39,
	input [31:0] I_dis_acc40,
	output reg [31:0] O_new_dis_acc40,
	output reg O_branch40,
	input [31:0] I_dis_acc41,
	output reg [31:0] O_new_dis_acc41,
	output reg O_branch41,
	input [31:0] I_dis_acc42,
	output reg [31:0] O_new_dis_acc42,
	output reg O_branch42,
	input [31:0] I_dis_acc43,
	output reg [31:0] O_new_dis_acc43,
	output reg O_branch43,
	input [31:0] I_dis_acc44,
	output reg [31:0] O_new_dis_acc44,
	output reg O_branch44,
	input [31:0] I_dis_acc45,
	output reg [31:0] O_new_dis_acc45,
	output reg O_branch45,
	input [31:0] I_dis_acc46,
	output reg [31:0] O_new_dis_acc46,
	output reg O_branch46,
	input [31:0] I_dis_acc47,
	output reg [31:0] O_new_dis_acc47,
	output reg O_branch47,
	input [31:0] I_dis_acc48,
	output reg [31:0] O_new_dis_acc48,
	output reg O_branch48,
	input [31:0] I_dis_acc49,
	output reg [31:0] O_new_dis_acc49,
	output reg O_branch49,
	input [31:0] I_dis_acc50,
	output reg [31:0] O_new_dis_acc50,
	output reg O_branch50,
	input [31:0] I_dis_acc51,
	output reg [31:0] O_new_dis_acc51,
	output reg O_branch51,
	input [31:0] I_dis_acc52,
	output reg [31:0] O_new_dis_acc52,
	output reg O_branch52,
	input [31:0] I_dis_acc53,
	output reg [31:0] O_new_dis_acc53,
	output reg O_branch53,
	input [31:0] I_dis_acc54,
	output reg [31:0] O_new_dis_acc54,
	output reg O_branch54,
	input [31:0] I_dis_acc55,
	output reg [31:0] O_new_dis_acc55,
	output reg O_branch55,
	input [31:0] I_dis_acc56,
	output reg [31:0] O_new_dis_acc56,
	output reg O_branch56,
	input [31:0] I_dis_acc57,
	output reg [31:0] O_new_dis_acc57,
	output reg O_branch57,
	input [31:0] I_dis_acc58,
	output reg [31:0] O_new_dis_acc58,
	output reg O_branch58,
	input [31:0] I_dis_acc59,
	output reg [31:0] O_new_dis_acc59,
	output reg O_branch59,
	input [31:0] I_dis_acc60,
	output reg [31:0] O_new_dis_acc60,
	output reg O_branch60,
	input [31:0] I_dis_acc61,
	output reg [31:0] O_new_dis_acc61,
	output reg O_branch61,
	input [31:0] I_dis_acc62,
	output reg [31:0] O_new_dis_acc62,
	output reg O_branch62,
	input [31:0] I_dis_acc63,
	output reg [31:0] O_new_dis_acc63,
	output reg O_branch63
);

	wire [31:0] W_dis_acc_upper_branch0 = I_dis_acc0 + I_dis0;
	wire [31:0] W_dis_acc_lower_branch0 = I_dis_acc1 + I_dis3;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch0 <= 1;
			O_new_dis_acc0 <= W_dis_acc_upper_branch0;
		end
		else begin
			if(W_dis_acc_upper_branch0 <= W_dis_acc_lower_branch0) begin
				O_branch0 <= 1;
				O_new_dis_acc0 <= W_dis_acc_upper_branch0;
			end
			else begin
				O_branch0 <= 0;
				O_new_dis_acc0 <= W_dis_acc_lower_branch0;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch32 = I_dis_acc0 + I_dis3;
	wire [31:0] W_dis_acc_lower_branch32 = I_dis_acc1 + I_dis0;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch32 <= 1;
			O_new_dis_acc32 <= W_dis_acc_upper_branch32;
		end
		else begin
			if(W_dis_acc_upper_branch32 <= W_dis_acc_lower_branch32) begin
				O_branch32 <= 1;
				O_new_dis_acc32 <= W_dis_acc_upper_branch32;
			end
			else begin
				O_branch32 <= 0;
				O_new_dis_acc32 <= W_dis_acc_lower_branch32;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch16 = I_dis_acc32 + I_dis1;
	wire [31:0] W_dis_acc_lower_branch16 = I_dis_acc33 + I_dis2;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch16 <= 1;
			O_new_dis_acc16 <= W_dis_acc_upper_branch16;
		end
		else begin
			if(W_dis_acc_upper_branch16 <= W_dis_acc_lower_branch16) begin
				O_branch16 <= 1;
				O_new_dis_acc16 <= W_dis_acc_upper_branch16;
			end
			else begin
				O_branch16 <= 0;
				O_new_dis_acc16 <= W_dis_acc_lower_branch16;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch48 = I_dis_acc32 + I_dis2;
	wire [31:0] W_dis_acc_lower_branch48 = I_dis_acc33 + I_dis1;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch48 <= 1;
			O_new_dis_acc48 <= W_dis_acc_upper_branch48;
		end
		else begin
			if(W_dis_acc_upper_branch48 <= W_dis_acc_lower_branch48) begin
				O_branch48 <= 1;
				O_new_dis_acc48 <= W_dis_acc_upper_branch48;
			end
			else begin
				O_branch48 <= 0;
				O_new_dis_acc48 <= W_dis_acc_lower_branch48;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch8 = I_dis_acc16 + I_dis3;
	wire [31:0] W_dis_acc_lower_branch8 = I_dis_acc17 + I_dis0;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch8 <= 1;
			O_new_dis_acc8 <= W_dis_acc_upper_branch8;
		end
		else begin
			if(W_dis_acc_upper_branch8 <= W_dis_acc_lower_branch8) begin
				O_branch8 <= 1;
				O_new_dis_acc8 <= W_dis_acc_upper_branch8;
			end
			else begin
				O_branch8 <= 0;
				O_new_dis_acc8 <= W_dis_acc_lower_branch8;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch40 = I_dis_acc16 + I_dis0;
	wire [31:0] W_dis_acc_lower_branch40 = I_dis_acc17 + I_dis3;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch40 <= 1;
			O_new_dis_acc40 <= W_dis_acc_upper_branch40;
		end
		else begin
			if(W_dis_acc_upper_branch40 <= W_dis_acc_lower_branch40) begin
				O_branch40 <= 1;
				O_new_dis_acc40 <= W_dis_acc_upper_branch40;
			end
			else begin
				O_branch40 <= 0;
				O_new_dis_acc40 <= W_dis_acc_lower_branch40;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch24 = I_dis_acc48 + I_dis2;
	wire [31:0] W_dis_acc_lower_branch24 = I_dis_acc49 + I_dis1;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch24 <= 1;
			O_new_dis_acc24 <= W_dis_acc_upper_branch24;
		end
		else begin
			if(W_dis_acc_upper_branch24 <= W_dis_acc_lower_branch24) begin
				O_branch24 <= 1;
				O_new_dis_acc24 <= W_dis_acc_upper_branch24;
			end
			else begin
				O_branch24 <= 0;
				O_new_dis_acc24 <= W_dis_acc_lower_branch24;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch56 = I_dis_acc48 + I_dis1;
	wire [31:0] W_dis_acc_lower_branch56 = I_dis_acc49 + I_dis2;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch56 <= 1;
			O_new_dis_acc56 <= W_dis_acc_upper_branch56;
		end
		else begin
			if(W_dis_acc_upper_branch56 <= W_dis_acc_lower_branch56) begin
				O_branch56 <= 1;
				O_new_dis_acc56 <= W_dis_acc_upper_branch56;
			end
			else begin
				O_branch56 <= 0;
				O_new_dis_acc56 <= W_dis_acc_lower_branch56;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch4 = I_dis_acc8 + I_dis3;
	wire [31:0] W_dis_acc_lower_branch4 = I_dis_acc9 + I_dis0;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch4 <= 1;
			O_new_dis_acc4 <= W_dis_acc_upper_branch4;
		end
		else begin
			if(W_dis_acc_upper_branch4 <= W_dis_acc_lower_branch4) begin
				O_branch4 <= 1;
				O_new_dis_acc4 <= W_dis_acc_upper_branch4;
			end
			else begin
				O_branch4 <= 0;
				O_new_dis_acc4 <= W_dis_acc_lower_branch4;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch36 = I_dis_acc8 + I_dis0;
	wire [31:0] W_dis_acc_lower_branch36 = I_dis_acc9 + I_dis3;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch36 <= 1;
			O_new_dis_acc36 <= W_dis_acc_upper_branch36;
		end
		else begin
			if(W_dis_acc_upper_branch36 <= W_dis_acc_lower_branch36) begin
				O_branch36 <= 1;
				O_new_dis_acc36 <= W_dis_acc_upper_branch36;
			end
			else begin
				O_branch36 <= 0;
				O_new_dis_acc36 <= W_dis_acc_lower_branch36;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch20 = I_dis_acc40 + I_dis2;
	wire [31:0] W_dis_acc_lower_branch20 = I_dis_acc41 + I_dis1;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch20 <= 1;
			O_new_dis_acc20 <= W_dis_acc_upper_branch20;
		end
		else begin
			if(W_dis_acc_upper_branch20 <= W_dis_acc_lower_branch20) begin
				O_branch20 <= 1;
				O_new_dis_acc20 <= W_dis_acc_upper_branch20;
			end
			else begin
				O_branch20 <= 0;
				O_new_dis_acc20 <= W_dis_acc_lower_branch20;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch52 = I_dis_acc40 + I_dis1;
	wire [31:0] W_dis_acc_lower_branch52 = I_dis_acc41 + I_dis2;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch52 <= 1;
			O_new_dis_acc52 <= W_dis_acc_upper_branch52;
		end
		else begin
			if(W_dis_acc_upper_branch52 <= W_dis_acc_lower_branch52) begin
				O_branch52 <= 1;
				O_new_dis_acc52 <= W_dis_acc_upper_branch52;
			end
			else begin
				O_branch52 <= 0;
				O_new_dis_acc52 <= W_dis_acc_lower_branch52;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch12 = I_dis_acc24 + I_dis0;
	wire [31:0] W_dis_acc_lower_branch12 = I_dis_acc25 + I_dis3;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch12 <= 1;
			O_new_dis_acc12 <= W_dis_acc_upper_branch12;
		end
		else begin
			if(W_dis_acc_upper_branch12 <= W_dis_acc_lower_branch12) begin
				O_branch12 <= 1;
				O_new_dis_acc12 <= W_dis_acc_upper_branch12;
			end
			else begin
				O_branch12 <= 0;
				O_new_dis_acc12 <= W_dis_acc_lower_branch12;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch44 = I_dis_acc24 + I_dis3;
	wire [31:0] W_dis_acc_lower_branch44 = I_dis_acc25 + I_dis0;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch44 <= 1;
			O_new_dis_acc44 <= W_dis_acc_upper_branch44;
		end
		else begin
			if(W_dis_acc_upper_branch44 <= W_dis_acc_lower_branch44) begin
				O_branch44 <= 1;
				O_new_dis_acc44 <= W_dis_acc_upper_branch44;
			end
			else begin
				O_branch44 <= 0;
				O_new_dis_acc44 <= W_dis_acc_lower_branch44;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch28 = I_dis_acc56 + I_dis1;
	wire [31:0] W_dis_acc_lower_branch28 = I_dis_acc57 + I_dis2;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch28 <= 1;
			O_new_dis_acc28 <= W_dis_acc_upper_branch28;
		end
		else begin
			if(W_dis_acc_upper_branch28 <= W_dis_acc_lower_branch28) begin
				O_branch28 <= 1;
				O_new_dis_acc28 <= W_dis_acc_upper_branch28;
			end
			else begin
				O_branch28 <= 0;
				O_new_dis_acc28 <= W_dis_acc_lower_branch28;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch60 = I_dis_acc56 + I_dis2;
	wire [31:0] W_dis_acc_lower_branch60 = I_dis_acc57 + I_dis1;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch60 <= 1;
			O_new_dis_acc60 <= W_dis_acc_upper_branch60;
		end
		else begin
			if(W_dis_acc_upper_branch60 <= W_dis_acc_lower_branch60) begin
				O_branch60 <= 1;
				O_new_dis_acc60 <= W_dis_acc_upper_branch60;
			end
			else begin
				O_branch60 <= 0;
				O_new_dis_acc60 <= W_dis_acc_lower_branch60;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch2 = I_dis_acc4 + I_dis0;
	wire [31:0] W_dis_acc_lower_branch2 = I_dis_acc5 + I_dis3;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch2 <= 1;
			O_new_dis_acc2 <= W_dis_acc_upper_branch2;
		end
		else begin
			if(W_dis_acc_upper_branch2 <= W_dis_acc_lower_branch2) begin
				O_branch2 <= 1;
				O_new_dis_acc2 <= W_dis_acc_upper_branch2;
			end
			else begin
				O_branch2 <= 0;
				O_new_dis_acc2 <= W_dis_acc_lower_branch2;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch34 = I_dis_acc4 + I_dis3;
	wire [31:0] W_dis_acc_lower_branch34 = I_dis_acc5 + I_dis0;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch34 <= 1;
			O_new_dis_acc34 <= W_dis_acc_upper_branch34;
		end
		else begin
			if(W_dis_acc_upper_branch34 <= W_dis_acc_lower_branch34) begin
				O_branch34 <= 1;
				O_new_dis_acc34 <= W_dis_acc_upper_branch34;
			end
			else begin
				O_branch34 <= 0;
				O_new_dis_acc34 <= W_dis_acc_lower_branch34;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch18 = I_dis_acc36 + I_dis1;
	wire [31:0] W_dis_acc_lower_branch18 = I_dis_acc37 + I_dis2;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch18 <= 1;
			O_new_dis_acc18 <= W_dis_acc_upper_branch18;
		end
		else begin
			if(W_dis_acc_upper_branch18 <= W_dis_acc_lower_branch18) begin
				O_branch18 <= 1;
				O_new_dis_acc18 <= W_dis_acc_upper_branch18;
			end
			else begin
				O_branch18 <= 0;
				O_new_dis_acc18 <= W_dis_acc_lower_branch18;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch50 = I_dis_acc36 + I_dis2;
	wire [31:0] W_dis_acc_lower_branch50 = I_dis_acc37 + I_dis1;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch50 <= 1;
			O_new_dis_acc50 <= W_dis_acc_upper_branch50;
		end
		else begin
			if(W_dis_acc_upper_branch50 <= W_dis_acc_lower_branch50) begin
				O_branch50 <= 1;
				O_new_dis_acc50 <= W_dis_acc_upper_branch50;
			end
			else begin
				O_branch50 <= 0;
				O_new_dis_acc50 <= W_dis_acc_lower_branch50;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch10 = I_dis_acc20 + I_dis3;
	wire [31:0] W_dis_acc_lower_branch10 = I_dis_acc21 + I_dis0;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch10 <= 1;
			O_new_dis_acc10 <= W_dis_acc_upper_branch10;
		end
		else begin
			if(W_dis_acc_upper_branch10 <= W_dis_acc_lower_branch10) begin
				O_branch10 <= 1;
				O_new_dis_acc10 <= W_dis_acc_upper_branch10;
			end
			else begin
				O_branch10 <= 0;
				O_new_dis_acc10 <= W_dis_acc_lower_branch10;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch42 = I_dis_acc20 + I_dis0;
	wire [31:0] W_dis_acc_lower_branch42 = I_dis_acc21 + I_dis3;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch42 <= 1;
			O_new_dis_acc42 <= W_dis_acc_upper_branch42;
		end
		else begin
			if(W_dis_acc_upper_branch42 <= W_dis_acc_lower_branch42) begin
				O_branch42 <= 1;
				O_new_dis_acc42 <= W_dis_acc_upper_branch42;
			end
			else begin
				O_branch42 <= 0;
				O_new_dis_acc42 <= W_dis_acc_lower_branch42;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch26 = I_dis_acc52 + I_dis2;
	wire [31:0] W_dis_acc_lower_branch26 = I_dis_acc53 + I_dis1;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch26 <= 1;
			O_new_dis_acc26 <= W_dis_acc_upper_branch26;
		end
		else begin
			if(W_dis_acc_upper_branch26 <= W_dis_acc_lower_branch26) begin
				O_branch26 <= 1;
				O_new_dis_acc26 <= W_dis_acc_upper_branch26;
			end
			else begin
				O_branch26 <= 0;
				O_new_dis_acc26 <= W_dis_acc_lower_branch26;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch58 = I_dis_acc52 + I_dis1;
	wire [31:0] W_dis_acc_lower_branch58 = I_dis_acc53 + I_dis2;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch58 <= 1;
			O_new_dis_acc58 <= W_dis_acc_upper_branch58;
		end
		else begin
			if(W_dis_acc_upper_branch58 <= W_dis_acc_lower_branch58) begin
				O_branch58 <= 1;
				O_new_dis_acc58 <= W_dis_acc_upper_branch58;
			end
			else begin
				O_branch58 <= 0;
				O_new_dis_acc58 <= W_dis_acc_lower_branch58;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch6 = I_dis_acc12 + I_dis3;
	wire [31:0] W_dis_acc_lower_branch6 = I_dis_acc13 + I_dis0;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch6 <= 1;
			O_new_dis_acc6 <= W_dis_acc_upper_branch6;
		end
		else begin
			if(W_dis_acc_upper_branch6 <= W_dis_acc_lower_branch6) begin
				O_branch6 <= 1;
				O_new_dis_acc6 <= W_dis_acc_upper_branch6;
			end
			else begin
				O_branch6 <= 0;
				O_new_dis_acc6 <= W_dis_acc_lower_branch6;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch38 = I_dis_acc12 + I_dis0;
	wire [31:0] W_dis_acc_lower_branch38 = I_dis_acc13 + I_dis3;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch38 <= 1;
			O_new_dis_acc38 <= W_dis_acc_upper_branch38;
		end
		else begin
			if(W_dis_acc_upper_branch38 <= W_dis_acc_lower_branch38) begin
				O_branch38 <= 1;
				O_new_dis_acc38 <= W_dis_acc_upper_branch38;
			end
			else begin
				O_branch38 <= 0;
				O_new_dis_acc38 <= W_dis_acc_lower_branch38;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch22 = I_dis_acc44 + I_dis2;
	wire [31:0] W_dis_acc_lower_branch22 = I_dis_acc45 + I_dis1;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch22 <= 1;
			O_new_dis_acc22 <= W_dis_acc_upper_branch22;
		end
		else begin
			if(W_dis_acc_upper_branch22 <= W_dis_acc_lower_branch22) begin
				O_branch22 <= 1;
				O_new_dis_acc22 <= W_dis_acc_upper_branch22;
			end
			else begin
				O_branch22 <= 0;
				O_new_dis_acc22 <= W_dis_acc_lower_branch22;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch54 = I_dis_acc44 + I_dis1;
	wire [31:0] W_dis_acc_lower_branch54 = I_dis_acc45 + I_dis2;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch54 <= 1;
			O_new_dis_acc54 <= W_dis_acc_upper_branch54;
		end
		else begin
			if(W_dis_acc_upper_branch54 <= W_dis_acc_lower_branch54) begin
				O_branch54 <= 1;
				O_new_dis_acc54 <= W_dis_acc_upper_branch54;
			end
			else begin
				O_branch54 <= 0;
				O_new_dis_acc54 <= W_dis_acc_lower_branch54;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch14 = I_dis_acc28 + I_dis0;
	wire [31:0] W_dis_acc_lower_branch14 = I_dis_acc29 + I_dis3;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch14 <= 1;
			O_new_dis_acc14 <= W_dis_acc_upper_branch14;
		end
		else begin
			if(W_dis_acc_upper_branch14 <= W_dis_acc_lower_branch14) begin
				O_branch14 <= 1;
				O_new_dis_acc14 <= W_dis_acc_upper_branch14;
			end
			else begin
				O_branch14 <= 0;
				O_new_dis_acc14 <= W_dis_acc_lower_branch14;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch46 = I_dis_acc28 + I_dis3;
	wire [31:0] W_dis_acc_lower_branch46 = I_dis_acc29 + I_dis0;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch46 <= 1;
			O_new_dis_acc46 <= W_dis_acc_upper_branch46;
		end
		else begin
			if(W_dis_acc_upper_branch46 <= W_dis_acc_lower_branch46) begin
				O_branch46 <= 1;
				O_new_dis_acc46 <= W_dis_acc_upper_branch46;
			end
			else begin
				O_branch46 <= 0;
				O_new_dis_acc46 <= W_dis_acc_lower_branch46;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch30 = I_dis_acc60 + I_dis1;
	wire [31:0] W_dis_acc_lower_branch30 = I_dis_acc61 + I_dis2;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch30 <= 1;
			O_new_dis_acc30 <= W_dis_acc_upper_branch30;
		end
		else begin
			if(W_dis_acc_upper_branch30 <= W_dis_acc_lower_branch30) begin
				O_branch30 <= 1;
				O_new_dis_acc30 <= W_dis_acc_upper_branch30;
			end
			else begin
				O_branch30 <= 0;
				O_new_dis_acc30 <= W_dis_acc_lower_branch30;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch62 = I_dis_acc60 + I_dis2;
	wire [31:0] W_dis_acc_lower_branch62 = I_dis_acc61 + I_dis1;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch62 <= 1;
			O_new_dis_acc62 <= W_dis_acc_upper_branch62;
		end
		else begin
			if(W_dis_acc_upper_branch62 <= W_dis_acc_lower_branch62) begin
				O_branch62 <= 1;
				O_new_dis_acc62 <= W_dis_acc_upper_branch62;
			end
			else begin
				O_branch62 <= 0;
				O_new_dis_acc62 <= W_dis_acc_lower_branch62;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch1 = I_dis_acc2 + I_dis2;
	wire [31:0] W_dis_acc_lower_branch1 = I_dis_acc3 + I_dis1;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch1 <= 1;
			O_new_dis_acc1 <= W_dis_acc_upper_branch1;
		end
		else begin
			if(W_dis_acc_upper_branch1 <= W_dis_acc_lower_branch1) begin
				O_branch1 <= 1;
				O_new_dis_acc1 <= W_dis_acc_upper_branch1;
			end
			else begin
				O_branch1 <= 0;
				O_new_dis_acc1 <= W_dis_acc_lower_branch1;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch33 = I_dis_acc2 + I_dis1;
	wire [31:0] W_dis_acc_lower_branch33 = I_dis_acc3 + I_dis2;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch33 <= 1;
			O_new_dis_acc33 <= W_dis_acc_upper_branch33;
		end
		else begin
			if(W_dis_acc_upper_branch33 <= W_dis_acc_lower_branch33) begin
				O_branch33 <= 1;
				O_new_dis_acc33 <= W_dis_acc_upper_branch33;
			end
			else begin
				O_branch33 <= 0;
				O_new_dis_acc33 <= W_dis_acc_lower_branch33;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch17 = I_dis_acc34 + I_dis3;
	wire [31:0] W_dis_acc_lower_branch17 = I_dis_acc35 + I_dis0;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch17 <= 1;
			O_new_dis_acc17 <= W_dis_acc_upper_branch17;
		end
		else begin
			if(W_dis_acc_upper_branch17 <= W_dis_acc_lower_branch17) begin
				O_branch17 <= 1;
				O_new_dis_acc17 <= W_dis_acc_upper_branch17;
			end
			else begin
				O_branch17 <= 0;
				O_new_dis_acc17 <= W_dis_acc_lower_branch17;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch49 = I_dis_acc34 + I_dis0;
	wire [31:0] W_dis_acc_lower_branch49 = I_dis_acc35 + I_dis3;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch49 <= 1;
			O_new_dis_acc49 <= W_dis_acc_upper_branch49;
		end
		else begin
			if(W_dis_acc_upper_branch49 <= W_dis_acc_lower_branch49) begin
				O_branch49 <= 1;
				O_new_dis_acc49 <= W_dis_acc_upper_branch49;
			end
			else begin
				O_branch49 <= 0;
				O_new_dis_acc49 <= W_dis_acc_lower_branch49;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch9 = I_dis_acc18 + I_dis1;
	wire [31:0] W_dis_acc_lower_branch9 = I_dis_acc19 + I_dis2;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch9 <= 1;
			O_new_dis_acc9 <= W_dis_acc_upper_branch9;
		end
		else begin
			if(W_dis_acc_upper_branch9 <= W_dis_acc_lower_branch9) begin
				O_branch9 <= 1;
				O_new_dis_acc9 <= W_dis_acc_upper_branch9;
			end
			else begin
				O_branch9 <= 0;
				O_new_dis_acc9 <= W_dis_acc_lower_branch9;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch41 = I_dis_acc18 + I_dis2;
	wire [31:0] W_dis_acc_lower_branch41 = I_dis_acc19 + I_dis1;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch41 <= 1;
			O_new_dis_acc41 <= W_dis_acc_upper_branch41;
		end
		else begin
			if(W_dis_acc_upper_branch41 <= W_dis_acc_lower_branch41) begin
				O_branch41 <= 1;
				O_new_dis_acc41 <= W_dis_acc_upper_branch41;
			end
			else begin
				O_branch41 <= 0;
				O_new_dis_acc41 <= W_dis_acc_lower_branch41;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch25 = I_dis_acc50 + I_dis0;
	wire [31:0] W_dis_acc_lower_branch25 = I_dis_acc51 + I_dis3;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch25 <= 1;
			O_new_dis_acc25 <= W_dis_acc_upper_branch25;
		end
		else begin
			if(W_dis_acc_upper_branch25 <= W_dis_acc_lower_branch25) begin
				O_branch25 <= 1;
				O_new_dis_acc25 <= W_dis_acc_upper_branch25;
			end
			else begin
				O_branch25 <= 0;
				O_new_dis_acc25 <= W_dis_acc_lower_branch25;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch57 = I_dis_acc50 + I_dis3;
	wire [31:0] W_dis_acc_lower_branch57 = I_dis_acc51 + I_dis0;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch57 <= 1;
			O_new_dis_acc57 <= W_dis_acc_upper_branch57;
		end
		else begin
			if(W_dis_acc_upper_branch57 <= W_dis_acc_lower_branch57) begin
				O_branch57 <= 1;
				O_new_dis_acc57 <= W_dis_acc_upper_branch57;
			end
			else begin
				O_branch57 <= 0;
				O_new_dis_acc57 <= W_dis_acc_lower_branch57;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch5 = I_dis_acc10 + I_dis1;
	wire [31:0] W_dis_acc_lower_branch5 = I_dis_acc11 + I_dis2;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch5 <= 1;
			O_new_dis_acc5 <= W_dis_acc_upper_branch5;
		end
		else begin
			if(W_dis_acc_upper_branch5 <= W_dis_acc_lower_branch5) begin
				O_branch5 <= 1;
				O_new_dis_acc5 <= W_dis_acc_upper_branch5;
			end
			else begin
				O_branch5 <= 0;
				O_new_dis_acc5 <= W_dis_acc_lower_branch5;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch37 = I_dis_acc10 + I_dis2;
	wire [31:0] W_dis_acc_lower_branch37 = I_dis_acc11 + I_dis1;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch37 <= 1;
			O_new_dis_acc37 <= W_dis_acc_upper_branch37;
		end
		else begin
			if(W_dis_acc_upper_branch37 <= W_dis_acc_lower_branch37) begin
				O_branch37 <= 1;
				O_new_dis_acc37 <= W_dis_acc_upper_branch37;
			end
			else begin
				O_branch37 <= 0;
				O_new_dis_acc37 <= W_dis_acc_lower_branch37;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch21 = I_dis_acc42 + I_dis0;
	wire [31:0] W_dis_acc_lower_branch21 = I_dis_acc43 + I_dis3;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch21 <= 1;
			O_new_dis_acc21 <= W_dis_acc_upper_branch21;
		end
		else begin
			if(W_dis_acc_upper_branch21 <= W_dis_acc_lower_branch21) begin
				O_branch21 <= 1;
				O_new_dis_acc21 <= W_dis_acc_upper_branch21;
			end
			else begin
				O_branch21 <= 0;
				O_new_dis_acc21 <= W_dis_acc_lower_branch21;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch53 = I_dis_acc42 + I_dis3;
	wire [31:0] W_dis_acc_lower_branch53 = I_dis_acc43 + I_dis0;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch53 <= 1;
			O_new_dis_acc53 <= W_dis_acc_upper_branch53;
		end
		else begin
			if(W_dis_acc_upper_branch53 <= W_dis_acc_lower_branch53) begin
				O_branch53 <= 1;
				O_new_dis_acc53 <= W_dis_acc_upper_branch53;
			end
			else begin
				O_branch53 <= 0;
				O_new_dis_acc53 <= W_dis_acc_lower_branch53;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch13 = I_dis_acc26 + I_dis2;
	wire [31:0] W_dis_acc_lower_branch13 = I_dis_acc27 + I_dis1;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch13 <= 1;
			O_new_dis_acc13 <= W_dis_acc_upper_branch13;
		end
		else begin
			if(W_dis_acc_upper_branch13 <= W_dis_acc_lower_branch13) begin
				O_branch13 <= 1;
				O_new_dis_acc13 <= W_dis_acc_upper_branch13;
			end
			else begin
				O_branch13 <= 0;
				O_new_dis_acc13 <= W_dis_acc_lower_branch13;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch45 = I_dis_acc26 + I_dis1;
	wire [31:0] W_dis_acc_lower_branch45 = I_dis_acc27 + I_dis2;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch45 <= 1;
			O_new_dis_acc45 <= W_dis_acc_upper_branch45;
		end
		else begin
			if(W_dis_acc_upper_branch45 <= W_dis_acc_lower_branch45) begin
				O_branch45 <= 1;
				O_new_dis_acc45 <= W_dis_acc_upper_branch45;
			end
			else begin
				O_branch45 <= 0;
				O_new_dis_acc45 <= W_dis_acc_lower_branch45;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch29 = I_dis_acc58 + I_dis3;
	wire [31:0] W_dis_acc_lower_branch29 = I_dis_acc59 + I_dis0;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch29 <= 1;
			O_new_dis_acc29 <= W_dis_acc_upper_branch29;
		end
		else begin
			if(W_dis_acc_upper_branch29 <= W_dis_acc_lower_branch29) begin
				O_branch29 <= 1;
				O_new_dis_acc29 <= W_dis_acc_upper_branch29;
			end
			else begin
				O_branch29 <= 0;
				O_new_dis_acc29 <= W_dis_acc_lower_branch29;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch61 = I_dis_acc58 + I_dis0;
	wire [31:0] W_dis_acc_lower_branch61 = I_dis_acc59 + I_dis3;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch61 <= 1;
			O_new_dis_acc61 <= W_dis_acc_upper_branch61;
		end
		else begin
			if(W_dis_acc_upper_branch61 <= W_dis_acc_lower_branch61) begin
				O_branch61 <= 1;
				O_new_dis_acc61 <= W_dis_acc_upper_branch61;
			end
			else begin
				O_branch61 <= 0;
				O_new_dis_acc61 <= W_dis_acc_lower_branch61;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch3 = I_dis_acc6 + I_dis2;
	wire [31:0] W_dis_acc_lower_branch3 = I_dis_acc7 + I_dis1;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch3 <= 1;
			O_new_dis_acc3 <= W_dis_acc_upper_branch3;
		end
		else begin
			if(W_dis_acc_upper_branch3 <= W_dis_acc_lower_branch3) begin
				O_branch3 <= 1;
				O_new_dis_acc3 <= W_dis_acc_upper_branch3;
			end
			else begin
				O_branch3 <= 0;
				O_new_dis_acc3 <= W_dis_acc_lower_branch3;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch35 = I_dis_acc6 + I_dis1;
	wire [31:0] W_dis_acc_lower_branch35 = I_dis_acc7 + I_dis2;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch35 <= 1;
			O_new_dis_acc35 <= W_dis_acc_upper_branch35;
		end
		else begin
			if(W_dis_acc_upper_branch35 <= W_dis_acc_lower_branch35) begin
				O_branch35 <= 1;
				O_new_dis_acc35 <= W_dis_acc_upper_branch35;
			end
			else begin
				O_branch35 <= 0;
				O_new_dis_acc35 <= W_dis_acc_lower_branch35;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch19 = I_dis_acc38 + I_dis3;
	wire [31:0] W_dis_acc_lower_branch19 = I_dis_acc39 + I_dis0;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch19 <= 1;
			O_new_dis_acc19 <= W_dis_acc_upper_branch19;
		end
		else begin
			if(W_dis_acc_upper_branch19 <= W_dis_acc_lower_branch19) begin
				O_branch19 <= 1;
				O_new_dis_acc19 <= W_dis_acc_upper_branch19;
			end
			else begin
				O_branch19 <= 0;
				O_new_dis_acc19 <= W_dis_acc_lower_branch19;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch51 = I_dis_acc38 + I_dis0;
	wire [31:0] W_dis_acc_lower_branch51 = I_dis_acc39 + I_dis3;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch51 <= 1;
			O_new_dis_acc51 <= W_dis_acc_upper_branch51;
		end
		else begin
			if(W_dis_acc_upper_branch51 <= W_dis_acc_lower_branch51) begin
				O_branch51 <= 1;
				O_new_dis_acc51 <= W_dis_acc_upper_branch51;
			end
			else begin
				O_branch51 <= 0;
				O_new_dis_acc51 <= W_dis_acc_lower_branch51;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch11 = I_dis_acc22 + I_dis1;
	wire [31:0] W_dis_acc_lower_branch11 = I_dis_acc23 + I_dis2;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch11 <= 1;
			O_new_dis_acc11 <= W_dis_acc_upper_branch11;
		end
		else begin
			if(W_dis_acc_upper_branch11 <= W_dis_acc_lower_branch11) begin
				O_branch11 <= 1;
				O_new_dis_acc11 <= W_dis_acc_upper_branch11;
			end
			else begin
				O_branch11 <= 0;
				O_new_dis_acc11 <= W_dis_acc_lower_branch11;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch43 = I_dis_acc22 + I_dis2;
	wire [31:0] W_dis_acc_lower_branch43 = I_dis_acc23 + I_dis1;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch43 <= 1;
			O_new_dis_acc43 <= W_dis_acc_upper_branch43;
		end
		else begin
			if(W_dis_acc_upper_branch43 <= W_dis_acc_lower_branch43) begin
				O_branch43 <= 1;
				O_new_dis_acc43 <= W_dis_acc_upper_branch43;
			end
			else begin
				O_branch43 <= 0;
				O_new_dis_acc43 <= W_dis_acc_lower_branch43;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch27 = I_dis_acc54 + I_dis0;
	wire [31:0] W_dis_acc_lower_branch27 = I_dis_acc55 + I_dis3;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch27 <= 1;
			O_new_dis_acc27 <= W_dis_acc_upper_branch27;
		end
		else begin
			if(W_dis_acc_upper_branch27 <= W_dis_acc_lower_branch27) begin
				O_branch27 <= 1;
				O_new_dis_acc27 <= W_dis_acc_upper_branch27;
			end
			else begin
				O_branch27 <= 0;
				O_new_dis_acc27 <= W_dis_acc_lower_branch27;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch59 = I_dis_acc54 + I_dis3;
	wire [31:0] W_dis_acc_lower_branch59 = I_dis_acc55 + I_dis0;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch59 <= 1;
			O_new_dis_acc59 <= W_dis_acc_upper_branch59;
		end
		else begin
			if(W_dis_acc_upper_branch59 <= W_dis_acc_lower_branch59) begin
				O_branch59 <= 1;
				O_new_dis_acc59 <= W_dis_acc_upper_branch59;
			end
			else begin
				O_branch59 <= 0;
				O_new_dis_acc59 <= W_dis_acc_lower_branch59;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch7 = I_dis_acc14 + I_dis1;
	wire [31:0] W_dis_acc_lower_branch7 = I_dis_acc15 + I_dis2;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch7 <= 1;
			O_new_dis_acc7 <= W_dis_acc_upper_branch7;
		end
		else begin
			if(W_dis_acc_upper_branch7 <= W_dis_acc_lower_branch7) begin
				O_branch7 <= 1;
				O_new_dis_acc7 <= W_dis_acc_upper_branch7;
			end
			else begin
				O_branch7 <= 0;
				O_new_dis_acc7 <= W_dis_acc_lower_branch7;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch39 = I_dis_acc14 + I_dis2;
	wire [31:0] W_dis_acc_lower_branch39 = I_dis_acc15 + I_dis1;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch39 <= 1;
			O_new_dis_acc39 <= W_dis_acc_upper_branch39;
		end
		else begin
			if(W_dis_acc_upper_branch39 <= W_dis_acc_lower_branch39) begin
				O_branch39 <= 1;
				O_new_dis_acc39 <= W_dis_acc_upper_branch39;
			end
			else begin
				O_branch39 <= 0;
				O_new_dis_acc39 <= W_dis_acc_lower_branch39;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch23 = I_dis_acc46 + I_dis0;
	wire [31:0] W_dis_acc_lower_branch23 = I_dis_acc47 + I_dis3;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch23 <= 1;
			O_new_dis_acc23 <= W_dis_acc_upper_branch23;
		end
		else begin
			if(W_dis_acc_upper_branch23 <= W_dis_acc_lower_branch23) begin
				O_branch23 <= 1;
				O_new_dis_acc23 <= W_dis_acc_upper_branch23;
			end
			else begin
				O_branch23 <= 0;
				O_new_dis_acc23 <= W_dis_acc_lower_branch23;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch55 = I_dis_acc46 + I_dis3;
	wire [31:0] W_dis_acc_lower_branch55 = I_dis_acc47 + I_dis0;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch55 <= 1;
			O_new_dis_acc55 <= W_dis_acc_upper_branch55;
		end
		else begin
			if(W_dis_acc_upper_branch55 <= W_dis_acc_lower_branch55) begin
				O_branch55 <= 1;
				O_new_dis_acc55 <= W_dis_acc_upper_branch55;
			end
			else begin
				O_branch55 <= 0;
				O_new_dis_acc55 <= W_dis_acc_lower_branch55;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch15 = I_dis_acc30 + I_dis2;
	wire [31:0] W_dis_acc_lower_branch15 = I_dis_acc31 + I_dis1;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch15 <= 1;
			O_new_dis_acc15 <= W_dis_acc_upper_branch15;
		end
		else begin
			if(W_dis_acc_upper_branch15 <= W_dis_acc_lower_branch15) begin
				O_branch15 <= 1;
				O_new_dis_acc15 <= W_dis_acc_upper_branch15;
			end
			else begin
				O_branch15 <= 0;
				O_new_dis_acc15 <= W_dis_acc_lower_branch15;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch47 = I_dis_acc30 + I_dis1;
	wire [31:0] W_dis_acc_lower_branch47 = I_dis_acc31 + I_dis2;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch47 <= 1;
			O_new_dis_acc47 <= W_dis_acc_upper_branch47;
		end
		else begin
			if(W_dis_acc_upper_branch47 <= W_dis_acc_lower_branch47) begin
				O_branch47 <= 1;
				O_new_dis_acc47 <= W_dis_acc_upper_branch47;
			end
			else begin
				O_branch47 <= 0;
				O_new_dis_acc47 <= W_dis_acc_lower_branch47;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch31 = I_dis_acc62 + I_dis3;
	wire [31:0] W_dis_acc_lower_branch31 = I_dis_acc63 + I_dis0;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch31 <= 1;
			O_new_dis_acc31 <= W_dis_acc_upper_branch31;
		end
		else begin
			if(W_dis_acc_upper_branch31 <= W_dis_acc_lower_branch31) begin
				O_branch31 <= 1;
				O_new_dis_acc31 <= W_dis_acc_upper_branch31;
			end
			else begin
				O_branch31 <= 0;
				O_new_dis_acc31 <= W_dis_acc_lower_branch31;
			end
		end
	end

	wire [31:0] W_dis_acc_upper_branch63 = I_dis_acc62 + I_dis0;
	wire [31:0] W_dis_acc_lower_branch63 = I_dis_acc63 + I_dis3;
	always @(*) begin
		if(I_select_upper_branch) begin
			O_branch63 <= 1;
			O_new_dis_acc63 <= W_dis_acc_upper_branch63;
		end
		else begin
			if(W_dis_acc_upper_branch63 <= W_dis_acc_lower_branch63) begin
				O_branch63 <= 1;
				O_new_dis_acc63 <= W_dis_acc_upper_branch63;
			end
			else begin
				O_branch63 <= 0;
				O_new_dis_acc63 <= W_dis_acc_lower_branch63;
			end
		end
	end

endmodule
