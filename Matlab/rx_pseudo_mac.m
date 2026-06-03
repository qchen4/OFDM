%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: RX伪MAC模块Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rx_pseudo_mac(rx_data_in,data_bytes_num)
    num_bits_per_char  = 8;
    rx_payload = '';
    for i=1:data_bytes_num
        one_char_bits = rx_data_in(num_bits_per_char*(i-1)+1 : num_bits_per_char*i);
        one_char_bits_str = num2str(one_char_bits');
        one_char_bits_str = erase(one_char_bits_str, ' ');
        one_char_ascii = bin2dec(one_char_bits_str);
        rx_payload(i) = char(one_char_ascii);  
    end
    disp(rx_payload)
end