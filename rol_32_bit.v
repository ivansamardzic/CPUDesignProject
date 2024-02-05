module rol_32_bit(input reg [31:0] in, [31:0] roll, output reg [31:0] out)
    shl_32_bit sh(in, roll, out);
    assign out [roll:0] = in [31:31 - roll]; 
endmodule
