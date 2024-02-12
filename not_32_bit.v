module not_32_bit(
    input wire [31:0]Ra,
    output wire [31:0]Rz
);
	assign Rz = ~Ra;
	
endmodule
