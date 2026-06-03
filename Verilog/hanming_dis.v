//////////////////////////////////////////////////////////////
// 功能: 计算汉明距离
// 作者: 柳井刚(微信公众号/B站：柳同学聊芯片)
// 邮箱: jgliu_icer@163.com
// 描述: 本套代码是《OFDM无线通信芯片设计实战》随书代码，由本人独立开发，
//	   所有算法原理与实现方式在书中都尽量使用最浅显的语言进行了介绍。同时本
//	   人还开发了一套与之对应的Verilog代码。书中基本对所有Matlab代码和
//	   Verilog代码的每一行都做了详细的注释.感兴趣的读者可购买原书学习。
//	   读者在阅读本书的过程中有任何问题欢迎通过上方的邮箱与我交流讨论。
//	   本套代码仅供学习交流使用，请勿用作商业用途，谢谢.
/////////////////////////////////////////////////////////////
module hanming_dis(
    input  [1:0] I_rx_bits_para,
    output reg [1:0] O_dis0,
    output reg [1:0] O_dis1,
    output reg [1:0] O_dis2,
    output reg [1:0] O_dis3
    );

//求输入两个bit并行数据分别于00,01,10,11的汉明距离
always @(*) begin
    case(I_rx_bits_para)
        2'd0: begin
            O_dis0 <= 2'd0;
            O_dis1 <= 2'd1;
            O_dis2 <= 2'd1;
            O_dis3 <= 2'd2;
        end
        2'd1: begin
            O_dis0 <= 2'd1;
            O_dis1 <= 2'd0;
            O_dis2 <= 2'd2;
            O_dis3 <= 2'd1;
        end
        2'd2: begin
            O_dis0 <= 2'd1;
            O_dis1 <= 2'd2;
            O_dis2 <= 2'd0;
            O_dis3 <= 2'd1;
        end
        default:begin //(I_rx_bits_para == 2'd3)
            O_dis0 <= 2'd2;
            O_dis1 <= 2'd1;
            O_dis2 <= 2'd1;
            O_dis3 <= 2'd0;
        end       
    endcase
end
    
endmodule
