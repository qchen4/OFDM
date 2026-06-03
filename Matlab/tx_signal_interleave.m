%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: Signal域数据交织Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function interleave_out = tx_signal_interleave(signal_bits)
    N_CBPS = 48;    
    bits_num = length(signal_bits);
    
    % 第一级交织
    stage0_out = zeros(bits_num,1);    
    stage0_buff = signal_bits(1:N_CBPS);
    for k=0:N_CBPS-1
        i = (N_CBPS/16)*(mod(k,16)) + floor(k/16); 
        stage0_out(i+1) = stage0_buff(k+1);
    end        
    interleave_out = stage0_out;

    % 把interleave_out写入.txt文件用来验证
    fid_a = fopen('./verify_txt/signal_interleave_out.txt','w');
	fprintf(fid_a, '%d\n', interleave_out);
	fclose(fid_a);
end