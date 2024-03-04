`timescale 1ns/10ps
module and_tb;
    reg PCout, Zlowout, MDRout; // add any other signals to see in your simulation
    reg MARin, Zlowin, PCin, MDRin, IRin, Yin;
    reg IncPC, Read, AND;
    reg clock, clear;
    reg [31:0] Mdatain;
    reg Gra, Grb, Grc, Rin, Rout, BAout, Cout;

    parameter   Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
                Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
                T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;
    reg [3:0] Present_state = Default;

	DataPath DUT(.clock(clock), .clear(clear),  
		     .MDRin(MDRin), 
		     .MARin(MARin), .PCin(PCin), .MD_read(Read),
		     .Zlowin(Zlowin), .Zlowout(Zlowout), .IncPC(IncPC), .Yin(Yin), .IRin(IRin),  
		     .Mdatain(Mdatain), .MDRout(MDRout))
             .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rin(Rin), .Rout(Rout), .BAout(BAout), .Cout(Cout);
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
            Default : #40 Present_state = Reg_load1a;
            Reg_load1a : #40 Present_state = Reg_load1b;
            Reg_load1b : #40 Present_state = Reg_load2a;
            Reg_load2a : #40 Present_state = Reg_load2b;
            Reg_load2b : #40 Present_state = Reg_load3a;
            Reg_load3a : #40 Present_state = Reg_load3b;
            Reg_load3b : #40 Present_state = T0;
            T0 : #40 Present_state = T1;
            T1 : #40 Present_state = T2;
            T2 : #40 Present_state = T3;
            T3 : #40 Present_state = T4;
            T4 : #40 Present_state = T5;
        endcase
    end

always @(Present_state) // do the required job in each state
    begin
        case (Present_state) // assert the required signals in each clock cycle
            Default: begin
                    PCout <= 0; Zlowout <= 0; MDRout <= 0; // initialize the signals
                    MARin <= 0; Zlowin <= 0;
                    PCin <=0; MDRin <= 0; IRin <= 0; Yin <= 0;
                    IncPC <= 0; Read <= 0; AND <= 0;
                    Mdatain <= 32'h00000000;
                    Gra <= 0; Grb <= 0; Grc <= 0; Rin <= 0; Rout <= 0; BAout <= 0; Cout <= 0;
            end
		//------------------------------------------------------------
            Reg_load1a: begin
			Mdatain <= 32'h00000003; //sends data to MDMux
			Read = 0; MDRin = 0; // does nothing
			#10 Read <= 1; MDRin <= 1; //sets BusMuxInMDR to Mdatain 
			#15 Read <= 0; MDRin <= 0; //read selects Busmux out, MDRin disables MDR
            end
            Reg_load1b: begin
			#10 MDRout <= 1; Rin <= 1; //MDRout = 1 sets BusMuxOut to BusMuxInMDR aka Mdatain
			//R2in = 1 enables R2in, sets BMInR2 to BusMuxOut 
			#15 MDRout <= 0; Rin <= 0; //MDRout dissables bus change, R2in dissables register R2 change
            end
		//------------------------------------------------------------
            Reg_load2a: begin
                    Mdatain <= 32'h000000D;
                    #10 Read <= 1; MDRin <= 1;
                    #15 Read <= 0; MDRin <= 0;
						  //puts Mdatain to BusMuxInMDR
            end
            Reg_load2b: begin
                    #10 MDRout <= 1; Rin <= 1;
                    #15 MDRout <= 0; Rin <= 0; // initialize R3 with the value $14
						  //puts BusMuxInMDR to BusMuxOut to Register 3 (BMInR3)
            end
		//------------------------------------------------------------
            Reg_load3a: begin
                    Mdatain <= 32'h00000000;
                    #10 Read <= 1; MDRin <= 1;
                    #15 Read <= 0; MDRin <= 0;
							//puts Mdatain to BusMuxInMDR
            end
            Reg_load3b: begin
                    #10 MDRout <= 1; Rin <= 1;
                    #15 MDRout <= 0; Rin <= 0; // initialize R1 with the value $18
						  //puts BusMuxInMDR to BusMuxOut to Register 1 (BMInR1)
            end
		//------------------------------------------------------------
		
            T0: begin // see if you need to de-assert these signals
                    #10 PCout <= 1; MARin <= 1; IncPC <= 1; Zlowin <= 1;
		    #15 PCout <= 0; MARin <= 0; IncPC <= 0; Zlowin <= 0;
						  
            end
            T1: begin
                    #10 Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
		    #15 Zlowout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
            end
            T2: begin
                    #10 MDRout <= 1; IRin <= 1; //transfers MDR contents to IR reg
		    #15 MDRout <= 0; IRin <= 0;
            end
            T3: begin
                    #10 Rout <= 1; Yin <= 1; Grb <= 1; //transfers R2 contents to Y reg
			#15 Rout <= 0; Yin <= 0; Grb <= 0;;
            end
            T4: begin
                    #10 Cout <= 1; AND <= 1; Zlowin <= 1;
		    #15 Cout <= 0; AND <= 0; Zlowin <= 0;
            end
            T5: begin
                    #10 Zlowout <= 1; Rin <= 1; Gra <= 1;//transfers zlow contents into R1 
		    #15 Zlowout <= 0; Rin <= 0; Gra <= 1;
            end
        endcase
    end
endmodule
