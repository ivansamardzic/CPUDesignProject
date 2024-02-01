module And_32_bit(
    input [31:0]Ra,
    output [31:0]Rz
);

	for (i=0; i<32; i=i+1) begin : loop
			assign Rz[i] = !Ra[i];
		end

endmodule