`timescale 1ns/10ps
module brzr_tb;
    reg PCout, Zlowout, MDRout; // add any other signals to see in your simulation
    reg Zlowin, PCin, MDRin, IRin, Yin;
    reg IncPC, OR, ADD;
    reg clock, clear, MD_read, MAR_clear;
	 reg Rout; 
//    reg [31:0] Mdatain;

    parameter   Default = 4'b0000, T0 = 4'b0001, T1 = 4'b0010, T2 = 4'b0011, T3 = 4'b0100, 
	 T4 = 4'b0101, T5 = 4'b0110, T6 = 4'b0111, T7 = 4'b1000, T8 = 4'b1001, T9 = 4'b1010, T10 = 4'b1011, T11 = 4'b1100,
	 T12 = 4'b1101, T13 = 4'b1110, T14 = 4'b1111; 
    reg [3:0] Present_state = Default;
	 
	 reg Csignout, Grb, Gra, Read, Write, MARin, Rin, BAout; 

	 reg CONin, BRANCH; 
	 
	 wire CONFF;

	DataPath D(.clock(clock), .clear(clear),  
		     .MDRin(MDRin), .MAR_clear(MAR_clear),
		     .PCin(PCin), .MD_read(MD_read),
		     .Zlowin(Zlowin), .Zhighin(Zhighin), .Zlowout(Zlowout), .IncPC(IncPC), .Yin(Yin), .IRin(IRin),  
		     .MDRout(MDRout), 
			  
			  .PCout(PCout), .Rout(Rout), .CONin(CONin), .BRANCH(BRANCH), .CONFF(CONFF), .ADD(ADD), 
			  
			  .Csignout(Csignout), .Grb(Grb), .Gra(Gra), .BAout(BAout), .Read(Read), .Write(Write), .MARin(MARin), .Rin(Rin), .AND(AND));
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
        endcase
    end

always @(Present_state)
   begin
        case (Present_state) 
            Default: begin
                    PCout <= 0; Zlowout <= 0; MDRout <= 0; // initialize the signals
                    MARin <= 0; Zlowin <= 0;
                    PCin <=0; MDRin <= 0; IRin <= 0; Yin <= 0;
                    IncPC <= 0; Read <= 0; OR <= 0;
                    MD_read <= 0; Rout <= 0; 
						  Csignout <= 0; Grb <= 0; Gra <= 0; BAout <= 0; Rin <= 0; MAR_clear <= 1;
						  CONin <= 0; BRANCH <= 0; 
            end
		      T0: begin //Puts PC into MAR S
						#10 PCout <= 1; MARin <= 1; IncPC <= 1; Zlowin <= 1; 
						#15 PCout <= 0; MARin <= 0; IncPC <= 0; Zlowin <= 0;
            end
            T1: begin //Puts ram data into Mdatain
						#10 Zlowout <= 1; PCin <= 1; Read <= 1;  
						#15 Zlowout <= 0; PCin <= 0; Read <= 0; 
            end
            T2: begin //MDR content on to bus
                  #10 MDRout <= 1; MD_read <= 1; MDRin <= 1; 
						#15 MDRout <= 0; MD_read <= 0; MDRin <= 0;
            end
				T3: begin //IR has opcode 
                  #10 IRin <= 1;  
						#15 IRin <= 0; 
            end
            T4: begin //Yin contains 0 from R0
                  #10 Grb <= 1; BAout <= 1; Yin <= 1; 
						#15 Grb <= 0; BAout <= 0; Yin <= 0; 
            end
            T5: begin
                  #10 Csignout <= 1; ADD <= 1; Zlowin <= 1; //contents in Creg + Yreg = ZlowReg
						#15 Csignout <= 0; ADD <= 0; Zlowin <= 0; 
            end
				T6: begin
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1; //In register 2
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0; 
				end
					//BRANCH INSTRUCTION	
				T7: begin //Puts PC into MAR S
						#10 PCout <= 1; MARin <= 1; IncPC <= 1; Zlowin <= 1; MAR_clear <= 0;
						#15 PCout <= 0; MARin <= 0; IncPC <= 0; Zlowin <= 0;
            end
            T8: begin //Puts ram data into Mdatain
						#10 Zlowout <= 1; PCin <= 1; Read <= 1;  
						#15 Zlowout <= 0; PCin <= 0; Read <= 0; 
            end
            T9: begin //MDR content on to bus
                  #10 MDRout <= 1; MD_read <= 1; MDRin <= 1; 
						#15 MDRout <= 0; MD_read <= 0; MDRin <= 0;
            end
				T10: begin //IR has opcode 
                  #10 IRin <= 1;  
						#15 IRin <= 0; 
				end
				T11: begin
                  #10 Gra <= 1; Rout <= 1; CONin <= 1;
						#15 Gra <= 0; Rout <= 0; CONin <= 0;
            end
            T12: begin
                  #10 PCout <= 1; Yin <= 1;
						#15 PCout <= 0; Yin <= 0; 
            end
            T13: begin
                  #10 Csignout <= 1; BRANCH <= 1; Zlowin <= 1; 
						#15 Csignout <= 0; BRANCH <= 0; Zlowin <= 0;
            end
				T14: begin 
						#10 Zlowout <= 1; 
						if (CONFF) PCin <= 1; 
						#15 Zlowout <= 0; PCin <= 0; 	
				end	
        endcase
    end
endmodule
