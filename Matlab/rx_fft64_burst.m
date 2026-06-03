%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 64点FFT算法
% 作者: 柳井刚
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计》随书代码，所有代码均由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rx_fft_out = rx_fft64_burst(fft_array_in)
    [row,col] = size(fft_array_in);

    rx_fft_out = zeros(row,col);
    for k = 1:col
        rx_fft_out(:,k) = rx_fft64_fix(fft_array_in(:,k));
        
        quan_14S7_pattern = quantizer('fixed','round','saturate',[14,7]);
        rx_fft_out(:,k) = quantize(quan_14S7_pattern,rx_fft_out(:,k)); 
    end

    % 把rx_fft_out_i/q转化为列向量写入.txt文件用来验证
    rx_fft_out_txt_i = reshape(real(rx_fft_out),[],1);
    print_txt(rx_fft_out_txt_i,[14 7],'./verify_txt/rx_fft_out_i.txt');
    rx_fft_out_txt_q = reshape(imag(rx_fft_out),[],1);
    print_txt(rx_fft_out_txt_q,[14 7],'./verify_txt/rx_fft_out_q.txt');
end