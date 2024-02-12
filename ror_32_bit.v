module ror_32_bit(input wire [31:0] in, input wire[31:0] roll, output wire [31:0] out);

	 
    assign out = (in >> roll) | { (in << (32 - roll))[31:0], {32-roll{1'b0}} };


endmodule
