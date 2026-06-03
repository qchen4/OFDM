%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: DATA域数据解扰码Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rx_data_out = rx_data_de_scramble(rx_data_in,data_bytes_num)
    payload_bits_num = data_bytes_num * 8;

    service_bits = rx_data_in(1:7);

    rx_data_out = fun_de_scramble(service_bits,rx_data_in(8:end));

    rx_data_out = rx_data_out(10:payload_bits_num+9);

    fid_a = fopen('./verify_txt/rx_data_de_scramble_out.txt','w');
    fprintf(fid_a, '%d\n', rx_data_out);
    fclose(fid_a);
end

function fun_de_scramble_out = fun_de_scramble(buff_init_val,rx_bits)
    fun_de_scramble_out = zeros(length(rx_bits),1);
    buff = buff_init_val;

    for j=1:length(rx_bits)
        sftreg_in = xor(buff(7),buff(4));
        fun_de_scramble_out(j) = xor(sftreg_in,rx_bits(j));
    
        buff(7) = buff(6);
        buff(6) = buff(5);
        buff(5) = buff(4);
        buff(4) = buff(3);
        buff(3) = buff(2);
        buff(2) = buff(1);
        buff(1) = sftreg_in;
    end
end