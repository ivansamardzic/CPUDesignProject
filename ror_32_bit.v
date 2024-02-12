module ror_32_bit(input wire [31:0] in, input wire[31:0] amount, output wire [31:0] out);

	 
    assign out = (in >> amount) | (in << (32 - amount));


endmodule
