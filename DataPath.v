module DataPath(

	//declarations
	input wire clock, clear,
	input wire R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
	input wire HIin, LOin, ZHIin, ZLOin, PCin, MDRin, MARin, InPortin, Cin, MD_read,
	

	//not sure whats acc being used of this below
   input wire  Zin,
   input wire IncPC, IRin,  OutPortin,  Yin,  
	
	
	
	

   input wire [31:0] Mdatain
);

wire [31:0] BusMuxOut, BMInR0, BMInR1, BMInR2, BMInR3, BMInR4, BMInR5, BMInR6, BMInR7, BMInR8, BMInR9, 
BMInR10, BMInR11, BMInR12, BMInR13, BMInR14, BMInR15, BMInPC, BMInMDR, BMInCSign, BMInHI, BMInLO, BMInZhigh, BMInZlow; 

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

register HI_reg(clear, clock, HIin, BusMuxOut, BMInHI);
register LO_reg(clear, clock, LOin, BusMuxOut, BMInLO);
register Z_HI_reg(clear, clock, ZHIin, BusMuxOut, BMInZhigh);
register Z_LO_reg(clear, clock, ZLOin, BusMuxOut, BMInZlow);
register PC_reg(IncPC, clock, PCin, BusMuxOut, BMInPC);
register InPort_reg(clear, clock, InPortin, BusMuxOut, BMInInPort);
register C_reg(clear, clock, Cin, BusMuxOut, BMInCSign);




//register MDR()
//register IR_reg(clear, clock, IRin, BusMuxOut, BMInPC)
//register OutPort_reg(clear, clock, OutPortin, BusMuxOut, BMInPC)
//register Y_reg(clear, clock, Yin, BusMuxOut, BMInPC)
register RZ(clear, clock, RZin, Zregin, BusMuxInRZ);

// and


//





//Bus
Bus bus(


			//Flags 1 bit
			.R0out(R0in),
			.R1out(R1in),
			.R2out(R2in),
			.R3out(R3in),
			.R4out(R4in),
			.R5out(R5in),
			.R6out(R6in),
			.R7out(R7in),
			.R8out(R8in),
			.R9out(R9in),
			.R10out(R10in),
			.R11out(R11in),
			.R12out(R12in),
			.R13out(R13in),
			.R14out(R14in),
			.R15out(R15in),
			
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
			.BMInCSign(BMInCSign),
			
			.BusMuxOut(BusMuxOut)
	
			);
			and_32_bit and_32(.Ra(BMInR1), .Rb(BMInR2), .Rz(BMInR3));
			
			//MDR mdr(BuxMuxOut, Mdatain, MD_read, clear, clock, MDRin, MDRout);
			MDR mdr(clear, clock, MDRin, BuxMuxOut, Mdatain, MD_read, BMInMDR);

endmodule
