module FullAdder (output sum, c_out, input c_in, a, b);
	wire w1, w2, w3;
	//format (sum, c_out, a, b) 
	HalfAdder A1 (w1, w2, a, b);
	HalfAdder A2 (sum, w3, c_in, w1);
	// or (output, input 1, input 2) 
	or (c_out, w3, w2);
endmodule 

module HalfAdder (output sum, c_out, input a, b); 
	xor (sum, a, b); 
	and (c_out, a, b); 
endmodule 
	
