//////////////////////////////////////////////////////////////
// 功能: 剩余相位补偿Verilog代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module rx_phase_track(
	input I_clk,
	input I_rst_n,
	input I_clk_en,
	input [13:0] I_rx_phase_track_i, //14S7
	input [13:0] I_rx_phase_track_q, //14S7
	input I_rx_phase_track_valid,
	input [10:0] I_rx_ofdm_symbol_idx,
	
	output reg [13:0] O_rx_phase_track_out_i, //14S7
	output reg [13:0] O_rx_phase_track_out_q, //14S7
	output  	O_rx_phase_track_out_valid,
	output 		O_rx_phase_track_done,
	output reg [10:0] O_rx_ofdm_symbol_idx,
	
	output [13:0] O_decision_threshold //14S7
);

reg R_rx_phase_track_valid_d;
reg [13:0] R_rx_phase_track_i_d;
reg [13:0] R_rx_phase_track_q_d;
always @(posedge I_clk) begin
	if(I_clk_en)begin
		R_rx_phase_track_valid_d <= I_rx_phase_track_valid;
		R_rx_phase_track_i_d <= I_rx_phase_track_i;
		R_rx_phase_track_q_d <= I_rx_phase_track_q;
	end
end

wire W_rx_phase_track_start = ~R_rx_phase_track_valid_d & I_rx_phase_track_valid;

