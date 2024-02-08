module ALU(input wire [31:0] A, B, input wire [3:0] op, output reg[31:0] result);
	
	
	wire [31:0] and_result, or_result, neg_result, shr_result, shra_result, shl_result, ror_result, rol_result, add_result, sub_result, mul_result, div_result;
	
	and_32_bit and_32(A, B, 4'b0000, and_result);
	or_32_bit or_32(A, B, 4'b0001, or_result);
    neg_32_bit neg_32(A, B, 4'b0010, neg_result);
    shr_32_bit shr_32(A, B, 4'b0011, shr_result);
    shra_32_bit shra_32(A, B, 4'b0100, shra_result);
    shl_32_bit shl_32(A, B, 4'b0101, shl_result);
    ror_32_bit ror_32(A, B, 4'b0110, ror_result);
    rol_32_bit rol_32(A, B, 4'b0111, rol_result);
    CarrySelectAdder_32_bit add_32(A, B, 4'b1000, add_result);
    sub_32_bit sub_32(A, B, 4'b1001, sub_result);
    Bit_Pair_32_bit mul_32(A, B, 4'b1010, mul_result);
    Non_Restoring_32_bit div_32(A, B, 4'b1011, div_result);
    

	
	always @(*) begin
		case(op)
			0000	:	result = and_result;
			0001	:	result = or_result;
            0010	:	result = neg_result;
			0011	:	result = shr_result;
            0100	:	result = shra_result;
			0101	:	result = shl_result;
            0110	:	result = ror_result;
			0111	:	result = rol_result;
            1000	:	result = add_result;
			1001	:	result = sub_result;
			1010	:	result = mul_result;
			1011	:	result = div_result;
			default: result = 32'b0;
		endcase
	end
	
endmodule
