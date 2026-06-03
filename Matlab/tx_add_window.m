%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 加窗(Windowing)Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tx_add_win_out = tx_add_window(tx_add_win_in,lts_1st_data)     
	[row,col] = size(tx_add_win_in);
	tx_add_win_out = zeros(row,col);

	pre_symbol_1st_data = lts_1st_data;
	for k = 1:col
		cur_symbol_1st_data = (pre_symbol_1st_data + tx_add_win_in(1,k))/2;
		quan_14S13_pattern = quantizer('fixed','floor','saturate',[14,13]);
		cur_symbol_1st_data = quantize(quan_14S13_pattern,cur_symbol_1st_data);
		
		pre_symbol_1st_data = tx_add_win_in(1,k);

		tx_add_win_out(:,k) = [cur_symbol_1st_data;tx_add_win_in(2:end,k)];
		
		quan_14S13_pattern = quantizer('fixed','round','saturate',[14,13]);
		tx_add_win_out(:,k) = quantize(quan_14S13_pattern,tx_add_win_out(:,k));
	end

	% 把tx_add_win_out_i/q转化为列向量写入.txt文件用来验证
	tx_add_win_out_txt_i = reshape(real(tx_add_win_out),[],1);
	print_txt(tx_add_win_out_txt_i,[14 13],'./verify_txt/tx_add_win_out_i.txt');
	tx_add_win_out_txt_q = reshape(imag(tx_add_win_out),[],1);
	print_txt(tx_add_win_out_txt_q,[14 13],'./verify_txt/tx_add_win_out_q.txt');
end