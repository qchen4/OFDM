%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: OFDM符号同步Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rx_symbol_sync_out = rx_symbol_sync(rx_data_in,symbol_sync_threshold)

quan_12S7_pattern = quantizer('fixed','round','saturate',[12,7]);
quan_9S7_pattern = quantizer('fixed','round','saturate',[9,7]);
fft_length = 64;
D = 64; %延时长度

rx_data_in = quantize(quan_9S7_pattern,rx_data_in);

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

Ck = zeros(length(rx_data_in),1);
abs_Ck = zeros(length(rx_data_in),1);

rx_win_in_sign = zeros(length(rx_data_in),1);
for i = 1:(length(rx_data_in)-D)
    rx_win_in = rx_data_in(i:i+D-1);
    for k=1:length(rx_win_in)
        if(real(rx_win_in(k)) >= 0)
            rx_win_in_i_sign = 1;
        else
            rx_win_in_i_sign = -1;
        end
        if(imag(rx_win_in(k)) >= 0)
            rx_win_in_q_sign = 1;
        else
            rx_win_in_q_sign = -1;
        end
        rx_win_in_sign(k) = rx_win_in_i_sign + 1i*rx_win_in_q_sign;
    end
 
    Ck(i) = 0;
    for k = 1:D 
        cmult_out = conj(known_lts(k)) * rx_win_in_sign(k);
        cmult_out = quantize(quan_12S7_pattern,cmult_out);
        Ck(i) = Ck(i) + cmult_out;  
    end
    Ck(i) = quantize(quan_12S7_pattern,Ck(i));	
    abs_Ck(i) = abs_fix(Ck(i),[12 7]);
end

abs_Ck = quantize(quan_12S7_pattern,abs_Ck);
print_txt(abs_Ck,[12 7],'./verify_txt/rx_symbol_sync_abs_Ck.txt');

figure('Name','rx_symbol_sync');
plot(real(abs_Ck(1:270)),'k')
title('Plot abs(C(k))')
xlabel('rx\_data')
ylabel('abs(C(k))')

print(gcf, 'abs_Ck_L64.png', '-dpng', '-r600');

find_peak1 = 0;
find_peak2 = 0;
peak1_position = 0;
peak2_position = 0;
for k=1:length(abs_Ck)
    if((find_peak1==0)&&(abs_Ck(k) > symbol_sync_threshold))
        peak1_position = k;
        find_peak1 =1;
        continue;
    elseif((find_peak1==1)&&(abs_Ck(k) > symbol_sync_threshold))
        peak2_position = k;
        find_peak2 =1;
        continue;
    end
end

if((find_peak2 == 1) && (peak2_position - peak1_position == 64))
	%第一个LTS的第一个数往前推16个数，这里是为了和RTL一致
	out_start_idx = peak1_position-16; 

	rx_symbol_sync_out = rx_data_in(out_start_idx:end);
	print_txt(real(rx_symbol_sync_out),[9 7],'./verify_txt/rx_symbol_sync_out_i.txt');
	print_txt(imag(rx_symbol_sync_out),[9 7],'./verify_txt/rx_symbol_sync_out_q.txt');
else
	error("rx_symbol_sync failed!!!")
end

end
