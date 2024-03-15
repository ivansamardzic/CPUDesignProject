module CON_FF(
	input wire [31:0] BMInIR, BusMuxOut,
	input wire CONin, 
	output reg Q
	); 
	
	wire [1:0] IRbits; 
	wire Q_not; 
	reg flag; 
	 
	assign IRbits = BMInIR [22:21]; //op code is for [22:21], they want [20:19]???
	
	always @(*) begin 
		case (IRbits) 
			2'b00:	begin
							flag <= 0;
							if(BusMuxOut == 32'd0) flag <= 1; 
						end
			2'b01:	begin
							flag <= 0;
							if(BusMuxOut != 32'd0) flag <= 1; 
						end
			2'b10:	begin
							flag <= 0;
							if(BusMuxOut[31] == 0) flag <= 1; 
						end
			2'b11:	begin
							flag <= 0;
							if(BusMuxOut[31] == 1) flag <= 1; 
						end	
		endcase
	end 
	
	always @(*)
		begin
			if(CONin) Q <= flag;
		end 
	assign Q_not = !Q; 
						
		
endmodule
	
	
