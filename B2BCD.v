`timescale 1ns / 1ps

module B2BCD(clk,P,F,BCD);
input clk;
input [9:0]P,F;
output [31:0]BCD;
localparam [2:0] S0 = 0,S1 = 1,S2 = 2,S3 = 3,S4 = 4,S5 = 5,S6 = 6,S7 = 7;
reg [2:0] state_reg,state_next;
reg C0,C1,C2,C3,C4,C5;
reg [3:0] D0,D1,D2,D3,BCD0,BCD1,BCD2,BCD3,BCD4,BCD5,BCD6,BCD7,counter;
reg [9:0] r,I;
wire Z;
initial counter = 0;

assign BCD={BCD7,BCD6,BCD5,BCD4,BCD3,BCD2,BCD1,BCD0};

always @(posedge clk)
begin 
    if(C0) 
        counter <= 9;
    else if(C1)
        counter <= counter - 1;
end
assign Z  = (counter == 0);

always @*
begin
    if(C4)
        I <= P;
    else
        I <= F;
end

always @(posedge clk)
begin
    if(C0)
        r <= I;
    else if(C1)
        r <= r << 1;
end

always @(posedge clk)
begin
    if(C0)
        D3 <= 0;
    else if(C1)
        D3 <= {D3[2:0],D2[3]};
end

always @(posedge clk)
begin
    if(C3) 
        begin
            BCD3 <= D3;
            BCD2 <= D2;
            BCD1 <= D1;
            BCD0 <= D0;
        end
    if(C5) 
        begin
            BCD7 <= D3;
            BCD6 <= D2;
            BCD5 <= D1;
            BCD4 <= D0;
        end
end

always @(posedge clk)
begin
    if(C0)
        D2 <= 0;
        else if(C1)
            D2 <= {D2[2:0],D1[3]};
        else if(C2)
            if(D2 > 4)
                D2 <= D2 + 3;
end

always @(posedge clk)
begin
    if(C0)
        D1 <= 0;
    else if(C1)
        D1 <= {D1[2:0],D0[3]};
    else if(C2)
        if(D1 > 4)
            D1 <= D1 + 3;
end

always @(posedge clk)
begin
    if(C0)
        D0 <= 0;
    else if(C1)
        D0 <= {D0[2:0],r[9]};
    else if(C2)
        if(D0 > 4)
            D0 <= D0 + 3;
end

always@(posedge clk)
begin
    state_reg <= state_next;
end
always @*
begin
    case(state_reg)
    S0:
        begin
            C0 = 1;C1 = 0;C2 = 0;C3 = 0;C4 = 0;C5 = 0;
            state_next = S1;
        end
    S1:
        begin
            C0 = 0;C1 = 0;C2 = 1;C3 = 0;C4 = 0;C5 = 0;
            state_next = S2;
        end
    S2:
        begin
            if(Z)
                begin
                    C0 = 0;C1 = 1;C2 = 0;C3 = 0;C4 = 0;C5 = 0;
                    state_next = S3;
                end
            else
                begin
                    C0 = 0;C1 = 1;C2 = 0;C3 = 0;C4 = 0;C5 = 0;
                    state_next = S1;
                end
        end
    S3:
        begin
            C0 = 0;C1 = 0;C2 = 0;C3 = 1;C4 = 0;C5 = 0;
            state_next = S4;
        end
    S4:
        begin
            C0 = 1;C1 = 0;C2 = 0;C3 = 0;C4 = 1;C5 = 0;
            state_next = S5;
        end 
    S5:
        begin
            C0 = 0;C1 = 0;C2 = 1;C3 = 0;C4 = 0;C5 = 0;
            state_next = S6;
        end
    S6:
        begin
            if(Z)
                begin
                    C0 = 0;C1 = 1;C2 = 0;C3 = 0;C4 = 0;C5 = 0;
                    state_next = S7;
                end
             else
                begin
                    C0 = 0;C1 = 1;C2 = 0;C3 = 0;C4 = 0;C5 = 0;
                    state_next = S5;
                end
        end
    S7:
        begin
            C0 = 0;C1 = 0;C2 = 0;C3 = 0;C4 = 0;C5 = 1;
            state_next = S0;
        end 
    default:
    begin
        C0 = 0;C1 = 0;C2 = 0;C3 = 0;C4 = 0;C5 = 0;
        state_next = S0;
    end
    endcase
end
endmodule
