module MDR (
	//MDMux
	input [31:0]BusMuxOut, 
	input [31:0]Mdatain, 
	input wire Read,
	//MDR
	input wire Clear, 
	input wire Clock, 
	input wire MDRin,

	output wire [31:0]MDRout 
);

	wire [31:0]MDMuxout;

	reg [31:0]q;

	//call register 
	
	
	always @ (posedge Clock) begin
		if(Read) begin 
			q = Mdatain;
		end
		else begin
			q = BusMuxOut;
		end
		end 
	assign MDMuxout = q; 
	
	register MDR(Clear, Clock, MDRin, MDMuxout, BusMuxInMDR);
	
//	always @ (posedge Clock) begin
//		if(Read == 1) begin 
//			q = Mdatain;
//		end
//		else begin
//			q = BusMuxOut;
//		end
//		end 
//	assign MDMuxout = q; 
endmodule
