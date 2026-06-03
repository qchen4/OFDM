%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: Signal域数据BPSK调制
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function signal_bpsk_out = tx_signal_bpsk(signal_interleave_bits)   
    bpsk_symbol = zeros(length(signal_interleave_bits),1);
    
    for k = 1 : length(signal_interleave_bits)
        if(signal_interleave_bits(k) == 1)
            bpsk_symbol(k) = (1 - 1/2^7) + 0*1i;
        else
            bpsk_symbol(k) = -1 + 0*1i;
        end
    end
    signal_bpsk_out = bpsk_symbol;
    quan_8S7_pattern = quantizer('fixed','round','saturate',[8,7]);
    signal_bpsk_out = quantize(quan_8S7_pattern,signal_bpsk_out);

    print_txt(signal_bpsk_out,[8 7],'./verify_txt/signal_bpsk_out_i.txt');
end