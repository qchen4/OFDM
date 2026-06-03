%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 16-QAM调制的Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data_qam16_out = tx_data_qam16(data_array)    
    [row,col] = size(data_array);
    data_qam16_out = zeros(row/4,col);
    data_qam16_out_i = zeros(row/4,col);
    data_qam16_out_q = zeros(row/4,col);

    for k = 1:col
        one_ofdm_data = data_array(:,k);

        % 16-QAM 符号映射
        for i=1:length(one_ofdm_data)/4
            symbol = one_ofdm_data(4*i-3:4*i);
            symbol = symbol';
        
            if(isequal(symbol(1:2),[0 0])) 
                data_qam16_out_i(i,k) = -3;
            elseif(isequal(symbol(1:2),[0 1])) 
                data_qam16_out_i(i,k) = -1;
            elseif(isequal(symbol(1:2),[1 1])) 
                data_qam16_out_i(i,k) = 1;
            else %if(isequal(symbol(1:2),[1 0])) 
                data_qam16_out_i(i,k) = 3;
            end
        
            if(isequal(symbol(3:4),[0 0])) 
                data_qam16_out_q(i,k) = -3;
            elseif(isequal(symbol(3:4),[0 1])) 
                data_qam16_out_q(i,k) = -1;
            elseif(isequal(symbol(3:4),[1 1])) 
                data_qam16_out_q(i,k) = 1;
            else %if(isequal(symbol(3:4),[1 0])) 
                data_qam16_out_q(i,k) = 3;
            end
        end

        % 使用归一化因子K_mod对IQ数据进行归一化
        K_mod = 1/sqrt(10);
        data_qam16_out_i(:,k) = data_qam16_out_i(:,k)*K_mod;
        data_qam16_out_q(:,k) = data_qam16_out_q(:,k)*K_mod;
        
        % 用8S7的数据格式对IQ数据进行量化
        quan_8S7_pattern = quantizer('fixed','round','saturate',[8,7]);
        data_qam16_out_i(:,k) = quantize(quan_8S7_pattern,data_qam16_out_i(:,k));
        data_qam16_out_q(:,k) = quantize(quan_8S7_pattern,data_qam16_out_q(:,k));
        data_qam16_out(:,k) = data_qam16_out_i(:,k) + 1i*data_qam16_out_q(:,k);       
    end

    % 把data_qam16_out_i转化为列向量写入.txt文件用来验证
    data_qam16_out_txt_i = reshape(data_qam16_out_i,[],1);
    print_txt(data_qam16_out_txt_i,[8 7],'./verify_txt/data_qam16_out_i.txt');
    data_qam16_out_txt_q = reshape(data_qam16_out_q,[],1);
    print_txt(data_qam16_out_txt_q,[8 7],'./verify_txt/data_qam16_out_q.txt');
end