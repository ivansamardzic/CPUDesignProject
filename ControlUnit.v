`timescale 1ns/10ps
module ControlUnit (
	//Green section
	output reg PCout, MDRout, Zhighout, Zlowout, HIout, LOout,

	//Yellow section
	output reg Rin, Rout, Gra, Grb, Grc,

	//Dark blue section, not sure if we use Zin ---- added Zhighin, Zlowin even though not in diagram
	output reg BAout, Csignout, Out_Portin, MDRin, MARin, Yin, IRin, PCin, CONin, LOin, HIin, Zhighin, Zlowin,

	//Light green section
	output reg ADD, SUB, MUL, DIV,
	output reg AND, OR, 
	output reg SHR, SHRA, SHL,
	output reg ROR, ROL,
	output reg NEGATE, NOT,
	output reg IncPC, BRANCH, 

	//Light blue section
	output reg MD_read, Write,

	//Greyish section
	output reg InPortout,
	
	//Dark green section
	output reg clear, Strobe,
	
	//output reg [31:0] INPUT_UNIT,

	//Red section
	input clock, reset, stop, CONFF,
	input [31:0] IR_reg
);

	parameter 		reset_state = 8'b00000000, T0 = 8'b11111000, T1 = 8'b11111001, T2 = 8'b11111010,
					// Load
					LD_T3  = 8'b00000011, 	LD_T4  = 8'b00000100, 	LD_T5  = 8'b00000101, 	LD_T6 = 8'b00000110, LD_T7 = 8'b00000111,
					// Load Immediate
					LDI_T3 = 8'b00001011, 	LDI_T4 = 8'b00001100, 	LDI_T5 = 8'b00001101,
					// Store
					ST_T3  = 8'b00010011, 	ST_T4  = 8'b00010100, 	ST_T5  = 8'b00010101, 	ST_T6 = 8'b00010110,
					// Add
					ADD_T3  = 8'b00011011, 	ADD_T4  = 8'b00011100, 	ADD_T5  = 8'b00011101,
					// Add Immediate
					ADDI_T3 = 8'b01100011, 	ADDI_T4 = 8'b01100100, 	ADDI_T5 = 8'b01100101,
					// Subtract
					SUB_T3  = 8'b00100011, 	SUB_T4  = 8'b00100100, 	SUB_T5  = 8'b00100101,
					// Multiply
					MUL_T3  = 8'b01111011, 	MUL_T4  = 8'b01111100, 	MUL_T5  = 8'b01111101, 	MUL_T6 = 8'b01111110,
					// Divide
					DIV_T3  = 8'b10000011, 	DIV_T4  = 8'b10000100, 	DIV_T5  = 8'b10000101, 	DIV_T6 = 8'b10000110,
					// And
					AND_T3  = 8'b01010011, 	AND_T4  = 8'b01010100, 	AND_T5  = 8'b01010101,
					// And Immediate
					ANDI_T3 = 8'b01101011, 	ANDI_T4 = 8'b01101100, 	ANDI_T5 = 8'b01101101,
					// Or
					OR_T3   = 8'b01011011, 	OR_T4   = 8'b01011100,  OR_T5   = 8'b01011101,
					// Or Immediate
					ORI_T3  = 8'b01110011, 	ORI_T4  = 8'b01110100, 	ORI_T5  = 8'b01110101,
					// Shift Right
					SHR_T3  = 8'b00101011, 	SHR_T4  = 8'b00101100, 	SHR_T5  = 8'b00101101,
					// Shift Right Arithmetic
					SHRA_T3 = 8'b00110011, 	SHRA_T4 = 8'b00110100, 	SHRA_T5 = 8'b00110101,
					// Shift Left
					SHL_T3  = 8'b00111011, 	SHL_T4  = 8'b00111100, 	SHL_T5  = 8'b00111101,
					// Rotate Right
					ROR_T3  = 8'b01000011, 	ROR_T4  = 8'b01000100, 	ROR_T5  = 8'b01000101,
					// Rotate Left
					ROL_T3  = 8'b01001011, 	ROL_T4  = 8'b01001100, 	ROL_T5  = 8'b01001101,
					// Negate
					NEG_T3  = 8'b10001011, 	NEG_T4  = 8'b10001100,  NEG_T5  = 8'b10001101,
					// Not
					NOT_T3  = 8'b10010011, 	NOT_T4  = 8'b10010100,  NOT_T5  = 8'b10010101,
					// Branch
					BR_T3 = 8'b10011011, 	BR_T4 = 8'b10011100, 	BR_T5 = 8'b10011101, 	BR_T6 = 8'b10011110,
					// Jump
					JR_T3 = 8'b10100011,
					// Jump and Link
					JAL_T3 = 8'b10101011, 	JAL_T4 = 8'b10101100, JAL_T5 = 8'b010101101,
					// In
					IN_T3   = 8'b10110011, 	IN_T4 = 8'b10110100,
					// Out
					OUT_T3  = 8'b10111011,
					// Move from High
					MFHI_T3 = 8'b11000011,
					// Move from Low
					MFLO_T3 = 8'b11001011,
					// No Operation
					NOP_T3  = 8'b11010011,
					// Halt
					HALT_T3 = 8'b11011011;

					
	reg [7:0]present_state = 8'b11111111;
	reg run = 1;

	always @ (posedge clock, posedge reset) begin
		
			
		if (reset == 1'b1) begin
			present_state = reset_state;
		end
		
		else begin // check other cases
			
			case (present_state)
				8'b11111111:	#40 present_state = reset_state;
				reset_state: 	#40 present_state = T0;
				T0:	#40 present_state = T1;
				T1:	#40 present_state = T2;
				T2: #40 begin
						
					case (IR_reg[31:27])

						5'b00000 : present_state = LD_T3;
						5'b00001 : present_state = LDI_T3;
						5'b00010 : present_state = ST_T3;
						5'b00011 : present_state = ADD_T3;
						5'b01100 : present_state = ADDI_T3;
						5'b00100 : present_state = SUB_T3;
						5'b01111 : present_state = MUL_T3;
						5'b10000 : present_state = DIV_T3;
						5'b01010 : present_state = AND_T3;
						5'b01101 : present_state = ANDI_T3;
						5'b01011 : present_state = OR_T3;
						5'b01110 : present_state = ORI_T3;
						5'b00101 : present_state = SHR_T3;
						5'b00110 : present_state = SHRA_T3;
						5'b00111 : present_state = SHL_T3;
						5'b01000 : present_state = ROR_T3;
						5'b01001 : present_state = ROL_T3;
						5'b10001 : present_state = NEG_T3;
						5'b10010 : present_state = NOT_T3;
						5'b10011 : present_state = BR_T3;
						5'b10100 : present_state = JR_T3;
						5'b10101 : present_state = JAL_T3;
						5'b10110 : present_state = IN_T3;
						5'b10111 : present_state = OUT_T3;
						5'b11000 : present_state = MFHI_T3;
						5'b11001 : present_state = MFLO_T3;
						5'b11010 : present_state = NOP_T3;
						5'b11011 : present_state = HALT_T3;
					
					endcase
				end

				LD_T3 : #40 present_state = LD_T4;
				LD_T4 : #40 present_state = LD_T5;
				LD_T5 : #40 present_state = LD_T6;
				LD_T6 : #40 present_state = LD_T7;
				LD_T7 : #40 present_state = T0;

				LDI_T3 : #40 present_state = LDI_T4;
				LDI_T4 : #40 present_state = LDI_T5;
				LDI_T5 : #40 present_state = T0;
					
				ST_T3 : #40 present_state = ST_T4;
				ST_T4 : #40 present_state = ST_T5;
				ST_T5 : #40 present_state = ST_T6;
				ST_T6 : #40 present_state = T0;

				ADD_T3 : #40 present_state = ADD_T4;
				ADD_T4 : #40 present_state = ADD_T5;
				ADD_T5 : #40 present_state = T0;
					
				ADDI_T3 : #40 present_state = ADDI_T4;
				ADDI_T4 : #40 present_state = ADDI_T5;
				ADDI_T5 : #40 present_state = T0;

				SUB_T3 : #40 present_state = SUB_T4;
				SUB_T4 : #40 present_state = SUB_T5;
				SUB_T5 : #40 present_state = T0;
					
				MUL_T3 : #40 present_state = MUL_T4;
				MUL_T4 : #40 present_state = MUL_T5;
				MUL_T5 : #40 present_state = MUL_T6;
				MUL_T6 : #40 present_state = T0;

				DIV_T3 : #40 present_state = DIV_T4;
				DIV_T4 : #40 present_state = DIV_T5;
				DIV_T5 : #40 present_state = DIV_T6;
				DIV_T6 : #40 present_state = T0;
					
				AND_T3 : #40 present_state = AND_T4;
				AND_T4 : #40 present_state = AND_T5;
				AND_T5 : #40 present_state = T0;
					
				ANDI_T3 : #40 present_state = ANDI_T4;
				ANDI_T4 : #40 present_state = ANDI_T5;
				ANDI_T5 : #40 present_state = T0;
					
				OR_T3 : #40 present_state = OR_T4;
				OR_T4 : #40 present_state = OR_T5;
				OR_T5 : #40 present_state = T0;
					
				ORI_T3 : #40 present_state = ORI_T4;
				ORI_T4 : #40 present_state = ORI_T5;
				ORI_T5 : #40 present_state = T0;
					
				SHR_T3 : #40 present_state = SHR_T4;
				SHR_T4 : #40 present_state = SHR_T5;
				SHR_T5 : #40 present_state = T0;
					
				SHRA_T3 : #40 present_state = SHRA_T4;
				SHRA_T4 : #40 present_state = SHRA_T5;
				SHRA_T5 : #40 present_state = T0;
					
				SHL_T3 : #40 present_state = SHL_T4;
				SHL_T4 : #40 present_state = SHL_T5;
				SHL_T5 : #40 present_state = T0;
					
				ROR_T3 : #40 present_state = ROR_T4;
				ROR_T4 : #40 present_state = ROR_T5;
				ROR_T5 : #40 present_state = T0;
					
				ROL_T3 : #40 present_state = ROL_T4;
				ROL_T4 : #40 present_state = ROL_T5;
				ROL_T5 : #40 present_state = T0;
					
				NEG_T3 : #40 present_state = NEG_T4;
				NEG_T4 : #40 present_state = NEG_T5;
				NEG_T5 : #40 present_state = T0;
					
				NOT_T3 : #40 present_state = NOT_T4;
				NOT_T4 : #40 present_state = NOT_T5;
				NOT_T5 : #40 present_state = T0;
					
				BR_T3 : #40 present_state = BR_T4;
				BR_T4 : #40 present_state = BR_T5;
				BR_T5 : #40 present_state = BR_T6;
				BR_T6 : #40 present_state = T0;
					
				JR_T3 : #40 present_state = T0;
					
				JAL_T3 : #40 present_state = JAL_T4;
				JAL_T4 : #40 present_state = JAL_T5;
				JAL_T5 : #40 present_state = T0;
					
				IN_T3 : #40 present_state = IN_T4;
				IN_T4 : #40 present_state = T0;
					
				OUT_T3 : #40 present_state = T0;
					
				MFHI_T3 : #40 present_state = T0;
				MFLO_T3 : #40 present_state = T0;
					
				NOP_T3  : #40 present_state = T0; 
				HALT_T3 : #40 present_state = HALT_T3;
				
			endcase
		end
	end
	
	
always @(present_state) // do the job for each state
begin
    if (run) begin // only change state if program is supposed to be running
				case (present_state) 
				
					reset_state : begin
						clear <= 1; run <= 1;
					
						MD_read <= 0; Write <= 0;
                        Gra <= 0; Grb <= 0; Grc <= 0;
						Rin <= 0; Rout <= 0; BAout <= 0; 
						IncPC <= 0;
                        MDRin <= 0; MDRout <= 0; MARin <= 0; 
						PCin <= 0; PCout <= 0; IRin <= 0;
						Zhighin <= 0; Zlowin <= 0; Zhighout <= 0; Zlowout <= 0;
                        Out_Portin <= 0; InPortout <= 0;
						HIin <= 0; LOin <= 0; HIout <= 0; LOout <= 0;
						Csignout <= 0; Yin <= 0; CONin <= 0;
                        ADD <= 0; SUB <= 0; MUL <= 0; DIV <= 0;
						AND <= 0; OR <= 0;
						SHR <= 0; SHRA <= 0; SHL <= 0;
						ROR <= 0; ROL <= 0;
						NEGATE <= 0; NOT <= 0; BRANCH <= 0; Strobe <= 0; 
						#15 clear <= 0;
					end
				
                    //--------------------------------------------------------------------------------
                    // T0-T3 (DONE)
					T0 : begin
						#10 PCout <= 1; MARin <= 1; IncPC <= 1; Zlowin <= 1; 
						#15 PCout <= 0; MARin <= 0; IncPC <= 0; Zlowin <= 0;
					end
				
					T1 : begin
						#10 Zlowout <= 1; PCin <= 1;  MD_read <= 1; MDRin <= 1; 
						#15 Zlowout <= 0; PCin <= 0;  MD_read <= 0; MDRin <= 0;
					end
					
					T2 : begin
						#10 MDRout <= 1; IRin <= 1;
						#15 MDRout <= 0; IRin <= 0;
					end
                    //--------------------------------------------------------------------------------
                    // Load (Done)
					LD_T3 : begin
						#10 Grb <= 1; BAout <= 1; Yin <= 1; 
						#15 Grb <= 0; BAout <= 0; Yin <= 0; 
					end
					
					LD_T4 : begin
						#10 Csignout <= 1; ADD <= 1; Zlowin <= 1;
						#15 Csignout <= 0; ADD <= 0; Zlowin <= 0;
					end

					LD_T5 : begin
						#10 Zlowout <= 1; MARin <= 1;
						#15 Zlowout <= 0; MARin <= 0; 
					end
					
					LD_T6 : begin
						#10 MD_read <= 1; MDRin <= 1;
						#15 MD_read <= 0; MDRin <= 0;
					end
					
					LD_T7 : begin
						#10 MDRout <= 1; Gra <= 1; Rin <= 1; 
						#15 MDRout <= 0; Gra <= 0; Rin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// Load Immediate (DONE)
					LDI_T3 : begin
						#10 Grb <= 1; BAout <= 1; Yin <= 1; 
						#15 Grb <= 0; BAout <= 0; Yin <= 0; 
					end
					
					LDI_T4 : begin
						#10 Csignout <= 1; ADD <= 1; Zlowin <= 1;
						#15 Csignout <= 0; ADD <= 0; Zlowin <= 0;
					end
					
					LDI_T5 : begin
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
					
                    //--------------------------------------------------------------------------------
					// Store (DONE)
					ST_T3 : begin
						#10 Grb <= 1; BAout <= 1; Yin <= 1; 
						#15 Grb <= 0; BAout <= 0; Yin <= 0; 
					end
					
					ST_T4 : begin
						#10 Csignout <= 1; ADD <= 1; Zlowin <= 1;
						#15 Csignout <= 0; ADD <= 0; Zlowin <= 0;
					end
					
					ST_T5 : begin
						#10 Zlowout <= 1; MARin <= 1; //MAR_clear <= 0; 
						#15 Zlowout <= 0; MARin <= 0; 
					end
					
					ST_T6 : begin
						#10 Gra <= 1; BAout <= 1; Write <= 1; 
						#15 Gra <= 0; BAout <= 0; Write <= 0; 
					end
                        
                    //--------------------------------------------------------------------------------
					// Add (DONE)
					ADD_T3 : begin 
						#10 Grb <= 1; Rout <= 1; Yin <= 1; 
						#15 Grb <= 0; Rout <= 0; Yin <= 0; 
					end
					
					ADD_T4 : begin 
						#10 Rout <= 1; ADD <= 1; Zlowin <= 1; Grc <= 1;
						#15 Rout <= 0; ADD <= 0; Zlowin <= 0; Grc <= 0;
					end
					
					ADD_T5 : begin 
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
					
                    //--------------------------------------------------------------------------------
					// Add immediate (DONE)
					ADDI_T3 : begin 
						#10 Grb <= 1; Rout <= 1; Yin <= 1; 
						#15 Grb <= 0; Rout <= 0; Yin <= 0; 
					end
					
					ADDI_T4 : begin 
						#10 Csignout <= 1; ADD <= 1; Zlowin <= 1;
						#15 Csignout <= 0; ADD <= 0; Zlowin <= 0; 
					end
					
					ADDI_T5 : begin 
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0; 
					end
				
                    //--------------------------------------------------------------------------------
					// Subtract (DONE)
					SUB_T3 : begin 
						#10 Grb <= 1; Rout <= 1; Yin <= 1; 
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					SUB_T4 : begin 
						#10 Rout <= 1; SUB <= 1; Zlowin <= 1; Grc <= 1;
						#15 Rout <= 0; SUB <= 0; Zlowin <= 0; Grc <= 0;
					end
					
					SUB_T5 : begin 
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
					
                    //--------------------------------------------------------------------------------
					// Multiply (DONE)
					MUL_T3 : begin
						#10 Gra <= 1; Rout <= 1; Yin <= 1;
						#15 Gra <= 0; Rout <= 0; Yin <= 0;
					end
					
					MUL_T4 : begin
						#10 Grb <= 1; Rout <= 1; MUL <= 1; Zlowin <= 1; Zhighin <= 1;
						#15 Grb <= 0; Rout <= 0; MUL <= 0; Zlowin <= 0; Zhighin <= 0;
					end
					
					MUL_T5 : begin
						#10 Zlowout <= 1; LOin <= 1;
						#15 Zlowout <= 0; LOin <= 0;
					end
					
					MUL_T6 : begin
						#10 Zhighout <= 1; HIin <= 1;
						#15 Zhighout <= 0; HIin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// Divide (DONE)
					DIV_T3 : begin
						#10 Gra <= 1; Rout <= 1; Yin <= 1;
						#15 Gra <= 0; Rout <= 0; Yin <= 0;
					end
					
					DIV_T4 : begin
						#10 Grb <= 1; Rout <= 1; DIV <= 1; Zhighin <= 1; Zlowin <= 1;
						#15 Grb <= 0; Rout <= 0; DIV <= 0; Zhighin <= 0; Zlowin <= 0;
					end
					
					DIV_T5 : begin
						#10 Zlowout <= 1; LOin <= 1;
						#15 Zlowout <= 0; LOin <= 0;
					end
					
					DIV_T6 : begin
						#10 Zhighout <= 1; HIin <= 1;
						#15 Zhighout <= 0; HIin <= 0;
					end
					
					//--------------------------------------------------------------------------------
					// And (DONE)
					AND_T3 : begin
						#10 Grb <= 1; Rout <= 1; Yin <= 1; 
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					AND_T4 : begin
						#10 Rout <= 1; AND <= 1; Zlowin <= 1; Grc <= 1;
						#15 Rout <= 0; AND <= 0; Zlowin <= 0; Grc <= 0;
					end
					
					AND_T5 : begin
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// And Immediate (DONE)
					ANDI_T3 : begin
						#10 Grb <= 1; Rout <= 1; Yin <= 1; 
						#15 Grb <= 0; Rout <= 0; Yin <= 0; 
					end
					
					ANDI_T4 : begin
						#10 Csignout <= 1; AND <= 1; Zlowin <= 1;
						#15 Csignout <= 0; AND <= 0; Zlowin <= 0; 
					end
					
					ANDI_T5 : begin
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;  
					end
				
                    //--------------------------------------------------------------------------------
					// Or (DONE)
					OR_T3 : begin
						#10 Grb <= 1; Rout <= 1; Yin <= 1; 
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					OR_T4 : begin
						#10 Rout <= 1; OR <= 1; Zlowin <= 1; Grc <= 1;
						#15 Rout <= 0; OR <= 0; Zlowin <= 0; Grc <= 0;
					end
					
					OR_T5 : begin
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// Or immediate (DONE)
					ORI_T3 : begin
						#10 Grb <= 1; Rout <= 1; Yin <= 1; 
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					ORI_T4 : begin
						#10 Csignout <= 1; OR <= 1; Zlowin <= 1;
						#15 Csignout <= 0; OR <= 0; Zlowin <= 0; 
					end
					
					ORI_T5 : begin
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0; 
					end
				
                    //--------------------------------------------------------------------------------
					// Shift Right (DONE)
					SHR_T3 : begin
						#10 Grb <= 1; Rout <= 1; Yin <= 1; 
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					SHR_T4 : begin
						#10 Rout <= 1; SHR <= 1; Zlowin <= 1; Grc <= 1;
						#15 Rout <= 0; SHR <= 0; Zlowin <= 0; Grc <= 0;
					end
					
					SHR_T5 : begin
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// Shift Right Arithmetic (DONE)
					SHRA_T3 : begin
						#10 Grb <= 1; Rout <= 1; Yin <= 1;
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					SHRA_T4 : begin
						#10 Rout <= 1; SHRA <= 1; Zlowin <= 1; Grc <= 1;
						#15 Rout <= 0; SHRA <= 0; Zlowin <= 0; Grc <= 0;
					end
					
					SHRA_T5 : begin
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// Shift Left (DONE)
					SHL_T3 : begin
						#10 Grb <= 1; Rout <= 1; Yin <= 1;
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					SHL_T4 : begin
						#10 Rout <= 1; SHL <= 1; Zlowin <= 1; Grc <= 1;
						#15 Rout <= 0; SHL <= 0; Zlowin <= 0; Grc <= 0;
					end
					
					SHL_T5 : begin
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// Rotate Right (DONE)
					ROR_T3 : begin
						#15 Grb <= 1; Rout <= 1; Yin <= 1;
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					ROR_T4 : begin
						#10 Rout <= 1; ROR <= 1; Zlowin <= 1; Grc <= 1;
						#15 Rout <= 0; ROR <= 0; Zlowin <= 0; Grc <= 0;
					end
					
					ROR_T5 : begin
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
					
                    //--------------------------------------------------------------------------------
					// Rotate Left (DONE)
					ROL_T3 : begin
						#10 Grb <= 1; Rout <= 1; Yin <= 1;
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					ROL_T4 : begin
						#10 Rout <= 1; ROL <= 1; Zlowin <= 1; Grc <= 1;
						#15 Rout <= 0; ROL <= 0; Zlowin <= 0; Grc <= 0;
					end
					
					ROL_T5 : begin
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// Negate (DONE)
					NEG_T3 : begin
						#10 Grb <= 1; Rout <= 1; Yin <= 1;
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					NEG_T4 : begin
						#10 Rout <= 1; Zlowin <= 1; NEGATE <= 1; Grc <= 1;
						#15 Rout <= 0; Zlowin <= 0; NEGATE <= 0; Grc <= 0;
					end
					
					NEG_T5 : begin
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// Not (DONE)
					NOT_T3 : begin
						#10 Grb <= 1; Rout <= 1; Yin <= 1;
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					NOT_T4 : begin
						#10 Rout <= 1; Zlowin <= 1; NOT <= 1; Grc <= 1;
						#15 Rout <= 0; Zlowin <= 0; NOT <= 0; Grc <= 0;
					end
					
					NOT_T5 : begin
						#10 Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
				
				
                    //--------------------------------------------------------------------------------
					// Branch (DONE)
					BR_T3  : begin
						#10 Gra <= 1; Rout <= 1; CONin <= 1;
						#15 Gra <= 0; Rout <= 0; CONin <= 0;
					end
					
					BR_T4  : begin
						#10 PCout <= 1; Yin <= 1;
						#15 PCout <= 0; Yin <= 0;
					end
					
					BR_T5  : begin
						#10 Csignout <= 1; BRANCH <= 1; Zlowin <= 1; 
						#15 Csignout <= 0; BRANCH <= 0; Zlowin <= 0;
					end
					
					BR_T6  : begin
						#10 Zlowout <= 1; 
						if (CONFF) PCin <= 1; 
						#15 Zlowout <= 0; PCin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// Jump to Register (DONE)
					JR_T3 : begin
						#10 Gra <= 1; Rout <= 1; PCin <= 1; 
						#15 Gra <= 0; Rout <= 0; PCin <= 0; 
					end
					
                    //--------------------------------------------------------------------------------
					// Jump and Link (DONE)
					JAL_T3 : begin
						#10 PCout <= 1; BRANCH <= 1; Zlowin <= 1; 
						#15 PCout <= 0; BRANCH <= 0; Zlowin <= 0;
					end
					
					JAL_T4 : begin
						#10 Zlowout <= 1; Grb <= 1; Rin <= 1;
						#15 Zlowout <= 0; Grb <= 0; Rin <= 0; 
					end

                    JAL_T5 : begin
                        #10 Gra <= 1; Rout <= 1; PCin <= 1; 
						#15 Gra <= 0; Rout <= 0; PCin <= 0; 
                    end
				
                    //--------------------------------------------------------------------------------
					// In (DONE)
					IN_T3 : begin
						#10 Strobe <= 1; 
						#15 Strobe <= 0;
					end
					
					IN_T4 : begin
						#10 InPortout <= 1; Gra <= 1; Rin <= 1; 
						#15 InPortout <= 0; Gra <= 0; Rin <= 0;
					end
					
					//--------------------------------------------------------------------------------
					// Out (DONE)
					OUT_T3 : begin
						#10 Gra <= 1; Rout <= 1; Out_Portin <= 1; 
						#15 Gra <= 0; Rout <= 0; Out_Portin <= 0; 
					end
					
					//--------------------------------------------------------------------------------
					// Move from HI (DONE)
					MFHI_T3 : begin
						#10 HIout <= 1; Gra <= 1; Rin <= 1;
						#15 HIout <= 0; Gra <= 0; Rin <= 0;
					end
					
                    //--------------------------------------------------------------------------------
					// Move from LO (DONE)
					MFLO_T3 : begin
						#10 LOout <= 1; Gra <= 1; Rin <= 1;
						#15 LOout <= 0; Gra <= 0; Rin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// No Op (DONE)
					NOP_T3 : begin
						//Nothing to do
					end
					
                    //--------------------------------------------------------------------------------
					// Halt (DONE)
					HALT_T3 : begin
						run <= 0;
					end
						
				endcase
			
			end
	end
	
endmodule