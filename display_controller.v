`timescale 1ns / 1ps

module display_controller(clk,BCD,W,WADD,DIN);
    input clk;
    input [31:0] BCD;
    output reg W;
    output reg [2:0] WADD;
    output reg [5:0] DIN;
    localparam S0 = 0,S1 = 1;
    reg C1,C0,state_reg,state_next;
    wire Z;
    
    always@(*)
    begin
        if(WADD == 0)
            DIN <= {1'b1,BCD[3:0],1'b1};
        else if(WADD == 1)
            DIN <= {1'b1,BCD[7:4],1'b1};
        else if(WADD == 2)
            DIN <= {1'b1,BCD[11:8],1'b1};
        else if(WADD == 3)
            DIN <= {1'b1,BCD[15:12],1'b1};
        else if(WADD == 4)
            DIN <= {1'b1,BCD[19:16],1'b1};
        else if(WADD == 5)
            DIN <= {1'b1,BCD[23:20],1'b1};
        else if(WADD == 6)
            DIN <= {1'b1,BCD[27:24],1'b1};
        else if(WADD == 7)
            DIN <= {1'b1,BCD[31:28],1'b1};
    end
    
    always@(posedge clk)
    begin
        if(C0)
            WADD <= 7;
        else if(C1)
            WADD <= WADD - 1;
    end
    assign z = (WADD == 0);
    
    always@(posedge clk)
    begin
        state_reg <= state_next;
    end
    always@*
    begin
        case(state_reg)
        S0:
            begin
                W = 0; C1 = 0; C0 = 1;
                state_next = S1;
            end
        S1:
            begin
                if(z)
                    begin
                        W = 1; C1 = 0; C0 = 0;
                        state_next = S0;
                    end
                else
                    begin 
                        W = 1; C1 = 1; C0 = 0;
                        state_next = S1;
                    end
            end
        default: 
            begin 
                W = 0; C1 =0; C0 = 0;
                state_next = S0;
            end
        endcase
    end
endmodule
