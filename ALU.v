module ALU(input wire [31:0] Y, BusMuxOut, input ADD, IncPC, AND, OR, BRANCH, NEGATE, NOT, SUB, MUL, DIV, SHR, SHRA, SHL, ROR, ROL, output reg[63:0] C);
	
	
	wire [31:0] and_result, or_result, neg_result, not_result, shr_result, shra_result, shl_result, ror_result, rol_result, add_result, sub_result, Quotient, Remainder;
	wire [63:0] mul_result;
	
	reg [3:0] op; 
	//And/Or WORKS
	and_32_bit a(.Ra(Y), .Rb(BusMuxOut), .Rz(and_result));
	or_32_bit o(.Ra(Y), .Rb(BusMuxOut), .Rz(or_result));
	
	//Neg/Not WORKS
	//Note: There is no sign extension when preforming the operation
	neg_32_bit neg_32(Y, neg_result);
	not_32_bit not_32(Y, not_result);
	
	//Shifts
	shr_32_bit shr_32(Y, BusMuxOut, shr_result);
	shra_32_bit shra_32(Y, BusMuxOut, shra_result);
	shl_32_bit shl_32(Y, BusMuxOut, shl_result);
	
	//Rotates
	ror_32_bit ror_32(Y, BusMuxOut, ror_result);
	rol_32_bit rol_32(Y, BusMuxOut, rol_result);
	
	//Add/Sub
	CarrySelectAdder_32_bit add_32(.a(Y), .b(BusMuxOut), .sum(add_result));
	sub_32_bit sub_32(Y, BusMuxOut, sub_result);
	
	//Mul/Div
	Bit_Pair_32_bit mul_32(Y, BusMuxOut, mul_result);
	Non_Restoring_32_bit div_32(Y, BusMuxOut, Quotient, Remainder);
    
	
	
	always @(*) begin 
	if(ADD) op <= 4'b0100;
	else if(IncPC) op <= 4'b1101; 
	else if(AND) op <= 4'b0000;
	else if(OR) op <= 4'b0001;
	else if(BRANCH) op <= 4'b1110;
	else if(NEGATE) op <= 4'b0010; 
	else if(NOT) op <= 4'b0011;
	else if(SUB) op <= 4'b0101;
	else if(MUL) op <= 4'b0110;
	else if(DIV) op <= 4'b0111;
	else if(SHR) op <= 4'b1000;
	else if(SHRA) op <= 4'b1001;
	else if(SHL) op <= 4'b1010;
	else if(ROR) op <= 4'b1011;
	else if(ROL) op <= 4'b1100;
	begin 
		case(op)
			4'b0000	: begin 	
				C [31:0] <= and_result;
				C [63:32] <= 32'd0; end
 			4'b0001	: begin
				C [31:0] <= or_result;
				C [63:32] <= 32'd0; end 
			4'b0010	: begin 
				C [31:0] <= neg_result;
				C [63:32] <= 32'd0; end 
			4'b0011	: begin
				C [31:0] <= not_result;
				C [63:32] <= 32'd0; end 
			4'b0100	: begin
				C [31:0] <= add_result;
				C [63:32] <= 32'd0; end 
			4'b0101	: begin
				C [31:0] <= sub_result;
				C [63:32] <= 32'd0; end 
			4'b0110	: begin
				C [31:0] <= mul_result [31:0];
				C [63:32] <= mul_result [63:32]; end 
			4'b0111	: begin
				C [31:0] <= Quotient [31:0];
				C [63:32] <= Remainder [31:0]; end 
			4'b1000	: begin
				C [31:0] <= shr_result;
				C [63:32] <= 32'd0; end 
			4'b1001	: begin
				C [31:0] <= shra_result;
				C [63:32] <= 32'd0; end 
			4'b1010	: begin
				C [31:0] <= shl_result;
				C [63:32] <= 32'd0; end 
			4'b1011	: begin
				C [31:0] <= ror_result;
				C [63:32] <= 32'd0; end 
			4'b1100	: begin
				C [31:0] <= rol_result;
				C [63:32] <= 32'd0; end 
			4'b1101: begin
				C [31:0] <= 1 + BusMuxOut; //modify this pc line to start at a specific part in ram
				C [63:32] <= 32'd0; end 
			4'b1110: begin
				C [31:0] <= add_result; //modify this pc line to start at a specific part in ram
				C [63:32] <= 32'd0; end
	
		endcase
	end
	end
	
endmodule