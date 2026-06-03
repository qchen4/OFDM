//////////////////////////////////////////////////////////////
// 功能: 导频移除模块Verilog代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module rx_pilot_remove(
	input I_clk,
	input I_rst_n,
	input I_clk_en,
	
	input [13:0] I_decision_threshold,//14S7	
		
	input [13:0] I_rx_pilot_remove_in_i,//14S7
	input [13:0] I_rx_pilot_remove_in_q,//14S7
	input I_rx_pilot_remove_in_valid,
	input [10:0] I_rx_ofdm_symbol_idx,
	
	output reg [10:0] O_rx_ofdm_symbol_idx,
	output reg [13:0] O_rx_pilot_remove_out_i,//14S7
	output reg [13:0] O_rx_pilot_remove_out_q,//14S7
	output reg O_rx_pilot_remove_out_valid,
	output O_rx_pilot_remove_done,
	
	output reg [13:0] O_decision_threshold //14S7
);

reg R_rx_pilot_remove_in_valid_d;
reg [13:0] R_rx_pilot_remove_in_i_d;
reg [13:0] R_rx_pilot_remove_in_q_d;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		R_rx_pilot_remove_in_valid_d <= 1'b0;
		R_rx_pilot_remove_in_i_d <= 'd0;
		R_rx_pilot_remove_in_q_d <= 'd0;
	end
	else if(I_clk_en)begin
		R_rx_pilot_remove_in_valid_d <= I_rx_pilot_remove_in_valid;
		R_rx_pilot_remove_in_i_d <= I_rx_pilot_remove_in_i;
		R_rx_pilot_remove_in_q_d <= I_rx_pilot_remove_in_q;
	end
end

wire W_rx_pilot_remove_start = ~R_rx_pilot_remove_in_valid_d & I_rx_pilot_remove_in_valid;
wire W_rx_pilot_remove_in_valid_neg = ~I_rx_pilot_remove_in_valid & R_rx_pilot_remove_in_valid_d;

