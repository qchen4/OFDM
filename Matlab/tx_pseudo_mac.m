%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 伪MAC模块的Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [signal_bits, payload_array, tail_bits_start_idx]= tx_pseudo_mac(payload_message)
    signal_bits = zeros(24,1);
    signal_rate = [1 0 0 1];

    % payload_message共有71个字节
    payload_length = length(payload_message);
    signal_length = double(dec2bin(payload_length,12))-48;
    
    signal_bits(1:4) = flip(signal_rate');
    signal_bits(6:17) = flip(signal_length');

    num_bits_per_char  = 8;
    num_bits_per_ofdm_symbol = 96;
    
    % 把字符串转化为bit数据，每个字符包含8bit
    msg_in_bits = double(dec2bin(payload_message, num_bits_per_char)');
    psdu_bits = msg_in_bits(:) - 48;

    service_bits = zeros(16,1);
    tail_bits = zeros(6,1);
    tail_bits_start_idx = length(service_bits)+length(psdu_bits)+1;

    payload_bits = [service_bits; psdu_bits; tail_bits];
   
    % 计算payload的OFDM符号个数
    num_ofdm_symbols = ceil(length(payload_bits)/num_bits_per_ofdm_symbol);
    
	% 计算最后一个OFDM符号补0的个数
    num_pad_bits = num_ofdm_symbols * num_bits_per_ofdm_symbol - length(payload_bits);   
    payload_bits = [payload_bits ; zeros(num_pad_bits,1)];

    % 把payload_bits写入.txt文件用来验证
    fid_a = fopen('./verify_txt/payload_bits.txt','w');
	fprintf(fid_a, '%d\n', payload_bits);
	fclose(fid_a);
    
	% 把所有的OFDM符号组成一个二维矩阵
    payload_array = zeros(num_bits_per_ofdm_symbol,num_ofdm_symbols);
    for k=1:num_ofdm_symbols
        one_ofdm_symbol_bits = payload_bits(num_bits_per_ofdm_symbol*(k-1)+1:num_bits_per_ofdm_symbol*k);
        payload_array(:,k) = one_ofdm_symbol_bits;
    end
end
