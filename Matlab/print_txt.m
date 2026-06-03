%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 将定点化数据转化为整数并打印到txt文件中
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a_out = print_txt(a_fix,format,filename)
    a_integer = a_fix * 2^(format(2)) ;
    a_complement = zeros(length(a_integer),1);
    
    % 把量化后的a转化为补码
    for i = 1:length(a_complement)
       if(a_integer(i) < 0)
           a_complement(i) = 2^(format(1)) + a_integer(i) ;
       else
           a_complement(i) = a_integer(i) ;
       end
    end
    
    if strcmp(filename,'do_not_print_txt')
	    a_out = a_complement;
    else
	    a_out = a_complement;
    
	    % 把量化后的a的补码写入txt文件
	    fid_a = fopen(filename,'w');
    
        for i=1:length(a_complement)
	        fprintf(fid_a, '%x\n', a_complement(i));
        end
	    fclose(fid_a);
    end
end
