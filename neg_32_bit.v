module neg_32_bit(
    input wire [31:0]Ra,
    output wire [31:0]Rz
);

	assign Rz = ~Ra + 1'b1; 

endmodule
