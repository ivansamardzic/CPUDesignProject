module Bit_Pair_32_bit(input signed [31:0] a, b, output [63:0] z);
//a = q
//b = m
//variables

integer i,j; 
reg [31:0] m;
reg [31:0] q; 

wire [31:0] neg_b; 
neg_32_bit N(b, neg_b); 
reg [63:0] product = 64'b0;
reg [63:0] temp; 


    always @(a or b)
    begin
        for (j = 0; j < 16; j++)
            begin 
            i = j * 2; 
                if(i == 0) 
                    q[i] = {a[1], a[0], a[0]}; 
                else 
                    q[i] = {a[i+1], a[i], a[i-1]}; 
                    
                case(q[i])
                    3'b000: m = 0;
                    3'b001: m = b; 
                    3'b010: m = b; 
                    3'b011: shl_32_bit S1(.in(b), .shift(1), .out(m));  
    
                    3'b100: shl_32_bit S2(.in(neg_b), .shift(1), .out(m));
                    3'b101: m = neg_b; 
                    3'b110: m = neg_b; 
                    3'b111: m = 0; 
                endcase
                shl_32_bit S3(.in(m), .shift(i), .out(temp))
                product = product + temp; 
            end 
        assign z = product; 
    end
    

endmodule
