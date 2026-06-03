%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: Signal域BPSK解调算法
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rx_signal_de_bpsk_out = rx_signal_de_bpsk(rx_signal_de_bpsk_in)
	rx_signal_de_bpsk_out = zeros(length(rx_signal_de_bpsk_in),1);
	for k=1:length(rx_signal_de_bpsk_in)
		if(rx_signal_de_bpsk_in(k) > 0)
			rx_signal_de_bpsk_out(k) = 1;
		else
			rx_signal_de_bpsk_out(k) = 0;
		end
	end

	% 把rx_signal_de_bpsk_out写入.txt文件用来验证
    fid_a = fopen('./verify_txt/rx_signal_de_bpsk_out.txt','w');
	fprintf(fid_a, '%d\n', rx_signal_de_bpsk_out);
	fclose(fid_a);
end