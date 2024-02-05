module shl_32_bit(input wire[31:0] in, shift, output wire[31:0] out);

  assign out = in[31:0] * (2 ** shift);  
  
endmodule
