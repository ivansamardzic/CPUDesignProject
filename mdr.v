module mdr (
	//MDMux
	input [31:0]BusMuxOut, input [31:0]Mdatain, Read
	//MDR
	input Clear, Clock, MDRin,

	output wire [31:0]MDMuxout,
	wire [31:0] MDRout register (Clock, MDRin, CLear, MDMuxout)  

);

reg [31:0]q;

always @ (*) begin
	if(Read) MDMuxout = Mdatain;
	else 
	MDMuxout = BusMuxOut;

end
endmodule
