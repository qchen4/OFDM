//////////////////////////////////////////////////////////////
// 功能: OFDM Schmidl-Cox算法信号检测Verilog代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
//////////////////////////////////////////////////////////////
module rx_packet_detect(
	input			I_clk,
	input			I_clk_en,
	input			I_rst_n, 	
	input			I_search_packet_en,
	input	[7 : 0]	I_rx_data_in_i,  // 8S7
	input	[7 : 0]	I_rx_data_in_q,  // 8S7	
	input	[2 : 0]	CSR_Md_threshold,
	input	[8 : 0]	CSR_Md_cnt_threshold, 
	
	output			O_packet_detected_done	
);

reg R_search_packet_en_d;
always @(posedge I_clk) begin
	if(I_clk_en) begin
		R_search_packet_en_d <= I_search_packet_en;
	end
end

wire W_search_start = ~R_search_packet_en_d & I_search_packet_en;

reg [7:0] R_rx_data_in_i_d;
reg [7:0] R_rx_data_in_q_d;
always @(posedge I_clk) begin
	if(I_clk_en & I_search_packet_en)begin
		R_rx_data_in_i_d <= I_rx_data_in_i;
		R_rx_data_in_q_d <= I_rx_data_in_q;
	end
end

reg [7:0] R_data_buff_i[0:15]; //8S7
reg [7:0] R_data_buff_q[0:15]; //8S7
genvar i;
generate
	for(i=0;i<16;i=i+1) begin : for_loop0
		always @(posedge I_clk) begin
			if(I_clk_en & W_search_start) begin
				R_data_buff_i[i] <= 'd0; 
				R_data_buff_q[i] <= 'd0;
			end
			else if(I_clk_en & R_search_packet_en_d)begin
				if(i==0) begin
					R_data_buff_i[0] <= R_rx_data_in_i_d; 
					R_data_buff_q[0] <= R_rx_data_in_q_d;
				end
				else begin                                      
					R_data_buff_i[i] <= R_data_buff_i[i-1];
					R_data_buff_q[i] <= R_data_buff_q[i-1];
				end
			end
		end
	end
endgenerate

wire [7:0] rx_win_in_dly16_conj_i = R_data_buff_i[15];
wire [7:0] rx_win_in_dly16_conj_q = -R_data_buff_q[15];
wire [7:0] rx_win_in_i = R_rx_data_in_i_d;
wire [7:0] rx_win_in_q = R_rx_data_in_q_d;

// 计算P(d)
wire [16:0] W_cmult_out_i; //17S14
wire [16:0] W_cmult_out_q; //17S14
complex_mult #(1,8,8) u0(
	.I_in1_i(rx_win_in_dly16_conj_i),
	.I_in1_q(rx_win_in_dly16_conj_q),
	.I_in2_i(rx_win_in_i),
	.I_in2_q(rx_win_in_q),	
	.O_out_i(W_cmult_out_i),	
	.O_out_q(W_cmult_out_q));
	
wire [8:0] W_cmult_out_rs_i; //9S7
wire [8:0] W_cmult_out_rs_q; //9S7	
round_sat #(17,14,9,7) u1(.I_in(W_cmult_out_i),.O_out(W_cmult_out_rs_i));
round_sat #(17,14,9,7) u2(.I_in(W_cmult_out_q),.O_out(W_cmult_out_rs_q));

// 计算R(d)
wire [15:0] real_mult_out_i;
wire [15:0] real_mult_out_q;
real_mult #(1,8,8) u3(.I_in1(rx_win_in_i),.I_in2(rx_win_in_i),.O_out(real_mult_out_i));
real_mult #(1,8,8) u4(.I_in1(rx_win_in_q),.I_in2(rx_win_in_q),.O_out(real_mult_out_q));

wire [16:0] W_add_out = {1'b0,real_mult_out_i}+ {1'b0,real_mult_out_q}; //17S14

wire [8:0] W_add_rs_out; //9S7
round_sat #(17,14,9,7) u5(.I_in(W_add_out),.O_out(W_add_rs_out));

