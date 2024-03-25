module MDR(
	input clear, clock, MDRin,
	input [31:0]BusMuxOut, Mdatain,
	input MD_read,												
	
	output wire [31:0]BusMuxInMDR	
	);
	
	reg [31:0]q;
	initial q = 8'h00000000;
	
	always @ (posedge clock)
		begin
			if (clear) q <= {32{1'b0}};
			else if (MDRin) 
				begin
					if(MD_read) q <= Mdatain; 
					else q <= BusMuxOut; 
				end
		end
		
	assign BusMuxInMDR = q[31:0];
endmodule
