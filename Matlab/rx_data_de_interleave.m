%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: DATA域数据解交织Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rx_data_de_interleave_out = rx_data_de_interleave(rx_data_de_interleave_in)
N_CBPS = 192;
N_BPSC = 4;

[row,col] = size(rx_data_de_interleave_in);

rx_data_de_interleave_out = zeros(row,col);
for ofdm_idx = 1:col
    rx_bits = rx_data_de_interleave_in(:,ofdm_idx);
    bits_num = length(rx_bits);
    s = max(N_BPSC/2,1);

    %第一级解交织
    stage0_out = zeros(bits_num,1);
    stage0_buff = rx_bits;
    for j=0:N_CBPS-1
        i = s*floor(j/s) + mod((j + floor(16*j/N_CBPS)),s);
        stage0_out(i+1) = stage0_buff(j+1);
    end
    
    %第二级解交织
    stage1_out = zeros(bits_num,1);
    stage1_buff = stage0_out;
    for i=0:N_CBPS-1
        k = 16*i - (N_CBPS-1)*floor(16*i/N_CBPS);
        stage1_out(k+1) = stage1_buff(i+1);
    end
    
    rx_data_de_interleave_out(:,ofdm_idx) = stage1_out;
end
rx_data_de_interleave_out = reshape(rx_data_de_interleave_out,row*col,1);

fid_a = fopen('./verify_txt/rx_data_de_interleave_out.txt','w');
fprintf(fid_a, '%d\n', rx_data_de_interleave_out);
fclose(fid_a);
end