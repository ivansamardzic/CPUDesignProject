module ld(input [31:0] C_sign_extended, Rb, output [31:0] Ra);
	wire Read = 1; 
	wire [8:0]address; 
	wire [31:0] DataOut; 
	
	assign address = C_sign_extended + Rb; 
	
	RAM r1(.Read(Read), .Clock(Clock), .address(address), .DataOut(DataOut));
	
	assign Ra = DataOut;
	
endmodule
