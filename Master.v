`timescale 1ns / 1ps

module Master(clk,s,E,CAtoCG,DP);
    input clk;
    input s;
    output [7:0] E;
    output [6:0] CAtoCG;
    output DP;
    wire [9:0] NE,P;
    wire [31:0] BCD;
    wire w;
    wire [2:0] WADD;
    wire [5:0] DIN;
    wire [9:0] F;
    Period_Meter period_meter(clk,NE,P);
    frequency_meter freq_meter(clk,s,F,NE);
    B2BCD binarytobcd(clk,P,F,BCD);
    display_controller control(clk,BCD,w,WADD,DIN);
    display_interface interface(WADD,DIN,1,clk,CAtoCG,E,DP);
endmodule
