%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能:Preamble加窗Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [preamble_win, lts_1st_data] = tx_preamble_add_window(preamble)
quan_14S13_pattern = quantizer('fixed','floor','saturate',[14,13]);

% 短训练序列和长训练序列第一个数据
sts_1st_data = preamble(1);
lts_1st_data = preamble(161);

new_sts_1st_data = sts_1st_data / 2;
new_sts_1st_data = quantize(quan_14S13_pattern,new_sts_1st_data);

new_lts_1st_data = (sts_1st_data + lts_1st_data)/2;
new_lts_1st_data = quantize(quan_14S13_pattern,new_lts_1st_data);

preamble_win = [new_sts_1st_data; preamble(2:160);
				new_lts_1st_data; preamble(162:320)];

quan_14S13_pattern = quantizer('fixed','round','saturate',[16,13]);
preamble_win = quantize(quan_14S13_pattern,preamble_win);
lts_1st_data = quantize(quan_14S13_pattern,lts_1st_data);

% 把preamble_win_i/q写入.txt文件用来验证
print_txt(real(preamble_win),[14 13],'./verify_txt/preamble_i.txt');
print_txt(imag(preamble_win),[14 13],'./verify_txt/preamble_q.txt');
end