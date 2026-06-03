%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 生成OFDM符号同步中相关模块的Verilog代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
close all

quan_12S7_pattern = quantizer('fixed','round','saturate',[12,7]);
fft_length = 64;

% 长训练序列的IFFT输入
long_train_seq = [ 1,  1, -1, -1,  1,  1, -1,  1, -1,  1,  1,  1,...
	  1,  1,  1, -1, -1,  1,  1, -1,  1, -1,  1,  1,  1,  1, 0,...
	  1, -1, -1,  1,  1, -1,  1, -1,  1, -1, -1, -1, -1, -1,...
	  1,  1, -1, -1,  1, -1,  1, -1,  1,  1,  1,  1]';
  
% 补零
long_train_seq_pad0 = [zeros(6,1); long_train_seq; zeros(5,1)]; 

%使用IFFT之前一定要用fftshift()函数把-26到-1号载波数据映射到IFFT的38到63号端口
long_train_seq_ifft = ifft(fftshift(long_train_seq_pad0),fft_length);

known_lts = long_train_seq_ifft;
known_lts = quantize(quan_12S7_pattern,known_lts);

known_lts_i = print_txt(real(known_lts),[12 7],'do_not_print_txt');
known_lts_q = print_txt(imag(known_lts),[12 7],'do_not_print_txt');

% 创建文件
filename = 'rx_symbol_sync_corr.v';
fid_a = fopen(filename,'w');

fprintf(fid_a, 'module rx_symbol_sync_corr(\n');
fprintf(fid_a, '\tinput [63:0] I_data_sign_i,\n');
fprintf(fid_a, '\tinput [63:0] I_data_sign_q,\n');
fprintf(fid_a, '\toutput [11:0] O_abs_Ck\n');
fprintf(fid_a, ');\n');
fprintf(fid_a, '\n');

fprintf(fid_a, 'reg [11:0] R_cmult_out_i[0:63];\n');
fprintf(fid_a, 'reg [11:0] R_cmult_out_q[0:63];\n');
fprintf(fid_a, '\n');

for k=0:length(known_lts)-1
    fprintf(fid_a, 'always @(*) begin\n');

    cmult_out = conj(known_lts(64-k)) * (1+1i);
    cmult_out = quantize(quan_12S7_pattern,cmult_out);
    cmult_out_i = print_txt(real(cmult_out),[12 7],'do_not_print_txt');
    cmult_out_q = print_txt(imag(cmult_out),[12 7],'do_not_print_txt');
    fprintf(fid_a, '\t// conj(lts)*(1+j)\n');
    fprintf(fid_a, '\tif((I_data_sign_i[%d]==0)&&(I_data_sign_q[%d]==0)) begin\n',k,k);
    fprintf(fid_a, '\t\tR_cmult_out_i[%d]<= %d;\n',k,cmult_out_i);
    fprintf(fid_a, '\t\tR_cmult_out_q[%d]<= %d;\n',k,cmult_out_q);
    fprintf(fid_a, '\tend\n');

    cmult_out = conj(known_lts(64-k)) * (1-1i);
    cmult_out = quantize(quan_12S7_pattern,cmult_out);
    cmult_out_i = print_txt(real(cmult_out),[12 7],'do_not_print_txt');
    cmult_out_q = print_txt(imag(cmult_out),[12 7],'do_not_print_txt');
    fprintf(fid_a, '\t// conj(lts)*(1-j)\n');
    fprintf(fid_a, '\telse if((I_data_sign_i[%d]==0)&&(I_data_sign_q[%d]==1)) begin\n',k,k);
    fprintf(fid_a, '\t\tR_cmult_out_i[%d]<= %d;\n',k,cmult_out_i);
    fprintf(fid_a, '\t\tR_cmult_out_q[%d]<= %d;\n',k,cmult_out_q);
    fprintf(fid_a, '\tend\n');

    cmult_out = conj(known_lts(64-k)) * (-1+1i);
    cmult_out = quantize(quan_12S7_pattern,cmult_out);
    cmult_out_i = print_txt(real(cmult_out),[12 7],'do_not_print_txt');
    cmult_out_q = print_txt(imag(cmult_out),[12 7],'do_not_print_txt');
    fprintf(fid_a, '\t// conj(lts)*(-1+j)\n');
    fprintf(fid_a, '\telse if((I_data_sign_i[%d]==1)&&(I_data_sign_q[%d]==0)) begin\n',k,k);
    fprintf(fid_a, '\t\tR_cmult_out_i[%d]<= %d;\n',k,cmult_out_i);
    fprintf(fid_a, '\t\tR_cmult_out_q[%d]<= %d;\n',k,cmult_out_q);
    fprintf(fid_a, '\tend\n');

    cmult_out = conj(known_lts(64-k)) * (-1-1i);
    cmult_out = quantize(quan_12S7_pattern,cmult_out);
    cmult_out_i = print_txt(real(cmult_out),[12 7],'do_not_print_txt');
    cmult_out_q = print_txt(imag(cmult_out),[12 7],'do_not_print_txt');
    fprintf(fid_a, '\t// conj(lts)*(-1-j)\n');
    fprintf(fid_a, '\telse begin\n');
    fprintf(fid_a, '\t\tR_cmult_out_i[%d]<= %d;\n',k,cmult_out_i);
    fprintf(fid_a, '\t\tR_cmult_out_q[%d]<= %d;\n',k,cmult_out_q);
    fprintf(fid_a, '\tend\n');

    fprintf(fid_a, 'end\n');
    fprintf(fid_a, '\n');
end

for k=0:63
    if(k==0)
        fprintf(fid_a, 'wire [11:0] W_Ck_i = R_cmult_out_i[0]+\n');
    elseif(k==63)
        fprintf(fid_a, '\t\t\t\t\tR_cmult_out_i[%d];\n',k);
    else
        fprintf(fid_a, '\t\t\t\t\tR_cmult_out_i[%d]+\n',k);
    end
end

fprintf(fid_a, '\n');

for k=0:63
    if(k==0)
        fprintf(fid_a, 'wire [11:0] W_Ck_q = R_cmult_out_q[0]+\n');
    elseif(k==63)
        fprintf(fid_a, '\t\t\t\t\tR_cmult_out_q[%d];\n',k);
    else
        fprintf(fid_a, '\t\t\t\t\tR_cmult_out_q[%d]+\n',k);
    end
end

fprintf(fid_a, '\n');
fprintf(fid_a, 'wire [11:0] W_abs_Ck_i=W_Ck_i[11]?-W_Ck_i:W_Ck_i;\n');
fprintf(fid_a, 'wire [11:0] W_abs_Ck_q=W_Ck_q[11]?-W_Ck_q:W_Ck_q;\n');

fprintf(fid_a, '\n');
fprintf(fid_a, 'wire [11:0] W_abs_Ck_max=(W_abs_Ck_i>=W_abs_Ck_q)?W_abs_Ck_i:W_abs_Ck_q;\n');
fprintf(fid_a, 'wire [11:0] W_abs_Ck_min=(W_abs_Ck_i< W_abs_Ck_q)?W_abs_Ck_i:W_abs_Ck_q;\n');

fprintf(fid_a, '\n');
fprintf(fid_a, 'wire [11:0] W_abs_Ck=W_abs_Ck_max-(W_abs_Ck_max>>4)+\n');
fprintf(fid_a, '\t\t\t\t\t\t(W_abs_Ck_min>>1)-(W_abs_Ck_min>>5);\n');

fprintf(fid_a, 'assign O_abs_Ck = W_abs_Ck;\n');
fprintf(fid_a, 'endmodule\n');

% 关闭文件
fclose(fid_a);