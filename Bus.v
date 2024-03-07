module Bus (
	//Mux
	//23 inputs based on 32:1 Multiplixer BusMux from Figure 3
	input [31:0]BMInR0, BMInR1, BMInR2, BMInR3, BMInR4, BMInR5, BMInR6, BMInR7, BMInR8, BMInR9, BMInR10, BMInR11, BMInR12, BMInR13, BMInR14, BMInR15,
	
	input [31:0]BMInHI, C_sign_extended, BMInLO, BMInZhigh, BMInZlow, BMInPC, BusMuxInMDR, BMInInPort, 
	
	input [31:0]BMInINPORT,
	
	//Encoder
	//23 outputs based on 32-to-5 Encoder from Figure 3
	input R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
	
	input Strobe, 
	
	input HIout, LOout, Zhighout, Zlowout, PCout, MDRout, InPortout, Csignout, 

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
		
		if(Csignout) q = C_sign_extended; 
		if(Strobe) q = BMInINPORT; 
		
		if(HIout) q = BMInHI; 
		if(LOout) q = BMInLO;
		if(Zhighout) q = BMInZhigh;
		if(Zlowout) q = BMInZlow;
		if(PCout) q = BMInPC; 
		if(MDRout) q = BusMuxInMDR;
		if(InPortout) q = BMInInPort;
	end
	assign BusMuxOut = q;
endmodule
