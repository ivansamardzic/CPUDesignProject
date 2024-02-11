`timescale 1ns/10ps

module DataPath(
	input wire clock, clear,
	input wire R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
	input wire HIin, LOin, Zlowin, Zhighin, PCin, MDRin, MARin, InPortin, Cin, MD_read,
	input wire IncPC, IRin, OutPortin, Yin, 
	
	input wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
	input wire HIout, LOout, Zhighout, Zlowout, PCout, MDRout, MARout, InPortout, Cout,
	
	//change to outs later
   //input wire Zin, IncPC, IRin,  OutPortin,  Yin,  	
	input wire [31:0] Mdatain
);

	wire [31:0] BMInR0, BMInR1, BMInR2, BMInR3, BMInR4, BMInR5, BMInR6, BMInR7, BMInR8, BMInR9, BMInR10, BMInR11, BMInR12, BMInR13, BMInR14, BMInR15; 
	wire [31:0] BusMuxOut, BMInPC, BMInIR, BusMuxInMDR, BusMuxInMAR, BMInCSign, BMInHI, BMInLO, BMInZhigh, BMInZlow, BMInY; 
	wire [63:0] C; 

	
	//MDR mdr(BuxMuxOut, Mdatain, MD_read, clear, clock, MDRin, MDRout);
	MDR mdr(.clear(clear), .clock(clock), .MDRin(MDRin), .BusMuxOut(BusMuxOut), .Mdatain(Mdatain), .read(MD_read), .BusMuxInMDR(BusMuxInMDR));
	
	register MAR(clear, clock, MARin, BusMuxOut, BusMuxInMAR);
	//Register Assignment
	//clear, clock, enable, input, output 
	register R0(clear, clock, R0in, BusMuxOut, BMInR0);
	register R1(clear, clock, R1in, BusMuxOut, BMInR1);
	register R2(clear, clock, R2in, BusMuxOut, BMInR2);
	register R3(clear, clock, R3in, BusMuxOut, BMInR3);
	register R4(clear, clock, R4in, BusMuxOut, BMInR4);
	register R5(clear, clock, R5in, BusMuxOut, BMInR5);
	register R6(clear, clock, R6in, BusMuxOut, BMInR6);
	register R7(clear, clock, R7in, BusMuxOut, BMInR7);
	register R8(clear, clock, R8in, BusMuxOut, BMInR8);
	register R9(clear, clock, R9in, BusMuxOut, BMInR9);
	register R10(clear, clock, R10in, BusMuxOut, BMInR10);
	register R11(clear, clock, R11in, BusMuxOut, BMInR11);
	register R12(clear, clock, R12in, BusMuxOut, BMInR12);
	register R13(clear, clock, R13in, BusMuxOut, BMInR13);
	register R14(clear, clock, R14in, BusMuxOut, BMInR14);
	register R15(clear, clock, R15in, BusMuxOut, BMInR15);
	
	register Z_HI_reg(clear, clock, Zhighin, C[63:32], BMInZhigh);
	register Z_LO_reg(clear, clock, Zlowin, C[31:0], BMInZlow); //high and low FIX!!!!!!!!!!!!!!!!

	register HI_reg(clear, clock, HIin, BusMuxOut, BMInHI);
	register LO_reg(clear, clock, LOin, BusMuxOut, BMInLO);
	register PC_reg(IncPC, clock, PCin, BusMuxOut, BMInPC);
	register InPort_reg(clear, clock, InPortin, BusMuxOut, BMInInPort);
	//register C_reg(clear, clock, Cin, BusMuxOut, BMInCSign);
	register IR_reg(clear, clock, IRin, BusMuxOut, BMInIR); 
	//register OutPort_reg(clear, clock, OutPortin, BusMuxOut, BMInPC)
	register Y_reg(clear, clock, Yin, BusMuxOut, BMInY);

	
	Bus bus(
		.BMInR0(BMInR0), .BMInR1(BMInR1), .BMInR2(BMInR2), .BMInR3(BMInR3), .BMInR4(BMInR4), .BMInR5(BMInR5), .BMInR6(BMInR6), .BMInR7(BMInR7), .BMInR8(BMInR8), .BMInR9(BMInR9), .BMInR10(BMInR10), .BMInR11(BMInR11), .BMInR12(BMInR12), .BMInR13(BMInR13), .BMInR14(BMInR14), .BMInR15(BMInR15),
		.BMInHI(BMInHI), .BMInLO(BMInLO), .BMInZhigh(BMInZhigh), .BMInZlow(BMInZlow), .BMInPC(BMInPC), .BusMuxInMDR(BusMuxInMDR), .BMInInPort(BMInInPort), .BMInCSign(BMInCSign),

		.R0out(R0out), .R1out(R1out), .R2out(R2out), .R3out(R3out), .R4out(R4out), .R5out(R5out), .R6out(R6out), .R7out(R7out), .R8out(R8out), .R9out(R9out), .R10out(R10out), .R11out(R11out), .R12out(R12out), .R13out(R13out), .R14out(R14out), .R15out(R15out),
		.HIout(HIout), .LOout(LOout), .Zhighout(Zhighout), .Zlowout(Zlowout), .PCout(PCout), .MDRout(MDRout), .InPortout(InPortout), .Cout(Cout),
		
		.BusMuxOut(BusMuxOut)
		);
	
	ALU alu(.Y(BMInY), .BusMuxOut(BusMuxOut), .op(BMInIR), .C(C));
endmodule

