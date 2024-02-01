module ror_32_bit(input reg [31:0] in, [31:0] roll, output reg [31:0] out)
    out = in >> shift; 
    out[31:31-shift] = in[shift:0] ; 
endmodule
