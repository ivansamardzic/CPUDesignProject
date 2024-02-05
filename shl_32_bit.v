module shl_32_bit(input [31:0] in, shift, output wire[31:0] out);

  reg [31:0] temp; 
  always @(in)
    begin 
      temp[31:0] = in[31:0] * 2 ** shift;  
    end 
  assign out = temp [31:0]; 
endmodule