reg [8:0] R_cmult_buff_i[0:15]; //9S7
reg [8:0] R_cmult_buff_q[0:15]; //9S7
reg [8:0] R_add_buff[0:15]; //9S7
genvar j;
generate
	for(j=0;j<16;j=j+1) begin : for_loop1
		always @(posedge I_clk) begin
			if(I_clk_en & W_search_start) begin
				R_cmult_buff_i[j] <= 'd0; 
				R_cmult_buff_q[j] <= 'd0;
				R_add_buff[j] <= 'd0; 
			end
			else if(I_clk_en & R_search_packet_en_d)begin
				if(j==0) begin
					R_cmult_buff_i[j] <= W_cmult_out_rs_i; 
					R_cmult_buff_q[j] <= W_cmult_out_rs_q;
					R_add_buff[j] <= W_add_rs_out; 
				end
				else begin                                      
					R_cmult_buff_i[j] <= R_cmult_buff_i[j-1]; 
					R_cmult_buff_q[j] <= R_cmult_buff_q[j-1];
					R_add_buff[j] <= R_add_buff[j-1]; 
				end
			end
		end
	end
endgenerate

//16个9S7的数据相加，结果要用13S7表示(13=9+log2(16))
wire [12:0] W_Pd_i = {{4{R_cmult_buff_i[0][8]}},R_cmult_buff_i[0]} + 
					 {{4{R_cmult_buff_i[1][8]}},R_cmult_buff_i[1]} + 
					 {{4{R_cmult_buff_i[2][8]}},R_cmult_buff_i[2]} + 
					 {{4{R_cmult_buff_i[3][8]}},R_cmult_buff_i[3]} + 
					 {{4{R_cmult_buff_i[4][8]}},R_cmult_buff_i[4]} + 
					 {{4{R_cmult_buff_i[5][8]}},R_cmult_buff_i[5]} + 					
					 {{4{R_cmult_buff_i[6][8]}},R_cmult_buff_i[6]} + 					
					 {{4{R_cmult_buff_i[7][8]}},R_cmult_buff_i[7]} + 	
					 {{4{R_cmult_buff_i[8][8]}},R_cmult_buff_i[8]} + 
					 {{4{R_cmult_buff_i[9][8]}},R_cmult_buff_i[9]} + 
					 {{4{R_cmult_buff_i[10][8]}},R_cmult_buff_i[10]} + 	
					 {{4{R_cmult_buff_i[11][8]}},R_cmult_buff_i[11]} + 
					 {{4{R_cmult_buff_i[12][8]}},R_cmult_buff_i[12]} + 
					 {{4{R_cmult_buff_i[13][8]}},R_cmult_buff_i[13]} + 	
					 {{4{R_cmult_buff_i[14][8]}},R_cmult_buff_i[14]} + 
					 {{4{R_cmult_buff_i[15][8]}},R_cmult_buff_i[15]}; //13S7
					 
wire [12:0] W_Pd_q = {{4{R_cmult_buff_q[0][8]}},R_cmult_buff_q[0]} + 
					 {{4{R_cmult_buff_q[1][8]}},R_cmult_buff_q[1]} + 
					 {{4{R_cmult_buff_q[2][8]}},R_cmult_buff_q[2]} + 
					 {{4{R_cmult_buff_q[3][8]}},R_cmult_buff_q[3]} + 
					 {{4{R_cmult_buff_q[4][8]}},R_cmult_buff_q[4]} + 
					 {{4{R_cmult_buff_q[5][8]}},R_cmult_buff_q[5]} + 					
					 {{4{R_cmult_buff_q[6][8]}},R_cmult_buff_q[6]} + 					
					 {{4{R_cmult_buff_q[7][8]}},R_cmult_buff_q[7]} + 	
					 {{4{R_cmult_buff_q[8][8]}},R_cmult_buff_q[8]} + 
					 {{4{R_cmult_buff_q[9][8]}},R_cmult_buff_q[9]} + 
					 {{4{R_cmult_buff_q[10][8]}},R_cmult_buff_q[10]} + 	
					 {{4{R_cmult_buff_q[11][8]}},R_cmult_buff_q[11]} + 
					 {{4{R_cmult_buff_q[12][8]}},R_cmult_buff_q[12]} + 
					 {{4{R_cmult_buff_q[13][8]}},R_cmult_buff_q[13]} + 	
					 {{4{R_cmult_buff_q[14][8]}},R_cmult_buff_q[14]} + 
					 {{4{R_cmult_buff_q[15][8]}},R_cmult_buff_q[15]}; //13S7

