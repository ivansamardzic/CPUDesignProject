`timescale 1ns/10ps
module add_tb;
    reg PCout, Zlowout, MDRout; // add any other signals to see in your simulation
    reg Zlowin, PCin, MDRin, IRin, Yin;
    reg IncPC, ADD;
    reg clock, clear, MD_read, MAR_clear;
	 reg Rout; 
//    reg [31:0] Mdatain;

    parameter   Default = 5'b00000, T0 = 5'b00001, T1 = 5'b00010, T2 = 5'b00011, T3 = 5'b00100, 
	 T4 = 5'b00101, T5 = 5'b00110, T6 = 5'b00111, T7 = 5'b01000, T8 = 5'b01001, T9 = 5'b01010, T10 = 5'b01011,
	 T11 = 5'b01100, T12 = 5'b01101, T13 = 5'b01110, T14 = 5'b01111, T15 = 5'b10000, T16 = 5'b10001, T17 = 5'b10010, T18 = 5'b10011, T19 = 5'b10100; 
    reg [4:0] Present_state = Default;
	 
	 reg Csignout, Grb, Gra, Grc, Read, Write, MARin, Rin, BAout; 

	 

	DataPath D(.clock(clock), .clear(clear),  
		     .MDRin(MDRin), .MAR_clear(MAR_clear),
		     .PCin(PCin), .MD_read(MD_read),
		     .Zlowin(Zlowin), .Zhighin(Zhighin), .Zlowout(Zlowout), .IncPC(IncPC), .Yin(Yin), .IRin(IRin),  
		     .MDRout(MDRout), 
			  
			  .PCout(PCout), .Rout(Rout), 
			  
			  .Csignout(Csignout), .Grb(Grb), .Gra(Gra), .Grc(Grc), .BAout(BAout), .Read(Read), .Write(Write), .MARin(MARin), .Rin(Rin), .ADD(ADD));
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
            T7 : #40 Present_state = T8;
				T8 : #40 Present_state = T9;
				T9 : #40 Present_state = T10;
				T10 : #40 Present_state = T11;
				T11 : #40 Present_state = T12;
				T12 : #40 Present_state = T13;
				T13 : #40 Present_state = T14;
				T14 : #40 Present_state = T15;
				T15 : #40 Present_state = T16;
				T16 : #40 Present_state = T17;
				T17 : #40 Present_state = T18; 
				T18 : #40 Present_state = T19; 
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
                    MD_read <= 0; MAR_clear <= 0; Rout <= 0; 
						  Csignout <= 0; Grb <= 0; Gra <= 0; Grc <= 0; BAout <= 0; Rin <= 0;
            end
				T0: begin //Puts PC into MAR S
						#10 PCout <= 1; MARin <= 1; IncPC <= 1; Zlowin <= 1; 
						#15 PCout <= 0; MARin <= 0; IncPC <= 0; Zlowin <= 0;
            end
            T1: begin //Puts ram data into Mdatain
						#10 Zlowout <= 1; PCin <= 1; Read <= 1;  MD_read <= 1; MDRin <= 1; 
						#15 Zlowout <= 0; PCin <= 0; Read <= 0;  MD_read <= 0; MDRin <= 0;
            end
            T2: begin //MDR content on to bus
                  #10 MDRout <= 1; IRin <= 1;
						#15 MDRout <= 0; IRin <= 0;
            end
            T3: begin //Yin contains 0 from R0
                  #10 Grb <= 1; BAout <= 1; Yin <= 1; 
						#15 Grb <= 0; BAout <= 0; Yin <= 0; 
            end
            T4: begin
                  #10 Csignout <= 1; ADD <= 1; Zlowin <= 1; //contents in Creg + Yreg = ZlowReg
						#15 Csignout <= 0; ADD <= 0; Zlowin <= 0; 
            end
				T5: begin
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1; //In register 2
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0; 
				end
				
				//LDI
				T6: begin //Puts PC into MAR S
						#10 PCout <= 1; MARin <= 1; IncPC <= 1; Zlowin <= 1; 
						#15 PCout <= 0; MARin <= 0; IncPC <= 0; Zlowin <= 0;
            end
            T7: begin //Puts ram data into Mdatain
						#10 Zlowout <= 1; PCin <= 1; Read <= 1;  MD_read <= 1; MDRin <= 1; 
						#15 Zlowout <= 0; PCin <= 0; Read <= 0;  MD_read <= 0; MDRin <= 0;
            end
            T8: begin //MDR content on to bus
                  #10 MDRout <= 1; IRin <= 1;
						#15 MDRout <= 0; IRin <= 0;
            end
            T9: begin //Yin contains 0 from R0
                  #10 Grb <= 1; BAout <= 1; Yin <= 1; 
						#15 Grb <= 0; BAout <= 0; Yin <= 0; 
            end
            T10: begin
                  #10 Csignout <= 1; ADD <= 1; Zlowin <= 1; //contents in Creg + Yreg = ZlowReg
						#15 Csignout <= 0; ADD <= 0; Zlowin <= 0; 
            end
				T11: begin
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1; //In register 2
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0; 
				end
				
				//ADD
				
            T12: begin //Puts PC into MAR S
						#10 PCout <= 1; MARin <= 1; IncPC <= 1; Zlowin <= 1; 
						#15 PCout <= 0; MARin <= 0; IncPC <= 0; Zlowin <= 0;
            end
            T13: begin //Puts ram data into Mdatain
						#10 Zlowout <= 1; PCin <= 1; Read <= 1; MD_read <= 1; MDRin <= 1; 
						#15 Zlowout <= 0; PCin <= 0; Read <= 0; MD_read <= 0; MDRin <= 0;
            end
				T14: begin //IR has opcode 
                  #10 MDRout <= 1; IRin <= 1;  
						#15 MDRout <= 0; IRin <= 0; 
            end
            T15: begin //Yin contains 0 from R4
                  #10 Grb <= 1; BAout <= 1; Yin <= 1; 
						#15 Grb <= 0; BAout <= 0; Yin <= 0; 
            end
            T16: begin
                  #10 Grc <= 1; BAout <= 1; ADD <= 1; Zlowin <= 1; //contents in Creg + Yreg = ZlowReg
						#15 Grc <= 0; BAout <= 0; ADD <= 0; Zlowin <= 0; 
            end
				T17: begin
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1; //In register 3
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0; 
				end
					
				
        endcase
    end
endmodule
