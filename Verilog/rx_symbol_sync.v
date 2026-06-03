///////////////////////////////////////////////////////////////
// 功能: OFDM符号同步Verilog代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
//////////////////////////////////////////////////////////////
module rx_symbol_sync(
	input			I_clk, 
	input			I_clk_en, 
	input			I_rst_n, 	
	input	[11: 0]	CSR_symbol_sync_threshold,
	input			I_symbol_sync_en,
	input	[8 : 0]	I_symbol_sync_in_i,  //9S7
	input	[8 : 0]	I_symbol_sync_in_q,  //9S7
		
	output   reg [8: 0] O_symbol_sync_out_i, //9S7
	output   reg [8: 0] O_symbol_sync_out_q, //9S7
	output   reg O_symbol_sync_out_start 	
);
// 384=320+64
// 320 是Preamble的长度
// 64是buff的长度
parameter C_SYNC_CNT_THRESHOLD = 9'd384; // 384=320+64

reg R_symbol_sync_en_d;
always @(posedge I_clk) begin
	if(I_clk_en) begin
		R_symbol_sync_en_d <= I_symbol_sync_en;
	end
end
wire W_symbol_sync_start = ~R_symbol_sync_en_d & I_symbol_sync_en;

reg [8:0] R_symbol_sync_in_i_d; //9S7
reg [8:0] R_symbol_sync_in_q_d; //9S7
always @(posedge I_clk) begin
	if(I_clk_en & I_symbol_sync_en)begin
		R_symbol_sync_in_i_d <= I_symbol_sync_in_i;
		R_symbol_sync_in_q_d <= I_symbol_sync_in_q;
	end
end

reg R_symbol_sync_cnt_en;
reg [8:0] R_symbol_sync_cnt;
always @(posedge I_clk) begin
	if(I_clk_en & W_symbol_sync_start)
		R_symbol_sync_cnt <= 9'd0;
	else if(I_clk_en)begin
	    if(R_symbol_sync_cnt == C_SYNC_CNT_THRESHOLD)
			R_symbol_sync_cnt <= 9'd0;
		else if(R_symbol_sync_cnt_en)
			R_symbol_sync_cnt <= R_symbol_sync_cnt + 1'b1;
	end
end
always @(posedge I_clk) begin
	if(I_clk_en)begin
	    if(R_symbol_sync_cnt == C_SYNC_CNT_THRESHOLD)
			R_symbol_sync_cnt_en <= 1'd0;
		else if(W_symbol_sync_start)
			R_symbol_sync_cnt_en <= 1'd1;
	end
end

// 将输入数据的最高位符号位延时64拍
reg [63:0] R_data_sign_buff_i;
reg [63:0] R_data_sign_buff_q;
always @(posedge I_clk) begin
	if(W_symbol_sync_start) begin
		R_data_sign_buff_i <= 'd0;
		R_data_sign_buff_q <= 'd0;
	end
	else if(I_clk_en & R_symbol_sync_en_d)begin
		R_data_sign_buff_i <= {R_data_sign_buff_i[62:0],R_symbol_sync_in_i_d[8]};
		R_data_sign_buff_q <= {R_data_sign_buff_q[62:0],R_symbol_sync_in_q_d[8]};
	end
end

wire [11:0] W_abs_Ck;
rx_symbol_sync_corr u0(
	.I_data_sign_i(R_data_sign_buff_i),
	.I_data_sign_q(R_data_sign_buff_q),
	.O_abs_Ck(W_abs_Ck)
);

wire W_peak_valid = (W_abs_Ck >= CSR_symbol_sync_threshold)?1'b1:1'b0;

reg [8:0] R_peak1_position;
reg R_find_peak1;
reg [8:0] R_peak2_position;
reg R_find_peak2;
always @(posedge I_clk) begin
	if(I_clk_en & W_symbol_sync_start) begin
		R_find_peak1 <= 1'b0;
		R_find_peak2 <= 1'b0;
		R_peak1_position <= 9'd0;
		R_peak2_position <= 9'd0;
	end
	else if(I_clk_en)begin
	    if(W_peak_valid && (R_find_peak1==1'b0)) begin
			R_peak1_position <= R_symbol_sync_cnt;
			R_find_peak1 <= 1'b1;
		end
		else if(W_peak_valid && (R_find_peak1==1'b1)) begin
			R_peak2_position <= R_symbol_sync_cnt;
			R_find_peak2 <= 1'b1;
		end
	end
end

always @(posedge I_clk) begin
	if(I_clk_en) begin
		O_symbol_sync_out_start <= R_find_peak1 & W_peak_valid;
	end
end

reg [8:0] R_data_buff_i[0:144]; //9S7
reg [8:0] R_data_buff_q[0:144]; //9S7
genvar j;
generate
	for(j=0;j<145;j=j+1) begin : for_loop1
		always @(posedge I_clk) begin
			if(I_clk_en & W_symbol_sync_start) begin
				R_data_buff_i[j] <= 'd0; 
				R_data_buff_q[j] <= 'd0;
			end
			else if(I_clk_en)begin
				if(j==0) begin
					R_data_buff_i[j] <= R_symbol_sync_in_i_d; 
					R_data_buff_q[j] <= R_symbol_sync_in_q_d;
				end
				else begin                                      
					R_data_buff_i[j] <= R_data_buff_i[j-1];
					R_data_buff_q[j] <= R_data_buff_q[j-1];
				end
			end
		end
	end
endgenerate

wire [8:0] delta_peak_position = R_peak2_position - R_peak1_position;
always @(posedge I_clk) begin
	if(I_clk_en & W_symbol_sync_start) begin
		O_symbol_sync_out_i <= 9'd0;
		O_symbol_sync_out_q <= 9'd0;
	end
	else if(I_clk_en)begin
	    if((delta_peak_position >= 9'd63)&&(delta_peak_position <= 9'd65)) begin
			O_symbol_sync_out_i <= R_data_buff_i[144];
			O_symbol_sync_out_q <= R_data_buff_q[144];
		end
		else begin
			O_symbol_sync_out_i <= 9'd0;
			O_symbol_sync_out_q <= 9'd0;
		end
	end
end

endmodule