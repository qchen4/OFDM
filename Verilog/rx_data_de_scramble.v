//////////////////////////////////////////////////////////////
// 功能: DATA域数据解扰码Verilog代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module rx_data_de_scramble(
	input I_clk,
	input I_rst_n,
	input I_clk_en_20M,
	input I_clk_en_40M,
	input I_rx_bits,
	input I_rx_bits_valid,
	input [10:0] I_rx_ofdm_symbol_idx,
	input [11:0] I_decode_bytes_num,
	
	input [10:0] I_decode_data_ofdm_num,
	input  		 I_decode_data_ofdm_num_valid,

	output reg O_de_scramble_out,
	output reg O_de_scramble_out_valid,
	output O_de_scramble_start,
	output O_data_decode_done
);
	wire [14:0] W_payload_bits_num = {I_decode_bytes_num,3'd0};

	reg R_rx_bits_valid_d;
	always @(posedge I_clk or negedge I_rst_n) begin
		if(~I_rst_n)
	       R_rx_bits_valid_d <= 1'b0;      
		else 
           R_rx_bits_valid_d <= I_rx_bits_valid;
	end	
	assign O_de_scramble_start = ~R_rx_bits_valid_d & I_rx_bits_valid & (I_rx_ofdm_symbol_idx == 1);
	
	reg R_service_cnt_en;
	reg [2:0] R_service_cnt;
	always @(posedge I_clk or negedge I_rst_n) begin
		if(~I_rst_n)
	       R_service_cnt_en <= 1'b0;   
		else if(O_de_scramble_start)
           R_service_cnt_en <= 1'b1;
		else if(I_clk_en_40M && (R_service_cnt == 3'd6))
           R_service_cnt_en <= 1'b0;
	end
	
	always @(posedge I_clk or negedge I_rst_n) begin
		if(~I_rst_n)
	       R_service_cnt <= 3'd0;  		
		else if(O_de_scramble_start)
           R_service_cnt <= 3'd0; 
		else if(I_clk_en_40M && R_service_cnt_en)
           R_service_cnt <= R_service_cnt + 1'd1; 
	end
	
	reg [6:0] R_service_buff;
	always @(posedge I_clk or negedge I_rst_n) begin
		if(~I_rst_n)
	       R_service_buff <= 7'd0;  		
		else if(O_de_scramble_start)
           R_service_buff <= 7'd0;  
		else if(I_clk_en_40M && R_service_cnt_en)
           R_service_buff <= {R_service_buff[5:0],I_rx_bits}; 	   
	end
	
	reg R_service_cnt_en_d;
	always @(posedge I_clk or negedge I_rst_n) begin
		if(~I_rst_n)
	       R_service_cnt_en_d <= 1'd0;   
		else if(O_de_scramble_start)
           R_service_cnt_en_d <= 1'd0;  
		else
           R_service_cnt_en_d <= R_service_cnt_en;
	end
	wire W_load_seed = ~R_service_cnt_en & R_service_cnt_en_d;		
	
	reg [6:0] R_buff;
	wire W_sftreg_in = R_buff[6] + R_buff[3];	
	always @(posedge I_clk or negedge I_rst_n) begin
		if(~I_rst_n)
			R_buff <= 7'd0;   		   
		else if(W_load_seed) 
			R_buff <= R_service_buff;
		else if(I_clk_en_40M) begin
			if(I_rx_bits_valid) begin
                R_buff <= {R_buff[5:0], W_sftreg_in};
			end
		end
	end
    
    wire W_data_out = I_rx_bits + W_sftreg_in;
	
	reg R_data_out;
	always @(posedge I_clk or negedge I_rst_n) begin
		if(~I_rst_n)
	       R_data_out <= 1'b0; 
		else if(O_de_scramble_start) 
           R_data_out <= 1'b0;    
		else if(I_clk_en_40M) 
           R_data_out <= W_data_out;
	end
	
	reg R_data_out_valid;
	always @(posedge I_clk or negedge I_rst_n) begin
		if(~I_rst_n)
	       R_data_out_valid <= 1'b0; 
		else if(O_de_scramble_start) 
           R_data_out_valid <= 1'b0;    
		else if(R_service_cnt_en) 
           R_data_out_valid <= 1'b0; 
		else if(I_clk_en_40M) 
           R_data_out_valid <= I_rx_bits_valid; 
	end
		
	reg [14:0] R_data_out_cnt;
	always @(posedge I_clk or negedge I_rst_n) begin
		if(~I_rst_n)
	       R_data_out_cnt <= 15'd0; 
		else if(W_load_seed) 
           R_data_out_cnt <= 15'd0;    
		else if(I_clk_en_40M & R_data_out_valid) 
           R_data_out_cnt <= R_data_out_cnt + 1'b1; 
	end
	
	wire W_de_scramble_out_valid = 	R_data_out_valid & 
									(R_data_out_cnt >= 9) & 
									(R_data_out_cnt <= W_payload_bits_num + 8);
	
	wire W_de_scramble_out = W_de_scramble_out_valid ? R_data_out : 1'b0;
							
	always @(posedge I_clk or negedge I_rst_n) begin
		if(~I_rst_n)
	       O_de_scramble_out <= 1'b0; 
		else if(O_de_scramble_start) 
           O_de_scramble_out <= 1'b0;     
		else if(I_clk_en_40M) 
           O_de_scramble_out <= W_de_scramble_out;
	end
	
	always @(posedge I_clk or negedge I_rst_n) begin
		if(~I_rst_n)
	       O_de_scramble_out_valid <= 1'b0;  
		else if(O_de_scramble_start) 
           O_de_scramble_out_valid <= 1'b0;  		   
		else if(I_clk_en_40M)
           O_de_scramble_out_valid <= W_de_scramble_out_valid;
	end	
	
	reg R_data_out_valid_d;
	always @(posedge I_clk or negedge I_rst_n) begin
		if(~I_rst_n)
	       R_data_out_valid_d <= 1'b0;  
		else if(O_de_scramble_start) 
           R_data_out_valid_d <= 1'b0;  		   
		else if(I_clk_en_20M)
           R_data_out_valid_d <= R_data_out_valid;
	end		
	wire W_data_out_valid_neg = ~R_data_out_valid & R_data_out_valid_d;
	
	assign O_data_decode_done = I_decode_data_ofdm_num_valid & W_data_out_valid_neg
								&(I_rx_ofdm_symbol_idx == I_decode_data_ofdm_num);

endmodule
