//////////////////////////////////////////////////////////////
// 功能: 粗频偏估计与补偿Verilog代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
//////////////////////////////////////////////////////////////
module rx_coarse_foc(
	input			I_clk,
	input			I_clk_en,
	input			I_rst_n,	
	input			I_coarse_foc_en,
	input	[7 : 0]	I_rx_coarse_foc_in_i,// 8S7
	input	[7 : 0]	I_rx_coarse_foc_in_q,// 8S7
	
	output	[21:0]	O_coarse_estimate_freq,
	output			O_rx_coarse_foc_out_start,
	output  reg [8:0] O_rx_coarse_foc_out_i, //9S7
	output  reg [8:0] O_rx_coarse_foc_out_q  //9S7	
);

parameter C_PI = 16'd25736; //16S13

reg R_coarse_foc_en_d;
always @(posedge I_clk) begin
	if(I_clk_en) begin
		R_coarse_foc_en_d <= I_coarse_foc_en;
	end
end
wire W_coarse_foc_start = ~R_coarse_foc_en_d & I_coarse_foc_en;

reg [7:0] R_rx_coarse_foc_in_i_d;
reg [7:0] R_rx_coarse_foc_in_q_d;
always @(posedge I_clk) begin
	if(I_clk_en & I_coarse_foc_en)begin
		R_rx_coarse_foc_in_i_d <= I_rx_coarse_foc_in_i;
		R_rx_coarse_foc_in_q_d <= I_rx_coarse_foc_in_q;
	end
end

