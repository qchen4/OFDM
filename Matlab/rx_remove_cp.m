%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 移除循环前缀Matlab代码
% 作者: 柳井刚
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计》随书代码，所有代码均由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rx_remove_cp_out = rx_remove_cp(rx_data_in,rx_data_ofdm_num)

lts_start_point = 17;
lts1 = rx_data_in(lts_start_point : lts_start_point+63);
lts2 = rx_data_in(lts_start_point+64 : lts_start_point+127);

signal_cp = rx_data_in(lts_start_point+128 : lts_start_point+143);
signal_ofdm = rx_data_in(lts_start_point+144 : lts_start_point+207);

data_start_point = lts_start_point + 208;
data_array = zeros(80,rx_data_ofdm_num);
data_ofdm = zeros(64,rx_data_ofdm_num);
for k=1:rx_data_ofdm_num
    data_array(:,k) = rx_data_in(data_start_point+80*(k-1):data_start_point+79+80*(k-1));
    data_ofdm(:,k) = data_array(17:end,k);
end

rx_remove_cp_out = [lts1,lts2,signal_ofdm,data_ofdm];

% 把rx_remove_cp_out_i/q转化为列向量写入.txt文件用来验证
rx_remove_cp_out_i = reshape(real(rx_remove_cp_out),[],1);
print_txt(rx_remove_cp_out_i,[8 7],'./verify_txt/rx_remove_cp_out_i.txt');
rx_remove_cp_out_q = reshape(imag(rx_remove_cp_out),[],1);
print_txt(rx_remove_cp_out_q,[8 7],'./verify_txt/rx_remove_cp_out_q.txt');
end
