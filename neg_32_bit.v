module neg_32_bit(
    input wire [31:0]Ra,
    output wire [31:0]Rz
);

	not_32_bit N(Ra, Rz); 
    	assign Rz = Rz + 1'b1;
endmodule