reg R_data_in_cnt_en;
reg [4:0] R_data_in_cnt;
always @(posedge I_clk) begin
	if(I_clk_en)begin
		if(W_coarse_foc_start)
			R_data_in_cnt_en <= 1'd1;
		else if(R_data_in_cnt == 5'd31)
			R_data_in_cnt_en <= 1'd0;
	end
end

always @(posedge I_clk) begin
	if(W_coarse_foc_start)
		R_data_in_cnt <= 5'd0;
	else if(I_clk_en)begin
		if(R_data_in_cnt == 5'd31)
			R_data_in_cnt <= 5'd0;
		else if(R_data_in_cnt_en)
			R_data_in_cnt <= R_data_in_cnt + 1'd1;
	end
end

reg [7:0] R_data_buff_i[0:32]; //8S7
reg [7:0] R_data_buff_q[0:32]; //8S7
genvar i;
generate
	for(i=0;i<33;i=i+1) begin : data_buff_for_loop
		always @(posedge I_clk) begin
			if(W_coarse_foc_start) begin
				R_data_buff_i[i] <= 'd0; 
				R_data_buff_q[i] <= 'd0;
			end
			else if(I_clk_en & R_coarse_foc_en_d)begin
				if(i==0) begin
					R_data_buff_i[0] <= R_rx_coarse_foc_in_i_d; 
					R_data_buff_q[0] <= R_rx_coarse_foc_in_q_d;
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
wire [7:0] rx_win_in_i = R_rx_coarse_foc_in_i_d;
wire [7:0] rx_win_in_q = R_rx_coarse_foc_in_q_d;

// 计算输入信号的相关值
wire [16:0] W_cmult_out_i;
wire [16:0] W_cmult_out_q;
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

wire W_corr_en = R_data_in_cnt_en & R_data_in_cnt[4];

//16个9S7格式的数据相加结果为13S7
reg [12:0] R_Pk_i; //13S7
reg [12:0] R_Pk_q; //13S7
always @(posedge I_clk) begin
	if(W_coarse_foc_start) begin
		R_Pk_i <= 'd0;
		R_Pk_q <= 'd0;
	end
	else if(I_clk_en & W_corr_en)begin
		R_Pk_i <= R_Pk_i + {{4{W_cmult_out_rs_i[8]}},W_cmult_out_rs_i};
		R_Pk_q <= R_Pk_q + {{4{W_cmult_out_rs_q[8]}},W_cmult_out_rs_q};
	end
end

//必须将R_Pk_i/q的值限制在-1~1的范围内，CORDIC才不会溢出
wire [12:0] W_abs_Pk_i = R_Pk_i[12] ? -R_Pk_i : R_Pk_i;
wire [12:0] W_abs_Pk_q = R_Pk_q[12] ? -R_Pk_q : R_Pk_q;

wire [12:0] W_abs_Pk_max = (W_abs_Pk_i > W_abs_Pk_q) ? W_abs_Pk_i : W_abs_Pk_q;

reg [18:0] R_Pk_i_19S13;
reg [18:0] R_Pk_q_19S13;
always @(*) begin
	if((W_abs_Pk_max > {6'd0,7'd0}) && (W_abs_Pk_max <= {6'd1,7'd0})) begin
		R_Pk_i_19S13 <= {R_Pk_i,6'd0};
		R_Pk_q_19S13 <= {R_Pk_q,6'd0};
	end
	else if((W_abs_Pk_max > {6'd1,7'd0}) && (W_abs_Pk_max <= {6'd2,7'd0})) begin
	   R_Pk_i_19S13 <= {R_Pk_i[12],R_Pk_i,5'd0};
	   R_Pk_q_19S13 <= {R_Pk_q[12],R_Pk_q,5'd0};
	end
	else if((W_abs_Pk_max > {6'd2,7'd0}) && (W_abs_Pk_max <= {6'd4,7'd0})) begin
	   R_Pk_i_19S13 <= {{2{R_Pk_i[12]}},R_Pk_i,4'd0};
	   R_Pk_q_19S13 <= {{2{R_Pk_q[12]}},R_Pk_q,4'd0};
	end
	else if((W_abs_Pk_max > {6'd4,7'd0}) && (W_abs_Pk_max <= {6'd8,7'd0})) begin
	   R_Pk_i_19S13 <= {{3{R_Pk_i[12]}},R_Pk_i,3'd0};
	   R_Pk_q_19S13 <= {{3{R_Pk_q[12]}},R_Pk_q,3'd0};
	end
	else if((W_abs_Pk_max > {6'd8,7'd0}) && (W_abs_Pk_max <= {6'd16,7'd0})) begin
	   R_Pk_i_19S13 <= {{4{R_Pk_i[12]}},R_Pk_i,2'd0};
	   R_Pk_q_19S13 <= {{4{R_Pk_q[12]}},R_Pk_q,2'd0};
	end
	else if((W_abs_Pk_max > {6'd16,7'd0}) && (W_abs_Pk_max <= {6'd32,7'd0})) begin
	   R_Pk_i_19S13 <= {{5{R_Pk_i[12]}},R_Pk_i,1'd0};
	   R_Pk_q_19S13 <= {{5{R_Pk_q[12]}},R_Pk_q,1'd0};
	end
	else begin //根据实测的数据，短训练序列Pk的绝对值不可能超过8
		R_Pk_i_19S13 <= {R_Pk_i,6'd0};
		R_Pk_q_19S13 <= {R_Pk_q,6'd0};
	end
end

//13S7 -> 19S13
//wire [18:0] W_Pk_i_19S13 = {R_Pk_i,6'd0};
//wire [18:0] W_Pk_q_19S13 = {R_Pk_q,6'd0};
wire [15:0] W_Pk_i_16S13;
wire [15:0] W_Pk_q_16S13;
round_sat #(19,13,16,13) u3(.I_in(R_Pk_i_19S13),.O_out(W_Pk_i_16S13));
round_sat #(19,13,16,13) u4(.I_in(R_Pk_q_19S13),.O_out(W_Pk_q_16S13));
wire [15:0] W_Pk_phi;
cordic_full_quadrant_arctan #(
	.C_DATA_WIDTH(16),
	.C_ANGLE_WIDTH(16),
	.C_ITER_NUM(11)
)u5(
	.I_x(W_Pk_i_16S13), //16S13
	.I_y(W_Pk_q_16S13),	
	.O_theta(W_Pk_phi) // 16S13
);

reg [15:0] R_Pk_phi; //16S13
always @(posedge I_clk) begin
	if(W_coarse_foc_start) 
		R_Pk_phi <= 16'd0;
	else if(I_clk_en)
		R_Pk_phi <= W_Pk_phi;
end

wire [18:0] W_scale_factor = 19'd198944; //=Fs/(2*pi*16) 19S0
wire [34:0] W_estimate_freq; // 35S13
real_mult #(1,19,16) u6(.I_in1(W_scale_factor),.I_in2(R_Pk_phi),.O_out(W_estimate_freq));
round_sat #(35,13,22,0) u7(.I_in(W_estimate_freq),.O_out(O_coarse_estimate_freq));

// 将R_Pk_phi从16S13转化为20S17实现除以16
wire [19:0] W_Pk_phi_div16_20S17 = {{4{R_Pk_phi[15]}},R_Pk_phi};

// 把W_Pk_phi_div16_20S17转化为16S13数据格式
wire [15:0] W_Pk_phi_div16;
round_sat #(20,17,16,13) u8(.I_in(W_Pk_phi_div16_20S17),.O_out(W_Pk_phi_div16));

wire W_data_in_cnt_done = R_data_in_cnt_en && (R_data_in_cnt==5'd31);
reg R_compensate_en;
always @(posedge I_clk) begin
	if(W_coarse_foc_start) 
		R_compensate_en <= 1'd0;
	else if(I_clk_en & W_data_in_cnt_done)
		R_compensate_en <= 1'd1;
end

reg R_compensate_en_d;
always @(posedge I_clk) begin
	if(W_coarse_foc_start) 
		R_compensate_en_d <= 1'd0;
	else if(I_clk_en)
		R_compensate_en_d <= R_compensate_en;
end
wire W_compensate_en_start = ~R_compensate_en_d & R_compensate_en;

// 对Pk_phi进行累加
reg [15:0] R_Pk_phi_acc; //16S13
wire [15:0] W_Pk_phi_acc_new = -W_Pk_phi_div16 + R_Pk_phi_acc;
always @(posedge I_clk) begin
	if(W_compensate_en_start)
		R_Pk_phi_acc <= 16'd0;
	else if(I_clk_en & R_compensate_en)begin
		if((W_Pk_phi_acc_new[15]==1'b0)&&(W_Pk_phi_acc_new >= C_PI))
			R_Pk_phi_acc <= -C_PI + (W_Pk_phi_acc_new - C_PI);
		else if((W_Pk_phi_acc_new[15]==1'b1)&&(W_Pk_phi_acc_new <= -C_PI))
			R_Pk_phi_acc <= C_PI - (-C_PI - W_Pk_phi_acc_new);
		else
			R_Pk_phi_acc <= W_Pk_phi_acc_new;
	end
end

wire [15:0] W_cos_16S13;
wire [15:0] W_sin_16S13;
cordic_full_quadrant_sincos #(
	.C_DATA_WIDTH(16),
	.C_ANGLE_WIDTH(16),
	.C_ITER_NUM(11)
)u9( 
	.I_theta(R_Pk_phi_acc), //16S13	
	.O_sin(W_sin_16S13), //16S13
	.O_cos(W_cos_16S13) //16S13
);

wire [7:0] W_cos_8S6;
wire [7:0] W_sin_8S6;
round_sat #(16,13,8,6) u10(.I_in(W_sin_16S13),.O_out(W_sin_8S6));
round_sat #(16,13,8,6) u11(.I_in(W_cos_16S13),.O_out(W_cos_8S6));

//这里因为W_sin_8S6和W_cos_8S6经过了很长的组合逻辑路径，
//为了保险起见，在这里加上Pipeline避免Critical Path
reg [7:0] R_cos_8S6_d;
reg [7:0] R_sin_8S6_d;
reg [7:0] R_foc_in_i_d;
reg [7:0] R_foc_in_q_d;
always @(posedge I_clk) begin
	if(I_clk_en & W_compensate_en_start) begin
		R_cos_8S6_d <= 8'd0;
		R_sin_8S6_d <= 8'd0;
		R_foc_in_i_d <= 8'd0;
		R_foc_in_q_d <= 8'd0;
	end
	else if(I_clk_en & R_compensate_en)begin
		R_cos_8S6_d <= W_cos_8S6;
		R_sin_8S6_d <= W_sin_8S6;
		R_foc_in_i_d <= R_data_buff_i[32];
		R_foc_in_q_d <= R_data_buff_q[32];
	end
end

// 执行频偏补偿
wire [16:0] W_comp_out_i; //17S13
wire [16:0] W_comp_out_q; //17S13
complex_mult #(1,8,8) u12(
	.I_in1_i(R_cos_8S6_d),
	.I_in1_q(R_sin_8S6_d), 
	.I_in2_i(R_foc_in_i_d),
	.I_in2_q(R_foc_in_q_d),	
	.O_out_i(W_comp_out_i),	
	.O_out_q(W_comp_out_q));
	
wire [8:0] W_comp_out_rs_i; //9S7
wire [8:0] W_comp_out_rs_q;	//9S7
round_sat #(17,13,9,7) u13(.I_in(W_comp_out_i),.O_out(W_comp_out_rs_i));
round_sat #(17,13,9,7) u14(.I_in(W_comp_out_q),.O_out(W_comp_out_rs_q));

always @(posedge I_clk) begin
	if(W_compensate_en_start) begin
		O_rx_coarse_foc_out_i <=  9'd0 ;    
		O_rx_coarse_foc_out_q <=  9'd0 ;
	end
	else if(I_clk_en & R_compensate_en) begin
		O_rx_coarse_foc_out_i <=  W_comp_out_rs_i ;    
		O_rx_coarse_foc_out_q <=  W_comp_out_rs_q ; 
	end
end

reg [1:0] R_compensate_en_start_d;
always @(posedge I_clk) begin   
	if(W_coarse_foc_start) 
		R_compensate_en_start_d <=  2'd0 ; 
	else if(I_clk_en)
		R_compensate_en_start_d <= {R_compensate_en_start_d[0],W_compensate_en_start} ; 
end
assign O_rx_coarse_foc_out_start = R_compensate_en_start_d[1];

endmodule