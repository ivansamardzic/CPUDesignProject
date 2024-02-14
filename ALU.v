module ALU(input wire [31:0] Y, BusMuxOut, input wire [3:0] op, output reg[63:0] C);
	
	
	wire [31:0] and_result, or_result, neg_result, not_result, shr_result, shra_result, shl_result, ror_result, rol_result, add_result, sub_result, Quotient, Remainder;
	wire [63:0] mul_result;

	parameter AND = 4'b0000, OR = 4'b0001, NEG = 4'b0010, NOT = 4'b0011, ADD = 4'b0100, SUB = 4'b0101,
	MUL = 4'b0110, DIV = 4'b0111, SHR = 4'b1000, SHRA = 4'b1001, SHL = 4'b1010, ROR = 4'b1011, ROL = 4'b1100;
	
	//And/Or WORKS
	and_32_bit and_32(Y, BusMuxOut, and_result);
	or_32_bit or_32(Y, BusMuxOut, or_result);
	
	//Neg/Not WORKS
	neg_32_bit neg_32(Y, neg_result);
	not_32_bit not_32(Y, not_result);
	
	//Shifts WORK
	shr_32_bit shr_32(Y, BusMuxOut, shr_result);
	shra_32_bit shra_32(Y, BusMuxOut, shra_result);
	shl_32_bit shl_32(Y, BusMuxOut, shl_result);
	
	//Rotates WORK
	ror_32_bit ror_32(Y, BusMuxOut, ror_result);
	rol_32_bit rol_32(Y, BusMuxOut, rol_result);
	
	//Add/Sub WORKS
	CarrySelectAdder_32_bit add_32(.a(Y), .b(BusMuxOut), .sum(add_result));
	sub_32_bit sub_32(.a(Y), .b(BusMuxOut), .sum(sub_result));
	
	//Mul/Div WORKS
	Bit_Pair_32_bit mul_32(Y, BusMuxOut, mul_result);
	Non_Restoring_32_bit div_32(Y, BusMuxOut, Quotient, Remainder);
    

	
	always @(*) begin
		case(op)
			AND	: begin 	
				C [31:0] <= and_result;
				C [63:32] <= 32'd0; end
 			OR	: begin
				C [31:0] <= or_result;
				C [63:32] <= 32'd0; end 
			NEG	: begin 
				C [31:0] <= neg_result;
				C [63:32] <= 32'd0; end 
			NOT	: begin
				C [31:0] <= not_result;
				C [63:32] <= 32'd0; end 
			ADD	: begin
				C [31:0] <= add_result;
				C [63:32] <= 32'd0; end 
			SUB	: begin
				C [31:0] <= sub_result;
				C [63:32] <= 32'd0; end 
			MUL	: begin
				C [31:0] <= mul_result [31:0];
				C [63:32] <= mul_result [63:32]; end 
			DIV	: begin
				C [31:0] <= Quotient [31:0];
				C [63:32] <= Remainder [31:0]; end 
			SHR	: begin
				C [31:0] <= shr_result;
				C [63:32] <= 32'd0; end 
			SHRA	: begin
				C [31:0] <= shra_result;
				C [63:32] <= 32'd0; end 
			SHL	: begin
				C [31:0] <= shl_result;
				C [63:32] <= 32'd0; end 
			ROR	: begin
				C [31:0] <= ror_result;
				C [63:32] <= 32'd0; end 
			ROL	: begin
				C [31:0] <= rol_result;
				C [63:32] <= 32'd0; end 
	
		endcase
	end
	
endmodule
