//////////////////////////////////////////////////////////////
// 功能: IEEE802.11a OFDM系统顶层Testbench
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
//////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module tb_ieee80211a_rx_top();

// 导出 VCD：DUMP_VCD=1 bash run_vivado_sim.sh → waves/rx_top.vcd（文件可能很大）
`ifdef DUMP_VCD
initial begin
	$dumpfile("rx_top.vcd");
	$dumpvars(0, tb_ieee80211a_rx_top);
end
`endif

reg R_clk;
reg R_rst_n;
initial begin
	R_clk = 0;
	R_rst_n = 1;
	#1;
	R_rst_n = 0;
	#47;
	R_rst_n = 1;
end

always #6.25 R_clk = ~R_clk; // Clock frequency = 80MHz

wire W_clk_en_40M;
wire W_clk_en_20M;
wire W_rst_n_sync;	
clock_rst u0(
	.I_clk(R_clk), //80M时钟
	.I_rst_n(R_rst_n),
	
	.O_clk_en_40M(W_clk_en_40M),
	.O_clk_en_20M(W_clk_en_20M),
	.O_rst_n(W_rst_n_sync)	
);

reg [7:0] R_matlab_channel_out_i[0:1319];
reg [7:0] R_matlab_channel_out_q[0:1319];
reg [12:0] R_matlab_abs_Pd[0:1319];
reg [12:0] R_matlab_Rd[0:1319];
reg [8:0] R_matlab_coarse_foc_out_i[0:1319];
reg [8:0] R_matlab_coarse_foc_out_q[0:1319];
reg [11:0] R_matlab_symbol_sync_abs_Ck[0:1319];
reg [7:0] R_matlab_fine_foc_out_i[0:1319];
reg [7:0] R_matlab_fine_foc_out_q[0:1319];
reg [7:0] R_matlab_remove_cp_out_i[0:1319];
reg [7:0] R_matlab_remove_cp_out_q[0:1319];
reg [13:0] R_matlab_fft_out_i[0:1319];
reg [13:0] R_matlab_fft_out_q[0:1319];
reg [13:0] R_matlab_equalize_out_i[0:1319];
reg [13:0] R_matlab_equalize_out_q[0:1319];
reg [13:0] R_matlab_phase_track_out_i[0:1319];
reg [13:0] R_matlab_phase_track_out_q[0:1319];
reg [13:0] R_matlab_pilot_remove_out_i[0:1319];
reg [13:0] R_matlab_pilot_remove_out_q[0:1319];
reg [0:0] R_matlab_signal_de_bpsk_out[0:47];
reg [0:0] R_matlab_signal_de_interleave_out[0:47];
reg [0:0] R_matlab_data_de_qam16_out[0:1343];
reg [0:0] R_matlab_data_de_interleave_out[0:1343];
reg [0:0] R_matlab_signal_viterbi217_out[0:35];
reg [0:0] R_matlab_data_viterbi217_out[0:671];
reg [0:0] R_matlab_data_de_scramble_out[0:567];
initial begin
    $readmemh("verify_txt/channel_model_out_i.txt",R_matlab_channel_out_i);
    $readmemh("verify_txt/channel_model_out_q.txt",R_matlab_channel_out_q);
    $readmemh("verify_txt/abs_Pd.txt",R_matlab_abs_Pd);
    $readmemh("verify_txt/Rd.txt",R_matlab_Rd);
	$readmemh("verify_txt/rx_coarse_foc_out_i.txt",R_matlab_coarse_foc_out_i);
    $readmemh("verify_txt/rx_coarse_foc_out_q.txt",R_matlab_coarse_foc_out_q);
	$readmemh("verify_txt/rx_symbol_sync_abs_Ck.txt",R_matlab_symbol_sync_abs_Ck);
	$readmemh("verify_txt/rx_fine_foc_out_i.txt",R_matlab_fine_foc_out_i);
    $readmemh("verify_txt/rx_fine_foc_out_q.txt",R_matlab_fine_foc_out_q);
	$readmemh("verify_txt/rx_remove_cp_out_i.txt",R_matlab_remove_cp_out_i);
    $readmemh("verify_txt/rx_remove_cp_out_q.txt",R_matlab_remove_cp_out_q);
    $readmemh("verify_txt/rx_fft_out_i.txt",R_matlab_fft_out_i);
    $readmemh("verify_txt/rx_fft_out_q.txt",R_matlab_fft_out_q);
    $readmemh("verify_txt/rx_equalize_out_i.txt",R_matlab_equalize_out_i);
    $readmemh("verify_txt/rx_equalize_out_q.txt",R_matlab_equalize_out_q);
    $readmemh("verify_txt/rx_phase_track_out_i.txt",R_matlab_phase_track_out_i);
    $readmemh("verify_txt/rx_phase_track_out_q.txt",R_matlab_phase_track_out_q);
    $readmemh("verify_txt/rx_pilot_remove_out_i.txt",R_matlab_pilot_remove_out_i);
    $readmemh("verify_txt/rx_pilot_remove_out_q.txt",R_matlab_pilot_remove_out_q);
	$readmemh("verify_txt/rx_signal_de_bpsk_out.txt",R_matlab_signal_de_bpsk_out);
	$readmemh("verify_txt/rx_signal_de_interleave_out.txt",R_matlab_signal_de_interleave_out);
	$readmemh("verify_txt/rx_data_de_qam16_out.txt",R_matlab_data_de_qam16_out);	
	$readmemh("verify_txt/rx_data_de_interleave_out.txt",R_matlab_data_de_interleave_out);
	$readmemh("verify_txt/rx_signal_viterbi217_out.txt",R_matlab_signal_viterbi217_out);
	$readmemh("verify_txt/rx_data_viterbi217_out.txt",R_matlab_data_viterbi217_out);	
	$readmemh("verify_txt/rx_data_de_scramble_out.txt",R_matlab_data_de_scramble_out);	
