module sub_32_bit(
    input Cin, 
    input [31:0] a, 
    input [31:0] b, 
    output Cout, 
    output [31:0] sum
);
    wire [31:0] temp; 
    neg_32_bit neg(b, temp);
    CarrySelectAdder_32_bit add(0, a, temp, Cout, sum);

endmodule
