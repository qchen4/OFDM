////////////////////////////////////////////////
// 功能：Radix-2 DIF FFT算法蝶形运算单元Verilog代码
// 作者：柳井刚（B站/微信公众号：柳同学聊芯片）
// 描述：《OFDM无线通信芯片设计实战》随书代码
// 使用说明：
// 1.对于最后两个stage，不需要使用复数乘法器
// 2.如果不是最后两个stage，那么每经过两个stage，输出比输入增加3bit，
//   在这两个stage中，对于第一个stage，输出比输入增加2bit
//   对于第二个stage，输出比输入增加1bit
// 3.当输出位宽增加到最终的输出位宽以后，输出位宽保持不变
////////////////////////////////////////////////
module butterfly_r2_dif #(
	parameter C_IN_W1  			= 8, // 输入数据总位宽
	parameter C_IN_W2  			= 7, // 输入数据小数位宽
	parameter C_OUT_W1  		= 10, // 输出数据总位宽
	parameter C_OUT_W2  		= 7, // 输出数据小数位宽
	parameter C_ROT_W1  		= 9, // 旋转因子总位宽
	parameter C_ROT_W2  		= 7, // 旋转因子小数位宽
	parameter C_BF_IDX  		= 0 , // 蝶形单元的级数
	parameter C_TOTAL_BF_NUM  	= 3   // FFT算法蝶形单元总个数
)(
	input								I_clk,
	input								I_clk_en, 
	input								I_rst_n,
	
	input								I_bf_in_valid, 
	input		[C_IN_W1 -1: 0]			I_bf_in_i,  // 8S7
	input		[C_IN_W1 -1: 0]			I_bf_in_q,  // 8S7
	
	output	reg     					O_bf_out_valid,
	output		    					O_bf_start,
	output	reg [C_TOTAL_BF_NUM -1: 0]	O_bf_out_idx,
	output	reg	[C_OUT_W1 -1: 0]		O_bf_out_i, // 10S7
	output	reg	[C_OUT_W1 -1: 0]		O_bf_out_q, // 10S7
	
	input		[C_ROT_W1 -1: 0]		I_wn_i,  // 旋转因子, 9S7
	input		[C_ROT_W1 -1: 0]		I_wn_q,  // 旋转因子, 9S7
	output	 	[C_TOTAL_BF_NUM -1: 0]	O_wn_addr  //旋转因子地址	
);

//FFT点数 , 它等于 2^(C_TOTAL_BF_NUM)
localparam C_FFT_NUM = 2**(C_TOTAL_BF_NUM) ;

// 蝶形运算单元中延时DFF的个数
localparam C_MEM_NUM = 2**(C_TOTAL_BF_NUM - C_BF_IDX - 1) ;
 
reg R_bf_in_valid_dly;
reg [C_IN_W1 -1:0] R_bf_in_i_dly;
reg [C_IN_W1 -1:0] R_bf_in_q_dly;
always @(posedge I_clk or negedge I_rst_n) begin
	if(!I_rst_n) begin
		R_bf_in_valid_dly <= 'd0;
		R_bf_in_i_dly <= 'd0;
		R_bf_in_q_dly <= 'd0;
	end
	else if(I_clk_en)begin
		R_bf_in_valid_dly <= I_bf_in_valid;
		R_bf_in_i_dly <= I_bf_in_i;
		R_bf_in_q_dly <= I_bf_in_q;
	end
end

wire W_bf_start = ~R_bf_in_valid_dly & I_bf_in_valid;
assign O_bf_start = W_bf_start;

reg [C_TOTAL_BF_NUM - 1:0] 	R_mux_sel_cnt;
always @(posedge I_clk or negedge I_rst_n) begin
	if(!I_rst_n) begin
		R_mux_sel_cnt <= 'd0;
	end
	else if(W_bf_start) begin
		R_mux_sel_cnt <= 'd0;
	end
	else if(I_clk_en)begin
		if(R_mux_sel_cnt == (C_FFT_NUM -1))
			R_mux_sel_cnt <= 'd0;
		else if(R_bf_in_valid_dly)
			R_mux_sel_cnt <= R_mux_sel_cnt + 1'd1;
	end
end

wire W_mux_sel = R_mux_sel_cnt[C_TOTAL_BF_NUM - C_BF_IDX - 1];

wire	[C_IN_W1:0]	W_xn_i = {R_bf_in_i_dly[C_IN_W1 -1],R_bf_in_i_dly}; //9S7
wire	[C_IN_W1:0]	W_xn_q = {R_bf_in_q_dly[C_IN_W1 -1],R_bf_in_q_dly}; //9S7

