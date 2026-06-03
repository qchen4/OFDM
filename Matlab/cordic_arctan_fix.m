%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 利用CORDIC算法求arctan
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cordic_out = cordic_arctan_fix(data_in)
 
N = 11; % 设置迭代次数11次

x = zeros(N,1);
x_shift = zeros(N,1);
y = zeros(N,1);
y_shift = zeros(N,1);
z = zeros(N,1);
d = zeros(N,1);

quan_16S13_pattern = quantizer('fixed','round','saturate',[16 13]);
data_in = quantize(quan_16S13_pattern,data_in);

arctan_table = zeros(N,1);
for i=0:N-1
    arctan_table(i+1) = atan(2^(-i));
end
arctan_table = quantize(quan_16S13_pattern,arctan_table);

pi_quan = quantize(quan_16S13_pattern,pi);
pi_div2_quan = quantize(quan_16S13_pattern,pi/2);

data_in_i = real(data_in);
data_in_q = imag(data_in);

%角度预处理
if((data_in_i<0) && (data_in_q>0))
    cordic_i =  data_in_q;
    cordic_q = -data_in_i;
elseif((data_in_i<0) && (data_in_q<0))
    cordic_i = -data_in_q;
    cordic_q =  data_in_i;
else
    cordic_i =  data_in_i;
    cordic_q =  data_in_q;
end

% Cordic算法计算arctan(Q/I)
x(1) = cordic_i; % 横坐标初始值赋为复数实部
y(1) = cordic_q; % 纵坐标初始值赋为复数虚部
z(1) = 0; 
 
if y(1) >= 0 % 判断第一次的旋转方向
    d(1) = 0;
else
    d(1) = 1;
end

for i = 1 : N
    if(d(i) == 0)
        y_shift(i) = bitshift_fix(y(i),-(i-1),[16 13]);
        x(i+1) = x(i) + y_shift(i);

        x_shift(i) = bitshift_fix(x(i),-(i-1),[16 13]);
        y(i+1) = y(i) - x_shift(i);

        z(i+1) = z(i) + arctan_table(i); %计算累计旋转角度
    else %(d(i) == 1)
        y_shift(i) = bitshift_fix(y(i),-(i-1),[16 13]);
        x(i+1) = x(i) - y_shift(i);

        x_shift(i) = bitshift_fix(x(i),-(i-1),[16 13]);
        y(i+1) = y(i) + x_shift(i);

        z(i+1) = z(i) - arctan_table(i); %计算累计旋转角度
    end

    x(i+1) = quantize(quan_16S13_pattern,x(i+1));
    y(i+1) = quantize(quan_16S13_pattern,y(i+1));
    z(i+1) = quantize(quan_16S13_pattern,z(i+1));

    if y(i+1) >= 0 % 判断下一次的旋转方向
        d(i+1) = 0;
    else
        d(i+1) = 1;
    end
end

% 结果保护
if((data_in_i == 0) && (data_in_q == 0))
    cordic_out = 0;
elseif((data_in_i>0) && (data_in_q==0))
    cordic_out = 0;
elseif((data_in_i==0) && (data_in_q>0))
    cordic_out = pi_div2_quan; 
elseif((data_in_i<0) && (data_in_q==0))
    cordic_out = -pi_quan; 
elseif((data_in_i==0) && (data_in_q<0))
    cordic_out = -pi_div2_quan; 
elseif((data_in_i<0) && (data_in_q>0))
    cordic_out = z(N+1) + pi_div2_quan; 
elseif((data_in_i<0) && (data_in_q<0))
    cordic_out = z(N+1) - pi_div2_quan; 
else
    cordic_out = z(N+1); 
end

cordic_out = quantize(quan_16S13_pattern,cordic_out);
end





