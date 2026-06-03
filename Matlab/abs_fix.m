%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 使用Max-Min算法求解复数的模
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function abs_data = abs_fix(data,format)
    quan_pattern = quantizer('fixed','round','saturate',format);

    abs_data_i = abs(real(data));
    abs_data_q = abs(imag(data));
    
    max_abs_data = max(abs_data_i,abs_data_q);
    min_abs_data = min(abs_data_i,abs_data_q);
    
    % abs_data = (15/16)*max_abs_data + (15/32)*min_abs_data;
    abs_data =  bitshift_fix(max_abs_data, 0, format) - ...
                bitshift_fix(max_abs_data, -4, format) + ...
                bitshift_fix(min_abs_data, -1, format) - ...
                bitshift_fix(min_abs_data, -5, format);
    
    abs_data = quantize(quan_pattern,abs_data);
end