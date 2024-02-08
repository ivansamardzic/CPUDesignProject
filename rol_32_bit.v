module rol_32_bit(input wire[31:0] in, roll, output wire[31:0] out);
    shl_32_bit sh(in, roll, out);
    assign out [roll:0] = in [31:31 - roll]; 
endmodule
