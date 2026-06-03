//////////////////////////////////////////////////////////////
// 功能: 移除循环前缀(remove CP)
// 作者: 柳井刚
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计》随书代码，所有代码均由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
//////////////////////////////////////////////////////////////
module rx_remove_cp(
	input			I_clk, 
	input			I_clk_en,
	input			I_rst_n, 
	
	input	[10:0]  I_decode_data_ofdm_num, 
	input			I_decode_data_ofdm_num_valid, 
	
	input			I_rx_remove_cp_start,
	input	[7 : 0]	I_rx_remove_cp_in_i,  // 8S7
	input	[7 : 0]	I_rx_remove_cp_in_q,  // 8S7
	
	output  reg [7: 0] O_rx_remove_cp_out_i, 
	output  reg [7: 0] O_rx_remove_cp_out_q, 
	output	reg O_rx_remove_cp_out_valid,
	output	reg [10:0] O_rx_ofdm_symbol_idx
);

reg R_ofdm_symbol_en;
wire W_ofdm_symbol_en_neg = ~R_ofdm_symbol_en & O_rx_remove_cp_out_valid;

reg R_rx_remove_cp_en;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_rx_remove_cp_en <= 1'd0;
	else if(I_clk_en & I_rx_remove_cp_start)
		R_rx_remove_cp_en <= 1'd1;
	else if(I_rx_remove_cp_start)
		R_rx_remove_cp_en <= 1'd0;
	else if(I_decode_data_ofdm_num_valid & W_ofdm_symbol_en_neg)begin
	    //加3是因为：2个LTS，1个Signal OFDM
		if(O_rx_ofdm_symbol_idx == (I_decode_data_ofdm_num + 3)) begin
			R_rx_remove_cp_en <= 1'd0;
		end
	end
end

reg [7:0] R_buff_i[0:15]; //8S7
reg [7:0] R_buff_q[0:15]; //8S7
genvar i;
generate
	for(i=0;i<16;i=i+1) begin : data_buff_for_loop
		always @(posedge I_clk or negedge I_rst_n) begin
			if(!I_rst_n) begin
				R_buff_i[i] <= 'd0; 
				R_buff_q[i] <= 'd0;
			end
			else if(I_clk_en & I_rx_remove_cp_start) begin
				R_buff_i[i] <= 'd0; 
				R_buff_q[i] <= 'd0;
			end
			else if(I_clk_en & R_rx_remove_cp_en)begin
				if(i==0) begin
					R_buff_i[0] <= I_rx_remove_cp_in_i; 
					R_buff_q[0] <= I_rx_remove_cp_in_q;
				end
				else begin                                      
					R_buff_i[i] <= R_buff_i[i-1];
					R_buff_q[i] <= R_buff_q[i-1];
				end
			end
		end
	end
endgenerate

reg [6:0] R_data_in_cnt;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_data_in_cnt <= 7'd0;
	else if(I_clk_en & I_rx_remove_cp_start) 
		R_data_in_cnt <= 7'd0;
	else if(I_clk_en)begin
		if(R_data_in_cnt == 7'd79)
			R_data_in_cnt <= 7'd0;
		else if(R_rx_remove_cp_en)
			R_data_in_cnt <= R_data_in_cnt + 1'd1;
	end
end

always @(*) begin
	if(R_rx_remove_cp_en) begin
		if((R_data_in_cnt>=7'd16)&&(R_data_in_cnt<=7'd79)) 
			R_ofdm_symbol_en <= 1'b1;
		else 
			R_ofdm_symbol_en <= 1'b0;
	end
	else begin
		R_ofdm_symbol_en <= 1'b0;
	end
end

wire W_ofdm_idx_add_en = (R_data_in_cnt == 7'd15)?1'b1:1'b0;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n)
		O_rx_ofdm_symbol_idx <= 32'd0;
	else if(I_clk_en & I_rx_remove_cp_start) 
		O_rx_ofdm_symbol_idx <= 32'd0;
	else if(I_clk_en)begin
		if(R_rx_remove_cp_en & W_ofdm_idx_add_en)begin
			O_rx_ofdm_symbol_idx <= O_rx_ofdm_symbol_idx + 1'd1;
		end
	end
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		O_rx_remove_cp_out_i <= 8'd0;
		O_rx_remove_cp_out_q <= 8'd0;
	end
	else if(I_clk_en & I_rx_remove_cp_start) begin
		O_rx_remove_cp_out_i <= 8'd0;
		O_rx_remove_cp_out_q <= 8'd0;
	end
	else if(I_clk_en)begin
		if(R_ofdm_symbol_en)begin
			if(O_rx_ofdm_symbol_idx == 32'd1) begin
				O_rx_remove_cp_out_i <= I_rx_remove_cp_in_i;
				O_rx_remove_cp_out_q <= I_rx_remove_cp_in_q;
			end
			else begin
				O_rx_remove_cp_out_i <= R_buff_i[15];
				O_rx_remove_cp_out_q <= R_buff_q[15];
			end
		end
	end
end

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		O_rx_remove_cp_out_valid <= 1'd0;
	else if(I_clk_en)
		O_rx_remove_cp_out_valid <= R_ofdm_symbol_en;
end

endmodule