end

reg [31:0] R_rx_global_cnt;
always @(posedge R_clk or negedge W_rst_n_sync) begin
	if(~W_rst_n_sync)
		R_rx_global_cnt <= 0;
	else if(W_clk_en_20M) begin
		if(R_rx_global_cnt == 32'd2000)
			R_rx_global_cnt <= 32'd2000; 
		else
			R_rx_global_cnt <= R_rx_global_cnt + 1; 
	end
end

wire W_mac_start_rx = (R_rx_global_cnt == 32'd10) ? 1'b1 : 1'b0;

wire W_packet_detected_done;	
wire W_coarse_foc_out_start;	
wire W_symbol_sync_out_start;	
wire W_fine_foc_out_start;
wire W_signal_decode_done;
wire W_data_decode_done;

wire W_search_packet_en;
wire W_coarse_foc_en;
wire W_symbol_sync_en;
wire W_fine_foc_en;
wire W_decode_en;
rx_fsm u1(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_clk_en(W_clk_en_20M),
	
	.I_mac_start_rx(W_mac_start_rx), 	
	.I_packet_detected_done(W_packet_detected_done),
	.I_coarse_foc_out_start(W_coarse_foc_out_start),
	.I_symbol_sync_out_start(W_symbol_sync_out_start),
	.I_fine_foc_out_start(W_fine_foc_out_start),
	.I_signal_decode_done(W_signal_decode_done),
	.I_data_decode_done(W_data_decode_done),	
	
	.O_search_packet_en(W_search_packet_en),
	.O_coarse_foc_en(W_coarse_foc_en),
	.O_symbol_sync_en(W_symbol_sync_en),
	.O_fine_foc_en(W_fine_foc_en),
	.O_decode_en(W_decode_en)
);

wire [31:0] W_rx_data_cnt = (R_rx_global_cnt >= 11)? R_rx_global_cnt - 11 : 0;
wire [7:0] W_rx_data_in_i = R_matlab_channel_out_i[W_rx_data_cnt];
wire [7:0] W_rx_data_in_q = R_matlab_channel_out_q[W_rx_data_cnt];

wire [2:0]	CSR_Md_threshold = 3'd3;
wire [8:0]	CSR_Md_cnt_threshold = 9'd32;
rx_packet_detect u2(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_clk_en(W_clk_en_20M), 	
	.I_search_packet_en(W_search_packet_en),
	.I_rx_data_in_i(W_rx_data_in_i),  // 8S7
	.I_rx_data_in_q(W_rx_data_in_q),  // 8S7	
	.CSR_Md_threshold(CSR_Md_threshold),
	.CSR_Md_cnt_threshold(CSR_Md_cnt_threshold), 
	
	.O_packet_detected_done(W_packet_detected_done)
);

wire [21:0]	    W_coarse_estimate_freq;
wire [8:0]      W_rx_coarse_foc_out_i; 
wire [8:0]      W_rx_coarse_foc_out_q; 	
rx_coarse_foc u3(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_clk_en(W_clk_en_20M), 	
	.I_coarse_foc_en(W_coarse_foc_en),
	.I_rx_coarse_foc_in_i(W_rx_data_in_i),// 8S7
	.I_rx_coarse_foc_in_q(W_rx_data_in_q),// 8S7
	
	.O_coarse_estimate_freq(W_coarse_estimate_freq),
	.O_rx_coarse_foc_out_start(W_coarse_foc_out_start),
	.O_rx_coarse_foc_out_i(W_rx_coarse_foc_out_i), 
	.O_rx_coarse_foc_out_q(W_rx_coarse_foc_out_q) 	
);

// threshold=7.5
wire   [11:0] CSR_symbol_sync_threshold = 12'd960; 
wire   [8: 0] W_symbol_sync_out_i; 
wire   [8: 0] W_symbol_sync_out_q; 
rx_symbol_sync u4(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_clk_en(W_clk_en_20M), 
	.CSR_symbol_sync_threshold(CSR_symbol_sync_threshold), 	
	.I_symbol_sync_en(W_symbol_sync_en),
	.I_symbol_sync_in_i(W_rx_coarse_foc_out_i),
	.I_symbol_sync_in_q(W_rx_coarse_foc_out_q),
	
	.O_symbol_sync_out_i(W_symbol_sync_out_i), 
	.O_symbol_sync_out_q(W_symbol_sync_out_q), 
	.O_symbol_sync_out_start(W_symbol_sync_out_start) 	
);

wire [21:0]	    W_fine_estimate_freq;
wire [7:0]      W_rx_fine_foc_out_i; 
wire [7:0]      W_rx_fine_foc_out_q; 	
rx_fine_foc u5(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_clk_en(W_clk_en_20M), 	
	.I_fine_foc_en(W_fine_foc_en),
	.I_rx_fine_foc_in_i(W_symbol_sync_out_i),// 8S7
	.I_rx_fine_foc_in_q(W_symbol_sync_out_q),// 8S7
	
	.O_fine_estimate_freq(W_fine_estimate_freq),
	.O_rx_fine_foc_out_start(W_fine_foc_out_start),
	.O_rx_fine_foc_out_i(W_rx_fine_foc_out_i), 
	.O_rx_fine_foc_out_q(W_rx_fine_foc_out_q) 	
);

wire [10:0] W_decode_data_ofdm_num = 11'd7;
wire W_decode_data_ofdm_num_valid = 1'b1;
wire [7: 0] W_rx_remove_cp_out_i; 
wire [7: 0] W_rx_remove_cp_out_q;
wire W_rx_remove_cp_out_valid;
wire [10:0] W_rx_rm_cp_ofdm_symbol_idx;
rx_remove_cp u6(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_clk_en(W_clk_en_20M), 
	
	.I_decode_data_ofdm_num(W_decode_data_ofdm_num), 
	.I_decode_data_ofdm_num_valid(W_decode_data_ofdm_num_valid), 
	
	.I_rx_remove_cp_start(W_fine_foc_out_start),
	.I_rx_remove_cp_in_i(W_rx_fine_foc_out_i),  // 8S7
	.I_rx_remove_cp_in_q(W_rx_fine_foc_out_q),  // 8S7
	
	.O_rx_remove_cp_out_i(W_rx_remove_cp_out_i), 
	.O_rx_remove_cp_out_q(W_rx_remove_cp_out_q), 
	.O_rx_remove_cp_out_valid(W_rx_remove_cp_out_valid),
	.O_rx_ofdm_symbol_idx(W_rx_rm_cp_ofdm_symbol_idx)
);

wire [10:0] W_rx_fft_ofdm_symbol_idx;
wire		W_rx_fft_out_valid;
wire [5: 0] W_rx_fft_out_idx;
wire [13:0] W_rx_fft_out_i; // 14S7
wire [13:0] W_rx_fft_out_q; // 14S7
rx_fft64_burst u7(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_clk_en(W_clk_en_20M),  
	
	.I_rx_ofdm_symbol_idx(W_rx_rm_cp_ofdm_symbol_idx),
	
	.I_fft_in_valid(W_rx_remove_cp_out_valid), 
	.I_fft_in_i(W_rx_remove_cp_out_i),  // 8S7
	.I_fft_in_q(W_rx_remove_cp_out_q),  // 8S7
	
	.O_rx_ofdm_symbol_idx(W_rx_fft_ofdm_symbol_idx),
	.O_fft_out_valid(W_rx_fft_out_valid),
	.O_fft_out_idx(W_rx_fft_out_idx),
	.O_fft_out_i(W_rx_fft_out_i), // 14S7
	.O_fft_out_q(W_rx_fft_out_q)  // 14S7	
);

wire [10:0] W_rx_equalize_ofdm_symbol_idx;
wire		W_rx_equalize_out_valid;
wire [5: 0] W_rx_equalize_out_idx;
wire [13:0] W_rx_equalize_out_i; // 14S7
wire [13:0] W_rx_equalize_out_q; // 14S7
rx_equalize u8(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_clk_en(W_clk_en_20M),  
	
	.I_rx_ofdm_symbol_idx(W_rx_fft_ofdm_symbol_idx),	
	.I_rx_equalize_in_valid(W_rx_fft_out_valid), 
	.I_rx_equalize_in_i(W_rx_fft_out_i),  // 14S7
	.I_rx_equalize_in_q(W_rx_fft_out_q),  // 14S7
	
	.O_rx_ofdm_symbol_idx(W_rx_equalize_ofdm_symbol_idx),
	.O_rx_equalize_out_valid(W_rx_equalize_out_valid),
	.O_rx_equalize_out_idx(W_rx_equalize_out_idx),
	.O_rx_equalize_out_i(W_rx_equalize_out_i), 
	.O_rx_equalize_out_q(W_rx_equalize_out_q) 
);

wire [13:0] W_rx_phase_track_out_i;
wire [13:0] W_rx_phase_track_out_q;
wire  	    W_rx_phase_track_out_valid;
wire		W_rx_phase_track_done;
wire [10:0] W_rx_phase_track_ofdm_symbol_idx;	
wire [13:0] W_phase_track_decision_threshold;
rx_phase_track u9(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_clk_en(W_clk_en_20M),  
	
	.I_rx_phase_track_i(W_rx_equalize_out_i),
	.I_rx_phase_track_q(W_rx_equalize_out_q),
	.I_rx_phase_track_valid(W_rx_equalize_out_valid),
	.I_rx_ofdm_symbol_idx(W_rx_equalize_ofdm_symbol_idx),
	
	.O_rx_phase_track_out_i(W_rx_phase_track_out_i),
	.O_rx_phase_track_out_q(W_rx_phase_track_out_q),
	.O_rx_phase_track_out_valid(W_rx_phase_track_out_valid),
	.O_rx_phase_track_done(W_rx_phase_track_done),
	.O_rx_ofdm_symbol_idx(W_rx_phase_track_ofdm_symbol_idx),
	
	.O_decision_threshold(W_phase_track_decision_threshold)
);

wire [10:0] W_rx_pilot_remove_ofdm_symbol_idx;
wire [13:0] W_rx_pilot_remove_out_i;
wire [13:0] W_rx_pilot_remove_out_q;
wire W_rx_pilot_remove_out_valid;
wire W_rx_pilot_remove_done;
wire [13:0] W_pilot_remove_decision_threshold; //14S7
rx_pilot_remove u10(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_clk_en(W_clk_en_20M), 
	
	.I_decision_threshold(W_phase_track_decision_threshold),//14S7	
	
	.I_rx_pilot_remove_in_i(W_rx_phase_track_out_i),
	.I_rx_pilot_remove_in_q(W_rx_phase_track_out_q),
	.I_rx_pilot_remove_in_valid(W_rx_phase_track_out_valid),
	.I_rx_ofdm_symbol_idx(W_rx_phase_track_ofdm_symbol_idx),
	
	.O_rx_ofdm_symbol_idx(W_rx_pilot_remove_ofdm_symbol_idx),
	.O_rx_pilot_remove_out_i(W_rx_pilot_remove_out_i),
	.O_rx_pilot_remove_out_q(W_rx_pilot_remove_out_q),
	.O_rx_pilot_remove_out_valid(W_rx_pilot_remove_out_valid),
	.O_rx_pilot_remove_done(W_rx_pilot_remove_done),
	
	.O_decision_threshold(W_pilot_remove_decision_threshold) //14S7
);

wire [13:0] W_rx_signal_ofdm_out_i;
wire [13:0] W_rx_signal_ofdm_out_q;
wire W_rx_signal_ofdm_out_valid;	
wire [13:0] W_rx_data_ofdm_out_i;
wire [13:0] W_rx_data_ofdm_out_q;
wire W_rx_data_ofdm_out_valid;	
wire [10:0] W_rx_split_ofdm_symbol_idx;
rx_signal_data_split u11(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_clk_en(W_clk_en_20M),
	
	.I_rx_ofdm_symbol_idx(W_rx_pilot_remove_ofdm_symbol_idx),
	
	.I_rx_split_in_valid(W_rx_pilot_remove_out_valid),
	.I_rx_split_in_i(W_rx_pilot_remove_out_i),
	.I_rx_split_in_q(W_rx_pilot_remove_out_q),	
	
	.O_rx_signal_ofdm_out_i(W_rx_signal_ofdm_out_i),
	.O_rx_signal_ofdm_out_q(W_rx_signal_ofdm_out_q),
	.O_rx_signal_ofdm_out_valid(W_rx_signal_ofdm_out_valid),
	
	.O_rx_data_ofdm_out_i(W_rx_data_ofdm_out_i),
	.O_rx_data_ofdm_out_q(W_rx_data_ofdm_out_q),
	.O_rx_data_ofdm_out_valid(W_rx_data_ofdm_out_valid),

	.O_rx_ofdm_symbol_idx(W_rx_split_ofdm_symbol_idx)
);

wire  W_signal_de_bpsk_out_valid;
wire  W_signal_de_bpsk_out;
rx_signal_de_bpsk u12(
    .I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_clk_en(W_clk_en_20M),
	 
    .I_de_bpsk_in_i(W_rx_signal_ofdm_out_i),
	.I_de_bpsk_in_q(W_rx_signal_ofdm_out_q),
    .I_de_bpsk_in_valid(W_rx_signal_ofdm_out_valid),
    
    .O_de_bpsk_out_valid(W_signal_de_bpsk_out_valid),
    .O_de_bpsk_out(W_signal_de_bpsk_out)
);

wire W_signal_de_interleave_out;
wire W_signal_de_interleave_out_valid;
wire W_signal_de_interleave_done;
rx_signal_de_interleave u13(
    .I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_rx_bits(W_signal_de_bpsk_out),
	.I_rx_bits_valid(W_signal_de_bpsk_out_valid),
	
	.O_de_interleave_out(W_signal_de_interleave_out),
	.O_de_interleave_out_valid(W_signal_de_interleave_out_valid),
	.O_de_interleave_done(W_signal_de_interleave_done)
);

wire W_rx_data_de_qam16_out;
wire W_rx_data_de_qam16_out_valid;
wire W_rx_data_de_qam16_done;
rx_data_de_qam16 u14(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_clk_en(W_clk_en_20M),
	.I_de_qam16_threshold(W_pilot_remove_decision_threshold),
	.I_rx_de_qam16_valid(W_rx_data_ofdm_out_valid),
	.I_rx_de_qam16_i(W_rx_data_ofdm_out_i),
	.I_rx_de_qam16_q(W_rx_data_ofdm_out_q),
	.O_rx_de_qam16_out(W_rx_data_de_qam16_out),
	.O_rx_de_qam16_out_valid(W_rx_data_de_qam16_out_valid),
	.O_rx_de_qam16_done(W_rx_data_de_qam16_done)
);

wire [10:0] W_rx_data_de_interleave_ofdm_symbol_idx;
wire W_rx_data_de_interleave_out;
wire W_rx_data_de_interleave_out_valid;
wire W_rx_data_de_interleave_done;
rx_data_de_interleave u15(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_rx_bits(W_rx_data_de_qam16_out),
	.I_rx_bits_valid(W_rx_data_de_qam16_out_valid),
	.I_rx_ofdm_symbol_idx(W_rx_split_ofdm_symbol_idx),
	
	.O_rx_ofdm_symbol_idx(W_rx_data_de_interleave_ofdm_symbol_idx),
	.O_data_de_interleave_out(W_rx_data_de_interleave_out),
	.O_data_de_interleave_out_valid(W_rx_data_de_interleave_out_valid),
	.O_data_de_interleave_done(W_rx_data_de_interleave_done)
);

wire W_rx_signal_out_start;
wire W_rx_data_out_start;
wire W_rx_signal_data_out;
wire W_rx_signal_data_out_valid;
wire [7:0] W_rx_bits_num;
wire [10:0] W_rx_signal_data_combine_ofdm_symbol_idx;
wire W_rx_viterbi217_en;
rx_signal_data_combine u16(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	
	.I_decode_en(W_decode_en),
	.I_rx_ofdm_symbol_idx(W_rx_data_de_interleave_ofdm_symbol_idx),
	
	.I_rx_signal_bits(W_signal_de_interleave_out),
	.I_rx_signal_bits_valid(W_signal_de_interleave_out_valid),
	
	.I_rx_data_bits(W_rx_data_de_interleave_out),
	.I_rx_data_bits_valid(W_rx_data_de_interleave_out_valid),
	
	.O_rx_signal_out_start(W_rx_signal_out_start),
	.O_rx_data_out_start(W_rx_data_out_start),
	.O_rx_viterbi217_en(W_rx_viterbi217_en),
	
	.O_rx_signal_data_out(W_rx_signal_data_out),
	.O_rx_signal_data_out_valid(W_rx_signal_data_out_valid),
	.O_rx_bits_num(W_rx_bits_num),
	.O_rx_ofdm_symbol_idx(W_rx_signal_data_combine_ofdm_symbol_idx)
);

wire W_rx_signal_dec_bits;
wire W_rx_signal_dec_bits_valid;
wire W_rx_data_dec_bits;
wire W_rx_data_dec_bits_valid;
wire W_rx_viterbi_done;
rx_viterbi217 u17(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_clk_en(W_clk_en_40M),
	
	.I_rx_signal_in_start(W_rx_signal_out_start),
	.I_rx_data_in_start(W_rx_data_out_start),
	.I_rx_viterbi217_en(W_rx_viterbi217_en),
	
	.I_decode_data_ofdm_num(W_decode_data_ofdm_num),
	.I_rx_ofdm_symbol_idx(W_rx_signal_data_combine_ofdm_symbol_idx),
	
	.I_rx_bits(W_rx_signal_data_out),
	.I_rx_bits_valid(W_rx_signal_data_out_valid),
	.I_rx_bits_num(W_rx_bits_num), // 有效bit的总数

	.O_signal_dec_bits(W_rx_signal_dec_bits),
	.O_signal_dec_bits_valid(W_rx_signal_dec_bits_valid),
	.O_data_dec_bits(W_rx_data_dec_bits),
	.O_data_dec_bits_valid(W_rx_data_dec_bits_valid),
	.O_viterbi_done(W_rx_viterbi_done)
    );

wire [11:0] W_decode_bytes_num;
rx_signal_parse u18(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_clk_en_20M(W_clk_en_20M),
	.I_clk_en_40M(W_clk_en_40M),

	.I_rx_signal_bits(W_rx_signal_dec_bits),
	.I_rx_signal_bits_valid(W_rx_signal_dec_bits_valid),	
	
	.O_decode_bytes_num(W_decode_bytes_num),	
	.O_decode_data_ofdm_num(W_decode_data_ofdm_num),
	.O_decode_data_ofdm_num_valid(W_decode_data_ofdm_num_valid),
	
	.O_signal_decode_done(W_signal_decode_done)	
);

wire W_rx_data_de_scramble_out;
wire W_rx_data_de_scramble_out_valid;
wire W_rx_data_de_scramble_start;
rx_data_de_scramble u19(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_clk_en_20M(W_clk_en_20M),
	.I_clk_en_40M(W_clk_en_40M),
	
	.I_rx_bits(W_rx_data_dec_bits),
	.I_rx_bits_valid(W_rx_data_dec_bits_valid),
	.I_rx_ofdm_symbol_idx(W_rx_signal_data_combine_ofdm_symbol_idx),
	.I_decode_bytes_num(W_decode_bytes_num),
	
	.I_decode_data_ofdm_num(W_decode_data_ofdm_num),
	.I_decode_data_ofdm_num_valid(W_decode_data_ofdm_num_valid),

	.O_de_scramble_out(W_rx_data_de_scramble_out),
	.O_de_scramble_out_valid(W_rx_data_de_scramble_out_valid),
	.O_de_scramble_start(W_rx_data_de_scramble_start),
	.O_data_decode_done(W_data_decode_done)
);

rx_pseudo_mac u20(
	.I_clk(R_clk),
	.I_rst_n(W_rst_n_sync),
	.I_clk_en_20M(W_clk_en_20M),
	.I_clk_en_40M(W_clk_en_40M),
	
	.I_rx_bits(W_rx_data_de_scramble_out),
	.I_rx_bits_valid(W_rx_data_de_scramble_out_valid),
		
	.O_mac_start_rx(W_mac_start_rx)	
);

// 验证 abs_Pd 和 Rd
wire [31:0] W_packet_detect_cnt = (R_rx_global_cnt >= 44)? R_rx_global_cnt - 44 : 0;
wire [7:0] W_matlab_abs_Pd = R_matlab_abs_Pd[W_packet_detect_cnt];
wire [7:0] W_matlab_Rd = R_matlab_Rd[W_packet_detect_cnt];

wire W_u2_compare_win = (W_packet_detect_cnt > 0) && W_search_packet_en;
wire [7:0] W_verilog_abs_Pd = tb_ieee80211a_rx_top.u2.W_abs_Pd;
wire [7:0] W_verilog_Rd = tb_ieee80211a_rx_top.u2.W_Rd;

wire W_error_abs_Pd = W_u2_compare_win?((W_verilog_abs_Pd == W_matlab_abs_Pd)?1'b0:1'b1):1'b0;
wire W_error_Rd = W_u2_compare_win?((W_verilog_Rd == W_matlab_Rd)?1'b0:1'b1):1'b0;

// 验证rx_coarse_foc_out_i/q
wire [31:0] W_coarse_foc_compare_length = 32'd1075;
reg  		R_coarse_foc_cnt_en;
reg [31:0] 	R_coarse_foc_cnt;
always @(posedge R_clk or negedge R_rst_n) begin
	if(~R_rst_n)
		R_coarse_foc_cnt_en <= 1'd0;
	else if(W_clk_en_20M) begin
		if(W_coarse_foc_out_start)
			R_coarse_foc_cnt_en <= 1'b1;
		else if(R_coarse_foc_cnt == W_coarse_foc_compare_length)
			R_coarse_foc_cnt_en <= 1'b0;
	end		
end
always @(posedge R_clk or negedge R_rst_n) begin
	if(~R_rst_n)
		R_coarse_foc_cnt <= 32'd0;
	else if(W_clk_en_20M) begin
		if(W_coarse_foc_out_start)
			R_coarse_foc_cnt <= 32'd0;
		else if(R_coarse_foc_cnt_en)
			R_coarse_foc_cnt <= R_coarse_foc_cnt + 1'd1;
	end		
end
wire [8:0] W_matlab_coarse_foc_out_i = R_matlab_coarse_foc_out_i[R_coarse_foc_cnt];
wire [8:0] W_matlab_coarse_foc_out_q = R_matlab_coarse_foc_out_q[R_coarse_foc_cnt];
wire W_u3_compare_win = R_coarse_foc_cnt_en;

wire W_error_coarse_foc_out_i = W_u3_compare_win?((W_rx_coarse_foc_out_i == W_matlab_coarse_foc_out_i)?1'b0:1'b1):1'b0;
wire W_error_coarse_foc_out_q = W_u3_compare_win?((W_rx_coarse_foc_out_q == W_matlab_coarse_foc_out_q)?1'b0:1'b1):1'b0;

// 验证rx_symbol_sync_abs_Ck
wire [31:0] W_symbol_sync_compare_length = 32'd1011;
reg  		R_symbol_sync_cnt_en;
reg [31:0] 	R_symbol_sync_cnt;
wire W_symbol_sync_abs_Ck_start = (R_rx_global_cnt == 32'd355) ? 1'b1 : 1'b0;
always @(posedge R_clk or negedge R_rst_n) begin
	if(~R_rst_n)
		R_symbol_sync_cnt_en <= 1'd0;
	else if(W_clk_en_20M) begin
		if(W_symbol_sync_abs_Ck_start)
			R_symbol_sync_cnt_en <= 1'b1;
		else if(R_symbol_sync_cnt == W_symbol_sync_compare_length)
			R_symbol_sync_cnt_en <= 1'b0;
	end		
end
always @(posedge R_clk or negedge R_rst_n) begin
	if(~R_rst_n)
		R_symbol_sync_cnt <= 32'd0;
	else if(W_clk_en_20M) begin
		if(W_symbol_sync_abs_Ck_start)
			R_symbol_sync_cnt <= 32'd0;
		else if(R_symbol_sync_cnt_en)
			R_symbol_sync_cnt <= R_symbol_sync_cnt + 1'd1;
	end		
end
wire [11:0] W_matlab_symbol_sync_abs_Ck = R_matlab_symbol_sync_abs_Ck[R_symbol_sync_cnt];
wire W_u4_compare_win = R_symbol_sync_cnt_en;

wire [11:0] W_verilog_symbol_sync_abs_Ck = tb_ieee80211a_rx_top.u4.W_abs_Ck;
wire W_error_symbol_sync_abs_Ck = W_u4_compare_win?((W_verilog_symbol_sync_abs_Ck == W_matlab_symbol_sync_abs_Ck)?1'b0:1'b1):1'b0;

// 验证rx_fine_foc_out_i/q
wire [31:0] W_fine_foc_compare_length = 32'd963;
reg  		R_fine_foc_cnt_en;
reg [31:0] 	R_fine_foc_cnt;
always @(posedge R_clk or negedge R_rst_n) begin
	if(~R_rst_n)
		R_fine_foc_cnt_en <= 1'd0;
	else if(W_clk_en_20M) begin
		if(W_fine_foc_out_start)
			R_fine_foc_cnt_en <= 1'b1;
		else if(R_fine_foc_cnt == W_fine_foc_compare_length)
			R_fine_foc_cnt_en <= 1'b0;
	end		
end
always @(posedge R_clk or negedge R_rst_n) begin
	if(~R_rst_n)
		R_fine_foc_cnt <= 32'd0;
	else if(W_clk_en_20M) begin
		if(W_fine_foc_out_start)
			R_fine_foc_cnt <= 32'd0;
		else if(R_fine_foc_cnt_en)
			R_fine_foc_cnt <= R_fine_foc_cnt + 1'd1;
	end		
end
wire [7:0] W_matlab_fine_foc_out_i = R_matlab_fine_foc_out_i[R_fine_foc_cnt];
wire [7:0] W_matlab_fine_foc_out_q = R_matlab_fine_foc_out_q[R_fine_foc_cnt];
wire W_u5_compare_win = R_fine_foc_cnt_en;

wire W_error_fine_foc_out_i = W_u5_compare_win?((W_rx_fine_foc_out_i == W_matlab_fine_foc_out_i)?1'b0:1'b1):1'b0;
wire W_error_fine_foc_out_q = W_u5_compare_win?((W_rx_fine_foc_out_q == W_matlab_fine_foc_out_q)?1'b0:1'b1):1'b0;

// 验证rx_remove_cp_out_i/q
reg [31:0] R_remove_cp_out_cnt;
always @(posedge R_clk or negedge W_rst_n_sync) begin
	if(~W_rst_n_sync)
		R_remove_cp_out_cnt <= 0;
	else if(W_clk_en_20M) begin
		if(R_remove_cp_out_cnt == 32'd639)
			R_remove_cp_out_cnt <= 32'd639; 
		else if(W_rx_remove_cp_out_valid)
			R_remove_cp_out_cnt <= R_remove_cp_out_cnt + 1; 
	end
end
wire [7:0] W_matlab_remove_cp_out_i = R_matlab_remove_cp_out_i[R_remove_cp_out_cnt];
wire [7:0] W_matlab_remove_cp_out_q = R_matlab_remove_cp_out_q[R_remove_cp_out_cnt];
wire W_error_remove_cp_out_i = W_rx_remove_cp_out_valid?((W_rx_remove_cp_out_i == W_matlab_remove_cp_out_i)?1'b0:1'b1):1'b0;
wire W_error_remove_cp_out_q = W_rx_remove_cp_out_valid?((W_rx_remove_cp_out_q == W_matlab_remove_cp_out_q)?1'b0:1'b1):1'b0;

// 验证rx_fft_out_i/q
reg [31:0] R_rx_fft_out_cnt;
always @(posedge R_clk or negedge W_rst_n_sync) begin
	if(~W_rst_n_sync)
		R_rx_fft_out_cnt <= 0;
	else if(W_clk_en_20M) begin
		if(R_rx_fft_out_cnt == 32'd639)
			R_rx_fft_out_cnt <= 32'd639; 
		else if(W_rx_fft_out_valid)
			R_rx_fft_out_cnt <= R_rx_fft_out_cnt + 1; 
	end
end
wire [13:0] W_matlab_fft_out_i = R_matlab_fft_out_i[R_rx_fft_out_cnt];
wire [13:0] W_matlab_fft_out_q = R_matlab_fft_out_q[R_rx_fft_out_cnt];
wire W_error_rx_fft_out_i = W_rx_fft_out_valid?((W_rx_fft_out_i == W_matlab_fft_out_i)?1'b0:1'b1):1'b0;
wire W_error_rx_fft_out_q = W_rx_fft_out_valid?((W_rx_fft_out_q == W_matlab_fft_out_q)?1'b0:1'b1):1'b0;

// 验证rx_equalize_i/q
reg [31:0] R_rx_equalize_cnt;
always @(posedge R_clk or negedge W_rst_n_sync) begin
	if(~W_rst_n_sync)
		R_rx_equalize_cnt <= 0;
	else if(W_clk_en_20M) begin
		if(R_rx_equalize_cnt == 32'd511)
			R_rx_equalize_cnt <= 32'd511; 
		else if(W_rx_equalize_out_valid)
			R_rx_equalize_cnt <= R_rx_equalize_cnt + 1; 
	end
end
wire [13:0] W_matlab_equalize_out_i = R_matlab_equalize_out_i[R_rx_equalize_cnt];
wire [13:0] W_matlab_equalize_out_q = R_matlab_equalize_out_q[R_rx_equalize_cnt];
wire W_error_rx_equalize_out_i = W_rx_equalize_out_valid?((W_rx_equalize_out_i == W_matlab_equalize_out_i)?1'b0:1'b1):1'b0;
wire W_error_rx_equalize_out_q = W_rx_equalize_out_valid?((W_rx_equalize_out_q == W_matlab_equalize_out_q)?1'b0:1'b1):1'b0;

// 验证rx_phase_track_i/q
reg [31:0] R_rx_phase_track_cnt;
always @(posedge R_clk or negedge W_rst_n_sync) begin
	if(~W_rst_n_sync)
		R_rx_phase_track_cnt <= 0;
	else if(W_clk_en_20M) begin
		if(R_rx_phase_track_cnt == 32'd511)
			R_rx_phase_track_cnt <= 32'd511; 
		else if(W_rx_phase_track_out_valid)
			R_rx_phase_track_cnt <= R_rx_phase_track_cnt + 1; 
	end
end
wire [13:0] W_matlab_phase_track_out_i = R_matlab_phase_track_out_i[R_rx_phase_track_cnt];
wire [13:0] W_matlab_phase_track_out_q = R_matlab_phase_track_out_q[R_rx_phase_track_cnt];
wire W_error_rx_phase_track_out_i = W_rx_phase_track_out_valid?((W_rx_phase_track_out_i == W_matlab_phase_track_out_i)?1'b0:1'b1):1'b0;
wire W_error_rx_phase_track_out_q = W_rx_phase_track_out_valid?((W_rx_phase_track_out_q == W_matlab_phase_track_out_q)?1'b0:1'b1):1'b0;

// 验证rx_pilot_remove_i/q
reg [31:0] R_rx_pilot_remove_cnt;
always @(posedge R_clk or negedge W_rst_n_sync) begin
	if(~W_rst_n_sync)
		R_rx_pilot_remove_cnt <= 0;
	else if(W_clk_en_20M) begin
		if(R_rx_pilot_remove_cnt == 32'd383)
			R_rx_pilot_remove_cnt <= 32'd383; 
		else if(W_rx_pilot_remove_out_valid)
			R_rx_pilot_remove_cnt <= R_rx_pilot_remove_cnt + 1; 
	end
end
wire [13:0] W_matlab_pilot_remove_out_i = R_matlab_pilot_remove_out_i[R_rx_pilot_remove_cnt];
wire [13:0] W_matlab_pilot_remove_out_q = R_matlab_pilot_remove_out_q[R_rx_pilot_remove_cnt];
wire W_error_rx_pilot_remove_out_i = W_rx_pilot_remove_out_valid?((W_rx_pilot_remove_out_i == W_matlab_pilot_remove_out_i)?1'b0:1'b1):1'b0;
wire W_error_rx_pilot_remove_out_q = W_rx_pilot_remove_out_valid?((W_rx_pilot_remove_out_q == W_matlab_pilot_remove_out_q)?1'b0:1'b1):1'b0;

// 验证rx_signal_de_bpsk_out
reg [31:0] R_rx_signal_de_bpsk_cnt;
always @(posedge R_clk or negedge W_rst_n_sync) begin
	if(~W_rst_n_sync)
		R_rx_signal_de_bpsk_cnt <= 0;
	else begin
		if(R_rx_signal_de_bpsk_cnt == 32'd47)
			R_rx_signal_de_bpsk_cnt <= 32'd47; 
		else if(W_signal_de_bpsk_out_valid)
			R_rx_signal_de_bpsk_cnt <= R_rx_signal_de_bpsk_cnt + 1; 
	end
end
wire W_matlab_signal_de_bpsk_out = R_matlab_signal_de_bpsk_out[R_rx_signal_de_bpsk_cnt];
wire W_error_rx_signal_de_bpsk_out = W_signal_de_bpsk_out_valid?((W_signal_de_bpsk_out == W_matlab_signal_de_bpsk_out)?1'b0:1'b1):1'b0;

// 验证rx_signal_de_interleave_out
reg [31:0] R_rx_signal_de_interleave_cnt;
always @(posedge R_clk or negedge W_rst_n_sync) begin
	if(~W_rst_n_sync)
		R_rx_signal_de_interleave_cnt <= 0;
	else begin
		if(R_rx_signal_de_interleave_cnt == 32'd47)
			R_rx_signal_de_interleave_cnt <= 32'd47; 
		else if(W_signal_de_interleave_out_valid)
			R_rx_signal_de_interleave_cnt <= R_rx_signal_de_interleave_cnt + 1; 
	end
end
wire W_matlab_signal_de_interleave_out = R_matlab_signal_de_interleave_out[R_rx_signal_de_interleave_cnt];
wire W_error_rx_signal_de_interleave_out = W_signal_de_interleave_out_valid?((W_signal_de_interleave_out == W_matlab_signal_de_interleave_out)?1'b0:1'b1):1'b0;

// 验证rx_data_de_qam16_out
reg [31:0] R_rx_data_de_qam16_cnt;
always @(posedge R_clk or negedge W_rst_n_sync) begin
	if(~W_rst_n_sync)
		R_rx_data_de_qam16_cnt <= 0;
	else begin
		if(R_rx_data_de_qam16_cnt == 32'd1343)
			R_rx_data_de_qam16_cnt <= 32'd1343; 
		else if(W_rx_data_de_qam16_out_valid)
			R_rx_data_de_qam16_cnt <= R_rx_data_de_qam16_cnt + 1; 
	end
end
wire W_matlab_data_de_qam16_out = R_matlab_data_de_qam16_out[R_rx_data_de_qam16_cnt];
wire W_error_rx_data_de_qam16_out = W_rx_data_de_qam16_out_valid?((W_rx_data_de_qam16_out == W_matlab_data_de_qam16_out)?1'b0:1'b1):1'b0;

// 验证rx_data_de_interleave_out
reg [31:0] R_rx_data_de_interleave_cnt;
always @(posedge R_clk or negedge W_rst_n_sync) begin
	if(~W_rst_n_sync)
		R_rx_data_de_interleave_cnt <= 0;
	else begin
		if(R_rx_data_de_interleave_cnt == 32'd1343)
			R_rx_data_de_interleave_cnt <= 32'd1343; 
		else if(W_rx_data_de_interleave_out_valid)
			R_rx_data_de_interleave_cnt <= R_rx_data_de_interleave_cnt + 1; 
	end
end
wire W_matlab_data_de_interleave_out = R_matlab_data_de_interleave_out[R_rx_data_de_interleave_cnt];
wire W_error_rx_data_de_interleave_out = W_rx_data_de_interleave_out_valid?((W_rx_data_de_interleave_out == W_matlab_data_de_interleave_out)?1'b0:1'b1):1'b0;

// 验证rx_viterbi217_out
reg [31:0] R_rx_signal_viterbi217_cnt;
always @(posedge R_clk or negedge W_rst_n_sync) begin
	if(~W_rst_n_sync)
		R_rx_signal_viterbi217_cnt <= 0;
	else if(W_clk_en_40M)begin
		if(R_rx_signal_viterbi217_cnt == 32'd35)
			R_rx_signal_viterbi217_cnt <= 32'd35; 
		else if(W_rx_signal_dec_bits_valid)
			R_rx_signal_viterbi217_cnt <= R_rx_signal_viterbi217_cnt + 1; 
	end
end
wire W_matlab_signal_viterbi217_out = R_matlab_signal_viterbi217_out[R_rx_signal_viterbi217_cnt];
wire W_error_rx_signal_dec_bits = W_rx_signal_dec_bits_valid?((W_rx_signal_dec_bits == W_matlab_signal_viterbi217_out)?1'b0:1'b1):1'b0;

reg [31:0] R_rx_data_viterbi217_cnt;
always @(posedge R_clk or negedge W_rst_n_sync) begin
	if(~W_rst_n_sync)
		R_rx_data_viterbi217_cnt <= 0;
	else if(W_clk_en_40M)begin
		if(R_rx_data_viterbi217_cnt == 32'd671)
			R_rx_data_viterbi217_cnt <= 32'd671; 
		else if(W_rx_data_dec_bits_valid)
			R_rx_data_viterbi217_cnt <= R_rx_data_viterbi217_cnt + 1; 
	end
end
wire W_matlab_data_viterbi217_out = R_matlab_data_viterbi217_out[R_rx_data_viterbi217_cnt];
wire W_error_rx_data_dec_bits = W_rx_data_dec_bits_valid?((W_rx_data_dec_bits == W_matlab_data_viterbi217_out)?1'b0:1'b1):1'b0;

// 验证rx_data_de_scramble_out
reg [31:0] R_rx_data_de_scramble_cnt;
always @(posedge R_clk or negedge W_rst_n_sync) begin
	if(~W_rst_n_sync)
		R_rx_data_de_scramble_cnt <= 0;
	else if(W_clk_en_40M)begin
		if(R_rx_data_de_scramble_cnt == 32'd567)
			R_rx_data_de_scramble_cnt <= 32'd567; 
		else if(W_rx_data_de_scramble_out_valid)
			R_rx_data_de_scramble_cnt <= R_rx_data_de_scramble_cnt + 1; 
	end
end
wire W_matlab_data_de_scramble_out = R_matlab_data_de_scramble_out[R_rx_data_de_scramble_cnt];
wire W_error_rx_data_de_scramble = W_rx_data_de_scramble_out_valid?((W_rx_data_de_scramble_out == W_matlab_data_de_scramble_out)?1'b0:1'b1):1'b0;

// Auto-stop after last compare point (for iverilog / batch sim)
initial begin
	wait(R_rx_data_de_scramble_cnt == 32'd567);
	#5000;
	$display("[%0t] RX TB done: de_scramble_cnt=%0d", $time, R_rx_data_de_scramble_cnt);
	$finish;
end

endmodule
