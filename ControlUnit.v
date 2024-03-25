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

	//Dark green section, MEMread & MEMwrite are not in diagram but added here
	output run, clear,

	//Brown section, interrupt functionality is not necessary
);

	parameter 			reset_state = 8'b00000000, T0 = 8'b11111000, T1 = 8'b11111001, T2 = 8'b11111010,
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
					OR_T3   = 8'b01011011, 	OR_T4   = 8'b01011100,  OR_T5   = 8'b01011110,
					// Or Immediate
					ORI_T3  = 8'b01110011, 	ORI_T4  = 8'b01110100, 	ORI_T5  = 8'b01110110,
					// Shift Right
					SHR_T3  = 8'b00101011, 	SHR_T4  = 8'b00101100, 	SHR_T5  = 8'b00101110,
					// Shift Right Arithmetic
					SHRA_T3 = 8'b00110011, 	SHRA_T4 = 8'b00110100, 	SHRA_T5 = 8'b00110110,
					// Shift Left
					SHL_T3  = 8'b00111011, 	SHL_T4  = 8'b00111100, 	SHL_T5  = 8'b00111110,
					// Rotate Right
					ROR_T3  = 8'b01000011, 	ROR_T4  = 8'b01000100, 	ROR_T5  = 8'b01000110,
					// Rotate Left
					ROL_T3  = 8'b01001011, 	ROL_T4  = 8'b01001100, 	ROL_T5  = 8'b01001110,
					// Negate
					NEG_T3  = 8'b10001011, 	NEG_T4  = 8'b10001100,
					// Not
					NOT_T3  = 8'b10010011, 	NOT_T4  = 8'b10010100,
					// Branch
					BR_T3 = 8'b10011011, 	BR_T4 = 8'b10011100, 	BR_T5 = 8'b10011101, 	BR_T6 = 8'b10011110,
					// Jump
					JR_T3 = 8'b10100011,
					// Jump and Link
					JAL_T3 = 8'b10101011, 	JAL_T4 = 8'b10101100,
					// In
					IN_T3   = 8'b10110011, 	IN_T4 = 8'b10110100,
					// Out
					OUT_T3  = 8'b10111011,
					// Move from High
					MFHI_T3 = 8'b11000011,
					// Move from Low
					MFLO_T3 = 8'b11001011,
					// Nothing
					NOP_T3  = 8'b11010011,
					// Halt
					HALT_T3 = 8'b11011011;

					
	reg [7:0]present_state = 8'b11111111;
	reg run = 1;

	always @ (negedge clock, posedge reset) begin
		
			
		if (reset == 1'b1) begin
			present_state = reset_state;
		end
		
		else begin // check other cases
			
			case (present_state)
				8'b11111111 :	present_state = reset_state;
				reset_state : 	present_state = T0;
				T0				:	present_state = T1;
				T1				:	present_state = T2;
				T2 : begin
						
					case (IR[31:27]) // checks all 8 bits

						5'b00000 : present_state = LD_T3;
						5'b00001 : present_state = LDI_T3;
						5'b00010 : present_state = ST_T3;
						5'b00011 : present_state = ADD_T3;
						5'b01100 : present_state = ADDI_T3;
						5'b00100 : present_state = SUB_T3;
						5'b01111 : present_state = MUL_T3;
						5'100000 : present_state = DIV_T3;
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
						5'b10011 : present_state = OUT_T3;
						5'b11000 : present_state = MFHI_T3;
						5'b11001 : present_state = MFLO_T3;
						5'b11010 : present_state = NOP_T3;
						5'b11011 : present_state = HALT_T3;
					
					endcase
				end

				LD_T3 : present_state = LD_T4;
				LD_T4 : present_state = LD_T5;
				LD_T5 : present_state = LD_T6;
				LD_T6 : present_state = LD_T7;
				LD_T7 : present_state = T0;
				
				LDI_T3 : present_state = LDI_T4;
				LDI_T4 : present_state = LDI_T5;
				LDI_T5 : present_state = T0;
					
				ST_T3 : present_state = ST_T4;
				ST_T4 : present_state = ST_T5;
				ST_T5 : present_state = ST_T6;
				ST_T6 : present_state = T0;

				ADD_T3 : present_state = ADD_T4;
				ADD_T4 : present_state = ADD_T5;
				ADD_T5 : present_state = T0;
					
				ADDI_T3 : present_state = ADDI_T4;
				ADDI_T4 : present_state = ADDI_T5;
				ADDI_T5 : present_state = T0;

				SUB_T3 : present_state = SUB_T4;
				SUB_T4 : present_state = SUB_T5;
				SUB_T5 : present_state = T0;
					
				MUL_T3 : present_state = MUL_T4;
				MUL_T4 : present_state = MUL_T5;
				MUL_T5 : present_state = MUL_T6;
				MUL_T6 : present_state = T0;

				DIV_T3 : present_state = DIV_T4;
				DIV_T4 : present_state = DIV_T5;
				DIV_T5 : present_state = DIV_T6;
				DIV_T6 : present_state = T0;
					
				AND_T3 : present_state = AND_T4;
				AND_T4 : present_state = AND_T5;
				AND_T5 : present_state = T0;
					
				ANDI_T3 : present_state = ANDI_T4;
				ANDI_T4 : present_state = ANDI_T5;
				ANDI_T5 : present_state = T0;
					
				OR_T3 : present_state = OR_T4;
				OR_T4 : present_state = OR_T5;
				OR_T5 : present_state = T0;
					
				ORI_T3 : present_state = ORI_T4;
				ORI_T4 : present_state = ORI_T5;
				ORI_T5 : present_state = T0;
					
				SHR_T3 : present_state = SHR_T4;
				SHR_T4 : present_state = SHR_T5;
				SHR_T5 : present_state = T0;
					
				SHRA_T3 : present_state = SHRA_T4;
				SHRA_T4 : present_state = SHRA_T5;
				SHRA_T5 : present_state = T0;
					
				SHL_T3 : present_state = SHL_T4;
				SHL_T4 : present_state = SHL_T5;
				SHL_T5 : present_state = T0;
					
				ROR_T3 : present_state = ROR_T4;
				ROR_T4 : present_state = ROR_T5;
				ROR_T5 : present_state = T0;
					
				ROL_T3 : present_state = ROL_T4;
				ROL_T4 : present_state = ROL_T5;
				ROL_T5 : present_state = T0;
					
				NEG_T3 : present_state = NEG_T4;
				NEG_T4 : present_state = T0;
					
				NOT_T3 : present_state = NOT_T4;
				NOT_T4 : present_state = T0;
					
				BR_T3 : present_state = BR_T4;
				BR_T4 : present_state = BR_T5;
				BR_T5 : present_state = BR_T6;
				BR_T6 : present_state = T0;
					
				JR_T3 : present_state = T0;
					
				JAL_T3 : present_state = JAL_T4;
				JAL_T4 : present_state = T0;
					
				IN_T3 : present_state = IN_T4;
				IN_T4 : present_state = T0;
					
				OUT_T3 : present_state = T0;
					
				MFHI_T3 : present_state = T0;
				MFLO_T3 : present_state = T0;
					
				NOP_T3  : present_state = T0; 
				HALT_T3 : present_state = HALT_T3;
				
			endcase
		end
	end

	// everything should be properly shifted (tabbed) after we are done
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

always @(present_state) // do the job for each state
begin
    case (present_state) // assert the required signals in each state
        reset_state: begin
            Gra <= 0; Grb <= 0; Grc <= 0; Yin <= 0; // initialize the signals
            // Initialize other signals
        end
        fetch0: begin
            PCout <= 1; // see if you need to de-assert these signals
            MARin <= 1;
            IncPC <= 1;
            Zin <= 1;
            // Set other signals for fetch0 state
        end
        add3: begin
            Grb <= 1; Rout <= 1;
            Yin <= 1;
            // Set other signals for add3 state
        end
        // Add more cases for other states
    endcase
end

endmodule
