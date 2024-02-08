  module shra_32_bit(input wire [31:0] in, integer shift, output wire[31:0] out);
    shr_32_bit sh1(in, shift, out_1); 
    shr_32_bit sh0(in, shift, out_0); 
    
    assign out_1 [31:31 - shift] = 1'b1; 
    assign out_0 [31:31 - shift] = 1'b0; 
    
    assign out = (in[31]) ? out_1:out_0; 
  endmodule
