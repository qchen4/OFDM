%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 信道模型的Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function channel_model_out = channel_model(channel_in,EbN0dB,freq_offset,phase_offset,delay,sample_rate)

fft_length            = 64;
data_carrier_num      = 48;
cyclic_prefix_length  = 16;

% Step1,给信号加高斯白噪声    
EsN0dB = EbN0dB + 10*log10((data_carrier_num)/(fft_length+cyclic_prefix_length)); 
SNR    = EsN0dB - 10*log10((data_carrier_num)/fft_length);
channel_noise_out = sqrt((fft_length+cyclic_prefix_length)/data_carrier_num)*awgn(channel_in,SNR,'measured'); 

% Step2,给信号加频偏和相偏
theta = phase_offset*pi/180;
offset_factor = exp(1i*(2*pi*freq_offset/sample_rate*(1:length(channel_noise_out))'+theta));
channel_offset_out = channel_noise_out .* offset_factor;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step3,IEEE802.11信道模型
t_rms = 10; % RMS时延扩展为10ns
Ts = 50; % 样本周期为50ns

% 计算FIR抽头个数
p_max = ceil(10*t_rms/Ts); 

% 计算sigma0
sigma0 =(1-exp(-Ts/t_rms))/(1-exp(-(p_max+1)*Ts/t_rms));

% 计算sigma_p
idx = 0:p_max;
sigma_p = sigma0*exp(-idx*Ts/t_rms);

% 产生复高斯随机变量hp
hp = (randn(1,length(sigma_p))+1i*randn(1,length(sigma_p)))/sqrt(2);

fir_h = hp.*sigma_p;

channel_fir_out = filter(fir_h,1,channel_offset_out);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step4,给信号加随机延时和尾部噪音
noise_min = -0.05;
noise_max = 0.05;

noise_i = (noise_max - noise_min)*rand(delay,1)+noise_min;
noise_q = (noise_max - noise_min)*rand(delay,1)+noise_min;
noise = noise_i + 1i*noise_q;

channel_model_out = [noise;channel_fir_out;noise]; 

quan_8S7_pattern = quantizer('fixed','round','saturate',[8,7]);
channel_model_out = quantize(quan_8S7_pattern,channel_model_out); 

% 把channel_model_out_i/q写入.txt文件用来验证
print_txt(real(channel_model_out),[8 7],'./verify_txt/channel_model_out_i.txt');
print_txt(imag(channel_model_out),[8 7],'./verify_txt/channel_model_out_q.txt');

end
