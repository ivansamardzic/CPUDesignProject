module I_O(input clear, clock, Out_Portin, Strobe, 
	input [31:0] BusMuxOut, INPUT_UNIT,
	output [31:0] OUTPUT_UNIT, BMInINPORT
	);


	register RO(clear, clock, Out_Portin, BusMuxOut, OUTPUT_UNIT); 
	register RI(clear, clock, Strobe, INPUT_UNIT, BMInINPORT); 
	
	
endmodule 
