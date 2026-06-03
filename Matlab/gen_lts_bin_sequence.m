%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 生成长训练符号的二进制序列
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc

ideal_lts = [1,  1, -1, -1,  1,  1, -1,  1, -1,  1,  1,  1,...
	         1,  1,  1, -1, -1,  1,  1, -1,  1, -1,  1,  1,  1,  1, 0,...
	         1, -1, -1,  1,  1, -1,  1, -1,  1, -1, -1, -1, -1, -1,...
	         1,  1, -1, -1,  1, -1,  1, -1,  1,  1,  1,  1]';
ideal_lts_pad0 = [zeros(6,1);ideal_lts;zeros(5,1)]; 
ideal_lts_pad0 = fftshift(ideal_lts_pad0); 

ideal_lts_bin = zeros(length(ideal_lts_pad0),1);
for i=1:length(ideal_lts_pad0)
    if(ideal_lts_pad0(i) == 1)
        ideal_lts_bin(i) = 1;
    else
        ideal_lts_bin(i) = 0;
    end
end

ideal_lts_flip = flip(ideal_lts_bin');
ideal_lts_str = num2str(ideal_lts_flip);
ideal_lts_str = erase(ideal_lts_str, ' ');

hex_str1 = bin2hex(ideal_lts_str(1:32),8); % 转换为十六进制字符串
hex_str2 = bin2hex(ideal_lts_str(33:64),8); % 转换为十六进制字符串
disp([hex_str1,hex_str2]); % 显示结果

function hex_str = bin2hex(bin_str,min_digits)
    % 将二进制字符串转换为十进制数
    dec_num = bin2dec(bin_str);
    
    % 将十进制数转换为十六进制字符串
    hex_str = dec2hex(dec_num,min_digits);
end