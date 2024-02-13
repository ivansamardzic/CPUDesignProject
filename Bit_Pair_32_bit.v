module Bit_Pair_32_bit(input [31:0] a, input [31:0] b, output reg[63:0] z);

integer i,j; 
reg [31:0] m;
reg [2:0] q; 

wire [31:0] neg_b; 
assign neg_b = ~b + 1'b1;

reg [63:0] product;
reg [63:0] temp; 


    always @(*)
    begin
	 product = 64'b0; 
        for (i = 0; i < 32; i = i + 2)
            begin 
                if(i == 0) 
                    q = {a[1], a[0], 1'b0}; 
                else 
                    q = {a[i+1], a[i], a[i-1]}; 
                    
                case(q)
                    3'b000: m = 0;
                    3'b001: m = b; 
                    3'b010: m = b; 
                    3'b011: m = b << 1;  
    
                    3'b100: m = neg_b << 1;
                    3'b101: m = neg_b; 
                    3'b110: m = neg_b; 
                    3'b111: m = 0; 
                endcase
					 temp = $signed(m); 
                temp = temp << i;
                product = product + temp; 
            end 
        z = product; 
    end    

endmodule
