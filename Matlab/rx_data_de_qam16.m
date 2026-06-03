%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: DATA域数据16QAM解调Matlab算法
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rx_de_qam16_out = rx_data_de_qam16(rx_de_qam16_in,threshold)
[row,col] = size(rx_de_qam16_in);

rx_de_qam16_out = zeros(row*4,col);
for k=1:col
    rx_de_qam16_i = real(rx_de_qam16_in(:,k));
    rx_de_qam16_q = imag(rx_de_qam16_in(:,k));
     
    for i=1:length(rx_de_qam16_i)
        symbol = zeros(1,4);
    
        if(rx_de_qam16_i(i) < -1*threshold(k)) 
            symbol(1:2) = [0 0];
        elseif(rx_de_qam16_i(i) >= -1*threshold(k) && rx_de_qam16_i(i) < 0) 
            symbol(1:2) = [0 1];
        elseif(rx_de_qam16_i(i) >= 0 && rx_de_qam16_i(i) < threshold(k)) 
            symbol(1:2) = [1 1];
        else %if(rx_qam16_i >= threshold) 
            symbol(1:2) = [1 0];
        end
    
        if(rx_de_qam16_q(i) < -1*threshold(k)) 
            symbol(3:4) = [0 0];
        elseif(rx_de_qam16_q(i) >= -1*threshold(k) && rx_de_qam16_q(i) < 0) 
            symbol(3:4) = [0 1];
        elseif(rx_de_qam16_q(i) >= 0 && rx_de_qam16_q(i) < threshold(k)) 
            symbol(3:4) = [1 1];
        else %if(rx_qam16_q >= threshold) 
            symbol(3:4) = [1 0];
        end
    
        rx_de_qam16_out(4*i-3:4*i,k) = symbol';    
    end
end

% 把rx_de_qam16_out转化为列向量写入.txt文件用来验证
rx_de_qam16_out_bits = reshape(rx_de_qam16_out,row*4*col,1);
fid_a = fopen('./verify_txt/rx_data_de_qam16_out.txt','w');
fprintf(fid_a, '%d\n', rx_de_qam16_out_bits);
fclose(fid_a);
end