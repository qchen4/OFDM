%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: Viterbi算法的Matlab代码
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rx_viterbi217_out = rx_viterbi217(rx_bits, filename)

% 定义网格图最前面部分的路径节点矩阵
register_num = 6;
pre_node_array = 0;

% 得到64个节点数据
for n = 1:register_num
    node_array = zeros(2^n,1);
    for k=1:length(pre_node_array)
        % 方法一：使用除法和floor函数
        % node_array(2*k-1) = floor(pre_node_array(k)/2);
        % node_array(2*k) = floor(pre_node_array(k)/2) + 2^(register_num-1);

        % 方法二：使用bitshift移位函数
        node_array(2*k-1) = bitshift(pre_node_array(k),-1);
        node_array(2*k) = bitshift(pre_node_array(k),-1) + 2^(register_num-1);
    end
    pre_node_array = node_array;       
end
node_array = pre_node_array;

% 初始化幸存路径数组和累积距离
branch = zeros(64,length(rx_bits)/2);
dis_acc = zeros(64,1);
new_dis_acc = zeros(64,1);

for t = 1:length(rx_bits)/2
    rx_bits_para = [rx_bits(2*t-1) rx_bits(2*t)];

    %计算汉明距离
    dis0 = hamming_distance(rx_bits_para,[0 0]);
    dis1 = hamming_distance(rx_bits_para,[0 1]);
    dis2 = hamming_distance(rx_bits_para,[1 0]);
    dis3 = hamming_distance(rx_bits_para,[1 1]);
    dis = [dis0 dis1 dis2 dis3];

    for node_idx = 1:64
        current_node = node_array(node_idx);
        current_node_str = dec2bin(current_node,6);
        current_node_array = double(current_node_str) - 48;
        input_bit = current_node_array(1); 

        % 根据当前节点下标计算上节点和下节点
        [pre_upper_node,pre_lower_node] = calculate_pre_node(node_idx, node_array);
        
        % 计算上节点和下节点的输出
        pre_upper_node_out = calculate_node_out(input_bit, pre_upper_node);
        pre_lower_node_out = calculate_node_out(input_bit, pre_lower_node);
       
        % 加(ADD)
        dis_acc_upper_branch = dis_acc(pre_upper_node+1) + dis(pre_upper_node_out+1);
        dis_acc_lower_branch = dis_acc(pre_lower_node+1) + dis(pre_lower_node_out+1);

        % 比选(Compare & Select)
        if(t<=6) %只选择上分支
                branch(current_node+1,t) = 1; % 1 表示选择上分支，0表示选择下分支
                new_dis_acc(current_node+1) = dis_acc_upper_branch; % 更新累计距离
        else
            if(dis_acc_upper_branch <= dis_acc_lower_branch) 
                branch(current_node+1,t) = 1; % 1 表示选择上分支，0表示选择下分支
                new_dis_acc(current_node+1) = dis_acc_upper_branch; % 更新累计距离
            else 
                branch(current_node+1,t) = 0; % 1 表示选择上分支，0表示选择下分支
                new_dis_acc(current_node+1) = dis_acc_lower_branch; % 更新累计距离
            end
        end
    end

    % update 累计距离
    dis_acc = new_dis_acc;  
end

% 选择尾节点为0的幸存路径回溯
select_branch = 0;

dec_bits = zeros(1,length(branch(1,:)));
for t = length(branch(1,:)):-1:1
    tmp_dec_str = dec2bin(select_branch,6);
    tmp_dec_bin_array = double(tmp_dec_str) - 48;
    dec_bits(t) = tmp_dec_bin_array(1);

    for i=1:64
        if(select_branch == node_array(i))
            select_branch_idx = i;
            break;
        end  
    end

    [pre_upper_node,pre_lower_node] = calculate_pre_node(select_branch_idx, node_array);

    if(branch(select_branch+1,end)==1)
        select_branch = pre_upper_node;
    else
        select_branch = pre_lower_node;
    end

    for k=1:64
        branch(k,:) = [0 branch(k,1:end-1)];
    end
end

rx_viterbi217_out = dec_bits';

% 把rx_viterbi217_out写入.txt文件用来验证
filepath = ['./verify_txt/',filename];
fid_a = fopen(filepath,'w');
fprintf(fid_a, '%d\n', rx_viterbi217_out);
fclose(fid_a);

end

function dis = hamming_distance(x,y)
    if(x(1)==y(1)) && (x(2)==y(2))
        dis = 0;
    elseif(x(1)~=y(1)) && (x(2)==y(2))
        dis = 1;  
    elseif(x(1)==y(1)) && (x(2)~=y(2))
        dis = 1;  
    else
        dis = 2;
    end
end

function node_out_dec = calculate_node_out(input_bit, node)
    polynomial_a = [1 0 1 1 0 1 1];
    polynomial_b = [1 1 1 1 0 0 1];

    node_str = dec2bin(node,6);
    node_array = double(node_str)-48; %二进制字符串转化为0,1的数组

    tmp_bin_array = [input_bit node_array];
    out1 = tmp_bin_array(1);
    out2 = tmp_bin_array(1);
    for idx = 2:length(tmp_bin_array)
        if(polynomial_a(idx) == 1)
            out1 = xor(out1,tmp_bin_array(idx));
        end 
        if(polynomial_b(idx) == 1)
            out2 = xor(out2,tmp_bin_array(idx));
        end 
    end
    node_out_dec = out1*2+out2;
end

function [pre_upper_node,pre_lower_node] = calculate_pre_node(current_node_idx, node_array)
    node_idx = current_node_idx;
    if(mod(node_idx,2)==1) %node_idx是奇数
        pre_upper_node_idx = (node_idx+1)/2;
    else  %node_idx是偶数
        pre_upper_node_idx = node_idx/2;
    end
    pre_lower_node_idx = pre_upper_node_idx + 32;

    %计算上节点和下节点
    pre_upper_node = node_array(pre_upper_node_idx);
    pre_lower_node = node_array(pre_lower_node_idx); 
end