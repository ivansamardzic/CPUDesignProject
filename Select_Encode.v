module Select_Encode (
	input wire [31:0] BMInIR, 
	input wire Gra, Grb, Grc, Rin, Rout, BAout, 
	
	output reg [15:0] IN, OUT, 
	output [31:0] C_sign_extended
	);
	
	wire [3:0] Ra, Rb, Rc;  
	wire [4:0] Opcode; 
	
	wire [3:0] Gra_and, Grb_and, Grc_and, enc_sel;
	 
	
	assign C_sign_extended = {{13{BMInIR[18]}},BMInIR[18:0]};
	assign Opcode[4:0] = BMInIR[31:27]; 
	assign Ra = BMInIR[26:23];
	assign Rb = BMInIR[22:19];
	assign Rc = BMInIR[18:15]; 
	
//	and g1(Gra_and, Gra, Ra); 
//	and g2(Grb_and, Grb, Rb);
//	and g3(Grc_and, Grc, Rc); 	
//	or g4(enc_sel, Gra_and, Grb_and, Grc_and); 
	assign Gra_and = Gra & Ra;
	assign Grb_and = Grb & Rb;
	assign Grc_and = Grc & Rc;
	assign enc_sel1 = Gra_and | Grb_and | Grc_and;
	
	
	//4 to 16 decoder
	always @(*) begin 
		case(enc_sel)
			4'b0000:	begin
					if(Rin) IN <= 16'h0001; 
					if(Rout | BAout) OUT <= 16'h0001; 
				end
			4'b0001:	begin
					if(Rin) IN <= 16'h0002; 
					if(Rout | BAout) OUT <= 16'h0002; 
				end 
			4'b0010:	begin
					if(Rin) IN <= 16'h0004; 
					if(Rout | BAout) OUT <= 16'h0004; 
				end 
			4'b0011:	begin
					if(Rin) IN <= 16'h0008; 
					if(Rout | BAout) OUT <= 16'h0008; 
				end 
			4'b0100:	begin
					if(Rin) IN <= 16'h0010; 
					if(Rout | BAout) OUT <= 16'h0010; 
				end 
			4'b0101:	begin
					if(Rin) IN <= 16'h0020; 
					if(Rout | BAout) OUT <= 16'h0020; 
				end 	
			4'b0110:	begin
					if(Rin) IN <= 16'h0040; 
					if(Rout | BAout) OUT <= 16'h0040;
				end 
			4'b0111:	begin
					if(Rin) IN <= 16'h0080; 
					if(Rout | BAout) OUT <= 16'h0080;
				end 
			4'b1000:	begin
					if(Rin) IN <= 16'h0100; 
					if(Rout | BAout) OUT <= 16'h0100; 
				end 
			4'b1001:	begin
					if(Rin) IN <= 16'h0200; 
					if(Rout | BAout) OUT <= 16'h0200; 
				end 
			4'b1010:	begin
					if(Rin) IN <= 16'h0400; 
					if(Rout | BAout) OUT <= 16'h0400; 
				end 
			4'b1011:	begin
					if(Rin) IN <= 16'h0800; 
					if(Rout | BAout) OUT <= 16'h0800; 
				end 
			4'b1100:	begin
					if(Rin) IN <= 16'h1000; 
					if(Rout | BAout) OUT <= 16'h1000;  
				end 	
			4'b1101:	begin
					if(Rin) IN <= 16'h2000; 
					if(Rout | BAout) OUT <= 16'h2000; 
				end 
			4'b1110:	begin
					if(Rin) IN <= 16'h4000; 
					if(Rout | BAout) OUT <= 16'h4000; 
				end 
			4'b1111:	begin
					if(Rin) IN <= 16'h8000; 
					if(Rout | BAout) OUT <= 16'h8000; 
				end 
		endcase
	end 
	
	
endmodule 
		
