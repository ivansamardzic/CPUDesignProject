module DataPath(
//test
	
	input wire PCout, Zlowout, MDRout, R2out, R3out, // add any other signals to see in your simulation
   input wire MARin, Zin,
   input wire IncPC, Read, AND, R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in, PCin, IRin, MDRin, InPortin, OutPortin, Cin, Yin, HIin, LOin, ZHIin, ZLOin,
   input wire Clock, clear,
   input wire [31:0] Mdatain
);

wire [31:0] BusMuxOut, BMInR0, BMInR1, BMInR2, BMInR3, BMInR4, BMInR5, BMInR6, BMInR7, BMInR8, BMInR9, 
BMInR10, BMInR11, BMInR12, BMInR13, BMInR14, BMInR15, BMInPC, BMInMDR, BMInCSign, BMInHI, BMInLO, BMInZhigh, BMInZlow, BusMuxInMDR; 

wire [31:0] Zregin;

//Register Assignment
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

register PC_reg(IncPC, clock, PCin, BusMuxOut, BMInPC);
//register IR_reg(clear, clock, IRin, BusMuxOut, BMInPC)*
//register InPort_reg(clear, clock, InPortin, BusMuxOut, BMInInPort)*
//register OutPort_reg(clear, clock, OutPortin, BusMuxOut, BMInPC)*
register C_reg(clear, clock, Cin, BusMuxOut, BMInCSign);
//register Y_reg(clear, clock, Yin, BusMuxOut, BMInPC)*
register HI_reg(clear, clock, HIin, BusMuxOut, BMInHI);
register LO_reg(clear, clock, LOin, BusMuxOut, BMInLO);
register Z_HI_reg(clear, clock, ZHIin, BusMuxOut, BMInZhigh);
register Z_LO_reg(clear, clock, ZLOin, BusMuxOut, BMInZlow);


// adder

and_32_bit and_32(RA, RB, RZ);
MDR mdr(BuxMuxOut, Mdatain, Read, clear, clock, MDRin, BusMuxInMDR);



//register RZ(clear, clock, RZin, Zregin, BusMuxInRZ);

//Bus
Bus bus(


			//Flags 1 bit
			.R0out(R0in),
			.R1out(R1in),
			.R2out(R0in),
			.R3out(R0in),
			.R4out(R0in),
			.R5out(R0in),
			.R6out(R0in),
			.R7out(R0in),
			.R8out(R0in),
			.R9out(R0in),
			.R10out(R0in),
			.R11out(R0in),
			.R12out(R0in),
			.R13out(R0in),
			.R14out(R0in),
			.R15out(R0in),
			
			.HIout(HIin),
			.LOout(LOin),
			.Zhighout(ZHIin),
			.Zlowout(ZLOin),
			.PCout(PCin),
			.MDRout(MDRin),
			//.InPortout(),
			.Cout(Cin),
			
			
			
			

			//Data, 32 bit
			.BMInR0(BMInR0),
			.BMInR1(BMInR1),
			.BMInR2(BMInR2),
			.BMInR3(BMInR3),
			.BMInR4(BMInR4),
			.BMInR5(BMInR5),
			.BMInR6(BMInR6),
			.BMInR7(BMInR7),
			.BMInR8(BMInR8),
			.BMInR9(BMInR9),
			.BMInR10(BMInR10),
			.BMInR11(BMInR11),
			.BMInR12(BMInR12),
			.BMInR13(BMInR13),
			.BMInR14(BMInR14),
			.BMInR15(BMInR15),
			
			.BMInHI(BMInHI),
			.BMInLO(BMInLO),
			.BMInZhigh(BMInZhigh),
			.BMInZlow(BMInZlow),
			.BMInPC(BMInPC),
			.BMInMDR(BMInMDR),
			.BMInInPort(BMInInPort),
			.BMInCSign(BMInCSign)
	
			);

endmodule
