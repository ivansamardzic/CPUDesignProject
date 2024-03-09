`timescale 1ns/10ps

module DataPath(
	input wire clock, clear,
	
	input wire HIin, LOin, Zlowin, Zhighin, PCin, MDRin, MARin, InPortin, Cin, MD_read,
	input wire IncPC, IRin, OutPortin, Yin, 
	input wire Out_Portin, Strobe, 
	
	input wire HIout, LOout, Zhighout, Zlowout, PCout, MDRout, MARout, InPortout, 
	
	input wire Gra, Grb, Grc, Rin, Rout, BAout, Csignout, Read, Write, 
	input wire ADD, 
	
	input wire CONin, CONFF,  
	//change to outs later
   //input wire Zin, IncPC, IRin,  OutPortin,  Yin,  	
	input wire [31:0] Mdatain
	//input wire [31:0] INPUT_UNIT,
	//input wire [31:0] OUTPUT_UNIT
);

	wire [31:0] BMInR0, BMInR1, BMInR2, BMInR3, BMInR4, BMInR5, BMInR6, BMInR7, BMInR8, BMInR9, BMInR10, BMInR11, BMInR12, BMInR13, BMInR14, BMInR15; 
	wire [31:0] BMInINPORT;
	wire [31:0] BusMuxOut, C_sign_extended, BMInPC, BMInIR, BusMuxInMDR, BusMuxInMAR, BMInHI, BMInLO, BMInZhigh, BMInZlow, BMInY; 
	wire [63:0] C; 
	
	wire [15:0] IN, OUT; 
	wire [8:0] address;
	
	
	
	//MDR mdr(BuxMuxOut, Mdatain, MD_read, clear, clock, MDRin, MDRout);
	MDR mdr(.clear(clear), .clock(clock), .MDRin(MDRin), .BusMuxOut(BusMuxOut), .Mdatain(Mdatain), .read(MD_read), .BusMuxInMDR(BusMuxInMDR));
	
	register IR_reg(clear, clock, IRin, BusMuxOut, BMInIR); 
	
	Select_Encode E1(.BMInIR(BMInIR), .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rin(Rin), .Rout(Rout), .BAout(BAout), .IN(IN), .OUT(OUT), .C_sign_extended(C_sign_extended)); 
	
	I_O E2(.clear(clear), .clock(clock), .Out_Portin(Out_Portin), .Strobe(Strobe), .BusMuxOut(BusMuxOut), .OUTPUT_UNIT(OUTPUT_UNIT), .INPUT_UNIT(INPUT_UNIT), .BMInINPORT(BMInINPORT));
	
	MAR mar(.clear(clear), .clock(clock), .MARin(MARin), .BusMuxOut(BusMuxOut), .address(address));
	
	RAM ram(.Read(Read), .Write(Write), .clock(clock), .DataIn(BusMuxOut), .address(address), .DataOut(Mdatain));  
	
	CON_FF con(.BMInIR(BMInIR), .BusMuxOut(BusMuxOut), .CONin(CONin), .Q(CONFF));
	
	
	//Register Assignment
	//clear, clock, enable, input, output 
	
	
	
	//register R0
	reg [31:0]q;
	initial q = 32'h0;

	always @ (posedge clock)
			begin 
				if (clear) begin
					q <= 32'h0;
				end
				else if (IN[0]) begin
					q <= BusMuxOut;
				end
			end
		assign BMInR0 = q & ~BAout; //may need to concatenate 
		
		
	register R1(clear, clock, IN[1], BusMuxOut, BMInR1);
	register R2(clear, clock, IN[2], BusMuxOut, BMInR2);
	register R3(clear, clock, IN[3], BusMuxOut, BMInR3);
	register R4(clear, clock, IN[4], BusMuxOut, BMInR4);
	register R5(clear, clock, IN[5], BusMuxOut, BMInR5);
	register R6(clear, clock, IN[6], BusMuxOut, BMInR6);
	register R7(clear, clock, IN[7], BusMuxOut, BMInR7);
	register R8(clear, clock, IN[8], BusMuxOut, BMInR8);
	register R9(clear, clock, IN[9], BusMuxOut, BMInR9);
	register R10(clear, clock, IN[10], BusMuxOut, BMInR10);
	register R11(clear, clock, IN[11], BusMuxOut, BMInR11);
	register R12(clear, clock, IN[12], BusMuxOut, BMInR12);
	register R13(clear, clock, IN[13], BusMuxOut, BMInR13);
	register R14(clear, clock, IN[14], BusMuxOut, BMInR14);
	register R15(clear, clock, IN[15], BusMuxOut, BMInR15);
	
	register Z_HI_reg(clear, clock, Zhighin, C[63:32], BMInZhigh);
	register Z_LO_reg(clear, clock, Zlowin, C[31:0], BMInZlow);

	register HI_reg(clear, clock, HIin, BusMuxOut, BMInHI);
	register LO_reg(clear, clock, LOin, BusMuxOut, BMInLO);
	register PC_reg(IncPC, clock, PCin, BusMuxOut, BMInPC);
	register InPort_reg(clear, clock, InPortin, BusMuxOut, BMInInPort);
	//register C_reg(clear, clock, Cin, BusMuxOut, BMInCSign)
	//register OutPort_reg(clear, clock, OutPortin, BusMuxOut, BMInPC)
	register Y_reg(clear, clock, Yin, BusMuxOut, BMInY);

	
	Bus bus(
		.C_sign_extended(C_sign_extended), .Strobe(Strobe), .BMInINPORT(BMInINPORT), 
		
		.BMInR0(BMInR0), .BMInR1(BMInR1), .BMInR2(BMInR2), .BMInR3(BMInR3), .BMInR4(BMInR4), .BMInR5(BMInR5), .BMInR6(BMInR6), .BMInR7(BMInR7), .BMInR8(BMInR8), .BMInR9(BMInR9), .BMInR10(BMInR10), .BMInR11(BMInR11), .BMInR12(BMInR12), .BMInR13(BMInR13), .BMInR14(BMInR14), .BMInR15(BMInR15),
		.BMInHI(BMInHI), .BMInLO(BMInLO), .BMInZhigh(BMInZhigh), .BMInZlow(BMInZlow), .BMInPC(BMInPC), .BusMuxInMDR(BusMuxInMDR), .BMInInPort(BMInInPort),

		.Csignout(Csignout),
		
		.R0out(OUT[0]), .R1out(OUT[1]), .R2out(OUT[2]), .R3out(OUT[3]), .R4out(OUT[4]), .R5out(OUT[5]), .R6out(OUT[6]), .R7out(OUT[7]), .R8out(OUT[8]), .R9out(OUT[9]), .R10out(OUT[10]), .R11out(OUT[11]), .R12out(OUT[12]), .R13out(OUT[13]), .R14out(OUT[14]), .R15out(OUT[15]),
		.HIout(HIout), .LOout(LOout), .Zhighout(Zhighout), .Zlowout(Zlowout), .PCout(PCout), .MDRout(MDRout), .InPortout(InPortout),
		
		.BusMuxOut(BusMuxOut)
		);
		
	
		ALU alu(.Y(BMInY), .BusMuxOut(BusMuxOut), .op(4'b0100), .enable(ADD), .C(C));

	
	
		//ADD LOGIC_____________________________________________________________ call alu later but im lazy 
	
	
endmodule

