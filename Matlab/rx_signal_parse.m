%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: signal域数据解析 Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [data_rate_code,data_bytes_num,data_ofdm_num] = rx_signal_parse(signal_bits)
	num_bits_per_ofdm_symbol = 96;

	data_rate_code = signal_bits(1:4)';

    data_length = flip(signal_bits(6:17));
    data_length_str = num2str(data_length');
    data_length_str = erase(data_length_str, ' ');
    data_bytes_num = bin2dec(data_length_str);
	
	% 计算payload的OFDM符号个数
	service_length = 16;
	psdu_length = data_bytes_num * 8;
	tail_length = 6;
	
	payload_length = service_length + psdu_length + tail_length;
	data_ofdm_num = ceil(payload_length/num_bits_per_ofdm_symbol);
end