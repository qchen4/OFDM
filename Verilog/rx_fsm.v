//////////////////////////////////////////////////////////////
// 功能: RX总控状态机Verilog代码
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
//////////////////////////////////////////////////////////////
module rx_fsm(
	input I_clk,
	input I_rst_n,
	input I_clk_en,
	
	input I_mac_start_rx, 	
	input I_packet_detected_done,
	input I_coarse_foc_out_start,
	input I_symbol_sync_out_start,
	input I_fine_foc_out_start,
	input I_signal_decode_done,
	input I_data_decode_done,	
	
	output reg O_search_packet_en,
	output reg O_coarse_foc_en,
	output reg O_symbol_sync_en,
	output reg O_fine_foc_en,
	output reg O_decode_en
);

localparam C_IDLE = 3'd0;
localparam C_SEARCH_PACKET = 3'd1;
localparam C_COARSE_FOC = 3'd2;
localparam C_SYMBOL_SYNC = 3'd3;
localparam C_FINE_FOC = 3'd4;
localparam C_SIGNAL_DECODE = 3'd5;
localparam C_DATA_DECODE = 3'd6;

reg [2:0] R_cur_state, R_next_state;
always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) 
		R_cur_state <= 3'd0;
	else if(I_clk_en)
		R_cur_state <= R_next_state;
end

always @(*) begin
	case(R_cur_state)
		C_IDLE : begin
			if(I_mac_start_rx) 
				R_next_state <= C_SEARCH_PACKET;
			else
				R_next_state <= C_IDLE;
		end
		C_SEARCH_PACKET : begin 
			if(I_packet_detected_done) 
				R_next_state <= C_COARSE_FOC;
			else
				R_next_state <= C_SEARCH_PACKET;
		end
		C_COARSE_FOC : begin
			if(I_coarse_foc_out_start) 
				R_next_state <= C_SYMBOL_SYNC;
			else
				R_next_state <= C_COARSE_FOC;
		end
		C_SYMBOL_SYNC : begin
			if(I_symbol_sync_out_start) 
				R_next_state <= C_FINE_FOC;
			else
				R_next_state <= C_SYMBOL_SYNC;
		end
		C_FINE_FOC : begin			
			if(I_fine_foc_out_start) 
				R_next_state <= C_SIGNAL_DECODE;
			else
				R_next_state <= C_FINE_FOC;
		end
		C_SIGNAL_DECODE : begin			
			if(I_signal_decode_done) 
				R_next_state <= C_DATA_DECODE;
			else
				R_next_state <= C_SIGNAL_DECODE;
		end
		C_DATA_DECODE : begin			
			if(I_data_decode_done) 
				R_next_state <= C_IDLE;
			else
				R_next_state <= C_DATA_DECODE;
		end
		default : begin
			R_next_state <= C_IDLE;
		end	
	endcase
end

always @(posedge I_clk or negedge I_rst_n) begin
    if(!I_rst_n) begin
        O_search_packet_en <= 1'b0;
        O_coarse_foc_en <= 1'b0;
        O_symbol_sync_en <= 1'b0;
        O_fine_foc_en <= 1'b0; 
		O_decode_en <= 1'b0;
    end
    else if(I_clk_en) begin
        case(R_next_state)
            C_IDLE : begin
                O_search_packet_en <= 1'b0;
                O_coarse_foc_en <= 1'b0;
                O_symbol_sync_en <= 1'b0;
                O_fine_foc_en <= 1'b0; 
                O_decode_en <= 1'b0;
            end
            C_SEARCH_PACKET : begin 
                O_search_packet_en <= 1'b1;   
                O_coarse_foc_en <= 1'b0;   
                O_symbol_sync_en <= 1'b0;  
                O_fine_foc_en <= 1'b0;   
                O_decode_en <= 1'b0;      
            end
            C_COARSE_FOC : begin
                O_search_packet_en <= 1'b0;   
                O_coarse_foc_en <= 1'b1; 
                O_symbol_sync_en <= 1'b0;
                O_fine_foc_en <= 1'b0; 
                O_decode_en <= 1'b0;
            end
            C_SYMBOL_SYNC : begin
                O_search_packet_en <= 1'b0;   
                O_coarse_foc_en <= 1'b1; 
                O_symbol_sync_en <= 1'b1;
                O_fine_foc_en <= 1'b0; 
                O_decode_en <= 1'b0;
            end
            C_FINE_FOC : begin
                O_search_packet_en <= 1'b0;   
                O_coarse_foc_en <= 1'b1; 
                O_symbol_sync_en <= 1'b1;
                O_fine_foc_en <= 1'b1; 
                O_decode_en <= 1'b0;
            end
			C_SIGNAL_DECODE : begin			
				O_search_packet_en <= 1'b0;   
                O_coarse_foc_en <= 1'b1; 
                O_symbol_sync_en <= 1'b1;
                O_fine_foc_en <= 1'b1; 
                O_decode_en <= 1'b1;
			end
			C_DATA_DECODE : begin			
				O_search_packet_en <= 1'b0;   
                O_coarse_foc_en <= 1'b1; 
                O_symbol_sync_en <= 1'b1;
                O_fine_foc_en <= 1'b1; 
                O_decode_en <= 1'b1;
			end
            default : begin
                O_search_packet_en <= 1'b0;
                O_coarse_foc_en <= 1'b0;
                O_symbol_sync_en <= 1'b0;
                O_fine_foc_en <= 1'b0; 
                O_decode_en <= 1'b0;
            end	
        endcase
    end
end

endmodule