// Ripple Carry Adder
module RippleCarryAdder_4bit(A, B, Result, c_out);

	input [3:0] A, B;
	output [3:0] Result;
	output c_out; 

	reg [3:0] Result;
	reg [4:0] LocalCarry;

integer i;

always@(A or B)
	begin
		LocalCarry = 5'd0;
		for(i = 0; i < 4; i = i + 1)
		begin
			//^ = xor
			Result[i] = A[i]^B[i]^LocalCarry[i];
			LocalCarry[i+1] = (A[i]&B[i]) | (LocalCarry[i]&A[I]) | (LocalCarry[i]&B[i]);
		end
	end
	c_out = LocalCarry[4]

