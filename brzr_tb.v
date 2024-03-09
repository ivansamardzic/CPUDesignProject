`timescale 1ns/10ps
module brzr_tb;
    reg PCout, Zlowout, MDRout; // add any other signals to see in your simulation
    reg Zlowin, PCin, MDRin, IRin, Yin;
    reg IncPC, ADD;
    reg clock, clear;
    reg [31:0] Mdatain;

    parameter   Default = 4'b0000, T0 = 4'b0001, T1 = 4'b0010, T2 = 4'b0011, T3 = 4'b0100, 
	 T4 = 4'b0101, T5 = 4'b0110, T6 = 4'b0111, T7 = 4'b1000;
    reg [3:0] Present_state = Default;
	 
	 reg Csignout, Grb, Gra, Read, Write, MARin, Rin, Rout, BAout; 
	 
	 reg CONFF, CONin; 

	DataPath D(.clock(clock), .clear(clear),  
		     .MDRin(MDRin), 
		     .PCin(PCin), .MD_read(Read),
		     .Zlowin(Zlowin), .Zhighin(Zhighin), .Zlowout(Zlowout), .IncPC(IncPC), .Yin(Yin), .IRin(IRin),  
		     .Mdatain(Mdatain), .MDRout(MDRout), 
			  
			  .Csignout(Csignout), .Grb(Grb), .Gra(Gra), .Read(Read), .Write(Write), .MARin(MARin), .Rin(Rin), .Rout(Rout), .ADD(ADD),
			  
			  .CONFF(CONFF), .CONin(CONin)
			  );
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
            
        endcase
    end

always @(Present_state)
    begin
		  
        case (Present_state) 
            Default: begin
                    PCout <= 0; Zlowout <= 0; MDRout <= 0; // initialize the signals
                    MARin <= 0; Zlowin <= 0;
                    PCin <= 0; MDRin <= 0; IRin <= 0; Yin <= 0; 
                    IncPC <= 0; Read <= 0; ADD <= 0;
                    Mdatain <= 32'h00000000;
						  Csignout <= 0; Grb <= 0; Gra <= 0; BAout <= 0; Rin <= 0; 
						  CONin <= 0;	CONFF <= 0; 
            end
		
            T0: begin // see if you need to de-assert these signals
						#10 PCout <= 1; MARin <= 1; IncPC <= 1; Zlowin <= 1;
						#15 PCout <= 0; MARin <= 0; IncPC <= 0; Zlowin <= 0;
            end
            T1: begin
						#10 Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1; Mdatain <= 32'b10011_0001_00_00_0000000000000000000; 
						#15 Zlowout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
            end
            T2: begin
                  #10 MDRout <= 1; IRin <= 1; //transfers MDR contents to IR reg
						#15 MDRout <= 0; IRin <= 0;
            end
            T3: begin
                  #10 Gra <= 1; Rout <= 1; CONin <= 1; 
						#15 Gra <= 0; Rout <= 0; CONin <= 0; 
            end
            T4: begin
                  #10 PCout <= 1; Yin <= 1;
						#15 PCout <= 0; Yin <= 0; 
            end
            T5: begin
                  #10 Csignout <= 1; ADD <= 1; Zlowin <= 1; 
						#15 Csignout <= 0; ADD <= 0; Zlowin <= 0;
            end
				T6: begin 
						#10 Zlowout <= 1; PCin <= CONFF; 
						#15 Zlowout <= 0; PCin <= 0; 	
				end	
        endcase
    end
endmodule

