%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 信道均衡Matlab算法顶层模块
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rx_equalize_out = rx_equalize(rx_data_in)
quan_14S7_pattern = quantizer('fixed','round','saturate',[14,7]);

[row, col] = size(rx_data_in);
signal_data_ofdm_num = col - 2;% 1 signal ofdm + 7 data ofdm

% 长训练序列的IFFT输入
ideal_lts = [ 1,  1, -1, -1,  1,  1, -1,  1, -1,  1,  1,  1,...
	  1,  1,  1, -1, -1,  1,  1, -1,  1, -1,  1,  1,  1,  1, 0,...
	  1, -1, -1,  1,  1, -1,  1, -1,  1, -1, -1, -1, -1, -1,...
	  1,  1, -1, -1,  1, -1,  1, -1,  1,  1,  1,  1]';
  
% 补零
ideal_lts_pad0 = [zeros(6,1); ideal_lts; zeros(5,1)]; 
ideal_lts_pad0 = fftshift(ideal_lts_pad0); 

rx_lts1 = rx_data_in(:,1);
rx_lts2 = rx_data_in(:,2);

rx_lts_mean = zeros(length(rx_lts1),1);
chan_est = zeros(length(rx_lts1),1);
for i=1:length(rx_lts_mean)
    rx_lts_mean(i) = (rx_lts1(i)+rx_lts2(i))/2;	
	quan_14S7_pattern_floor = quantizer('fixed','floor','saturate',[14,7]);
    rx_lts_mean(i) = quantize(quan_14S7_pattern_floor,rx_lts_mean(i));

	% 信道估计 
    chan_est(i) = rx_lts_mean(i)*conj(ideal_lts_pad0(i)); 
end
chan_est = quantize(quan_14S7_pattern,chan_est);

rx_equalize_out = zeros(64,signal_data_ofdm_num);
for k=1:signal_data_ofdm_num
    rx_ofdm_symbol = rx_data_in(:,k+2);

    % 信道均衡
    rx_equalize_out(:,k) = rx_ofdm_symbol.*conj(chan_est);	
end
rx_equalize_out = quantize(quan_14S7_pattern,rx_equalize_out);

% 画图
figure('Name','rx_equalize');
subplot(3,2,1)
plot_scatter(rx_data_in(:,3))
subplot(3,2,2)
plot_scatter(rx_equalize_out(:,1))
subplot(3,2,3)
plot_scatter(rx_data_in(:,4))
subplot(3,2,4)
plot_scatter(rx_equalize_out(:,2))
subplot(3,2,5)
plot_scatter(rx_data_in(:,10))
subplot(3,2,6)
plot_scatter(rx_equalize_out(:,8))

print(gcf, 'rx_equalize.png', '-dpng', '-r600');

% 把rx_equalize_out_i/q转化为列向量写入.txt文件用来验证
rx_equalize_out_txt_i = reshape(real(rx_equalize_out),[],1);
print_txt(rx_equalize_out_txt_i,[14 7],'./verify_txt/rx_equalize_out_i.txt');
rx_equalize_out_txt_q = reshape(imag(rx_equalize_out),[],1);
print_txt(rx_equalize_out_txt_q,[14 7],'./verify_txt/rx_equalize_out_q.txt');
end

function plot_scatter(data_in)
	scatter(real(data_in),imag(data_in),10,"filled",'k')
	max_i = max(abs(real(data_in)));
	max_q = max(abs(imag(data_in)));
	max_iq = max([max_i,max_q])+0.1;
	xlim([-max_iq, max_iq]); % 设置x轴范围
	ylim([-max_iq, max_iq]); % 设置y轴范围
	xlabel('I')
	ylabel('Q')
end
