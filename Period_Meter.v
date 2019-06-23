`timescale 1ns / 1ps

module Period_Meter(clk,NE,P);
    input clk,NE;
    output reg [9:0] P;
    reg [7:0] n_count;
    reg [9:0] pc_count;
    reg C0,C1,C2,C3;
    wire Z;
    reg [1:0] state_next,state_reg;
    localparam [1:0] S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
    initial state_reg = S0;
    
    //n-bit Down Counter
    always@(posedge clk)
    begin
        if(C1)
            n_count <= 100;
        else
            n_count <= n_count - 1;
    end
    
    assign Z = (n_count == 0);
    
    //PC up counter
    always@(posedge clk)
    begin
        if(C2)
            begin
                if(Z)
                    pc_count <= pc_count + 1;
                else if(C0)
                    pc_count <= 0;
            end
    end
    
    //P Register
    always@(posedge clk)
    begin
        if(C3)
            P <= pc_count;
    end
    
    //FSM
    always@(posedge clk)
        state_next <= state_reg;
        
    always@*
    begin
        state_next = state_reg;
        case(state_reg)
        
            S0:
            begin
                C3 = 0; C2 = 0; C1 = 0; C0 = 1;
                state_next = S1;
            end
            
            S1:
            begin
                if(NE)
                begin
                    C3 = 0; C2 = 1; C1 = 1; C0 = 0;
                    state_next = S2;
                end
                else
                begin
                    C3 = 0; C2 = 0; C1 = 0; C0 = 0;
                    state_next = S1;
                end
            end
            
            S2:
            begin
                if(Z == 0)
                begin
                    if(NE)
                    begin
                    C3 = 0; C2 = 1; C1 = 1; C0 = 0;
                    state_next = S2;
                    end  
                else
                begin
                    C3 = 0; C2 = 1; C1 = 0; C0 = 0;
                    state_next = S2;
                end
                end
                if(NE)
                begin
                    C3 = 1; C2 = 0; C1 = 0; C0 = 0;
                    state_next = S3;
                end
            end
            
            S3:
            begin
                C3 = 0; C2 = 0; C1 = 0; C0 = 0;
                state_next = S0;
            end
            default:
            begin
                C3 = 0; C2 = 0; C1 = 0; C0 = 0;
                state_next = S0;
            end
        endcase
    end
    
endmodule
