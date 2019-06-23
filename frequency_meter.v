`timescale 1ns / 1ps

module frequency_meter(clk,s,F,NE);
    input clk;
    input s;
    output reg [9:0] F;
    output NE;
    localparam S0 = 0,S1 = 1;
    reg [16:0] MPC;
    reg state_reg,state_next,C0,C1,Q0,Q1,Q2;
    wire Z,inc,enb;
    reg [9:0] FC;
    initial state_reg = 0;
    initial C1 = 0;
    initial C0 = 0;
    initial FC = 0;
    
    always@(posedge clk)
    begin
        Q0 <= Q1;
        Q1 <= Q2;
        Q2 <= s;
    end
    
    assign NE = ~Q1 & Q0;
    assign inc = NE;
    
    always @(posedge clk)
    begin
        if(C0)
            MPC <= 100000;
        else
            MPC <= MPC -1;
    end
    
    assign Z = (MPC ==0);
    assign enb = ~Z;
    
    always @(posedge clk)
    begin
        if(C0)
            FC <= 0;
        else if(inc)
            if(enb)
                FC <= FC + 1;
    end
    
    always@(posedge clk)
    begin
        if(C1)
            F <= FC;
    end
    
    always @(posedge clk)
        begin
            state_reg <= state_next;
        end
    always @(*)
    begin
        case(state_reg)
        S0:
            begin
                C1 = 0;C0 = 1;
                state_next = S1;
            end
        S1:
            begin
                if(Z)
                    begin
                        C1 = 1;C0 = 0;
                        state_next = S0;
                    end
                else
                    begin
                        C1 = 0;C0 = 0;
                        state_next = S1;
                    end
            end
        default: 
            begin
                C0 = 0;C1 = 0;
                state_next = S0;
            end
        endcase
    end
endmodule
