module ALU(input wire [31:0] A, B, input wire [3:0] op, output reg[31:0] result);
	
	
	wire [31:0] and_result, or_result, neg_result, shr_result, shra_result, shl_result, ror_result, rol_result, add_result, sub_result, mul_result, div_result;
	
	//All commented operations have not been tested...
	//All uncommented operations work
	
	//And/Or
	and_32_bit and_32(A, B, and_result);
	or_32_bit or_32(A, B, or_result);
	
	//Neg/Not
	//Note: There is no sign extension when preforming the operation
   //neg_32_bit neg_32(A, neg_result);
	//not_32_bit not_32(A, not_result);
	
	//Shifts
   //shr_32_bit shr_32(A, B, shr_result);
   //shra_32_bit shra_32(A, B, shra_result);
   //shl_32_bit shl_32(A, B, shl_result);
	
	//Rotates
   //ror_32_bit ror_32(A, B, ror_result);
   //rol_32_bit rol_32(A, B, rol_result);
	
	//Add/Sub
   //CarrySelectAdder_32_bit add_32(A, B, add_result);
   //sub_32_bit sub_32(A, B, sub_result);
	
	//Mul/Div
   //Bit_Pair_32_bit mul_32(A, B, mul_result);
   //Non_Restoring_32_bit div_32(A, B, div_result);
    

	
	always @(*) begin
		case(op)
			4'b0000	:	result = and_result;
			4'b0001	:	result = or_result;
         4'b0010	:	result = neg_result;
			4'b0011	:	result = not_result;
			//4'b0100	:	result = shr_result;
         //4'b0101	:	result = shra_result;
			//4'b0110	:	result = shl_result;
         //4'b0111	:	result = ror_result;
			//4'b1000	:	result = rol_result;
         //4'b1001	:	result = add_result;
			//4'b1010	:	result = sub_result;
			//4'b1011	:	result = mul_result;
			//4'b1100	:	result = div_result;
		endcase
	end
	
endmodule
