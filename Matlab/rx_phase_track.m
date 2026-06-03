%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 相位跟踪 Matlab算法顶层模块
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [rx_phase_track_out,de_qam16_threshold] = rx_phase_track(rx_data_in)
quan_8S7_pattern = quantizer('fixed','round','saturate',[8,7]);
quan_8S7_pattern_floor = quantizer('fixed','floor','saturate',[8,7]);
quan_14S7_pattern = quantizer('fixed','round','saturate',[14,7]);

[row, col] = size(rx_data_in);
signal_data_ofdm_num = col;% 1 signal ofdm + 7 data ofdm

scramble_out = gen_pilot_scramble;

rx_phase_track_out = zeros(row,col);
comp_factor = zeros(signal_data_ofdm_num,1);
for k=1:signal_data_ofdm_num
    rx_pilot_neg21 = rx_data_in(43+1,k); % -21
    rx_pilot_neg7  = rx_data_in(57+1,k); % -7
    rx_pilot_pos7  = rx_data_in(7+1,k); %   7
    rx_pilot_pos21 = rx_data_in(21+1,k); %  21

    if(scramble_out(k)==0)  % [1 1 1 -1]
        pilot_sum = rx_pilot_neg21 + rx_pilot_neg7 + rx_pilot_pos7 - rx_pilot_pos21;
    else                    % [-1 -1 -1 1]
        pilot_sum = -rx_pilot_neg21 - rx_pilot_neg7 - rx_pilot_pos7 + rx_pilot_pos21;
    end

    pilot_sum = quantize(quan_14S7_pattern,pilot_sum);
    pilot_sum_conj = conj(pilot_sum);

    pilot_sum_conj_i = real(pilot_sum_conj);
    pilot_sum_conj_q = imag(pilot_sum_conj);
    if(abs(pilot_sum_conj_i) > abs(pilot_sum_conj_q))
        abs_pilot_sum_max = abs(pilot_sum_conj_i);
    else
        abs_pilot_sum_max = abs(pilot_sum_conj_q);
    end

    if(abs_pilot_sum_max >= 0 && abs_pilot_sum_max < 1)
        pilot_sum_conj_8S7 = quantize(quan_8S7_pattern_floor,pilot_sum_conj); %8S7
    elseif(abs_pilot_sum_max >= 1 && abs_pilot_sum_max < 2)
        pilot_sum_conj_8S7 = quantize(quan_8S7_pattern_floor,pilot_sum_conj/2); %8S7
    elseif(abs_pilot_sum_max >= 2 && abs_pilot_sum_max < 4)
        pilot_sum_conj_8S7 = quantize(quan_8S7_pattern_floor,pilot_sum_conj/4); %8S7
    elseif(abs_pilot_sum_max >= 4 && abs_pilot_sum_max < 8)
        pilot_sum_conj_8S7 = quantize(quan_8S7_pattern_floor,pilot_sum_conj/8); %8S7 
    elseif(abs_pilot_sum_max >= 8 && abs_pilot_sum_max < 16)
        pilot_sum_conj_8S7 = quantize(quan_8S7_pattern_floor,pilot_sum_conj/16); %8S7 
    elseif(abs_pilot_sum_max >= 16 && abs_pilot_sum_max < 32)
        pilot_sum_conj_8S7 = quantize(quan_8S7_pattern_floor,pilot_sum_conj/32); %8S7      
    else
        pilot_sum_conj_8S7 = quantize(quan_8S7_pattern_floor,Pk/64);      
    end

    comp_factor(k) = pilot_sum_conj_8S7;

    rx_phase_track_out(:,k) = rx_data_in(:,k)*comp_factor(k); 
end
rx_phase_track_out = quantize(quan_14S7_pattern,rx_phase_track_out);

de_qam16_threshold = zeros(1,col);
for i=1:col
    %提取补偿后四个导频实部的绝对值
    pilot1 = abs(real(rx_phase_track_out(7+1,i)));
    pilot2 = abs(real(rx_phase_track_out(21+1,i)));
    pilot3 = abs(real(rx_phase_track_out(43+1,i)));
    pilot4 = abs(real(rx_phase_track_out(57+1,i)));

    pilot_abs_sum = pilot1 + pilot2 + pilot3 + pilot4;
    pilot_abs_sum = quantize(quan_14S7_pattern,pilot_abs_sum);

    pilot_abs_sum_div4 = bitshift_fix(pilot_abs_sum, -2, [14 7]);

    const_val = 2/3;
    const_val = quantize(quan_8S7_pattern,const_val);
	const_val_int = print_txt(const_val,[8 7],'do_not_print_txt');
	
    de_qam16_threshold(i) = pilot_abs_sum_div4 * const_val;
    de_qam16_threshold(i) = quantize(quan_14S7_pattern,de_qam16_threshold(i));
end

% 画图
figure('Name','rx_phase_track');
subplot(3,2,1)
plot_scatter(rx_data_in(:,1))
subplot(3,2,2)
plot_scatter(rx_phase_track_out(:,1))
subplot(3,2,3)
plot_scatter(rx_data_in(:,2))
subplot(3,2,4)
plot_scatter(rx_phase_track_out(:,2))
subplot(3,2,5)
plot_scatter(rx_data_in(:,8))
subplot(3,2,6)
plot_scatter(rx_phase_track_out(:,8))

print(gcf, 'rx_phase_track.png', '-dpng', '-r600');

% 把rx_phase_track_out_i/q转化为列向量写入.txt文件用来验证
rx_phase_track_out_txt_i = reshape(real(rx_phase_track_out),[],1);
print_txt(rx_phase_track_out_txt_i,[14 7],'./verify_txt/rx_phase_track_out_i.txt');
rx_phase_track_out_txt_q = reshape(imag(rx_phase_track_out),[],1);
print_txt(rx_phase_track_out_txt_q,[14 7],'./verify_txt/rx_phase_track_out_q.txt');
end

function scramble_out = gen_pilot_scramble
	buff = [1 1 1 1 1 1 1];
	scramble_out = zeros(1,127);

	for j=1:length(scramble_out)
		sftreg_in = xor(buff(7),buff(4));
		scramble_out(j) = sftreg_in;

		buff(7) = buff(6);
		buff(6) = buff(5);
		buff(5) = buff(4);
		buff(4) = buff(3);
		buff(3) = buff(2);
		buff(2) = buff(1);
		buff(1) = sftreg_in;
	end
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