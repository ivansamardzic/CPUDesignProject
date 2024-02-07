module MDR(
	input clear, clock, MDRin,
	input [31:0]BMout, Mdatain, //MDR register has extra Mdatain input
	input read,												// extra signal for MDMux select, see Phase 1 documentation
	
	output wire [31:0]BMInMDR		// '02/01', output to memory chip should prob also be here 
);

reg [31:0]q;

initial q = 8'h00000002;

always @ (posedge clock)
		begin
			if (clear) begin
				q <= {32{1'b0}};
			end
			else if (MDRin) begin
				if(read) q <= Mdatain; //assuming read=1 means read from mem chip
				else q <= BMout; // otherwise set q to data from bus
			end
		end
		
	assign BMInMDR = q[31:0];
endmodule
