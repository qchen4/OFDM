%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: DATA域数据交织Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data_interleave_out = tx_data_interleave(data_bits)
    N_CBPS = 192;
    N_BPSC = 4;

    row = N_CBPS;
    col = length(data_bits)/N_CBPS;
    data_array = reshape(data_bits,row,col);
    
    data_interleave_out = zeros(row,col);    
    for n = 1:col
        one_ofdm_bits = data_array(:,n);
        bits_num = length(one_ofdm_bits);
        
        % 第一级交织
        stage0_out = zeros(bits_num,1);   
        stage0_buff = one_ofdm_bits;
        for k=0:N_CBPS-1
            i = (N_CBPS/16)*(mod(k,16)) + floor(k/16); 
            stage0_out(i+1) = stage0_buff(k+1);
        end    
        
        % 第二级交织
        s = max(N_BPSC/2,1);
        stage1_out = zeros(bits_num,1);
        stage1_buff = stage0_out;
        for i=0:N_CBPS-1
            j = s*floor(i/s) + mod((i+N_CBPS-floor(16*i/N_CBPS)),s); 
            stage1_out(j+1) = stage1_buff(i+1);
        end        
        data_interleave_out(:,n) = stage1_out;
    end
   
    % 把data_interleave_out转化为列向量写入.txt文件用来验证
    data_interleave_bits = reshape(data_interleave_out,row*col,1);
    fid_a = fopen('./verify_txt/data_interleave_out.txt','w');
	fprintf(fid_a, '%d\n', data_interleave_bits);
	fclose(fid_a);
end