wire	[C_IN_W1:0]	W_mux1_in1_i,W_mux1_in1_q; //9S7
wire	[C_IN_W1:0]	W_mux1_in2_i,W_mux1_in2_q; //9S7
wire	[C_IN_W1:0]	W_mux1_out_i,W_mux1_out_q; //9S7
									
wire	[C_IN_W1:0]	W_mux2_in1_i,W_mux2_in1_q; //9S7
wire	[C_IN_W1:0]	W_mux2_in2_i,W_mux2_in2_q; //9S7
wire	[C_IN_W1:0]	W_mux2_out_i,W_mux2_out_q; //9S7
			 
wire	[C_IN_W1:0]	W_mux1_out_d_i,W_mux1_out_d_q; //9S7

assign W_mux1_in1_i = W_mux1_out_d_i - W_xn_i;
assign W_mux1_in2_i = W_xn_i ;
assign W_mux1_out_i = W_mux_sel ? W_mux1_in1_i : W_mux1_in2_i ;

assign W_mux1_in1_q = W_mux1_out_d_q - W_xn_q;
assign W_mux1_in2_q = W_xn_q ;
assign W_mux1_out_q = W_mux_sel ? W_mux1_in1_q : W_mux1_in2_q ;

assign W_mux2_in1_i = W_mux1_out_d_i;
assign W_mux2_in2_i = W_mux1_out_d_i + W_xn_i;
assign W_mux2_out_i = W_mux_sel ? W_mux2_in2_i : W_mux2_in1_i ;

assign W_mux2_in1_q = W_mux1_out_d_q;
assign W_mux2_in2_q = W_mux1_out_d_q + W_xn_q;
assign W_mux2_out_q = W_mux_sel ? W_mux2_in2_q : W_mux2_in1_q ;


reg [C_IN_W1:0] R_men_i_reg; //9S7
reg [C_IN_W1:0] R_men_q_reg; //9S7

reg [C_IN_W1:0] R_men_i[0:(C_MEM_NUM-1)]; //9S7
reg [C_IN_W1:0] R_men_q[0:(C_MEM_NUM-1)]; //9S7
generate
	if(C_BF_IDX==C_TOTAL_BF_NUM - 1) begin : at_last_stage
		always @(posedge I_clk or negedge I_rst_n) begin
			if(!I_rst_n) begin
				R_men_i_reg <= 'd0; R_men_q_reg <= 'd0;
			end
			else if(W_bf_start) begin
                R_men_i_reg <= 'd0; R_men_q_reg <= 'd0;
            end
			else if(I_clk_en)begin
				R_men_i_reg <= W_mux1_out_i;
				R_men_q_reg <= W_mux1_out_q	;
			end
		end
		assign W_mux1_out_d_i = R_men_i_reg ;
		assign W_mux1_out_d_q = R_men_q_reg ;
	end
	else begin : other_stage
		genvar i;
		for(i=0;i<C_MEM_NUM;i=i+1) begin : mem_for_loop
			always @(posedge I_clk or negedge I_rst_n) begin
				if(!I_rst_n) begin
					R_men_i[i] <= 'd0; R_men_q[i] <= 'd0;
				end
				else if(W_bf_start) begin
                    R_men_i[i] <= 'd0; R_men_q[i] <= 'd0;
                end
				else if(I_clk_en)begin
					if(i==0) begin
						R_men_i[0] <= W_mux1_out_i; 
						R_men_q[0] <= W_mux1_out_q;
					end
					else begin                                      
						R_men_i[i] <= R_men_i[i-1];
						R_men_q[i] <= R_men_q[i-1];
					end
				end
			end
		end
		assign W_mux1_out_d_i = R_men_i[C_MEM_NUM-1] ;
		assign W_mux1_out_d_q = R_men_q[C_MEM_NUM-1] ;
	end
endgenerate