reg [5:0] R_pilot_remove_in_cnt;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		R_pilot_remove_in_cnt <= 6'd0;
	else if(I_clk_en & W_rx_pilot_remove_start) 
		R_pilot_remove_in_cnt <= 6'd0;
	else if(I_clk_en & R_rx_pilot_remove_in_valid_d) begin
		if(R_pilot_remove_in_cnt == 6'd63)
			R_pilot_remove_in_cnt <= 8'd0;
		else
			R_pilot_remove_in_cnt <= R_pilot_remove_in_cnt + 1'd1;
	end
end

// 地址映射
reg [5:0] R_buff_wr_addr;
always @(*) begin
	if(R_pilot_remove_in_cnt >= 6'd38 && R_pilot_remove_in_cnt <= 6'd42)
		R_buff_wr_addr <= R_pilot_remove_in_cnt - 38;
	else if(R_pilot_remove_in_cnt >= 6'd44 && R_pilot_remove_in_cnt <= 6'd56)
		R_buff_wr_addr <= R_pilot_remove_in_cnt - 39;
	else if(R_pilot_remove_in_cnt >= 6'd58 && R_pilot_remove_in_cnt <= 6'd63)
		R_buff_wr_addr <= R_pilot_remove_in_cnt - 40;
	else if(R_pilot_remove_in_cnt >= 6'd1 && R_pilot_remove_in_cnt <= 6'd6)
		R_buff_wr_addr <= R_pilot_remove_in_cnt + 23;
	else if(R_pilot_remove_in_cnt >= 6'd8 && R_pilot_remove_in_cnt <= 6'd20)
		R_buff_wr_addr <= R_pilot_remove_in_cnt + 22;
	else if(R_pilot_remove_in_cnt >= 6'd22 && R_pilot_remove_in_cnt <= 6'd26)
		R_buff_wr_addr <= R_pilot_remove_in_cnt + 21;
	else 
		R_buff_wr_addr <= 6'h3f;	// 无效地址
end
													
reg R_buff_in_sel;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_buff_in_sel <= 1'b0;	
	else if(I_clk_en & W_rx_pilot_remove_start)
		R_buff_in_sel <= I_rx_ofdm_symbol_idx[0];
end

reg [13:0] R_buff0_i[0:63];
reg [13:0] R_buff0_q[0:63];
reg [13:0] R_buff1_i[0:63];
reg [13:0] R_buff1_q[0:63];
integer i;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin	
		for(i = 0; i<=63; i = i + 1) begin
			R_buff0_i[i] <= 'd0;
			R_buff0_q[i] <= 'd0;
			R_buff1_i[i] <= 'd0;
			R_buff1_q[i] <= 'd0;
		end
	end
	else if(I_clk_en & R_rx_pilot_remove_in_valid_d) begin
		if(R_buff_in_sel == 1'b0) begin
			R_buff0_i[R_buff_wr_addr] <= R_rx_pilot_remove_in_i_d;
			R_buff0_q[R_buff_wr_addr] <= R_rx_pilot_remove_in_q_d;
		end
		else begin
			R_buff1_i[R_buff_wr_addr] <= R_rx_pilot_remove_in_i_d;
			R_buff1_q[R_buff_wr_addr] <= R_rx_pilot_remove_in_q_d;
		end
	end
end

reg R_buff_out_en;
reg [5:0] R_buff_out_en_cnt;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		R_buff_out_en <= 1'd0;
	else if(I_clk_en) begin
		if(R_buff_out_en_cnt == 6'd47)
			R_buff_out_en <= 1'd0;
		else if(W_rx_pilot_remove_in_valid_neg)
			R_buff_out_en <= 1'd1;
	end
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		R_buff_out_en_cnt <= 6'd0;
	else if(I_clk_en) begin
		if(R_buff_out_en_cnt == 6'd47)
			R_buff_out_en_cnt <= 6'd0;
		else if(R_buff_out_en)
			R_buff_out_en_cnt <= R_buff_out_en_cnt + 1'd1;
	end
end

reg R_buff_out_sel;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_buff_out_sel <= 1'b0;
	else if(I_clk_en & W_rx_pilot_remove_in_valid_neg)
		R_buff_out_sel <= R_buff_in_sel;
end

wire [5:0] W_buff_rd_addr = R_buff_out_en_cnt;

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		O_rx_pilot_remove_out_i <= 'd0;
		O_rx_pilot_remove_out_q <= 'd0;
	end
	else if(I_clk_en & R_buff_out_en) begin
		if(R_buff_out_sel == 1'b0) begin
			O_rx_pilot_remove_out_i <= R_buff0_i[W_buff_rd_addr];
			O_rx_pilot_remove_out_q <= R_buff0_q[W_buff_rd_addr];
		end
		else begin
			O_rx_pilot_remove_out_i <= R_buff1_i[W_buff_rd_addr];
			O_rx_pilot_remove_out_q <= R_buff1_q[W_buff_rd_addr];
		end
	end
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		O_rx_pilot_remove_out_valid <= 1'd0;
	else if(I_clk_en)
		O_rx_pilot_remove_out_valid <= R_buff_out_en;
end

assign O_rx_pilot_remove_done = ~R_buff_out_en & O_rx_pilot_remove_out_valid;

wire W_rx_pilot_remove_out_start = R_buff_out_en & (~O_rx_pilot_remove_out_valid);
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		O_decision_threshold <= 'd0;
		O_rx_ofdm_symbol_idx <= 'd0;
	end
	else if(I_clk_en & W_rx_pilot_remove_out_start) begin
		O_rx_ofdm_symbol_idx <= I_rx_ofdm_symbol_idx;
		
		if(I_rx_ofdm_symbol_idx == 0) // signal OFDM
			O_decision_threshold <= 'd0;
		else
			O_decision_threshold <= I_decision_threshold;
	end
end

endmodule 
