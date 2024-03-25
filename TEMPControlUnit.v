
`timescale 1ns/10ps
module control_unit (
	//Going CCW
	
	//Green section
	output reg PCout, MDRout, Zhighout, Zlowout, HIout, LOout,

	//Yellow section
	output reg Rin, Rout, Gra, Grb, Grc,

	//Dark blue section, not sure if we use Zin ---- added Zhighin, Zlowin even though not in diagram
	output reg BAout, Csignout, OutPortin, MDRin, MARin, Yin, IRin, PCin, CONin, LOin, HIin, Zhighin, Zlowin,

	//Light green section
	output reg ADD, SUB, MUL, DIV,
	output reg AND, OR, 
	output reg SHR, SHRA, SHL,
	output reg ROR, ROL,
	output reg NEG, NOT,
	output reg IncPC,

	//Light blue section
	output reg MD_read, Write

	//Greyish section
	output reg InPortout

	//Red section
	input clock, reset, stop, CONFF,
	input [31:0] IR_reg,

	//Dark green section, MD_read & Write are not in diagram but added here
	output run, clear,

	//Brown section, interrupt functionality is not necessary
);

parameter reset_state = 4'b0000, fetch0 = 4'b0001, fetch1 = 4'b0010, fetch2 = 4'b0011,
          add3 = 4'b0100, add4 = 4'b0101, add5 = 4'b0110;

reg [3:0] present_state = reset_state; // adjust the bit pattern based on the number of states

always @(posedge Clock, posedge Reset) // finite state machine; if clock or reset rising-edge
begin
    if (Reset == 1'b1)
        present_state = reset_state;
    else
        case (present_state)
            reset_state: present_state = fetch0;
            fetch0: present_state = fetch1;
            fetch1: present_state = fetch2;
            fetch2: begin
                // inst. decoding based on the opcode to set the next state
                case (IR[31:27])
                    5'b00011: present_state = add3; // this is the add instruction
                    // Add more cases for other opcodes
                endcase
            end
            add3: present_state = add4;
            add4: present_state = add5;
            // Add more cases for other states
        endcase
end

//----------------------------------------------Everything above is done by Sere in the ControlUnit.v file----------------------------------------------
always @(present_state) // do the job for each state
begin
    if (run) begin // only change state if program is supposed to be running
				case (present_state) 
				
					reset_state : begin
						clear <= 1; run <= 1;
					
						MD_read <= 0; Write <= 0;
						Rin <= 0; Rout <= 0; BAout <= 0; Gra <= 0; Grb <= 0; Grc <= 0;
						IncPC <= 0;
						PCin <= 0; PCout <= 0; IRin <= 0;
						MDRin <= 0; MDRout <= 0; MARin <= 0; 
						Zhighin <= 0; Zlowin <= 0; Zhighout <= 0; Zlowout <= 0;
						HIin <= 0; LOin <= 0; HIout <= 0; LOout <= 0;
						Csignout <= 0;
						Yin <= 0;
						ConIn <= 0;
						OutPortin <= 0; InPortout <= 0;
                        ADD <= 0; SUB <= 0; MUL <= 0; DIV <= 0;
						AND <= 0; OR <= 0;
						SHR <= 0; SHRA <= 0; SHL <= 0;
						ROR <= 0; ROL <= 0;
						NEG <= 0; NOT <= 0;
						#15 clear <= 0;
					end
				
                    //--------------------------------------------------------------------------------
                    // T0-T3 (DONE)
					T0 : begin
						#10 PCout <= 1; MARin <= 1; IncPC <= 1; Zlowin <= 1; 
						#15 PCout <= 0; MARin <= 0; IncPC <= 0; Zlowin <= 0;
					end
				
					T1 : begin
						#10 Zlowout <= 1; PCin <= 1; Read <= 1;  MD_read <= 1; MDRin <= 1; 
						#15 Zlowout <= 0; PCin <= 0; Read <= 0;  MD_read <= 0; MDRin <= 0;
					end
					
					T2 : begin
						#10 MDRout <= 1; IRin <= 1;
						#15 MDRout <= 0; IRin <= 0;
					end
                    //--------------------------------------------------------------------------------
                    // Load
					LD_T3 : begin
						Grb <= 1; BAout <= 1; Yin <= 1;
						#15 Grb <= 0; BAout <= 0; Yin <= 0;
					end
					
					LD_T4 : begin
						Csignout <= 1; ADD <= 1; Zlowin <= 1;
						#15 Csignout <= 0; ADD <= 0; Zlowin <= 0;
					end
					
					LD_T5 : begin
						Zlowout <= 1; MARin <= 1;
						#15 Zlowout <= 0; MARin <= 0; 
					end
					
					LD_T6 : begin
						MD_read <= 1; MDRin <= 1;
						#15 MD_read <= 0; MDRin <= 0;
					end
					
					LD_T7 : begin
						MDRout <= 1; Gra <= 1; Rin <= 1;
						#15 MDRout <= 0; Gra <= 0; Rin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// Load Immediate
					LDI_T3 : begin
						Grb <= 1; BAout <= 1; Yin <= 1;
						#15 Grb <= 0; BAout <= 0; Yin <= 0;
					end
					
					LDI_T4 : begin
						Csignout <= 1; ADD <= 1; Zlowin <= 1;
						#15 Csignout <= 0; ADD <= 0; Zlowin <= 0;
					end
					
					LDI_T5 : begin
						Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
					
                    //--------------------------------------------------------------------------------
					// Store
					ST_T3 : begin
						Grb <= 1; BAout <= 1; Yin <= 1;
						#15 Grb <= 0; BAout <= 0; Yin <= 0;
					end
					
					ST_T4 : begin
						Csignout <= 1; ADD <= 1; Zlowin <= 1;
						#15 Csignout <= 0; ADD <= 0; Zlowin <= 0;
					end
					
					ST_T5 : begin
						Zlowout <= 1; MARin <= 1;
						#15 Zlowout <= 0; MARin <= 0;
					end
					
					ST_T6 : begin
						Gra <= 1; Rout <= 1; Write <= 1;
						#15 Gra <= 0; Rout <= 0; Write <= 0;
					end
                        
                    //--------------------------------------------------------------------------------
					// Add
					ADD_T3 : begin 
						Grb <= 1; Rout <= 1; Yin <= 1;
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					ADD_T4 : begin 
						Grc <= 1; Rout <= 1; ADD <= 1; Zlowin <= 1;
						#15 Grc <= 0; Rout <= 0; ADD <= 0; Zlowin <= 0;
					end
					
					ADD_T5 : begin 
						Zlowout <= 1; Gra <= 1; Rin <= 1;
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
					// Subtract
					SUB_T3 : begin 
						Grb <= 1; Rout <= 1; Yin <= 1;
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					SUB_T4 : begin 
						Grc <= 1; Rout <= 1; SUB <= 1; Zlowin <= 1;
						#15 Grc <= 0; Rout <= 1; SUB <= 0; Zlowin <= 0;
					end
					
					SUB_T5 : begin 
						Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
					
                    //--------------------------------------------------------------------------------
					// Multiply
					MUL_T3 : begin
						Gra <= 1; Rout <= 1; Yin <= 1;
						#15 Gra <= 0; Rout <= 0; Yin <= 0;
					end
					
					MUL_T4 : begin
						Grb <= 1; Rout <= 1; MUL <= 1; Zlowin <= 1; Zhighin <= 1;
						#15 Grb <= 0; Rout <= 0; MUL <= 0; Zlowin <= 0; Zhighin <= 0;
					end
					
					MUL_T5 : begin
						Zlowout <= 1; LOin <= 1;
						#15 Zlowout <= 0; LOin <= 0;
					end
					
					MUL_T6 : begin
						Zhighout <= 1; HIin <= 1;
						#15 Zhighout <= 0; HIin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// Divide
					DIV_T3 : begin
						Gra <= 1; Rout <= 1; Yin <= 1;
						#15 Gra <= 0; Rout <= 0; Yin <= 0;
					end
					
					DIV_T4 : begin
						Grb <= 1; Rout <= 1; DIV <= 1; Zhighin <= 1; Zlowin <= 1;
						#15 Grb <= 0; Rout <= 0; DIV <= 0; Zhighin <= 1; Zlowin <= 0;
					end
					
					DIV_T5 : begin
						Zlowout <= 1; LOin <= 1;
						#15 Zlowout <= 0; LOin <= 0;
					end
					
					DIV_T6 : begin
						Zhighout <= 1; HIin <= 1;
						#15 Zhighout <= 0; HIin <= 0;
					end
					
					//--------------------------------------------------------------------------------
					// And
					AND_T3 : begin
						Grb <= 1; Rout <= 1; Yin <= 1;
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					AND_T4 : begin
						Grc <= 1; Rout <= 1; AND <= 1; Zlowin <= 1;
						#15 Grc <= 0; Rout <= 0; AND <= 0; Zlowin <= 0;
					end
					
					AND_T5 : begin
						Zlowout <= 1; Gra <= 1; Rin <= 1;
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
					// Or
					OR_T3 : begin
						Grb <= 1; Rout <= 1; Yin <= 1;
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					OR_T4 : begin
						Grc <= 1; Rout <= 1; OR <= 1; Zlowin <= 1;
						#15 Grc <= 0; Rout <= 0; OR <= 0; Zlowin <= 0;
					end
					
					OR_T5 : begin
						Zlowout <= 1; Gra <= 1; Rin <= 1;
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
					// Shift Right
					SHR_T3 : begin
						Grb <= 1; Rout <= 1; Yin <= 1;
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					SHR_T4 : begin
						Grc <= 1; Rout <= 1; SHR <= 1; Zlowin <= 1;
						#15 Grc <= 0; Rout <= 0; SHR <= 0; Zlowin <= 0;
					end
					
					SHR_T5 : begin
						Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// Shift Right Arithmetic
					SHRA_T3 : begin
						Grb <= 1; Rout <= 1; Yin <= 1;
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					SHRA_T4 : begin
						Grc <= 1; Rout <= 1; SHRA <= 1; Zlowin <= 1;
						#15 Grc <= 0; Rout <= 0; SHRA <= 0; Zlowin <= 0;
					end
					
					SHRA_T5 : begin
						Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// Shift Left
					SHL_T3 : begin
						Grb <= 1; Rout <= 1; Yin <= 1;
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					SHL_T4 : begin
						Grc <= 1; Rout <= 1; SHL <= 1; Zlowin <= 1;
						#15 Grc <= 0; Rout <= 0; SHL <= 0; Zlowin <= 0;
					end
					
					SHL_T5 : begin
						Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// Rotate Right
					ROR_T3 : begin
						Grb <= 1; Rout <= 1; Yin <= 1;
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					ROR_T4 : begin
						Grc <= 1; Rout <= 1; ROR <= 1; Zlowin <= 1;
						#15 Grc <= 0; Rout <= 0; ROR <= 0; Zlowin <= 0;
					end
					
					ROR_T5 : begin
						Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
					
                    //--------------------------------------------------------------------------------
					// Rotate Left
					ROL_T3 : begin
						Grb <= 1; Rout <= 1; Yin <= 1;
						#15 Grb <= 0; Rout <= 0; Yin <= 0;
					end
					
					ROL_T4 : begin
						Grc <= 1; Rout <= 1; ROL <= 1; Zlowin <= 1;
						#15 Grc <= 0; Rout <= 0; ROL <= 0; Zlowin <= 0;
					end
					
					ROL_T5 : begin
						Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// Negate
					NEG_T3 : begin
						Grb <= 1; Rout <= 1; NEG <= 1; Zlowin <= 1;
						#15 Grb <= 0; Rout <= 0; NEG <= 0; Zlowin <= 0;
					end
					
					NEG_T4 : begin
						Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// Not
					NOT_T3 : begin
						Grb <= 1; Rout <= 1; NOT <= 1; Zlowin <= 1;
						#15 Grb <= 0; Rout <= 0; NOT <= 0; Zlowin <= 0;
					end
					
					NOT_T4 : begin
						Zlowout <= 1; Gra <= 1; Rin <= 1;
						#15 Zlowout <= 0; Gra <= 0; Rin <= 0;
					end
				
				
                    //--------------------------------------------------------------------------------
					// Branch
					BR_T3  : begin
						Gra <= 1; Rout <= 1; ConIn <= 1;
						#15 Gra <= 0; Rout <= 0; ConIn <= 0;
					end
					
					BR_T4  : begin
						PCout <= 1; Yin <= 1;
						#15 PCout <= 0; Yin <= 0;
					end
					
					BR_T5  : begin
						Csignout <= 1; ADD <= 1; Zlowin <= 1;
						#15 Csignout <= 0; ADD <= 0; Zlowin <= 0;
					end
					
					BR_T6  : begin
						Zlowout <= 1;
						
						if (ConFF) begin
							PCin <= 1;
						end
						
						#15 Zlowout <= 0; PCin <= 0;
					end
				
				
                    //--------------------------------------------------------------------------------
					// Return
					JR_T3 : begin
						Gra <= 1; Rout <= 1; PCin <= 1;
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
					// In Port
					IN_T3 : begin
						// do nothing here, inport is getting data here
					end
					
					IN_T4 : begin
						InPortout <= 1; Gra <= 1; Rin <= 1;
						#15 InPortout <= 0; Gra <= 0; Rin <= 0;
					end
					
					//--------------------------------------------------------------------------------
					// Out Port
					OUT_T3 : begin
						Gra <= 1; Rout <= 1; OutPortin <= 1;
						#15 Gra <= 0; Rout <= 0; OutPortin <= 0;
					end
					
					//--------------------------------------------------------------------------------
					// Move from HI
					MFHI_T3 : begin
						HIout <= 1; Gra <= 1; Rin <= 1;
						#15 HIout <= 0; Gra <= 0; Rin <= 0;
					end
					
                    //--------------------------------------------------------------------------------
					// Move from LO
					MFLO_T3 : begin
						LOout <= 1; Gra <= 1; Rin <= 1;
						#15 LOout <= 0; Gra <= 0; Rin <= 0;
					end
				
                    //--------------------------------------------------------------------------------
					// NOP
					NOP_T3 : begin
						// do nothing, will change back to T0 on next clock cycle
					end
					
                    //--------------------------------------------------------------------------------
					// Halt
					HALT_T3 : begin
						run <= 0;
					end
						
				endcase
			
			end
	end
	
endmodule