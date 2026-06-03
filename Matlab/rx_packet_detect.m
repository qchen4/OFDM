%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: OFDM信号检测Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [rx_data_out, packet_detected_done] = rx_packet_detect(rx_data_in,Md_threshold,Md_cnt_threshold)
quan_9S7_pattern = quantizer('fixed','round','saturate',[9 7]);

L = 16; %延时长度是一个短训练符号的长度16
Md = zeros(length(rx_data_in),1);
Pd = zeros(length(rx_data_in),1);
abs_Pd = zeros(length(rx_data_in),1);
Rd = zeros(length(rx_data_in),1);
rand_num = 0.3*rand(length(rx_data_in),1);

for i = 1:length(rx_data_in)-2*L
    rx_win_in = rx_data_in(i:i+2*L-1);
 
    Pd(i) = 0;
    Rd(i) = 0;
    for k = 1:16
        cmult_out = conj(rx_win_in(k)) * rx_win_in(k+L);
        cmult_out = quantize(quan_9S7_pattern,cmult_out);
        Pd(i) = Pd(i) + cmult_out;
    
        add_out = real(rx_win_in(k+L))^2 + imag(rx_win_in(k+L))^2;
        add_out = quantize(quan_9S7_pattern,add_out);
        Rd(i) = Rd(i) + add_out;
    end
    abs_Pd(i) = abs_fix(Pd(i),[13 7]);
	
    Md(i) = abs_Pd(i) / Rd(i);
	% 输出保护
	if(isnan(Md(i)))
		Md(i) = rand_num(i);
	end
end

Md_cnt=0;
out_idx=0;
for k=1:length(Md)
    if(Md(k)>Md_threshold)
        Md_cnt = Md_cnt + 1;
    else
        Md_cnt = 0;
    end

    if(Md_cnt==Md_cnt_threshold)
        packet_detected_done = 1;
        out_idx = k;
        break;
    end
end

% 这里是为了保证输出与RTL对齐，也就是为了保证下一级coarse_foc的输入
% 在matlab和Verilog里面一模一样，这样方便验证
idx_offset = Md_cnt_threshold + 4;
rx_data_out = rx_data_in((out_idx+idx_offset):end);

% 把abs_Pd和Rd写入.txt文件用来验证
print_txt(abs_Pd,[13 7],'./verify_txt/abs_Pd.txt');
print_txt(Rd,[13 7],'./verify_txt/Rd.txt');

% 画图
figure('Name','rx_packet_detect');
subplot(3,1,1)
plot(Md(1:460),'k')
title('Plot M(d)')
xlabel('RX Data')
ylabel('M(d)')

subplot(3,1,2)
plot(abs_Pd(1:460),'k')
title('Plot abs(P(d))')
xlabel('RX Data')
ylabel('abs(P(d))')

subplot(3,1,3)
plot(Rd(1:460),'k')
title('Plot R(d)')
xlabel('RX Data')
ylabel('R(d)')

print(gcf, 'Mn.png', '-dpng', '-r600');
end