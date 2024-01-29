timescale 1ns/10ps
module Bus_w_Reg_tb();
reg clock, clear, PCout, MARin, IncPC, Zin, Zlowout, PCin, Read, Mdatain;
reg [31:0] MDRin, IRin, R1out, R2in, Yin; // Assuming 32-bit registers for MDR and IR
reg [7:0] R1_data; // Data for R1 register
reg [7:0] R2_data; // Data for R2 register
reg [3:0] present_state;

// Instantiate your DUT (DataPath module)
DataPath DP(
	clock, clear,
   PCout, MARin, IncPC, Zin, Zlowout, PCin, Read, Mdatain,
   MDRin, IRin, R1out, R2in, Yin
);


// Step Control Sequence T0 to T5
parameter init = 4'd1, T0 = 4'd2, T1 = 4'd3, T2 = 4'd4, T3 = 4'd5, T4 = 4'd6, T5 = 4'd7;
             
initial begin
	clock = 0;
   present_state = init;
   R1_data = 8'h05; // Initializing R1 with value 5
   R2_data = 8'h00; // Initializing R2 with value 0
end
    
// Toggle clock every 10 time units
always #10 clock = ~clock;
// State machine to control the test sequence
always @ (negedge clock) begin
	if (!clear) begin
		present_state <= init;
        end
        else begin
            case (present_state)
                init: begin
                    // Set up PC, MAR, and Z register
                    PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
                    #10 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                    present_state <= T0;
                end
                T0: begin
                    // Output value from R1 to bus
                    R1out <= 1; Yin <= R1_data;
                    #10 R1out <= 0; Yin <= 0;
                    present_state <= T1;
                end
                T1: begin
                    // Input value from bus to R2
                    PCin <= 1; Read <= 1; Mdatain <= R1_data; MDRin <= 1; IRin <= 1;
                    #10 PCin <= 0; Read <= 0; Mdatain <= 0; MDRin <= 0; IRin <= 0;
                    present_state <= T2;
                end
                T2: begin
                    // Move instruction from MDR to IR
                    MDRout <= 1; IRin <= 1;
                    #10 MDRout <= 0; IRin <= 0;
                    present_state <= T3;
                end
                T3: begin
                    // Output value from R1 to bus
                    R1out <= 1; Yin <= R1_data;
                    #10 R1out <= 0; Yin <= 0;
                    present_state <= T4;
                end
                T4: begin
                    // Input value from bus to R2
                    R2in <= 1; Yin <= R1_data;
                    #10 R2in <= 0; Yin <= 0;
                    present_state <= T5;
                end
                T5: begin
                    // Optionally update the Z register based on R2 value
                    Zlowout <= 1; R2in <= 1;
                    #10 Zlowout <= 0; R2in <= 0;
                    present_state <= init; // Reset state machine
                end
                default: present_state <= init;
            endcase
        end
    end
endmodule

