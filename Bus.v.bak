module Bus (
	//Mux
	//23 inputs based on 32:1 Multiplixer BusMux from Figure 3
	input [31:0]BMInR0, 
	input [31:0]BMInR1, 
	input [31:0]BMInR2, 
	input [31:0]BMInR3, 
	input [31:0]BMInR4, 
	input [31:0]BMInR5, 
	input [31:0]BMInR6, 
	input [31:0]BMInR7, 
	input [31:0]BMInR8, 
	input [31:0]BMInR9, 
	input [31:0]BMInR10, 
	input [31:0]BMInR11, 
	input [31:0]BMInR12, 
	input [31:0]BMInR13, 
	input [31:0]BMInR14, 
	input [31:0]BMInR15,
	
	input [31:0]BMInHI, 
	input [31:0]BMInLO, 
	input [31:0]BMInZhigh, 
	input [31:0]BMInZlow, 
	input [31:0]BMInPC, 
	input [31:0]BMInMDR, 
	input [31:0]BMInInPort, 
	input [31:0]BMInCSign, 
	//Encoder
	//23 outputs based on 32-to-5 Encoder from Figure 3
	input R0out,
	input R1out, 
	input R2out, 
	input R3out, 
	input R4out, 
	input R5out, 
	input R6out, 
	input R7out, 
	input R8out, 
	input R9out, 
	input R10out, 
	input R11out, 
	input R12out, 
	input R13out, 
	input R14out, 
	input R15out,
	
	input HIout, 
	input LOout, 
	input Zhighout, 
	input Zlowout, 
	input PCout, 
	input MDRout, 
	input InPortout, 
	input Cout,

	output wire [31:0]BusMuxOut
);
	reg [31:0]q;

always @ (*) begin
	if(R0out) q = BMInR0;
	if(R1out) q = BMInR1;
	if(R2out) q = BMInR2;
	if(R3out) q = BMInR3;
	if(R4out) q = BMInR4; 
	if(R5out) q = BMInR5;
	if(R6out) q = BMInR6;
	if(R7out) q = BMInR7;
	if(R8out) q = BMInR8; 
	if(R9out) q = BMInR9;
	if(R10out) q = BMInR10; 
	if(R11out) q = BMInR11;
	if(R12out) q = BMInR12;
	if(R13out) q = BMInR13;
	if(R14out) q = BMInR14;
	if(R15out) q = BMInR15; 
	
	if(HIout) q = BMInHI; 
	if(LOout) q = BMInLO;
	if(zhighout) q = BMInZhigh;
	if(zlowout) q = BMInZlow;
	if(PCout) q = BMInPC; 
	if(MDRout) q = BMInMDR;
	if(InPortout) q = BMInInPort;
	if(Cout) q = BMInCSign; 
end
assign BusMuxOut = q;
endmodule
