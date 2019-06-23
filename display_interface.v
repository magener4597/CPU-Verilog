`timescale 1ns / 1ps

module display_interface(WADD,DIN,enter,clk,CAtoCG,E,DP);
    input clk;
    input enter;
    input [2:0] WADD;
    input [5:0] DIN;
    output reg [7:0] E;
    output reg [6:0] CAtoCG;
    output DP;
    reg [5:0] D0,D1,D2,D3,D4,D5,D6,D7,B0,B1,B2,B3,B4,B5,B6,B7,DOUT;
    initial E = 8'b11111111;
    
    always @(WADD or enter or DIN)
    begin
    if(enter)
        begin
            case(WADD)
             0: D0 = DIN;
             1: D1 = DIN;
             2: D2 = DIN;
             3: D3 = DIN;
             4: D4 = DIN;
             5: D5 = DIN;
             6: D6 = DIN;
             7: D7 = DIN;
            endcase
        end
    end
    
    always @(posedge clk)
    begin
        case(WADD)
            0: B0 = D0;
            1: B1 = D1;
            2: B2 = D2;
            3: B3 = D3;
            4: B4 = D4;
            5: B5 = D5;
            6: B6 = D6;
            7: B7 = D7;
                endcase
    end
    
    reg [19:0] counter;
    always @(posedge clk) 
    counter = counter + 1;
    wire [2:0] select ;
    assign select= counter [19:17];
    
    always @(*)
    begin
            case(select)
             0: DOUT = B0;
             1: DOUT = B1;
             2: DOUT = B2;
             3: DOUT = B3;
             4: DOUT = B4;
             5: DOUT = B5;
             6: DOUT = B6;
             7: DOUT = B7;
             default DOUT = DOUT;
             endcase
    
        case(select)
        0:E = 8'b11111110;
        1:E = 8'b11111101;
        2:E = 8'b11111011;
        3:E = 8'b11110111;
        4:E = 8'b11101111;
        5:E = 8'b11011111;
        6:E = 8'b10111111;
        7:E = 8'b01111111;
        default E = E;
        endcase
    end
    
    assign DP = DOUT[0];
    
    always @ (DOUT) 
    begin
       if (DOUT[5])
           case(DOUT[4:1])
               0: CAtoCG <= 7'b0000001;
               1: CAtoCG <= 7'b1001111;
               2: CAtoCG <= 7'b0010010;
               3: CAtoCG <= 7'b0000110;
               4: CAtoCG <= 7'b1001100;
               5: CAtoCG <= 7'b0100100;
               6: CAtoCG <= 7'b0100000;
               7: CAtoCG <= 7'b0001111;
               8: CAtoCG <= 7'b0000000;
               9: CAtoCG <= 7'b0000100;
               10: CAtoCG <= 7'b0001000;
               11: CAtoCG <= 7'b1100000;
               12: CAtoCG <= 7'b0110001;
               13: CAtoCG <= 7'b1000010;
               14: CAtoCG <= 7'b0110000;
               15: CAtoCG <= 7'b0111000;
               default: CAtoCG <= CAtoCG;
           endcase
           else 
           CAtoCG <= 7'b1111111;
    end
endmodule
