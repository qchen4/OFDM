%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 导频插入模块的Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pilot_insert_out = tx_pilot_insert(signal_data_in,pilot_scramble_in)
	quan_8S7_pattern = quantizer('fixed','round','saturate',[8,7]);

    [row,col] = size(signal_data_in);
    pilot_insert_out = zeros(64,col);
    for n = 1:col
        for k=0:47
            if(k>=0 && k<=4)
                remap_idx = k + 38; % 42 >= remap_idx >= 38
            elseif(k>=5 && k<=17)
                remap_idx = k + 39; % 56 >= remap_idx >= 44
            elseif(k>=18 && k<=23)
                remap_idx = k + 40; % 63 >= remap_idx >= 58 
            elseif(k>=24 && k<=29)
                remap_idx = k - 23; % 6 >= remap_idx >= 1    
            elseif(k>=30 && k<=42)
                remap_idx = k - 22; % 20 >= remap_idx >= 8  
            elseif(k>=43 && k<=47)
                remap_idx = k - 21; % 26 >= remap_idx >= 22 
            end
            pilot_insert_out(remap_idx+1,n) = signal_data_in(k+1,n);   
        end

        % 插入导频
		if pilot_scramble_in(n) == 0
			pilot_insert_out(43+1,n) = 1-2^(-7); 	% -21
			pilot_insert_out(57+1,n) = 1-2^(-7); 	% -7
			pilot_insert_out(7+1,n) = 1-2^(-7);  	%  7
			pilot_insert_out(21+1,n) = -(1-2^(-7));	%  21
		else % if pilot_scramble_in(n) == 1
			pilot_insert_out(43+1,n) = -(1-2^(-7)); % -21
			pilot_insert_out(57+1,n) = -(1-2^(-7)); % -7
			pilot_insert_out(7+1,n) = -(1-2^(-7));  %  7
			pilot_insert_out(21+1,n) = 1-2^(-7);	%  21
		end
		
		% 对输出使用8S7的数据格式进行量化
		pilot_insert_out(:,n) = quantize(quan_8S7_pattern,pilot_insert_out(:,n));
    end
	
	% 把pilot_insert_out_i/q转化为列向量写入.txt文件用来验证
    pilot_insert_out_txt_i = reshape(real(pilot_insert_out),[],1);
    print_txt(pilot_insert_out_txt_i,[8 7],'./verify_txt/pilot_insert_out_i.txt');
    pilot_insert_out_txt_q = reshape(imag(pilot_insert_out),[],1);
    print_txt(pilot_insert_out_txt_q,[8 7],'./verify_txt/pilot_insert_out_q.txt');
end