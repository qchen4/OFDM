%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 64点IFFT中定点数据右移6bit实现除以64
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data_out = ifft_right_shift6(data_in_fix, input_format, output_format)

data_in_integer = data_in_fix * 2^(input_format(2)) ;
data_in_complement = zeros(length(data_in_integer),1);
data_out = zeros(length(data_in_integer),1);

% 把量化后的data_in_fix转化为补码
for i = 1:length(data_in_complement)
   if(data_in_integer(i) < 0)
       data_in_complement(i) = 2^(input_format(1)) + data_in_integer(i) ;
   else
       data_in_complement(i) = data_in_integer(i) ;
   end

   data_bin = dec2bin(data_in_complement(i),output_format(1));
    
   data_bin_int = data_bin(1:(output_format(1) - output_format(2)));
   data_bin_frac = data_bin((output_format(1) - output_format(2)+1):end);
    
   if(data_bin_int(1) == '0')
       data_out_int = bin2dec(data_bin_int);
   else
       data_out_int = bin2dec(data_bin_int) - 2^(output_format(1) - output_format(2));
   end
    
   data_out_frac = bin2dec(data_bin_frac) / 2^(output_format(2));
   data_out(i) = data_out_int + data_out_frac;
end
