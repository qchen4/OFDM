%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: DATA域数据扰码Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data_scramble_out = tx_data_scramble(data_array, tail_bits_start_idx,init_state)
    [row,col] = size(data_array);

    data_bits = reshape(data_array, row*col, 1);
    data_scramble_out = fun_scramble(init_state,data_bits);

    % 这个步骤必须做，IEEE802.11a协议有强制要求
    data_scramble_out(tail_bits_start_idx:tail_bits_start_idx+5) = zeros(6,1);  

    % 这个步骤可选，IEEE802.11a协议上没有强制要求
    data_scramble_out(end-5:end) = zeros(6,1);    

    % 把payload_bits写入.txt文件用来验证
    fid_a = fopen('./verify_txt/data_scramble_out.txt','w');
	fprintf(fid_a, '%d\n', data_scramble_out);
	fclose(fid_a);
end

function fun_scramble_out = fun_scramble(init_state,tx_bits)
    fun_scramble_out = zeros(length(tx_bits),1);

    buff = init_state;
    for j=1:length(tx_bits)
        sftreg_in = xor(buff(7),buff(4));
        fun_scramble_out(j) = xor(sftreg_in,tx_bits(j));
    
        buff(7) = buff(6);
        buff(6) = buff(5);
        buff(5) = buff(4);
        buff(4) = buff(3);
        buff(3) = buff(2);
        buff(2) = buff(1);
        buff(1) = sftreg_in;
    end
end