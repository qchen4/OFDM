%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能: 利用CORDIC算法求cos&sin
% 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
% 邮箱: jgliu_icer@163.com
% 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
%	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
%	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
%	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
%	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
%	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [cordic_sin,cordic_cos]=cordic_sincos_fix(theta_in)
 
quan_16S13_pattern = quantizer('fixed','round','saturate',[16 13]);

N = 11; % 设置迭代次数11次

K = zeros(N,1);%模长
K(1) = sqrt(1+2^(-2*0));
for i = 1 : N
    K(i+1) = K(i) * sqrt(1+2^(-2*i));
end
 
arctan_table = zeros(N,1);
for i=0:N-1
    arctan_table(i+1) = atan(2^(-i));
end
arctan_table = quantize(quan_16S13_pattern,arctan_table);

pi_div2_quan = quantize(quan_16S13_pattern,pi/2);
pi_quan = quantize(quan_16S13_pattern,pi);

theta_in = quantize(quan_16S13_pattern,theta_in);
if((theta_in > pi_div2_quan)&&(theta_in < pi_quan))
    theta_in_pre = theta_in - pi_div2_quan;
elseif((theta_in < -pi_div2_quan)&&(theta_in > -pi_quan))
    theta_in_pre = theta_in + pi_div2_quan;
else
    theta_in_pre = theta_in;
end

x = zeros(N,1);
y = zeros(N,1);
z = zeros(N,1);
d = zeros(N,1);
x_shift = zeros(N,1);
y_shift = zeros(N,1);

% Cordic算法计算cos, sin值
x(1) = 1/K(N+1); % 横坐标初始值赋为1/Kn
y(1) = 0; % 纵坐标初始值赋为0
z(1) = theta_in_pre; 

x(1) = quantize(quan_16S13_pattern,x(1));
z(1) = quantize(quan_16S13_pattern,z(1));
if z(1) >= 0 % 判断第一次的旋转方向
    d(1) = 1;
else
    d(1) = 0;
end

for i = 1 : N
	y_shift(i) = bitshift_fix(y(i),-(i-1),[16 13]);
	x_shift(i) = bitshift_fix(x(i),-(i-1),[16 13]);
    if(d(i) == 0)       
        x(i+1) = x(i) + y_shift(i); 
        y(i+1) = y(i) - x_shift(i);
        z(i+1) = z(i) + arctan_table(i); %计算累计旋转角度
    else %(d(i) == 1)
        x(i+1) = x(i) - y_shift(i);
        y(i+1) = y(i) + x_shift(i);
        z(i+1) = z(i) - arctan_table(i); %计算累计旋转角度
    end

    x(i+1) = quantize(quan_16S13_pattern,x(i+1));
    y(i+1) = quantize(quan_16S13_pattern,y(i+1));
    z(i+1) = quantize(quan_16S13_pattern,z(i+1));

    if z(i+1) >= 0 % 判断下一次的旋转方向
        d(i+1) = 1;
    else
        d(i+1) = 0;
    end
end
 
%输出保护
if(theta_in==0)
    cordic_sin = 0;
    cordic_cos = 1;
elseif(theta_in == pi_div2_quan)
    cordic_sin = 1;
    cordic_cos = 0;
elseif(theta_in == pi_quan)
    cordic_sin = 0;
    cordic_cos = -1; 
elseif(theta_in == -pi_div2_quan)
    cordic_sin = -1;
    cordic_cos = 0;
elseif((theta_in > pi_div2_quan)&&(theta_in < pi_quan))
    cordic_sin = x(N+1);
    cordic_cos = -y(N+1);
elseif((theta_in < -pi_div2_quan)&&(theta_in > -pi_quan))
    cordic_sin = -x(N+1);
    cordic_cos = y(N+1);
else
    cordic_sin = y(N+1);
    cordic_cos = x(N+1);
end

end