module And(
    input [31:0]Ra,
    input [31:0]Rb,
    output [31:0]Rz
);

	assign Rz = Ra & Rb;

endmodule

