module MDR (
	//MDMux
	input [31:0]BusMuxOut, 
	input [31:0]Mdatain, 
	input wire Read, 
	wire [31:0]MDMuxout,
	//MDR
	input wire Clear, 
	input wire Clock, 
	input wire MDRin,

	output wire [31:0]MDRout 
);

	reg [31:0]q;

	//call register 
	register MDR(Clear, Clock, MDRin, MDMuxout, MDRout);
	
	always @ (*) begin
		if(Read) begin 
			q = Mdatain;
		end
		else begin
			q = BusMuxOut;
		end
		end 
	assign MDMuxout = q; 
endmodule
