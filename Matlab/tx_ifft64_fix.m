%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 64点IFFT定点Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ifft_out = tx_ifft64_fix(ifft_in)

quan_8S7_pattern = quantizer('fixed','round','saturate',[8,7]);
quan_9S7_pattern = quantizer('fixed','round','saturate',[9,7]);
quan_10S7_pattern = quantizer('fixed','round','saturate',[10,7]);
quan_11S7_pattern = quantizer('fixed','round','saturate',[11,7]);
quan_13S7_pattern = quantizer('fixed','round','saturate',[13,7]);
quan_14S7_pattern = quantizer('fixed','round','saturate',[14,7]);
quan_14S13_pattern = quantizer('fixed','round','saturate',[14,13]);

% 交换ifft_in的实部和虚部
ifft_in_swap = imag(ifft_in) + 1i*real(ifft_in);

% 把ifft_in_swap使用8S7数据格式量化
ifft_in_swap = quantize(quan_8S7_pattern,ifft_in_swap); 

%%%%%%%%%% stage0 %%%%%%%%%%%%
% 输入数据格式 : 8S7
% 输出数据格式 : 10S7
stage0_in = ifft_in_swap;
stage0_out = zeros(64,1);
stage0_wn = zeros(32,1);
for n=0:31
    stage0_wn(n+1)  = cos(2*pi/64*n) - 1i*sin(2*pi/64*n) ;
end
stage0_wn = quantize(quan_9S7_pattern,stage0_wn);

% 分1组，每组间隔32个点构成蝶形运算
for i=1:32
	[stage0_out(i),stage0_out(i+32)] = fft64_butterfly_fix(stage0_in(i),stage0_in(i+32),stage0_wn(i));
end
stage0_out = quantize(quan_10S7_pattern,stage0_out); 

%%%%%%%%%% stage1 %%%%%%%%%%%%
% 输入数据格式 : 10S7
% 输出数据格式 : 11S7
stage1_in = stage0_out;
stage1_out = zeros(64,1);
stage1_wn = zeros(16,1);
for n=0:15
    stage1_wn(n+1)  = cos(2*pi/32*n) - 1i*sin(2*pi/32*n) ;
end
stage1_wn = quantize(quan_9S7_pattern,stage1_wn);

% 分2组，每组间隔16个点构成蝶形运算
for k=1:32:64
    for i=k:(k+15)
        wn_idx = i - k + 1;
	    [stage1_out(i),stage1_out(i+16)] = fft64_butterfly_fix(stage1_in(i),stage1_in(i+16),stage1_wn(wn_idx));
    end
end
stage1_out = quantize(quan_11S7_pattern,stage1_out); 

%%%%%%%%%% stage2 %%%%%%%%%%%%
% 输入数据格式 : 11S7
% 输出数据格式 : 13S7
stage2_in = stage1_out;
stage2_out = zeros(64,1);
stage2_wn = zeros(8,1);
for n=0:7
    stage2_wn(n+1)  = cos(2*pi/16*n) - 1i*sin(2*pi/16*n) ;
end
stage2_wn = quantize(quan_9S7_pattern,stage2_wn);

% 分4组，每组间隔8个点构成蝶形运算
for k=1:16:64
    for i=k:(k+7)
        wn_idx = i - k + 1;
	    [stage2_out(i),stage2_out(i+8)] = fft64_butterfly_fix(stage2_in(i),stage2_in(i+8),stage2_wn(wn_idx));
    end
end
stage2_out = quantize(quan_13S7_pattern,stage2_out);

%%%%%%%%%% stage3 %%%%%%%%%%%%
% 输入数据格式 : 13S7
% 输出数据格式 : 14S7
stage3_in = stage2_out;
stage3_out = zeros(64,1);
stage3_wn = zeros(4,1);
for n=0:3
    stage3_wn(n+1)  = cos(2*pi/8*n) - 1i*sin(2*pi/8*n) ;
end
stage3_wn = quantize(quan_9S7_pattern,stage3_wn);

% 分8组，每组间隔4个点构成蝶形运算
for k = 1:8:64 
	for i=k:(k+3)
        wn_idx = i - k + 1;
		[stage3_out(i),stage3_out(i+4)] = fft64_butterfly_fix(stage3_in(i),stage3_in(i+4),stage3_wn(wn_idx));
	end
end
stage3_out = quantize(quan_14S7_pattern,stage3_out);

%%%%%%%%%% stage4 %%%%%%%%%%%%
% 输入数据格式 : 14S7
% 输出数据格式 : 14S7
stage4_in = stage3_out;
stage4_out = zeros(64,1);
stage4_wn = zeros(2,1);
for n=0:1
    stage4_wn(n+1)  = cos(2*pi/4*n) - 1i*sin(2*pi/4*n) ;
end
stage4_wn = quantize(quan_9S7_pattern,stage4_wn);

% 分16组，每组间隔2个点构成蝶形运算
for k = 1:4:64 
	for i=k:(k+1)
        wn_idx = i - k + 1;
		[stage4_out(i),stage4_out(i+2)] = fft64_butterfly_fix(stage4_in(i),stage4_in(i+2),stage4_wn(wn_idx));
	end
end
stage4_out = quantize(quan_14S7_pattern,stage4_out);

%%%%%%%%%% stage5 %%%%%%%%%%%%
% 输入数据格式 : 14S7
% 输出数据格式 : 14S7
stage5_in = stage4_out;
stage5_out = zeros(64,1);
stage5_wn = 1;
stage5_wn = quantize(quan_9S7_pattern,stage5_wn);

%分32组，每组间隔2个点构成蝶形运算
for i=1:2:64
	[stage5_out(i),stage5_out(i+1)] = fft64_butterfly_fix(stage5_in(i),stage5_in(i+1),stage5_wn);
end
stage5_out = quantize(quan_14S7_pattern,stage5_out);

%%%%%%%%%% bit逆序输出 %%%%%%%%%%%%%%%%%%%
i_inv = zeros(64,1);
for i=1:64
	i_bin = dec2bin(i-1,6);
	i_bin_inv = fliplr(i_bin);
	i_inv(i) = bin2dec(i_bin_inv);
end

fft_out = zeros(64,1);
for i=1:64
	fft_out(i) = stage5_out(i_inv(i)+1);
end

% fft_out_div64 = fft_out/64;
fft_out_div64_i = ifft_right_shift6(real(fft_out), [14 7], [14 13]);
fft_out_div64_q = ifft_right_shift6(imag(fft_out), [14 7], [14 13]);

fft_out_div64 = fft_out_div64_i + 1i*fft_out_div64_q;
fft_out_div64 = quantize(quan_14S13_pattern,fft_out_div64);

% 交换实部与虚部
ifft_out = imag(fft_out_div64) + 1i*real(fft_out_div64);
end
