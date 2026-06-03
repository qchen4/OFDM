/////////////////////////////////////////////////////////////
// 功能: 信道均衡模块Verilog代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module rx_equalize(
	input			I_clk, // clock
	input			I_clk_en, // clock enable
	input			I_rst_n, // reset
	
	input [10:0] I_rx_ofdm_symbol_idx,	
	input			I_rx_equalize_in_valid, 
	input	[13:0]	I_rx_equalize_in_i,  // 14S7
	input	[13:0]	I_rx_equalize_in_q,  // 14S7
	
	output reg [10:0] O_rx_ofdm_symbol_idx,
	output	reg		O_rx_equalize_out_valid,
	output	reg [5: 0]  O_rx_equalize_out_idx,
	output  reg [13: 0] O_rx_equalize_out_i, 
	output  reg [13: 0] O_rx_equalize_out_q 
);

reg R_rx_equalize_in_valid_d;
reg [13:0] R_rx_equalize_in_i_d;
reg [13:0] R_rx_equalize_in_q_d;
always @(posedge I_clk) begin
	if(I_clk_en)begin
		R_rx_equalize_in_valid_d <= I_rx_equalize_in_valid;
		R_rx_equalize_in_i_d <= I_rx_equalize_in_i;
		R_rx_equalize_in_q_d <= I_rx_equalize_in_q;
	end
end

wire W_rx_equalize_start = ~R_rx_equalize_in_valid_d & I_rx_equalize_in_valid;

