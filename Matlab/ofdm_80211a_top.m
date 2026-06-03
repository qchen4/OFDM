%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: IEEE802.11a协议 Matlab算法顶层模块
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc
close all

% 创建verify_txt的文件夹用来存放txt文件
folder_name = './verify_txt';
if exist(folder_name, 'dir') ~= 7
    mkdir(folder_name);
end

% payload_message一共有71个字符，每个字符8bit，相当于71个字节
payload_message= 'Let life be beautiful like summer flowers and death like autumn leaves.';

% 伪MAC
[signal_bits, data_array, tail_bits_start_idx] = tx_pseudo_mac(payload_message);

% Signal域数据卷积码编码
signal_conv_code = tx_signal_conv_encode(signal_bits);

% signal 交织
signal_interleave_out = tx_signal_interleave(signal_conv_code);

% signal bpsk 调制
signal_bpsk_out = tx_signal_bpsk(signal_interleave_out);

% data 扰码
init_state = [1 0 1 1 1 0 1];
data_scramble_out = tx_data_scramble(data_array,tail_bits_start_idx,init_state);

% DATA域数据卷积码编码
data_conv_code = tx_data_conv_encode(data_scramble_out);

% DATA域数据交织
data_interleave_out = tx_data_interleave(data_conv_code);

% DATA域数据16QAM符号映射
data_qam16_out = tx_data_qam16(data_interleave_out);  

% Signal域数据和DATA域数据合并
signal_data_out = [signal_bpsk_out data_qam16_out]; 

% 产生改变导频极性的扰码伪随机序列
init_state = [1 1 1 1 1 1 1];
pilot_scramble_out = tx_pilot_scramble(init_state); 

% 插入导频
pilot_insert_out = tx_pilot_insert(signal_data_out,pilot_scramble_out);

% 64点IFFT
tx_ifft64_out = tx_ifft64_burst(pilot_insert_out);

% 添加循环前缀(Cyclic Prefix, CP)
tx_cp_out = tx_add_cp(tx_ifft64_out);

%产生Preamble
preamble = tx_gen_preamble();

% Preamble加窗
[preamble_win,lts_1st_data] = tx_preamble_add_window(preamble);

% OFDM符号加窗(add window)
% lts_1st_data = -0.15625; % 16S13
% lts_1st_data_dec = print_txt(lts_1st_data,[16 13],'do_not_print_txt');
tx_add_win_out = tx_add_window(tx_cp_out,lts_1st_data);

% 产生TX PATH最终的输出数据
tx_ieee802a_out = tx_preamble_ofdm_combine(preamble_win,tx_add_win_out);

%固定随机数生成器的种子seed=12345，保证每次的随机噪音数据都一样
rng(12345,'twister')

% 可调整的信道参数
EbN0dB = 30;          % 信噪比(dB)
freq_offset = 170e3;  % 频率偏移(Hz)
phase_offset = 20;    % 相位偏移(Degrees)
delay = 180;          % 初始延时(Samples)
sample_rate = 20e6;   % 样本速率为20Mbps

% 给基带信号加上噪音,频偏和相偏,延时
channel_model_out = channel_model(tx_ieee802a_out,EbN0dB,freq_offset,phase_offset,delay,sample_rate);

% 保存指定的单个变量 'dataVector' 到文件
save("channel_model_out.mat","channel_model_out")


% OFDM包检测
% 经过检测，数据少了(193=1320-1127)个
Md_threshold = 0.75;
Md_cnt_threshold = 32;
[rx_packet_detect_out, packet_detected] = rx_packet_detect(channel_model_out,Md_threshold,Md_cnt_threshold);

if(packet_detected == 0)
    disp('No any ofdm packet was found!!!!!')
else
    % 粗频率补偿
    rx_coarse_foc_out = rx_coarse_foc(rx_packet_detect_out,sample_rate);

    % 符号同步
    symbol_sync_threshold = 7.5;
    rx_symbol_sync_out = rx_symbol_sync(rx_coarse_foc_out,symbol_sync_threshold);

    % 细频偏补偿
    rx_fine_foc_out = rx_fine_foc(rx_symbol_sync_out,sample_rate);
	
	% 移除循环前缀
	rx_data_ofdm_num = 7;
    rx_remove_cp_out = rx_remove_cp(rx_fine_foc_out,rx_data_ofdm_num);

	% FFT
    rx_fft64_out = rx_fft64_burst(rx_remove_cp_out);
	
	% 信道均衡
    rx_equalize_out = rx_equalize(rx_fft64_out);

    %相位跟踪
    [rx_phase_track_out,de_qam16_threshold] = rx_phase_track(rx_equalize_out);

    %移除导频
    rx_pilot_remove_out = rx_pilot_remove(rx_phase_track_out);

    %Signal域OFDM与DATA域OFDM分离
    rx_signal_ofdm = rx_pilot_remove_out(:,1);
    rx_data_ofdm = rx_pilot_remove_out(:,2:end);

    %Signal域BPSK解调
    rx_signal_de_bpsk_out = rx_signal_de_bpsk(rx_signal_ofdm);
	
	%Signal域解交织
    rx_signal_de_interleave_out = rx_signal_de_interleave(rx_signal_de_bpsk_out);
	
	%DATA域16-QAM解调
    rx_data_de_qam16_out = rx_data_de_qam16(rx_data_ofdm,de_qam16_threshold);

    %DATA域解交织
    rx_data_de_interleave_out = rx_data_de_interleave(rx_data_de_qam16_out);
	
	%Signal域OFDM与DATA域OFDM合并
    rx_signal_de_interleave_out = [rx_signal_de_interleave_out;zeros(24,1)];
    rx_signal_data_out = [rx_signal_de_interleave_out;rx_data_de_interleave_out];	
	
	% Signal域和DATA域(2,1,7)卷积码的Viterbi解码
	rx_signal_viterbi217_out = rx_viterbi217(rx_signal_de_interleave_out,'rx_signal_viterbi217_out.txt');
	rx_data_viterbi217_out = rx_viterbi217(rx_data_de_interleave_out,'rx_data_viterbi217_out.txt');

    % Signal域decode
    [data_rate_code,data_bytes_num,data_ofdm_num] = rx_signal_parse(rx_signal_viterbi217_out);

    % DATA域解扰
    rx_data_de_scramble_out = rx_data_de_scramble(rx_data_viterbi217_out,data_bytes_num); 

    % RX伪MAC模块
    rx_pseudo_mac(rx_data_de_scramble_out,data_bytes_num); 
end