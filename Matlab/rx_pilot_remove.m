%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 移除导频Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rx_pilot_remove_out = rx_pilot_remove(rx_data_in)
[row,col] = size(rx_data_in);
rx_pilot_remove_out = zeros(row-16,col);

for i = 1:col
    for k=0:63
        if(k>=38 && k<=42)
            Rk = k - 38; 	% 4 >= Rk >= 0
        elseif(k>=44 && k<=56)
            Rk = k - 39; 	% 17 >= Rk >= 5
        elseif(k>=58 && k<=63)
            Rk = k - 40; 	% 23 >= Rk >= 18 
        elseif(k>=1 && k<=6)
            Rk = k + 23; 	% 29 >= Rk >= 24    
        elseif(k>=8 && k<=20)
            Rk = k + 22; 	% 42 >= Rk >= 30  
        elseif(k>=22 && k<=26)
            Rk = k + 21; 	% 47 >= Rk >= 43 
        end
    
        if(k==43 || k==57 || k==7 || k==21)
            pilot_str = 'pilot position';
        elseif((k>=27 && k<=37)||(k==0))
            null_str = 'zero position';
        else
            rx_pilot_remove_out(Rk+1,i) = rx_data_in(k+1,i); 
        end
    end
end

% 把rx_pilot_remove_out_i/q转化为列向量写入.txt文件用来验证
rx_pilot_remove_out_txt_i = reshape(real(rx_pilot_remove_out),[],1);
print_txt(rx_pilot_remove_out_txt_i,[14 7],'./verify_txt/rx_pilot_remove_out_i.txt');
rx_pilot_remove_out_txt_q = reshape(imag(rx_pilot_remove_out),[],1);
print_txt(rx_pilot_remove_out_txt_q,[14 7],'./verify_txt/rx_pilot_remove_out_q.txt');
end