reg [5:0] R_rx_equalize_cnt;
always @(posedge I_clk) begin
	if(I_clk_en & W_rx_equalize_start) 
		R_rx_equalize_cnt <= 6'd0;
	else if(I_clk_en & R_rx_equalize_in_valid_d) begin
		if(R_rx_equalize_cnt == 6'd63)
			R_rx_equalize_cnt <= 6'd0;
		else
			R_rx_equalize_cnt <= R_rx_equalize_cnt + 1'd1;
	end
end

reg [13:0] R_1st_lts_buff_i[0:63];
reg [13:0] R_1st_lts_buff_q[0:63];
always @(posedge I_clk) begin
	if(I_clk_en && R_rx_equalize_in_valid_d && (I_rx_ofdm_symbol_idx==1)) begin
		R_1st_lts_buff_i[R_rx_equalize_cnt] <= R_rx_equalize_in_i_d;
		R_1st_lts_buff_q[R_rx_equalize_cnt] <= R_rx_equalize_in_q_d;
	end
end

wire W_1st_lts_buff_out_en = (R_rx_equalize_in_valid_d&&(I_rx_ofdm_symbol_idx==2))?1'b1:1'b0;

reg [13:0] R_1st_lts_buff_out_i;
reg [13:0] R_1st_lts_buff_out_q;
always @(*) begin
	if(W_1st_lts_buff_out_en) begin
		R_1st_lts_buff_out_i <= R_1st_lts_buff_i[R_rx_equalize_cnt];
		R_1st_lts_buff_out_q <= R_1st_lts_buff_q[R_rx_equalize_cnt];
	end
	else begin
		R_1st_lts_buff_out_i <= 'd0;
		R_1st_lts_buff_out_q <= 'd0;
	end
end

// 求第一个LTS和第二个LTS的平均值
// 这里没有做符号位扩展是因为位宽足够大，结果并不会溢出
wire [13:0] W_lts_mean_i_pre = R_1st_lts_buff_out_i+R_rx_equalize_in_i_d;
wire [13:0] W_lts_mean_q_pre = R_1st_lts_buff_out_q+R_rx_equalize_in_q_d;

wire [13:0] W_lts_mean_i = {W_lts_mean_i_pre[13],W_lts_mean_i_pre[13:1]};
wire [13:0] W_lts_mean_q = {W_lts_mean_q_pre[13],W_lts_mean_q_pre[13:1]};

// 使用Matlab产生LTS的二进制序列
wire [63:0] W_ideal_lts = 64'hF59FACC007A982B2;

reg [13:0] R_chan_est_i;
reg [13:0] R_chan_est_q;
always @(*) begin
	if(W_1st_lts_buff_out_en) begin
		if((R_rx_equalize_cnt==0)||((R_rx_equalize_cnt>=27)&&(R_rx_equalize_cnt<=37)))begin
			R_chan_est_i <= 'd0;
			R_chan_est_q <= 'd0;
		end
		else begin
			if(W_ideal_lts[R_rx_equalize_cnt] == 1'b1) begin
				R_chan_est_i <= W_lts_mean_i;
				R_chan_est_q <= W_lts_mean_q;
			end
			else begin
				R_chan_est_i <= -W_lts_mean_i;
				R_chan_est_q <= -W_lts_mean_q;
			end
		end
	end
	else begin
		R_chan_est_i <= 'd0;
		R_chan_est_q <= 'd0;
	end
end

reg [13:0] R_chan_est_buff_i[0:63];
reg [13:0] R_chan_est_buff_q[0:63];
always @(posedge I_clk) begin
	if(I_clk_en && R_rx_equalize_in_valid_d && (I_rx_ofdm_symbol_idx==2)) begin
		R_chan_est_buff_i[R_rx_equalize_cnt] <= R_chan_est_i;
		R_chan_est_buff_q[R_rx_equalize_cnt] <= R_chan_est_q;
	end
end

//从这里到复数乘法器的输出有一条很长的组合逻辑链，有可能会时序收敛失败
//如果时序收敛失败，可在Critical Path上插入DFF截断，并适当减小复数
//乘法器输入位宽
wire W_chan_est_buff_out_en = (I_rx_ofdm_symbol_idx > 2)?R_rx_equalize_in_valid_d:1'b0;

reg [13:0] R_chan_est_buff_out_i;
reg [13:0] R_chan_est_buff_out_q;
always @(*) begin
	if(W_chan_est_buff_out_en) begin
		R_chan_est_buff_out_i <= R_chan_est_buff_i[R_rx_equalize_cnt];
		R_chan_est_buff_out_q <= R_chan_est_buff_q[R_rx_equalize_cnt];
	end
	else begin
		R_chan_est_buff_out_i <= 'd0;
		R_chan_est_buff_out_q <= 'd0;
	end
end

wire [28:0] W_cmult_out_i;
wire [28:0] W_cmult_out_q;
complex_mult #(1,14,14) u0(
			.I_in1_i(R_chan_est_buff_out_i), // 14S7
			.I_in1_q(-R_chan_est_buff_out_q),// 14S7
			.I_in2_i(R_rx_equalize_in_i_d), //14S7
			.I_in2_q(R_rx_equalize_in_q_d), //14S7	
			.O_out_i(W_cmult_out_i),	//29S14
			.O_out_q(W_cmult_out_q)); //29S14

wire [13:0] W_cmult_out_rs_i;
wire [13:0] W_cmult_out_rs_q;
round_sat #(29,14,14,7) u1(.I_in(W_cmult_out_i),.O_out(W_cmult_out_rs_i));
round_sat #(29,14,14,7) u2(.I_in(W_cmult_out_q),.O_out(W_cmult_out_rs_q));

always @(posedge I_clk) begin
	if(I_clk_en & W_chan_est_buff_out_en) begin
		O_rx_equalize_out_i <= W_cmult_out_rs_i;
		O_rx_equalize_out_q <= W_cmult_out_rs_q;
	end
end

always @(posedge I_clk) begin
	if(I_clk_en) begin
		O_rx_equalize_out_valid <= W_chan_est_buff_out_en;
	end
end

always @(posedge I_clk) begin
	if(I_clk_en) begin
		if(I_rx_ofdm_symbol_idx >= 3) 
			O_rx_equalize_out_idx <= R_rx_equalize_cnt;
		else 
			O_rx_equalize_out_idx <= 6'd0;
	end
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		O_rx_ofdm_symbol_idx <= 11'd0;
	else if(W_rx_equalize_start) begin
		if(I_rx_ofdm_symbol_idx >= 3) 
			O_rx_ofdm_symbol_idx <= I_rx_ofdm_symbol_idx - 3;
		else 
			O_rx_ofdm_symbol_idx <= 11'd0;
	end
end

endmodule