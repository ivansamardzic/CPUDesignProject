`timescale 1ns/10ps
module ld_tb;
    reg PCout, Zlowout, MDRout, R2out, R3out; 
    reg MARin, Zlowin, Zhighin, PCin, MDRin, IRin, Yin;
    reg IncPC, Read, Gra, Grb, Grc, BAout, Cout, ADD, Rin;
    reg clock, clear;
	 reg HIin, LOin, InPortin, Cin, OutPortin, Out_Portin, Strobe, HIout, LOout, Zhighout, MARout, InPortout, Rout;
	 reg [31:0] INPUT_UNIT;
	 reg [31:0] OUTPUT_UNIT;
	 reg [8:0] address;
    reg [31:0] Mdatain;

    parameter   Default = 4'b0000, T0 = 4'b0001, T1 = 4'b0010, T2 = 4'b0011, T3 = 4'b0100, T4 = 4'b0101, T5 = 4'b0110, T6 = 4'b0111, T7 = 4'b1000;
	
	 reg [3:0] Present_state = Default;

	DataPath DUT(.clock(clock), .clear(clear), 
		     .MDRin(MDRin), .HIin(HIin), .LOin(LOin), .InPortin(InPortin), .Cin(Cin), .Out_Portin(Out_Portin), .Strobe(Strobe), .HIout(HIout),
			  .LOout(LOout), .Zhighout(Zhighout), .PCout(PCout), .MARout(MARout), InPortout(InPortout), .Rout(Rout), .address(address), 
			  .INPUT_UNIT(INPUT_UNIT), .OUTPUT_UNIT(OUTPUT_UNIT), 
		     .MARin(MARin), .PCin(PCin), .MD_read(Read),
		     .Zlowin(Zlowin), .Zhighin(Zhighin), .Zlowout(Zlowout), .IncPC(IncPC), .Yin(Yin), .IRin(IRin),  
		     .Mdatain(Mdatain), .MDRout(MDRout), .Gra(Gra), .Grb(Grb), .Grc(Grc), .BAout(BAout), .Cout(Cout), .Rin(Rin));
			  
			  
		
	initial
		begin
		    clock = 0;
		    clear = 0;
		    forever #10 clock = ~ clock;
		end

always @(Present_state) // do the required job in each state
    begin
        case (Present_state)
            Default: begin
                    PCout <= 0; Zlowout <= 0; MDRout <= 0; // initialize the signals
                    MARin <= 0; Zlowin <= 0;
                    PCin <=0; MDRin <= 0; IRin <= 0; Yin <= 0;
                    IncPC <= 0; Read <= 0;
                    Gra <= 0; Grb <= 0; Grc <= 0; BAout <= 0; Cout <= 0; ADD <= 0; Rin <= 0;
            end

		//------------------------------------------------------------
		
            T0: begin //PCout, MARin, IncPC, Zin
                    #10 PCout <= 1; MARin <= 1; IncPC <= 1; Zlowin <= 1;
		            #15 PCout <= 0; MARin <= 0; IncPC <= 0; Zlowin <= 0;		  
            end
            T1: begin //Zlowout, PCin, Read, Mdatain[31..0], MDRin
                    #10 Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
		            #15 Zlowout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
            end
            T2: begin //MDRout, IRin
                    #10 MDRout <= 1; IRin <= 1;
		            #15 MDRout <= 0; IRin <= 0;
            end
            T3: begin //Grb, BAout, Yin
                    #10 Yin <= 1; Grb <= 1; BAout<= 1;
			        #15 Yin <= 0; Grb <= 0; BAout <= 0;
            end
            T4: begin //Cout, ADD, Zin
                    #10 Cout <= 1; ADD <= 1; Zhighin <= 1; Zlowin <= 1;
		            #15 Cout <= 0; ADD <= 0; Zhighin <= 0; Zlowin <= 0;
            end
            T5: begin //Zlowout, MARin 
                    #10 Zlowout <= 1; MARin <= 1;
		            #15 Zlowout <= 0; MARin <= 0;
            end
            T6: begin //Read, Mdatain[31..0], MDRin 
                    #10 Read <= 1; MDRin <= 1;
		            #15 Read <= 0; MDRin <= 0;
            end
            T7: begin //MDRout, Gra, Rin 
                    #10 Gra <= 1; Rin <= 1; MDRout <= 1;
		            #15 Gra <= 0; Rin <= 0; MDRout <= 0;
            end
        endcase
    end
endmodule
