%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 生成DATA域解交织地址映射关系Matlab代码
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

N_CBPS = 192;
N_BPSC = 4;
s = max(N_BPSC/2,1);

filename = 'data_de_interleave_address_mapping.v';
fid_a = fopen(filename,'w');
fprintf(fid_a, 'reg [7:0] R_wr_addr\n');
fprintf(fid_a, 'always @(*) begin\n');
fprintf(fid_a, '\tcase(R_rx_bits_cnt)\n');
for j=0:N_CBPS-1
    %第一级解交织
    i = s*floor(j/s) + mod((j + floor(16*j/N_CBPS)),s);

    %第二级解交织
    k = 16*i - (N_CBPS-1)*floor(16*i/N_CBPS);

    if(j == N_CBPS-1)
        fprintf(fid_a, '\t\t//%d : begin R_wr_addr <= %d; end\n',j,k);
        fprintf(fid_a, '\t\tdefault : begin R_wr_addr <= %d; end\n',k);
    else
        fprintf(fid_a, '\t\t%d : begin R_wr_addr <= %d; end\n',j,k);
    end
end
fprintf(fid_a, '\tendcase\n');
fprintf(fid_a, 'end\n');
fclose(fid_a);