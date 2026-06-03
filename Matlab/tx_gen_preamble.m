%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能:产生长训练序列和短训练序列Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function preamble = tx_gen_train_sequence()

fft_length=64;

% 短训练序列的IFFT输入
short_train_seq = ...
	[ 0    0  1+1i 0  0    0 -1-1i 0  0    0 ...                % [-26: -17]
	  1+1i 0  0    0 -1-1i 0  0    0 -1-1i 0 0 0 1+1i 0 0 0 ... % [-16: -1 ]
	  0    0  0    0 -1-1i 0  0    0 -1-1i 0 0 0 1+1i 0 0 0 ... % [ 0 :  15]
	  1+1i 0  0    0  1+1i 0  0    0  1+1i 0 0 ].';             % [ 16:  26]
  
% 补零
short_train_seq_pad0 =	[zeros(6,1); sqrt(13/6)*short_train_seq; zeros(5,1)]; 

%使用IFFT之前一定要用fftshift()函数把-26到-1号载波数据映射到IFFT的38到63号端口
short_train_seq_ifft = ifft(fftshift(short_train_seq_pad0),fft_length);

% 使用16S13格式的数据量化
quan_16S13_pattern = quantizer('fixed','round','saturate',[16,13]);
short_train_seq_ifft_16S13 = quantize(quan_16S13_pattern,short_train_seq_ifft);

% 长训练序列的IFFT输入
long_train_seq = [ 1,  1, -1, -1,  1,  1, -1,  1, -1,  1,  1,  1,...
	  1,  1,  1, -1, -1,  1,  1, -1,  1, -1,  1,  1,  1,  1, 0,...
	  1, -1, -1,  1,  1, -1,  1, -1,  1, -1, -1, -1, -1, -1,...
	  1,  1, -1, -1,  1, -1,  1, -1,  1,  1,  1,  1]';
  
% 补零
long_train_seq_pad0 =	[zeros(6,1); long_train_seq; zeros(5,1)]; 

%使用IFFT之前一定要用fftshift()函数把-26到-1号载波数据映射到IFFT的38到63号端口
long_train_seq_ifft = ifft(fftshift(long_train_seq_pad0),fft_length);

quan_16S13_pattern = quantizer('fixed','round','saturate',[16,13]);
long_train_seq_ifft_16S13 = quantize(quan_16S13_pattern,long_train_seq_ifft);
 
% preamble由短训练序列和长训练序列拼接而成
preamble = [short_train_seq_ifft_16S13; ...
		   short_train_seq_ifft_16S13; ...
		   short_train_seq_ifft_16S13(1:end/2); ...
		   long_train_seq_ifft_16S13(end/2+1:end); ...
		   long_train_seq_ifft_16S13; ...
		   long_train_seq_ifft_16S13];		       
end