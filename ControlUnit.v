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