reg [5:0] R_rx_phase_track_cnt;
always @(posedge I_clk) begin
	if(I_clk_en & W_rx_phase_track_start) 
		R_rx_phase_track_cnt <= 6'd0;
	else if(I_clk_en & R_rx_phase_track_valid_d) begin
		if(R_rx_phase_track_cnt == 6'd63)
			R_rx_phase_track_cnt <= 6'd0;
		else
			R_rx_phase_track_cnt <= R_rx_phase_track_cnt + 1'd1;
	end
end

// Buff写地址
wire [5:0] W_buff_wr_addr = R_rx_phase_track_cnt;

reg [13:0] R_pilot_pos7_i,R_pilot_pos7_q;
reg [13:0] R_pilot_pos21_i,R_pilot_pos21_q;
reg [13:0] R_pilot_neg21_i,R_pilot_neg21_q;
reg [13:0] R_pilot_neg7_i,R_pilot_neg7_q;
always @(posedge I_clk) begin
	if(I_clk_en & R_rx_phase_track_valid_d) begin
		if(R_rx_phase_track_cnt == 6'd7) begin
			R_pilot_pos7_i  <= R_rx_phase_track_i_d;
			R_pilot_pos7_q  <= R_rx_phase_track_q_d;
		end
		else if(R_rx_phase_track_cnt == 6'd21) begin
			R_pilot_pos21_i  <= R_rx_phase_track_i_d;
			R_pilot_pos21_q  <= R_rx_phase_track_q_d;
		end
		else if(R_rx_phase_track_cnt == 6'd43) begin
			R_pilot_neg21_i  <= R_rx_phase_track_i_d;
			R_pilot_neg21_q  <= R_rx_phase_track_q_d;
		end
		else if(R_rx_phase_track_cnt == 6'd57) begin
			R_pilot_neg7_i  <= R_rx_phase_track_i_d;
			R_pilot_neg7_q  <= R_rx_phase_track_q_d;
		end
	end
end

wire W_scramble_out;
rx_pilot_scramble u0(
	.I_clk(I_clk),
	.I_clk_en(I_clk_en),
	.I_rst_n(I_rst_n),
	
	.I_pilot_scramble_en(W_rx_phase_track_start),
	.I_rx_ofdm_symbol_idx(I_rx_ofdm_symbol_idx),	
	.O_pilot_scramble_out(W_scramble_out),
	.O_pilot_scramble_out_start()
);

reg [13:0] R_pilot_sum_i; //14S7
reg [13:0] R_pilot_sum_q; //14S7
always @(*) begin
	if(W_scramble_out==1'b0) begin //[1 1 1 -1]
		R_pilot_sum_i <= R_pilot_neg21_i + R_pilot_neg7_i +
						R_pilot_pos7_i - R_pilot_pos21_i;
		R_pilot_sum_q <= R_pilot_neg21_q + R_pilot_neg7_q +
						R_pilot_pos7_q - R_pilot_pos21_q;			
	end
	else begin //[-1 -1 -1 1]
		R_pilot_sum_i <= -R_pilot_neg21_i - R_pilot_neg7_i -
						R_pilot_pos7_i + R_pilot_pos21_i;
		R_pilot_sum_q <= -R_pilot_neg21_q - R_pilot_neg7_q -
						R_pilot_pos7_q + R_pilot_pos21_q;	
	end
end

wire [13:0] W_sum_conj_i =  R_pilot_sum_i; //14S7
wire [13:0] W_sum_conj_q = -R_pilot_sum_q; //14S7

wire [13:0] W_abs_sum_conj_i = W_sum_conj_i[13] ? -W_sum_conj_i : W_sum_conj_i;
wire [13:0] W_abs_sum_conj_q = W_sum_conj_q[13] ? -W_sum_conj_q : W_sum_conj_q;

//将补偿值归一化避免算法溢出
wire [13:0] W_abs_sum_max = (W_abs_sum_conj_i > W_abs_sum_conj_q) ? W_abs_sum_conj_i : W_abs_sum_conj_q;
reg [7:0] R_sum_conj_i_8S7;
reg [7:0] R_sum_conj_q_8S7;
always @(*) begin
	if((W_abs_sum_max >= {7'd0,7'd0}) && (W_abs_sum_max < {7'd1,7'd0})) begin
		R_sum_conj_i_8S7 <= W_sum_conj_i[7:0];
		R_sum_conj_q_8S7 <= W_sum_conj_q[7:0];
	end
	else if((W_abs_sum_max > {7'd1,7'd0}) && (W_abs_sum_max <= {7'd2,7'd0})) begin
	   R_sum_conj_i_8S7 <= W_sum_conj_i[8:1];
	   R_sum_conj_q_8S7 <= W_sum_conj_q[8:1];
	end
	else if((W_abs_sum_max > {7'd2,7'd0}) && (W_abs_sum_max <= {7'd4,7'd0})) begin
	   R_sum_conj_i_8S7 <= W_sum_conj_i[9:2];
	   R_sum_conj_q_8S7 <= W_sum_conj_q[9:2];
	end
	else if((W_abs_sum_max > {7'd4,7'd0}) && (W_abs_sum_max <= {7'd8,7'd0})) begin
	   R_sum_conj_i_8S7 <= W_sum_conj_i[10:3];
	   R_sum_conj_q_8S7 <= W_sum_conj_q[10:3];
	end
	else if((W_abs_sum_max > {7'd8,7'd0}) && (W_abs_sum_max <= {7'd16,7'd0})) begin
	   R_sum_conj_i_8S7 <= W_sum_conj_i[11:4];
	   R_sum_conj_q_8S7 <= W_sum_conj_q[11:4];
	end
	else if((W_abs_sum_max > {7'd16,7'd0}) && (W_abs_sum_max <= {7'd32,7'd0})) begin
	   R_sum_conj_i_8S7 <= W_sum_conj_i[12:5];
	   R_sum_conj_q_8S7 <= W_sum_conj_q[12:5];
	end
	else begin
		R_sum_conj_i_8S7 <= W_sum_conj_i[13:6];
		R_sum_conj_q_8S7 <= W_sum_conj_q[13:6];
	end
end

reg [7:0] R_comp_factor_i; //8S7
reg [7:0] R_comp_factor_q; //8S7
always @(posedge I_clk) begin
	if(I_clk_en & R_rx_phase_track_valid_d) begin
		if(R_rx_phase_track_cnt == 6'd63) begin
			R_comp_factor_i <=  R_sum_conj_i_8S7;
			R_comp_factor_q <=  R_sum_conj_q_8S7;
		end
	end
end
													
reg R_buff_in_sel;
always @(posedge I_clk) begin
	if(I_clk_en & W_rx_phase_track_start)
		R_buff_in_sel <= I_rx_ofdm_symbol_idx[0];
end

reg [13:0] R_buff0_i[0:63];
reg [13:0] R_buff0_q[0:63];
reg [13:0] R_buff1_i[0:63];
reg [13:0] R_buff1_q[0:63];
always @(posedge I_clk) begin
	if(I_clk_en & R_rx_phase_track_valid_d) begin
		if(R_buff_in_sel == 1'b0) begin
			R_buff0_i[W_buff_wr_addr] <= R_rx_phase_track_i_d;
			R_buff0_q[W_buff_wr_addr] <= R_rx_phase_track_q_d;
		end
		else begin
			R_buff1_i[W_buff_wr_addr] <= R_rx_phase_track_i_d;
			R_buff1_q[W_buff_wr_addr] <= R_rx_phase_track_q_d;
		end
	end
end

reg R_buff_out_en;
reg [5:0] R_buff_out_en_cnt;
always @(posedge I_clk) begin
	if(~I_rst_n)
		R_buff_out_en <= 1'd0;
	else if(I_clk_en) begin
		if(R_buff_out_en_cnt == 6'd63)
			R_buff_out_en <= 1'd0;
		else if(R_rx_phase_track_valid_d & (R_rx_phase_track_cnt == 6'd63))
			R_buff_out_en <= 1'd1;
	end
end

always @(posedge I_clk) begin
	if(~I_rst_n)
		R_buff_out_en_cnt <= 6'd0;
	else if(I_clk_en) begin
		if(R_buff_out_en_cnt == 6'd63)
			R_buff_out_en_cnt <= 6'd0;
		else if(R_buff_out_en)
			R_buff_out_en_cnt <= R_buff_out_en_cnt + 1'd1;
	end
end

reg R_buff_out_sel;
always @(posedge I_clk) begin
	if(~I_rst_n) 
		R_buff_out_sel <= 1'b0;
	if(I_clk_en) begin
		if(R_rx_phase_track_valid_d & (R_rx_phase_track_cnt == 6'd63))
			R_buff_out_sel <= R_buff_in_sel;
	end
end

wire [5:0] W_buff_rd_addr = R_buff_out_en_cnt;

reg [13:0] R_buff_out_i;
reg [13:0] R_buff_out_q;
always @(posedge I_clk) begin
	if(I_clk_en & R_buff_out_en) begin
		if(R_buff_out_sel == 1'b0) begin
			R_buff_out_i <= R_buff0_i[W_buff_rd_addr];
			R_buff_out_q <= R_buff0_q[W_buff_rd_addr];
		end
		else begin
			R_buff_out_i <= R_buff1_i[W_buff_rd_addr];
			R_buff_out_q <= R_buff1_q[W_buff_rd_addr];
		end
	end
end

wire [22:0] W_cmult_out_i;
wire [22:0] W_cmult_out_q;
complex_mult #(1,14,8) u1(
			.I_in1_i(R_buff_out_i), // 14S7
			.I_in1_q(R_buff_out_q), // 14S7
			.I_in2_i(R_comp_factor_i), //8S7
			.I_in2_q(R_comp_factor_q), //8S7	
			.O_out_i(W_cmult_out_i),   //23S14
			.O_out_q(W_cmult_out_q));  //23S14

wire [13:0] W_cmult_out_rs_i; // 14S7
wire [13:0] W_cmult_out_rs_q; // 14S7
round_sat #(23,14,14,7) u2(.I_in(W_cmult_out_i),.O_out(W_cmult_out_rs_i));
round_sat #(23,14,14,7) u3(.I_in(W_cmult_out_q),.O_out(W_cmult_out_rs_q));

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		O_rx_phase_track_out_i <= 'd0;
		O_rx_phase_track_out_q <= 'd0;
	end
	else if(I_clk_en) begin
		O_rx_phase_track_out_i <= W_cmult_out_rs_i;
		O_rx_phase_track_out_q <= W_cmult_out_rs_q;
	end
end

reg [1:0] R_buff_out_en_d;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_buff_out_en_d <= 2'd0;
	else if(I_clk_en)
		R_buff_out_en_d <= {R_buff_out_en_d[0],R_buff_out_en};
end

assign O_rx_phase_track_out_valid = R_buff_out_en_d[1];
assign O_rx_phase_track_done = ~R_buff_out_en_d[0] & R_buff_out_en_d[1];

wire W_update_ofdm_idx_en = R_buff_out_en_d[0] & (~R_buff_out_en_d[1]);
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		O_rx_ofdm_symbol_idx <= 'd0;
	else if(W_update_ofdm_idx_en)
		O_rx_ofdm_symbol_idx <= I_rx_ofdm_symbol_idx;
end

//提取补偿后的四个导频符号，由于W_cmult_out_rs_i相对W_buff_rd_addr延时了一拍
//因此W_buff_rd_addr的值需要加1提取导频
reg [13:0] R_pilot_pos7_comp_i;
reg [13:0] R_pilot_pos21_comp_i;
reg [13:0] R_pilot_neg21_comp_i;
reg [13:0] R_pilot_neg7_comp_i;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		R_pilot_pos7_comp_i  <= 'd0;
		R_pilot_pos21_comp_i <= 'd0;
		R_pilot_neg21_comp_i <= 'd0;
		R_pilot_neg7_comp_i  <= 'd0;
	end
	else if(I_clk_en & R_buff_out_en) begin
		if(W_buff_rd_addr == 6'd8) begin
			R_pilot_pos7_comp_i <= W_cmult_out_rs_i[13]?-W_cmult_out_rs_i:W_cmult_out_rs_i;
		end
		else if(W_buff_rd_addr == 6'd22) begin
			R_pilot_pos21_comp_i <= W_cmult_out_rs_i[13]?-W_cmult_out_rs_i:W_cmult_out_rs_i;
		end
		else if(W_buff_rd_addr == 6'd44) begin
			R_pilot_neg21_comp_i <= W_cmult_out_rs_i[13]?-W_cmult_out_rs_i:W_cmult_out_rs_i;
		end
		else if(W_buff_rd_addr == 6'd58) begin
			R_pilot_neg7_comp_i <= W_cmult_out_rs_i[13]?-W_cmult_out_rs_i:W_cmult_out_rs_i;
		end
	end
end

//14S7
wire [13:0] W_pilot_abs_sum = R_pilot_pos7_comp_i +  R_pilot_pos21_comp_i +
							  R_pilot_neg21_comp_i + R_pilot_neg7_comp_i;
wire [13:0] W_pilot_abs_sum_div4 = {{2{W_pilot_abs_sum[13]}},W_pilot_abs_sum[13:2]}; //14S7

//W_pilot_abs_sum_div4*(2/3)
wire [7:0] W_const_val = 8'd85; //8S7
wire [21:0] W_rmult_out; //22S14
real_mult #(1,14,8) u4(.I_in1(W_pilot_abs_sum_div4),.I_in2(W_const_val),.O_out(W_rmult_out));

wire [13:0] W_rmult_out_rs;//14S7
round_sat #(22,14,14,7) u5(.I_in(W_rmult_out),.O_out(W_rmult_out_rs));

assign O_decision_threshold = W_rmult_out_rs;

endmodule 
