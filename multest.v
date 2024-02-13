module Bit_Pair_32_bit(input [31:0] a, input [31:0] b, output reg[63:0] z);

integer i,j; 
reg [63:0] m;
reg [31:0] q; 

wire [31:0] neg_b; 
assign neg_b = ~b + 1'b1;

reg [63:0] product;
reg [63:0] temp; 


    always @(*)
    begin
	 product = 64'b0; 
        for (j = 0; j < 16; j=j+1)
            begin 
            i = j * 2; 
                if(i == 0) 
                    q[i] = {a[1], a[0], a[0]}; 
                else 
                    q[i] = {a[i+1], a[i], a[i-1]}; 
                    
                case(q[i])
                    3'b000: m = 0;
                    3'b001: m = b; 
                    3'b010: m = b; 
                    3'b011: m = b << 1;  
    
                    3'b100: m = neg_b << 1;
                    3'b101: m = neg_b; 
                    3'b110: m = neg_b; 
                    3'b111: m = 0; 
                endcase
                temp = m << i;
                product = product + temp; 
            end 
        z = product; 
    end



////Below is everything that gpt4 implemenmted
//// Variables for iteration and intermediate storage
//integer i;
//reg [63:0] product;
//reg [31:0] m;
//reg [2:0] recoded_bits;
//reg [63:0] temp;
//wire [31:0] neg_b = ~b + 1; // Assuming simple 2's complement for negation
//
//// Main computation block
//always @(*) begin
//    product = 64'b0; // Reset product for combinational logic
//    for (i = 0; i < 32; i = i + 2) {
//        // Check for the last bit pair with special handling for sign bit
//        if (i == 30) begin
//            recoded_bits = {a[i+1], a[i], a[i]};
//        end else if (i < 30) begin
//            recoded_bits = {a[i+1], a[i], a[i+2]};
//        end
//
//        // Determine the operation based on the recoded bits
//        case(recoded_bits)
//            3'b000, 3'b111: m = 0;
//            3'b001, 3'b010: m = b;
//            3'b011: m = b << 1; // Assuming logical shift left by 1 for doubling
//            3'b100: m = (neg_b << 1); // Assuming logical shift left by 1 for negated b doubled
//            3'b101, 3'b110: m = neg_b; // Direct negation of b
//            default: m = 0;
//        endcase
//
//        temp = (m << i); // Shift the calculated value based on the current bit pair
//        product = product + temp; // Accumulate the product
//    end
//    z = product; // Assign the final product to the output
//end
    

endmodule
