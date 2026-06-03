%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 粗频偏估计与补偿Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rx_coarse_foc_out = rx_coarse_foc(rx_data_in,sample_rate)
quan_8S7_pattern = quantizer('fixed','round','saturate',[8 7]);
quan_9S7_pattern = quantizer('fixed','round','saturate',[9 7]);
quan_13S7_pattern = quantizer('fixed','round','saturate',[13 7]);
quan_16S13_pattern = quantizer('fixed','round','saturate',[16 13]);
quan_19S13_pattern = quantizer('fixed','round','saturate',[19 13]);
quan_8S6_pattern = quantizer('fixed','round','saturate',[8 6]);

rx_data_in = quantize(quan_8S7_pattern,rx_data_in);

L = 16; %短训练符号长度

rx_win_in = rx_data_in(1:2*L);
Pk = 0;
for k = 1:L
	cmult_out = conj(rx_win_in(k)) * rx_win_in(k+L);
	cmult_out = quantize(quan_9S7_pattern,cmult_out);
	Pk = Pk + cmult_out;  
end
Pk = quantize(quan_13S7_pattern,Pk); %13S7

% 将Pk的实部和虚部值限制在(-1,1)范围内，这样可避免CORDIC算法溢出
abs_Pk_i = abs(real(Pk));
abs_Pk_q = abs(imag(Pk));
if(abs_Pk_i > abs_Pk_q)
    abs_Pk_max = abs_Pk_i;
else
    abs_Pk_max = abs_Pk_q;
end

if((abs_Pk_max > 0 && abs_Pk_max <= 1))
    Pk_19S13 = quantize(quan_19S13_pattern,Pk); %19S13
elseif((abs_Pk_max > 1 && abs_Pk_max <= 2))
    Pk_19S13 = quantize(quan_19S13_pattern,Pk/2); %19S13
elseif((abs_Pk_max > 2 && abs_Pk_max <= 4))
    Pk_19S13 = quantize(quan_19S13_pattern,Pk/4); %19S13
elseif((abs_Pk_max > 4 && abs_Pk_max <= 8))
    Pk_19S13 = quantize(quan_19S13_pattern,Pk/8); %19S13    
elseif((abs_Pk_max > 8 && abs_Pk_max <= 16))
    Pk_19S13 = quantize(quan_19S13_pattern,Pk/16); %19S13  
elseif((abs_Pk_max > 16 && abs_Pk_max <= 32))
    Pk_19S13 = quantize(quan_19S13_pattern,Pk/32); %19S13  
else
    Pk_19S13 = quantize(quan_19S13_pattern,Pk); %19S13      
end

% 将Pk四舍五入饱和处理为16S13
Pk_16S13 = quantize(quan_16S13_pattern,Pk_19S13); %16S13;

% Pk_phi = angle(Pk);
Pk_phi = cordic_arctan_fix(Pk_16S13);
Pk_phi = quantize(quan_16S13_pattern,Pk_phi); %16S13

scale_factor = sample_rate/(2*pi*L);
quan_19S0_pattern = quantizer('fixed','round','saturate',[19 0]);
scale_factor = quantize(quan_19S0_pattern,scale_factor); %19S0

% delta_f = theta*sample_rate/(2*pi*L)
coarse_estimate_freq = Pk_phi*scale_factor;
quan_22S0_pattern = quantizer('fixed','round','saturate',[22 0]);
coarse_estimate_freq = quantize(quan_22S0_pattern,coarse_estimate_freq);
fprintf('coarse_estimate_freq = %d\n',coarse_estimate_freq)

% 使用移位的方式将Pk_phi除以16得到相位累加因子
Pk_phi_div16 = coarse_foc_phi_div16(Pk_phi,[16 13]);
Pk_phi_div16 = quantize(quan_16S13_pattern,Pk_phi_div16);

pi_16S13 = quantize(quan_16S13_pattern,pi); %16S13

cordic_cos = zeros(length(rx_data_in),1);
cordic_sin = zeros(length(rx_data_in),1);
comp_item = zeros(length(rx_data_in),1);
acc_phase = 0; % 16S13
for i=1:length(rx_data_in)
    [cordic_sin(i),cordic_cos(i)] = cordic_sincos_fix(acc_phase);
    comp_item(i) = cordic_cos(i) + 1i*cordic_sin(i);
    comp_item(i) = quantize(quan_8S6_pattern,comp_item(i));

    acc_phase = -Pk_phi_div16 + acc_phase;
    if(acc_phase > pi_16S13)
        acc_phase = acc_phase - 2*pi_16S13;
    elseif(acc_phase < -pi_16S13)
        acc_phase = 2*pi_16S13 + acc_phase;
    end
    acc_phase = quantize(quan_16S13_pattern,acc_phase); 
end

rx_coarse_foc_out = rx_data_in .* comp_item;
rx_coarse_foc_out = quantize(quan_9S7_pattern,rx_coarse_foc_out);
print_txt(real(rx_coarse_foc_out),[9 7],'./verify_txt/rx_coarse_foc_out_i.txt');
print_txt(imag(rx_coarse_foc_out),[9 7],'./verify_txt/rx_coarse_foc_out_q.txt');

% 画图
figure('Name','rx_coarse_foc');
subplot(2,2,1)
plot(real(rx_data_in(1:80)),'k')
title('Plot rx\_data\_in\_i')
xlabel('RX Data')
ylabel('rx\_data\_in\_i')

subplot(2,2,2)
plot(imag(rx_data_in(1:80)),'k')
title('Plot rx\_data\_in\_q')
xlabel('RX Data')
ylabel('rx\_data\_in\_q')

subplot(2,2,3)
plot(real(rx_coarse_foc_out(1:80)),'k')
title('Plot rx\_coarse\_foc\_out\_i')
xlabel('RX Data')
ylabel('rx\_coarse\_foc\_out\_i')

subplot(2,2,4)
plot(imag(rx_coarse_foc_out(1:80)),'k')
title('Plot rx\_coarse\_foc\_out\_q')
xlabel('RX Data')
ylabel('rx\_coarse\_foc\_out\_q')

print(gcf, 'rx_coarse_foc.png', '-dpng', '-r600');
end