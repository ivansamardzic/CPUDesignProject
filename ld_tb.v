`timescale 1ns/10ps
module ld_tb;
    reg PCout, Zlowout, MDRout; // add any other signals to see in your simulation
    reg Zlowin, PCin, MDRin, IRin, Yin;
    reg IncPC, ADD;
    reg clock, clear, MD_read, MAR_clear;
	 reg MARin, Zhighin;
	 reg Csignout, Grb, Gra, Grc, Read, Rin, BAout, Cout; 
	 reg HIin, LOin, InPortin, Cin, OutPortin, Out_Portin, Strobe, HIout, LOout, Zhighout, MARout, InPortout, Rout;
	 reg [31:0] INPUT_UNIT;
	 reg [31:0] OUTPUT_UNIT;
	 
	 reg Write, CONin, CONFF;

    parameter   Default = 4'b0000, T0 = 4'b0001, T1 = 4'b0010, T2 = 4'b0011, T3 = 4'b0100, T4 = 4'b0101, T5 = 4'b0110, T6 = 4'b0111, T7 = 4'b1000;
    reg [3:0] Present_state = Default;
	 
	 
			  
	DataPath DUT(
		
		.HIin(HIin), .LOin(LOin), .Zlowin(Zlowin), .Zhighin(Zhighin), 
		.clock(clock), .clear(clear), .MAR_clear(MAR_clear),
		.PCin(PCin), .MDRin(MDRin), .MARin(MARin), .InPortin(InPortin), 
		.Cin(Cin), .MD_read(MD_read),
		.IncPC(IncPC), .IRin(IRin), .OutPortin(OutPortin), .Yin(Yin),
		.Out_Portin(Out_Portin), .Strobe(Strobe),
		.HIout(HIout), .LOout(LOout), .Zhighout(Zhighout), .Zlowout(Zlowout),
		.PCout(PCout), .MDRout(MDRout), .MARout(MARout), .InPortout(InPortout),
		.Gra(Gra), .Grb(Grb), .Grc(Grc), .Rin(Rin), .Rout(Rout), .BAout(BAout),
		.Csignout(Csignout), .Read(Read), .Write(Write),
		.ADD(ADD),
		.CONin(CONin), .CONFF(CONFF),
		.INPUT_UNIT(INPUT_UNIT), .OUTPUT_UNIT(OUTPUT_UNIT)
		);
		
		
//		address
//		Cout
//		
//		ADD, CONin, CONFF, Csignout, Read, Write
		
//		     .MDRin(MDRin), .HIin(HIin), .LOin(LOin), .InPortin(InPortin), .Cin(Cin), .Out_Portin(Out_Portin), .Strobe(Strobe), .HIout(HIout),
//			  .LOout(LOout), .Zhighout(Zhighout), .PCout(PCout), .MARout(MARout), InPortout(InPortout), .Rout(Rout), .address(address), 
//			  .INPUT_UNIT(INPUT_UNIT), .OUTPUT_UNIT(OUTPUT_UNIT), 
//		     .MARin(MARin), .PCin(PCin), .MD_read(MD_read),
//		     .Zlowin(Zlowin), .Zhighin(Zhighin), .Zlowout(Zlowout), .IncPC(IncPC), .Yin(Yin), .IRin(IRin),  
//				.MDRout(MDRout), .Gra(Gra), .Grb(Grb), .Grc(Grc), .BAout(BAout), .Cout(Cout), .Rin(Rin), .MAR_clear(MAR_clear));
// add test logic here
		
	initial
		begin
		   clock = 0;
			clear = 0;
		   forever #10 clock = ~ clock;
		end

always @(posedge clock) // finite state machine; if clock rising-edge
    begin
        case (Present_state)
            Default : #40 Present_state = T0;
            T0 : #40 Present_state = T1;
            T1 : #40 Present_state = T2;
            T2 : #40 Present_state = T3;
            T3 : #40 Present_state = T4;
            T4 : #40 Present_state = T5;
				T5 : #40 Present_state = T6;
            T6 : #40 Present_state = T7;
            
        endcase
    end

always @(Present_state)
    begin
        case (Present_state) 
            Default: begin
                    PCout <= 0; Zlowout <= 0; MDRout <= 0; // initialize the signals
                    MARin <= 0; Zlowin <= 0;
                    PCin <=0; MDRin <= 0; IRin <= 0; Yin <= 0;
                    IncPC <= 0; Read <= 0; ADD <= 0;
                     MD_read <= 0;
						  Csignout <= 0; Grb <= 0; Gra <= 0; BAout <= 0; Rin <= 0; MAR_clear <= 1;
            end
		
            T0: begin // see if you need to de-assert these signals
						#10 PCout <= 1; MARin <= 1; IncPC <= 1; Zlowin <= 1;
						#15 PCout <= 0; MARin <= 0; IncPC <= 0; Zlowin <= 0;
            end
            T1: begin
						#10 Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1; MD_read <= 1;  
						#15 Zlowout <= 0; PCin <= 0; Read <= 0; MDRin <= 0; MD_read <= 0;
            end
            T2: begin
                  #10 MDRout <= 1; IRin <= 1; //transfers MDR contents to IR reg
						#15 MDRout <= 0; IRin <= 0;
            end
            T3: begin
                  #10 Grb <= 1; BAout <= 1; Yin <= 1; //R2 contents get put into Yreg
						#15 Grb <= 0; BAout <= 0; Yin <= 0; 
            end
            T4: begin
                  #10 Csignout <= 1; ADD <= 1; Zlowin <= 1; //contents in Creg + Yreg = ZlowReg
						#15 Csignout <= 0; ADD <= 0; Zlowin <= 0; 
            end
            T5: begin
                  #10 Zlowout <= 1; MARin <= 1; //Zreg = address 
						#15 Zlowout <= 0; MARin <= 0;
            end
				T6: begin 
						#10 Read <= 1; MDRin <= 1; MD_read <= 1;
						#15 Read <= 0; MDRin <= 0; MD_read <= 0;
				end
				T7: begin
						#10 MDRout <= 1; Gra <= 1; Rin <= 1; //In register 1
						#15 MDRout <= 0; Gra <= 0; Rin <= 0; 
				end
        endcase
    end
endmodule

