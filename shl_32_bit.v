module shl_32_bit(input wire[31:0] in, input wire[31:0] shift, output wire[31:0] out);

  assign out[31:0] = in[31:0] << shift;  
  
endmodule