wire [(C_IN_W1+C_ROT_W1+1):0] W_mult_out_i,W_mult_out_q; //19S14 = 9S7 * 9S7
wire [C_IN_W1:0] W_last_mult_out_i,W_last_mult_out_q; 
wire [C_OUT_W1-1:0] W_mult_out_rs_i,W_mult_out_rs_q; //9S7
generate
	if(C_BF_IDX == C_TOTAL_BF_NUM - 1) begin : last_stage
		assign W_last_mult_out_i = W_mux2_out_i;
		assign W_last_mult_out_q = W_mux2_out_q;
		round_sat #((C_IN_W1 + 1),C_IN_W2,C_OUT_W1,C_OUT_W2) 
					u1_round_sat(.I_in(W_last_mult_out_i),.O_out(W_mult_out_rs_i));
		round_sat #((C_IN_W1 + 1),C_IN_W2,C_OUT_W1,C_OUT_W2) 
					u2_round_sat(.I_in(W_last_mult_out_q),.O_out(W_mult_out_rs_q));			
	end
	else if(C_BF_IDX == C_TOTAL_BF_NUM - 2) begin : penultimate_stage  
		//(a+bj)*(-j) = b + (-a)*j
		assign W_last_mult_out_i =  (O_wn_addr == 1) ?  W_mux2_out_q : W_mux2_out_i;
		assign W_last_mult_out_q =  (O_wn_addr == 1) ? -W_mux2_out_i : W_mux2_out_q;
		round_sat #((C_IN_W1 + 1),C_IN_W2,C_OUT_W1,C_OUT_W2) 
					u1_round_sat(.I_in(W_last_mult_out_i),.O_out(W_mult_out_rs_i));
		round_sat #((C_IN_W1 + 1),C_IN_W2,C_OUT_W1,C_OUT_W2) 
					u2_round_sat(.I_in(W_last_mult_out_q),.O_out(W_mult_out_rs_q));	
	end
	else begin : others	
		complex_mult #(1,(C_IN_W1+1),C_ROT_W1) u_complex_mult(
			.I_in1_i(W_mux2_out_i), // 9S7
			.I_in1_q(W_mux2_out_q), // 9S7
			.I_in2_i(I_wn_i), //9S7
			.I_in2_q(I_wn_q), //9S7	
			.O_out_i(W_mult_out_i),	//19S14
			.O_out_q(W_mult_out_q)); //19S14
		round_sat #((C_IN_W1 + C_ROT_W1 + 2),(C_IN_W2 + C_ROT_W2),C_OUT_W1,C_OUT_W2) 
					u1_round_sat(.I_in(W_mult_out_i),.O_out(W_mult_out_rs_i));
		round_sat #((C_IN_W1 + C_ROT_W1 + 2),(C_IN_W2 + C_ROT_W2),C_OUT_W1,C_OUT_W2) 
					u2_round_sat(.I_in(W_mult_out_q),.O_out(W_mult_out_rs_q));
	end
endgenerate

reg [C_TOTAL_BF_NUM - 1:0] R_bf_out_cnt;
reg R_bf_out_cnt_en;
always @(posedge I_clk or negedge I_rst_n) begin
	if(!I_rst_n) 
		R_bf_out_cnt <= 'd0; 
	else if(W_bf_start) 
        R_bf_out_cnt <= 'd0; 
	else if(I_clk_en)begin
		if(R_bf_out_cnt == (C_FFT_NUM - 1))
			R_bf_out_cnt <= 'd0; 
		else if(R_bf_out_cnt_en)
			R_bf_out_cnt <= R_bf_out_cnt + 1'b1;
	end
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(!I_rst_n) 
		R_bf_out_cnt_en <= 1'b0; 
	else if(W_bf_start)
		R_bf_out_cnt_en <= 1'b0;
	else if(I_clk_en)begin
		if(R_bf_out_cnt == (C_FFT_NUM - 1))
			R_bf_out_cnt_en <= 1'b0;
		else if(R_bf_in_valid_dly & (R_mux_sel_cnt == (C_MEM_NUM-1)))
			R_bf_out_cnt_en <= 1'b1;
	end
end

wire W_wn_addr_cnt_en = R_bf_out_cnt[C_TOTAL_BF_NUM - C_BF_IDX - 1];

reg	[C_TOTAL_BF_NUM - 1: 0]	R_wn_addr_cnt; 
always @(posedge I_clk or negedge I_rst_n) begin
	if(!I_rst_n) 
		R_wn_addr_cnt <= 'd0;
	else if(W_bf_start) 
		R_wn_addr_cnt <= 'd0;
	else if(I_clk_en)begin
		if(W_wn_addr_cnt_en)
			R_wn_addr_cnt <= R_wn_addr_cnt + 1'b1;
		else
			R_wn_addr_cnt <= 'd0;
	end
end
assign O_wn_addr = W_wn_addr_cnt_en ? R_wn_addr_cnt : 'd0;

always @(posedge I_clk or negedge I_rst_n) begin
	if(!I_rst_n) begin
		O_bf_out_i <= 'd0 ; 
		O_bf_out_q <= 'd0 ;
		O_bf_out_valid <= 'd0;
		O_bf_out_idx <= 'd0;
	end
	else if(W_bf_start) begin
        O_bf_out_i <= 'd0 ; 
		O_bf_out_q <= 'd0 ;
		O_bf_out_valid <= 'd0;
		O_bf_out_idx <= 'd0;
    end
	else if(I_clk_en)begin
		O_bf_out_i <= W_mult_out_rs_i ; 
		O_bf_out_q <= W_mult_out_rs_q ;
		O_bf_out_valid <= R_bf_out_cnt_en;
		O_bf_out_idx <= R_bf_out_cnt;
	end
end

endmodule
