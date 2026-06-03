%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: signal域数据解交织Matlab算法顶层模块
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function de_interleave_out = rx_signal_de_interleave(signal_bits)
    N_CBPS = 48;    
    bits_num = length(signal_bits);
    
    % 第一级解交织
    stage0_out = zeros(bits_num,1);    
    stage0_buff = signal_bits(1:N_CBPS);
    for i=0:N_CBPS-1
        k = 16*i-(N_CBPS-1)*floor(16*i/N_CBPS); 
        stage0_out(k+1) = stage0_buff(i+1);
    end        
    de_interleave_out = stage0_out;

    % 把de_interleave_out写入.txt文件用来验证
    fid_a = fopen('./verify_txt/rx_signal_de_interleave_out.txt','w');
	fprintf(fid_a, '%d\n', de_interleave_out);
	fclose(fid_a);
end