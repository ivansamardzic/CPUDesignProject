module NEG_32_bit(
    input wire [31:0]Ra,
    output wire [31:0]Rz
);

	for (i=0; i<32; i=i+1) begin : loop
		assign Rz[i] = !Ra[i];
	end

    assign Rz = Rz + 1'b1;


endmodule