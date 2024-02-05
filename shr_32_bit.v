module shr_32_bit(input wire [31:0] in, input shift, output wire[31:0] out);

  assign out[31:0] = in[31:0] / (2 ** shift);  
  
endmodule
