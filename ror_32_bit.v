module ror_32_bit(input wire [31:0] in, input [31:0] roll, output wire [31:0] out)
    shr_32_bit sh(in, roll, out); 
    assign out [31:31 - roll] = in [roll:0]; 
endmodule
