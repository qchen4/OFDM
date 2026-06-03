//////////////////////////////////////////////////////////////
// 功能: Burst时序Viterbi解码的Verilog代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module rx_viterbi217(
	input I_clk,
	input I_rst_n,
	input I_clk_en,
	
	input [10:0] I_decode_data_ofdm_num,
	input [10:0] I_rx_ofdm_symbol_idx,
	
	input I_rx_signal_in_start,
	input I_rx_data_in_start,
	input I_rx_viterbi217_en,
	
	input I_rx_bits,
	input I_rx_bits_valid,
	input [7:0] I_rx_bits_num, // 有效bit的总数

	output reg O_signal_dec_bits,
	output reg O_signal_dec_bits_valid,
	output reg O_data_dec_bits,
	output reg O_data_dec_bits_valid,
	output O_viterbi_done
    );
	
	wire W_viterbi_clear = I_rx_signal_in_start | I_rx_data_in_start;
	
    parameter C_TRACEBACK_LENGTH = 6'd36;
	wire [6:0] W_decode_bits_num = I_rx_bits_num[7:1];
	
	wire [1:0] W_dis0; 
	wire [1:0] W_dis1; 
	wire [1:0] W_dis2; 
	wire [1:0] W_dis3; 
	
	// 把输入bit存入移位寄存器，用来做串并变换
	reg [1:0] R_bits_buff;
	always @(posedge I_clk or negedge I_rst_n) begin
	   if(~I_rst_n)
	       R_bits_buff <= 2'd0;
	   else if(W_viterbi_clear) 
	       R_bits_buff <= 2'd0;
       else if(I_rx_bits_valid) begin
           R_bits_buff <= {R_bits_buff[0], I_rx_bits};
       end
	end
	
	// 把I_rx_bits_valid delay 2拍
	reg [1:0] R_rx_bits_valid_dly_buff;
	wire W_rx_bits_valid_dly2;
	always @(posedge I_clk or negedge I_rst_n) begin
	   if(~I_rst_n)
	       R_rx_bits_valid_dly_buff <= 2'd0;
	   else if(W_viterbi_clear)
	       R_rx_bits_valid_dly_buff <= 2'd0;
       else
           R_rx_bits_valid_dly_buff <= {R_rx_bits_valid_dly_buff[0],I_rx_bits_valid};
	end
	assign W_rx_bits_valid_dly2 = R_rx_bits_valid_dly_buff[1];
	
	//串并转化起始信号
	assign W_ser2para_start = I_rx_bits_valid & (~R_rx_bits_valid_dly_buff[0]);
	
	// 产生串并变换的选择信号	
	reg R_bits_sel;
	always @(posedge I_clk or negedge I_rst_n) begin
	   if(~I_rst_n)
	       R_bits_sel <= 1'd0;
	   else if(W_ser2para_start)
	       R_bits_sel <= 1'd0;
       else if(I_rx_viterbi217_en)
           R_bits_sel <= ~R_bits_sel;
	end
	
	// 输出并行数据，用来 Viterbi 解码
	reg [1:0] R_rx_bits_para;
	always @(posedge I_clk or negedge I_rst_n) begin
	   if(~I_rst_n) 
	       R_rx_bits_para <= 2'd0;
	   else if(W_viterbi_clear)
	       R_rx_bits_para <= 2'd0;
       else if(R_bits_sel && W_rx_bits_valid_dly2)
           R_rx_bits_para <= R_bits_buff;
	end
	
	reg R_rx_bits_para_cnt_en;
	reg [7:0] R_rx_bits_para_cnt;
	always @(posedge I_clk or negedge I_rst_n) begin
	   if(~I_rst_n) begin
	       R_rx_bits_para_cnt_en <= 1'd0;
	   end
	   else if(W_ser2para_start) begin
	       R_rx_bits_para_cnt_en <= 1'd0;
	   end
	   else if(R_bits_sel) begin
	       if(R_rx_bits_para_cnt == (W_decode_bits_num-1'b1)) begin
               R_rx_bits_para_cnt_en <= 1'd0;
           end
           else if(I_rx_bits_valid) begin
               R_rx_bits_para_cnt_en <= 1'd1;
           end
       end
	end

	always @(posedge I_clk or negedge I_rst_n) begin
	   if(~I_rst_n) begin
	       R_rx_bits_para_cnt <= 8'd0;
	   end
	   else if(W_ser2para_start) begin
	       R_rx_bits_para_cnt <= 8'd0;
	   end
       else if(R_bits_sel) begin
           if(R_rx_bits_para_cnt == (W_decode_bits_num-1'b1))
               R_rx_bits_para_cnt <= 8'd0;
           else if(R_rx_bits_para_cnt_en)
               R_rx_bits_para_cnt <= R_rx_bits_para_cnt + 1'b1;
       end
	end
	
	// Signal域和DATA域第一个OFDM符号才有可能只选择上分支
	wire W_select_upper_branch = R_rx_bits_para_cnt_en & (R_rx_bits_para_cnt < 8'd6) & (I_rx_ofdm_symbol_idx <= 1);
	
	// 每个节点的累计距离dis_acc0/1/2/3
	reg [31:0] R_dis_acc[0:63];
    wire [31:0] W_new_dis_acc[0:63];
    wire W_branch[63:0];
    
    integer i;
	always @(posedge I_clk or negedge I_rst_n) begin
		if(~I_rst_n) begin
			for(i = 0; i < 64; i = i+1) begin
				R_dis_acc[i] <= 32'd0;
			end
		end
		else if(W_viterbi_clear) begin
			for(i = 0; i < 64; i = i+1) begin
				R_dis_acc[i] <= 32'd0;
			end
		end
		else if(R_bits_sel && R_rx_bits_para_cnt_en && (I_rx_ofdm_symbol_idx <= 1)) begin
			if(R_rx_bits_para_cnt == 8'd0)begin
				R_dis_acc[0] <= W_new_dis_acc[0];
				R_dis_acc[32] <= W_new_dis_acc[32];
			end
			else if(R_rx_bits_para_cnt == 8'd1) begin
				R_dis_acc[0] <= W_new_dis_acc[0];
				R_dis_acc[32] <= W_new_dis_acc[32];
				R_dis_acc[16] <= W_new_dis_acc[16];
				R_dis_acc[48] <= W_new_dis_acc[48];
			end
			else if(R_rx_bits_para_cnt == 8'd2) begin
				R_dis_acc[0] <= W_new_dis_acc[0];
				R_dis_acc[32] <= W_new_dis_acc[32];
				R_dis_acc[16] <= W_new_dis_acc[16];
				R_dis_acc[48] <= W_new_dis_acc[48];
				R_dis_acc[8] <= W_new_dis_acc[8];
				R_dis_acc[40] <= W_new_dis_acc[40];
				R_dis_acc[24] <= W_new_dis_acc[24];
				R_dis_acc[56] <= W_new_dis_acc[56];
			end
			else if(R_rx_bits_para_cnt == 8'd3) begin
				R_dis_acc[0] <= W_new_dis_acc[0];
				R_dis_acc[32] <= W_new_dis_acc[32];
				R_dis_acc[16] <= W_new_dis_acc[16];
				R_dis_acc[48] <= W_new_dis_acc[48];
				R_dis_acc[8] <= W_new_dis_acc[8];
				R_dis_acc[40] <= W_new_dis_acc[40];
				R_dis_acc[24] <= W_new_dis_acc[24];
				R_dis_acc[56] <= W_new_dis_acc[56];
				R_dis_acc[4] <= W_new_dis_acc[4];
				R_dis_acc[36] <= W_new_dis_acc[36];
				R_dis_acc[20] <= W_new_dis_acc[20];
				R_dis_acc[52] <= W_new_dis_acc[52];
				R_dis_acc[12] <= W_new_dis_acc[12];
				R_dis_acc[44] <= W_new_dis_acc[44];
				R_dis_acc[28] <= W_new_dis_acc[28];
				R_dis_acc[60] <= W_new_dis_acc[60]; 
			end
			else if(R_rx_bits_para_cnt == 8'd4) begin
				R_dis_acc[0] <= W_new_dis_acc[0];
				R_dis_acc[32] <= W_new_dis_acc[32];
				R_dis_acc[16] <= W_new_dis_acc[16];
				R_dis_acc[48] <= W_new_dis_acc[48];
				R_dis_acc[8] <= W_new_dis_acc[8];
				R_dis_acc[40] <= W_new_dis_acc[40];
				R_dis_acc[24] <= W_new_dis_acc[24];
				R_dis_acc[56] <= W_new_dis_acc[56];
				R_dis_acc[4] <= W_new_dis_acc[4];
				R_dis_acc[36] <= W_new_dis_acc[36];
				R_dis_acc[20] <= W_new_dis_acc[20];
				R_dis_acc[52] <= W_new_dis_acc[52];
				R_dis_acc[12] <= W_new_dis_acc[12];
				R_dis_acc[44] <= W_new_dis_acc[44];
				R_dis_acc[28] <= W_new_dis_acc[28];
				R_dis_acc[60] <= W_new_dis_acc[60]; 
				R_dis_acc[2] <= W_new_dis_acc[2];
				R_dis_acc[34] <= W_new_dis_acc[34];
				R_dis_acc[18] <= W_new_dis_acc[18];
				R_dis_acc[50] <= W_new_dis_acc[50];
				R_dis_acc[10] <= W_new_dis_acc[10];
				R_dis_acc[42] <= W_new_dis_acc[42];
				R_dis_acc[26] <= W_new_dis_acc[26];
				R_dis_acc[58] <= W_new_dis_acc[58];
				R_dis_acc[6] <= W_new_dis_acc[6];
				R_dis_acc[38] <= W_new_dis_acc[38];
				R_dis_acc[22] <= W_new_dis_acc[22];
				R_dis_acc[54] <= W_new_dis_acc[54];
				R_dis_acc[14] <= W_new_dis_acc[14];
				R_dis_acc[46] <= W_new_dis_acc[46];
				R_dis_acc[30] <= W_new_dis_acc[30];
				R_dis_acc[62] <= W_new_dis_acc[62];             
			end
			else begin
				for(i = 0; i < 64; i = i+1) begin
					R_dis_acc[i] <= W_new_dis_acc[i];
				end 
			end
        end
		else if(R_bits_sel && R_rx_bits_para_cnt_en) begin
			for(i = 0; i < 64; i = i+1) begin
				R_dis_acc[i] <= W_new_dis_acc[i];
			end 
		end
	end	
	
	// 产生branch0/1/2/3 4个存储单元的enable信号
	wire W_branch_load_en = R_rx_bits_para_cnt_en;    
	
	// 开始traceback,decode出原始bit，假设traceback的深度为36
	reg [(C_TRACEBACK_LENGTH - 1) : 0] R_branch[0:63];
	
	// 存储幸存路径
	always @(posedge I_clk or negedge I_rst_n) begin
	   if(~I_rst_n) begin
	       for(i = 0; i < 64; i = i+1) begin
	           R_branch[i] <= 36'd0;
	       end
	   end
	   else if(W_viterbi_clear) begin
	       for(i = 0; i < 64; i = i+1) begin
	           R_branch[i] <= 36'd0;
	       end
	   end
	   else if(R_bits_sel && W_branch_load_en) begin
	       for(i = 0; i < 64; i = i+1) begin
	           R_branch[i] <= {R_branch[i][C_TRACEBACK_LENGTH-2:0],W_branch[i]};
	       end
	   end
	end
	
	reg R_traceback_en;
	reg [7:0] R_traceback_en_cnt;
	always @(posedge I_clk or negedge I_rst_n) begin
	   if(~I_rst_n) begin
	       R_traceback_en <= 1'b0;
	   end
	   else if(W_ser2para_start) begin
	       R_traceback_en <= 1'b0;
	   end
	   else if(R_bits_sel) begin
           if(R_rx_bits_para_cnt == (C_TRACEBACK_LENGTH-2'd1))begin
               R_traceback_en <= 1'b1;
           end
           else if(R_traceback_en_cnt == (W_decode_bits_num-1'b1))begin
               R_traceback_en <= 1'b0;
           end
       end
	end
	
	always @(posedge I_clk or negedge I_rst_n) begin
	   if(~I_rst_n) begin
	       R_traceback_en_cnt <= 8'd0;
	   end
	   else if(W_ser2para_start) begin
	       R_traceback_en_cnt <= 8'd0;
	   end
	   else if(R_bits_sel) begin
           if(R_traceback_en_cnt==(W_decode_bits_num-1'b1))begin
               R_traceback_en_cnt <= 8'd0;
           end
           else if(R_traceback_en)begin
               R_traceback_en_cnt <= R_traceback_en_cnt + 1'b1;
           end
	   end
	end
	
	wire [5:0] W_set_branch_stage[0:(C_TRACEBACK_LENGTH-1)];
	wire W_dec_bits_stage[1:C_TRACEBACK_LENGTH];
	
	assign W_set_branch_stage[0] = 6'd0;
	
	genvar j;
	generate
	   for(j = 0; j < C_TRACEBACK_LENGTH; j = j + 1) begin
	       traceback64_unit 
	       #(.C_TRACEBACK_LENGTH(C_TRACEBACK_LENGTH),
             .C_TRACEBACK_IDX(j))
	       stage(
                .I_set_branch(W_set_branch_stage[j]), //选择branch0
                .O_set_branch(W_set_branch_stage[j+1]),
                .O_dec_bits(W_dec_bits_stage[j+1]),
                
               	.I_branch0(R_branch[0]),
                .I_branch1(R_branch[1]),
                .I_branch2(R_branch[2]),
                .I_branch3(R_branch[3]),
                .I_branch4(R_branch[4]),
                .I_branch5(R_branch[5]),
                .I_branch6(R_branch[6]),
                .I_branch7(R_branch[7]),
                .I_branch8(R_branch[8]),
                .I_branch9(R_branch[9]),
                .I_branch10(R_branch[10]),
                .I_branch11(R_branch[11]),
                .I_branch12(R_branch[12]),
                .I_branch13(R_branch[13]),
                .I_branch14(R_branch[14]),
                .I_branch15(R_branch[15]),
                .I_branch16(R_branch[16]),
                .I_branch17(R_branch[17]),
                .I_branch18(R_branch[18]),
                .I_branch19(R_branch[19]),
                .I_branch20(R_branch[20]),
                .I_branch21(R_branch[21]),
                .I_branch22(R_branch[22]),
                .I_branch23(R_branch[23]),
                .I_branch24(R_branch[24]),
                .I_branch25(R_branch[25]),
                .I_branch26(R_branch[26]),
                .I_branch27(R_branch[27]),
                .I_branch28(R_branch[28]),
                .I_branch29(R_branch[29]),
                .I_branch30(R_branch[30]),
                .I_branch31(R_branch[31]),
                .I_branch32(R_branch[32]),
                .I_branch33(R_branch[33]),
                .I_branch34(R_branch[34]),
                .I_branch35(R_branch[35]),
                .I_branch36(R_branch[36]),
                .I_branch37(R_branch[37]),
                .I_branch38(R_branch[38]),
                .I_branch39(R_branch[39]),
                .I_branch40(R_branch[40]),
                .I_branch41(R_branch[41]),
                .I_branch42(R_branch[42]),
                .I_branch43(R_branch[43]),
                .I_branch44(R_branch[44]),
                .I_branch45(R_branch[45]),
                .I_branch46(R_branch[46]),
                .I_branch47(R_branch[47]),
                .I_branch48(R_branch[48]),
                .I_branch49(R_branch[49]),
                .I_branch50(R_branch[50]),
                .I_branch51(R_branch[51]),
                .I_branch52(R_branch[52]),
                .I_branch53(R_branch[53]),
                .I_branch54(R_branch[54]),
                .I_branch55(R_branch[55]),
                .I_branch56(R_branch[56]),
                .I_branch57(R_branch[57]),
                .I_branch58(R_branch[58]),
                .I_branch59(R_branch[59]),
                .I_branch60(R_branch[60]),
                .I_branch61(R_branch[61]),
                .I_branch62(R_branch[62]),
                .I_branch63(R_branch[63]));
	   end
	endgenerate  
	
	wire W_signal_traceback_en = (I_rx_ofdm_symbol_idx == 10'd0) && R_traceback_en;
	
	wire W_head_data_trackback_en = (I_rx_ofdm_symbol_idx == 10'd1) && W_branch_load_en && R_traceback_en;
	wire W_body_data_trackback_en = (I_rx_ofdm_symbol_idx >= 10'd2) && (I_rx_ofdm_symbol_idx <= I_decode_data_ofdm_num) && W_branch_load_en;
	wire W_tail_data_trackback_en = (I_rx_ofdm_symbol_idx != 10'd0) && (I_rx_ofdm_symbol_idx == I_decode_data_ofdm_num) && (~W_branch_load_en && R_traceback_en);
		
	reg  R_dec_bits_start;
	always @(posedge I_clk or negedge I_rst_n) begin
		if(~I_rst_n) begin
			R_dec_bits_start <= 1'b0;
		end
		else if(W_viterbi_clear) begin
			R_dec_bits_start <= 1'b0;
		end
		else if(R_bits_sel) begin
			if(W_signal_traceback_en | W_tail_data_trackback_en) begin
				case(R_traceback_en_cnt)
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 1) : begin R_dec_bits_start <= W_dec_bits_stage[35]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 2) : begin R_dec_bits_start <= W_dec_bits_stage[34]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 3) : begin R_dec_bits_start <= W_dec_bits_stage[33]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 4) : begin R_dec_bits_start <= W_dec_bits_stage[32]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 5) : begin R_dec_bits_start <= W_dec_bits_stage[31]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 6) : begin R_dec_bits_start <= W_dec_bits_stage[30]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 7) : begin R_dec_bits_start <= W_dec_bits_stage[29]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 8) : begin R_dec_bits_start <= W_dec_bits_stage[28]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 9) : begin R_dec_bits_start <= W_dec_bits_stage[27]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 10) : begin R_dec_bits_start <= W_dec_bits_stage[26]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 11) : begin R_dec_bits_start <= W_dec_bits_stage[25]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 12) : begin R_dec_bits_start <= W_dec_bits_stage[24]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 13) : begin R_dec_bits_start <= W_dec_bits_stage[23]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 14) : begin R_dec_bits_start <= W_dec_bits_stage[22]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 15) : begin R_dec_bits_start <= W_dec_bits_stage[21]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 16) : begin R_dec_bits_start <= W_dec_bits_stage[20]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 17) : begin R_dec_bits_start <= W_dec_bits_stage[19]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 18) : begin R_dec_bits_start <= W_dec_bits_stage[18]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 19) : begin R_dec_bits_start <= W_dec_bits_stage[17]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 20) : begin R_dec_bits_start <= W_dec_bits_stage[16]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 21) : begin R_dec_bits_start <= W_dec_bits_stage[15]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 22) : begin R_dec_bits_start <= W_dec_bits_stage[14]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 23) : begin R_dec_bits_start <= W_dec_bits_stage[13]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 24) : begin R_dec_bits_start <= W_dec_bits_stage[12]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 25) : begin R_dec_bits_start <= W_dec_bits_stage[11]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 26) : begin R_dec_bits_start <= W_dec_bits_stage[10]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 27) : begin R_dec_bits_start <= W_dec_bits_stage[9]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 28) : begin R_dec_bits_start <= W_dec_bits_stage[8]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 29) : begin R_dec_bits_start <= W_dec_bits_stage[7]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 30) : begin R_dec_bits_start <= W_dec_bits_stage[6]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 31) : begin R_dec_bits_start <= W_dec_bits_stage[5]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 32) : begin R_dec_bits_start <= W_dec_bits_stage[4]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 33) : begin R_dec_bits_start <= W_dec_bits_stage[3]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 34) : begin R_dec_bits_start <= W_dec_bits_stage[2]; end
					(W_decode_bits_num - C_TRACEBACK_LENGTH + 35) : begin R_dec_bits_start <= W_dec_bits_stage[1]; end
					default                                   : begin R_dec_bits_start <= W_dec_bits_stage[36]; end
				endcase
			end
			else if(W_head_data_trackback_en | W_body_data_trackback_en)
				R_dec_bits_start <= W_dec_bits_stage[36]; 
		end
	end	
	
	// 最终解码出来的Signal域数据域数据有效信号，必须和40MHz clk_en下降沿对齐
	reg R_signal_dec_bits_valid_unaligned;	 
	always @(posedge I_clk or negedge I_rst_n) begin
	   if(~I_rst_n) begin
	       R_signal_dec_bits_valid_unaligned <= 1'b0;
	   end
	   else if(W_viterbi_clear) begin
	       R_signal_dec_bits_valid_unaligned <= 1'b0;
	   end
	   else if(R_bits_sel) begin
			R_signal_dec_bits_valid_unaligned <= W_signal_traceback_en;
       end
	end 
	
	always @(posedge I_clk or negedge I_rst_n) begin
	   if(~I_rst_n) begin
	       O_signal_dec_bits <= 1'b0;
	       O_signal_dec_bits_valid <= 1'b0;
	   end
	   else if(I_clk_en)begin
		   O_signal_dec_bits <= R_dec_bits_start & (I_rx_ofdm_symbol_idx == 0);
	       O_signal_dec_bits_valid <= R_signal_dec_bits_valid_unaligned;
	   end
	end 
	
	// 最终解码出来的DATA域数据域数据有效信号，必须和40MHz clk_en下降沿对齐
	reg R_data_dec_bits_valid_unaligned;	 
	always @(posedge I_clk or negedge I_rst_n) begin
	   if(~I_rst_n) begin
	       R_data_dec_bits_valid_unaligned <= 1'b0;
	   end
	   else if(W_viterbi_clear) begin
	       R_data_dec_bits_valid_unaligned <= 1'b0;
	   end
	   else if(R_bits_sel) begin
			R_data_dec_bits_valid_unaligned <= W_head_data_trackback_en | W_body_data_trackback_en | W_tail_data_trackback_en;
       end
	end 
	
	always @(posedge I_clk or negedge I_rst_n) begin
	   if(~I_rst_n) begin
	       O_data_dec_bits <= 1'b0;
	       O_data_dec_bits_valid <= 1'b0;
	   end
	   else if(I_clk_en)begin
		   O_data_dec_bits <= R_dec_bits_start & (I_rx_ofdm_symbol_idx > 0);
	       O_data_dec_bits_valid <= R_data_dec_bits_valid_unaligned;
	   end
	end 
	
	//产生O_viterbi_done,表示所有bit全部decode完成
	assign O_viterbi_done = ~R_data_dec_bits_valid_unaligned & O_data_dec_bits_valid & (I_rx_ofdm_symbol_idx == I_decode_data_ofdm_num);
		 	
	// 求每个并行输入bits的汉明距离 dis0/1/2/3
	hanming_dis u_hanming_dis(
		.I_rx_bits_para(R_rx_bits_para),
		.O_dis0(W_dis0),
		.O_dis1(W_dis1),
		.O_dis2(W_dis2),
		.O_dis3(W_dis3)
    );
    
    acs64 u_acs64(
        .I_select_upper_branch(W_select_upper_branch),
        .I_dis0(W_dis0),
        .I_dis1(W_dis1),
        .I_dis2(W_dis2),
        .I_dis3(W_dis3),
        .I_dis_acc0(R_dis_acc[0]),
        .O_new_dis_acc0(W_new_dis_acc[0]),
        .O_branch0(W_branch[0]),
        .I_dis_acc1(R_dis_acc[1]),
        .O_new_dis_acc1(W_new_dis_acc[1]),
        .O_branch1(W_branch[1]),
        .I_dis_acc2(R_dis_acc[2]),
        .O_new_dis_acc2(W_new_dis_acc[2]),
        .O_branch2(W_branch[2]),
        .I_dis_acc3(R_dis_acc[3]),
        .O_new_dis_acc3(W_new_dis_acc[3]),
        .O_branch3(W_branch[3]),
        .I_dis_acc4(R_dis_acc[4]),
        .O_new_dis_acc4(W_new_dis_acc[4]),
        .O_branch4(W_branch[4]),
        .I_dis_acc5(R_dis_acc[5]),
        .O_new_dis_acc5(W_new_dis_acc[5]),
        .O_branch5(W_branch[5]),
        .I_dis_acc6(R_dis_acc[6]),
        .O_new_dis_acc6(W_new_dis_acc[6]),
        .O_branch6(W_branch[6]),
        .I_dis_acc7(R_dis_acc[7]),
        .O_new_dis_acc7(W_new_dis_acc[7]),
        .O_branch7(W_branch[7]),
        .I_dis_acc8(R_dis_acc[8]),
        .O_new_dis_acc8(W_new_dis_acc[8]),
        .O_branch8(W_branch[8]),
        .I_dis_acc9(R_dis_acc[9]),
        .O_new_dis_acc9(W_new_dis_acc[9]),
        .O_branch9(W_branch[9]),
        .I_dis_acc10(R_dis_acc[10]),
        .O_new_dis_acc10(W_new_dis_acc[10]),
        .O_branch10(W_branch[10]),
        .I_dis_acc11(R_dis_acc[11]),
        .O_new_dis_acc11(W_new_dis_acc[11]),
        .O_branch11(W_branch[11]),
        .I_dis_acc12(R_dis_acc[12]),
        .O_new_dis_acc12(W_new_dis_acc[12]),
        .O_branch12(W_branch[12]),
        .I_dis_acc13(R_dis_acc[13]),
        .O_new_dis_acc13(W_new_dis_acc[13]),
        .O_branch13(W_branch[13]),
        .I_dis_acc14(R_dis_acc[14]),
        .O_new_dis_acc14(W_new_dis_acc[14]),
        .O_branch14(W_branch[14]),
        .I_dis_acc15(R_dis_acc[15]),
        .O_new_dis_acc15(W_new_dis_acc[15]),
        .O_branch15(W_branch[15]),
        .I_dis_acc16(R_dis_acc[16]),
        .O_new_dis_acc16(W_new_dis_acc[16]),
        .O_branch16(W_branch[16]),
        .I_dis_acc17(R_dis_acc[17]),
        .O_new_dis_acc17(W_new_dis_acc[17]),
        .O_branch17(W_branch[17]),
        .I_dis_acc18(R_dis_acc[18]),
        .O_new_dis_acc18(W_new_dis_acc[18]),
        .O_branch18(W_branch[18]),
        .I_dis_acc19(R_dis_acc[19]),
        .O_new_dis_acc19(W_new_dis_acc[19]),
        .O_branch19(W_branch[19]),
        .I_dis_acc20(R_dis_acc[20]),
        .O_new_dis_acc20(W_new_dis_acc[20]),
        .O_branch20(W_branch[20]),
        .I_dis_acc21(R_dis_acc[21]),
        .O_new_dis_acc21(W_new_dis_acc[21]),
        .O_branch21(W_branch[21]),
        .I_dis_acc22(R_dis_acc[22]),
        .O_new_dis_acc22(W_new_dis_acc[22]),
        .O_branch22(W_branch[22]),
        .I_dis_acc23(R_dis_acc[23]),
        .O_new_dis_acc23(W_new_dis_acc[23]),
        .O_branch23(W_branch[23]),
        .I_dis_acc24(R_dis_acc[24]),
        .O_new_dis_acc24(W_new_dis_acc[24]),
        .O_branch24(W_branch[24]),
        .I_dis_acc25(R_dis_acc[25]),
        .O_new_dis_acc25(W_new_dis_acc[25]),
        .O_branch25(W_branch[25]),
        .I_dis_acc26(R_dis_acc[26]),
        .O_new_dis_acc26(W_new_dis_acc[26]),
        .O_branch26(W_branch[26]),
        .I_dis_acc27(R_dis_acc[27]),
        .O_new_dis_acc27(W_new_dis_acc[27]),
        .O_branch27(W_branch[27]),
        .I_dis_acc28(R_dis_acc[28]),
        .O_new_dis_acc28(W_new_dis_acc[28]),
        .O_branch28(W_branch[28]),
        .I_dis_acc29(R_dis_acc[29]),
        .O_new_dis_acc29(W_new_dis_acc[29]),
        .O_branch29(W_branch[29]),
        .I_dis_acc30(R_dis_acc[30]),
        .O_new_dis_acc30(W_new_dis_acc[30]),
        .O_branch30(W_branch[30]),
        .I_dis_acc31(R_dis_acc[31]),
        .O_new_dis_acc31(W_new_dis_acc[31]),
        .O_branch31(W_branch[31]),
        .I_dis_acc32(R_dis_acc[32]),
        .O_new_dis_acc32(W_new_dis_acc[32]),
        .O_branch32(W_branch[32]),
        .I_dis_acc33(R_dis_acc[33]),
        .O_new_dis_acc33(W_new_dis_acc[33]),
        .O_branch33(W_branch[33]),
        .I_dis_acc34(R_dis_acc[34]),
        .O_new_dis_acc34(W_new_dis_acc[34]),
        .O_branch34(W_branch[34]),
        .I_dis_acc35(R_dis_acc[35]),
        .O_new_dis_acc35(W_new_dis_acc[35]),
        .O_branch35(W_branch[35]),
        .I_dis_acc36(R_dis_acc[36]),
        .O_new_dis_acc36(W_new_dis_acc[36]),
        .O_branch36(W_branch[36]),
        .I_dis_acc37(R_dis_acc[37]),
        .O_new_dis_acc37(W_new_dis_acc[37]),
        .O_branch37(W_branch[37]),
        .I_dis_acc38(R_dis_acc[38]),
        .O_new_dis_acc38(W_new_dis_acc[38]),
        .O_branch38(W_branch[38]),
        .I_dis_acc39(R_dis_acc[39]),
        .O_new_dis_acc39(W_new_dis_acc[39]),
        .O_branch39(W_branch[39]),
        .I_dis_acc40(R_dis_acc[40]),
        .O_new_dis_acc40(W_new_dis_acc[40]),
        .O_branch40(W_branch[40]),
        .I_dis_acc41(R_dis_acc[41]),
        .O_new_dis_acc41(W_new_dis_acc[41]),
        .O_branch41(W_branch[41]),
        .I_dis_acc42(R_dis_acc[42]),
        .O_new_dis_acc42(W_new_dis_acc[42]),
        .O_branch42(W_branch[42]),
        .I_dis_acc43(R_dis_acc[43]),
        .O_new_dis_acc43(W_new_dis_acc[43]),
        .O_branch43(W_branch[43]),
        .I_dis_acc44(R_dis_acc[44]),
        .O_new_dis_acc44(W_new_dis_acc[44]),
        .O_branch44(W_branch[44]),
        .I_dis_acc45(R_dis_acc[45]),
        .O_new_dis_acc45(W_new_dis_acc[45]),
        .O_branch45(W_branch[45]),
        .I_dis_acc46(R_dis_acc[46]),
        .O_new_dis_acc46(W_new_dis_acc[46]),
        .O_branch46(W_branch[46]),
        .I_dis_acc47(R_dis_acc[47]),
        .O_new_dis_acc47(W_new_dis_acc[47]),
        .O_branch47(W_branch[47]),
        .I_dis_acc48(R_dis_acc[48]),
        .O_new_dis_acc48(W_new_dis_acc[48]),
        .O_branch48(W_branch[48]),
        .I_dis_acc49(R_dis_acc[49]),
        .O_new_dis_acc49(W_new_dis_acc[49]),
        .O_branch49(W_branch[49]),
        .I_dis_acc50(R_dis_acc[50]),
        .O_new_dis_acc50(W_new_dis_acc[50]),
        .O_branch50(W_branch[50]),
        .I_dis_acc51(R_dis_acc[51]),
        .O_new_dis_acc51(W_new_dis_acc[51]),
        .O_branch51(W_branch[51]),
        .I_dis_acc52(R_dis_acc[52]),
        .O_new_dis_acc52(W_new_dis_acc[52]),
        .O_branch52(W_branch[52]),
        .I_dis_acc53(R_dis_acc[53]),
        .O_new_dis_acc53(W_new_dis_acc[53]),
        .O_branch53(W_branch[53]),
        .I_dis_acc54(R_dis_acc[54]),
        .O_new_dis_acc54(W_new_dis_acc[54]),
        .O_branch54(W_branch[54]),
        .I_dis_acc55(R_dis_acc[55]),
        .O_new_dis_acc55(W_new_dis_acc[55]),
        .O_branch55(W_branch[55]),
        .I_dis_acc56(R_dis_acc[56]),
        .O_new_dis_acc56(W_new_dis_acc[56]),
        .O_branch56(W_branch[56]),
        .I_dis_acc57(R_dis_acc[57]),
        .O_new_dis_acc57(W_new_dis_acc[57]),
        .O_branch57(W_branch[57]),
        .I_dis_acc58(R_dis_acc[58]),
        .O_new_dis_acc58(W_new_dis_acc[58]),
        .O_branch58(W_branch[58]),
        .I_dis_acc59(R_dis_acc[59]),
        .O_new_dis_acc59(W_new_dis_acc[59]),
        .O_branch59(W_branch[59]),
        .I_dis_acc60(R_dis_acc[60]),
        .O_new_dis_acc60(W_new_dis_acc[60]),
        .O_branch60(W_branch[60]),
        .I_dis_acc61(R_dis_acc[61]),
        .O_new_dis_acc61(W_new_dis_acc[61]),
        .O_branch61(W_branch[61]),
        .I_dis_acc62(R_dis_acc[62]),
        .O_new_dis_acc62(W_new_dis_acc[62]),
        .O_branch62(W_branch[62]),
        .I_dis_acc63(R_dis_acc[63]),
        .O_new_dis_acc63(W_new_dis_acc[63]),
        .O_branch63(W_branch[63]));
endmodule
