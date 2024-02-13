module Bit_Pair_32_bit(wire input [31:0] a, wire input [31:0] b, output reg[63:0] z);
//a = q
//b = m
variables

integer i,j; 
reg [63:0] m;
reg [31:0] q; 

wire [31:0] neg_b; 
assign z = a; 
assign neg_b = ~b + 1'b1;

reg [63:0] product;
reg [63:0] temp; 


    always @(*)
    begin
	 product = 64'b0; 
        for (j = 0; j < 16; j=j+1)
            begin 
            i = j * 2; 
//                if(i == 0) 
//                    q[i] = {a[1], a[0], a[0]}; 
//                else 
//                    q[i] = {a[i+1], a[i], a[i-1]}; 
//                    
                case(q[i])
                    3'b000: m = 0;
                    3'b001: m = b; 
                    3'b010: m = b; 
                    3'b011: m = b << 1;  
    
                    3'b100: m = neg_b << 1;
                    3'b101: m = neg_b; 
                    3'b110: m = neg_b; 
                    3'b111: m = 0; 
                endcase
                temp = m << i;
                product = product + temp; 
            end 
        z = product; 
    end
endmodule
