module Bus (
	//Mux
	//23 inputs based on 32:1 Multiplixer BusMux from Figure 3
	input [31:0]BMInR0, input [31:0]BMInR1, input [31:0]BMInR2, input [31:0]BMInR3, input [31:0]BMInR4, input [31:0]BMInR5, input [31:0]BMInR6, input [31:0]BMInR7, input [31:0]BMInR8, input [31:0]BMInR9, input [31:0]BMInR10, input [31:0]BMInR11, input [31:0]BMInR12. input [31:0]BMInR13, input [31:0]BMInR14, input [31:0]BMInR15, input [31:0]BMInHIout, input [31:0]BMInLOout, input [31:0]BMInZhighout, input [31:0]BMInZlowout, input [31:0]BMInPC, input [31:0]BMInMDR, input [31:0]BMInInport, input [31:0]BMInCSign 
	//Encoder
	//23 outputs based on 32-to-5 Encoder from Figure 3
	input R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out, HIout, LOout, Zhighout, Zlowout, PCout, MDRout, InPortout, Cout

	output wire [31:0]BusMuxOut
);

reg [7:0]q;

always @ (*) begin
	if(RZout) q = BusMuxInRZ;
	if(RAout) q = BusMuxInRA;
	if(RBout) q = BusMuxInRB;
end
assign BusMuxOut = q;
endmodule
