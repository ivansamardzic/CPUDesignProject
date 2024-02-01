`timescale 1ns/10ps
module Bus_w_Reg_tb();

reg clock, clear, RZout, RAout, RBout, RAin, RBin, RZin;

reg[7:0] A = 8'h00;

reg[7:0] RegisterAImmediate = 8'h00;

wire [31:0] BusMuxOut;

DataPath DP(
	clock, clear, A, RegisterAImmediate, RZout, RAout, RBout, RAin, RBin, RZin, BusMuxOut
);


//// Step Control Sequence T0 to T5
//parameter init = 4'd1, T0 = 4'd2, T1 = 4'd3, T2 = 4'd4;

initial begin
    clock = 0;
    clear = 0;
    present_state = init;
    A = 8'h05; // Initializing A with value 5
    RegisterAImmediate = 8'h00; // Initializing RegisterAImmediate with value 0
end

// Toggle clock every 10 time units
always #10 clock = ~clock;

// Testbench control signals
    reg [7:0] R1_data = 8'h05; // Value to be transferred from R1 to R2
    reg [7:0] R2_data; // Value read from R2
    reg [3:0] present_state; // Control state

    // Step Control Sequence
    parameter init = 4'd1, T0 = 4'd2, T1 = 4'd3, T2 = 4'd4;

    // State machine to control the test sequence
    always @ (negedge clock) begin
        if (!clear) begin
            present_state <= init;
        end
        else begin
            case (present_state)
                init: begin
                    // Set up your test sequence here
                    // For example, you can initiate some actions on your datapath signals
                    RAin = 1; // Enable RA output
                    RBin = 1; // Enable RB output
                    present_state <= T0;
                end
                T0: begin
                    // Transfer data from R1 to R2
                    RAin = 1; // Enable RA output
                    A = R1_data; // Set data in R1
                    present_state <= T1;
                end
                T1: begin
                    RAin = 0; // Disable RA output
                    RBin = 1; // Enable RB input
                    present_state <= T2;
                end
                T2: begin
                    R2_data = BusMuxOut; // Read data from R2
                    RBin = 0; // Disable RB input
                    // You can continue the sequence as needed
                    // For example, check data transfer or perform other actions
                    // present_state <= T3;
                    // Add more states as required
                end
                default: present_state <= init;
            endcase
        end
    end

endmodule