wire [12:0] W_Rd   = {{4{R_add_buff[0][8]}},R_add_buff[0]} + 
					 {{4{R_add_buff[1][8]}},R_add_buff[1]} + 
					 {{4{R_add_buff[2][8]}},R_add_buff[2]} + 
					 {{4{R_add_buff[3][8]}},R_add_buff[3]} + 
					 {{4{R_add_buff[4][8]}},R_add_buff[4]} + 
					 {{4{R_add_buff[5][8]}},R_add_buff[5]} + 					
					 {{4{R_add_buff[6][8]}},R_add_buff[6]} + 					
					 {{4{R_add_buff[7][8]}},R_add_buff[7]} + 	
					 {{4{R_add_buff[8][8]}},R_add_buff[8]} + 
					 {{4{R_add_buff[9][8]}},R_add_buff[9]} + 
					 {{4{R_add_buff[10][8]}},R_add_buff[10]} + 	
					 {{4{R_add_buff[11][8]}},R_add_buff[11]} + 
					 {{4{R_add_buff[12][8]}},R_add_buff[12]} + 
					 {{4{R_add_buff[13][8]}},R_add_buff[13]} + 	
					 {{4{R_add_buff[14][8]}},R_add_buff[14]} + 
					 {{4{R_add_buff[15][8]}},R_add_buff[15]}; //13S7		   

// 下面6行用来计算复数W_Pd的模
wire [12:0] W_abs_Pd_i = W_Pd_i[12] ? -W_Pd_i : W_Pd_i;
wire [12:0] W_abs_Pd_q = W_Pd_q[12] ? -W_Pd_q : W_Pd_q;
wire [12:0] W_abs_Pd_max = (W_abs_Pd_i > W_abs_Pd_q) ? W_abs_Pd_i : W_abs_Pd_q;
wire [12:0] W_abs_Pd_min = (W_abs_Pd_i > W_abs_Pd_q) ? W_abs_Pd_q : W_abs_Pd_i;
wire [12:0] W_abs_Pd = W_abs_Pd_max - (W_abs_Pd_max >> 4)
					+(W_abs_Pd_min>>1) - (W_abs_Pd_min>>5);

//分段计算Rd 与 threshold的乘积
reg [12:0] W_Rd_x_threshold; //13S7
always @(*) begin
	case(CSR_Md_threshold)
		//threshold = 0.5625(=1/2+1/16)
		3'd0: begin W_Rd_x_threshold <= (W_Rd>>1)+(W_Rd>>4); end
		//threshold = 0.625(=1/2+1/8)
		3'd1: begin W_Rd_x_threshold <= (W_Rd>>1)+(W_Rd>>3); end
		//threshold = 0.6875(=1/2+1/8+1/16)
		3'd2: begin W_Rd_x_threshold <= (W_Rd>>1)+(W_Rd>>3)+(W_Rd>>4); end
		//threshold = 0.75(=1/2+1/4)
		3'd3: begin W_Rd_x_threshold <= (W_Rd>>1)+(W_Rd>>2); end
		//threshold = 0.8125(=1/2+1/4+1/16)
		3'd4: begin W_Rd_x_threshold <= (W_Rd>>1)+(W_Rd>>2)+(W_Rd>>4); end
		//threshold = 0.875(=1/2+1/4+1/16)
		3'd5: begin W_Rd_x_threshold <= (W_Rd>>1)+(W_Rd>>2)+(W_Rd>>3); end
		//threshold = 0.9375(=1/2+1/4+1/8+1/16)
		default: begin W_Rd_x_threshold <= (W_Rd>>1)+(W_Rd>>2)+(W_Rd>>3)+(W_Rd>>4); end
	endcase
end

reg R_compare;
always @(posedge I_clk) begin
	if(I_clk_en & W_search_start) 
		R_compare <= 1'd0;
	else if(I_clk_en & O_packet_detected_done) 
		R_compare <= 1'd0;
	else if(I_clk_en & I_search_packet_en)begin
		if(W_abs_Pd > W_Rd_x_threshold)
			R_compare <= 1'd1;
		else
			R_compare <= 1'd0;
	end
end

reg [8:0] R_compare_cnt;
always @(posedge I_clk) begin
	if(I_clk_en & W_search_start) 
		R_compare_cnt <= 9'd0;
	else if(I_clk_en)begin
		if(R_compare)
			R_compare_cnt <= R_compare_cnt + 1'b1;
		else
			R_compare_cnt <= 9'd0;
	end
end

assign O_packet_detected_done = (R_search_packet_en_d && (R_compare_cnt == CSR_Md_cnt_threshold)) ? 1'b1 : 1'b0;

endmodule