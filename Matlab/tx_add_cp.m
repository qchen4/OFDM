%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 添加循环前缀(Cyclix Prefix,CP)Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tx_cp_out = tx_add_cp(tx_cp_in)
    [row,col] = size(tx_cp_in);

    tx_cp_out = zeros(row+row/4,col);
    for k = 1:col
        tx_cp_out(1:16,k) = tx_cp_in(49:64,k);
        tx_cp_out(17:80,k) = tx_cp_in(:,k);
        
        quan_14S13_pattern = quantizer('fixed','round','saturate',[14,13]);
        tx_cp_out(:,k) = quantize(quan_14S13_pattern,tx_cp_out(:,k));
    end
end