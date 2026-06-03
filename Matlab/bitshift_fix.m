%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 对定点数据进行移位
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function new_data = bitshift_fix(a_fix, k, format)
    a_int = a_fix * 2^(format(2)) ;
    a_int_shift = bitshift(a_int,k,"int16");

    data = a_int_shift;

    data_bin = dec2bin(data,format(1));
    
    data_bin_int = data_bin(1:(format(1) - format(2)));
    data_bin_frac = data_bin((format(1) - format(2)+1):end);

    if(data_bin_int(1) == '0')
        new_data_int = bin2dec(data_bin_int);
    else
        new_data_int = bin2dec(data_bin_int) - 2^(format(1) - format(2));
    end

    new_data_frac = bin2dec(data_bin_frac) / 2^(format(2));

    new_data = new_data_int + new_data_frac;
end