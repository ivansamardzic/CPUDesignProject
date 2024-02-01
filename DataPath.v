module DataPath(
//test
//	input wire clock, clear,
//	input wire [7:0] A, 
//	input wire [7:0] RegisterAImmediate,
//	input wire RZout, RAout, RBout,
//	input wire RAin, RBin, RZin
	
	input wire PCout, Zlowout, MDRout, R2out, R3out, // add any other signals to see in your simulation
   input wire MARin, Zin, PCin, MDRin, IRin, Yin,
   input wire IncPC, Read, AND, R1in, R2in, R3in,
   input wire Clock, clear,
   input wire [31:0] Mdatain
);

wire [31:0] BusMuxOut, BusMuxInRZ, BusMuxInRA, BusMuxInRB; 

wire [31:0] Zregin;

//Devices
register RA(clear, clock, RAin, RegisterAImmediate, BusMuxInRA);
register RB(clear, clock, RBin, BusMuxOut, BusMuxInRB);

// adder
AND_32_bit and_32(A, BusMuxOut, Zregin);
register RZ(clear, clock, RZin, Zregin, BusMuxInRZ);

//Bus
Bus bus(BusMuxInRZ, BusMuxInRA, BusMuxInRB, RZout, RAout, RBout, BusMuxOut);

endmodule
