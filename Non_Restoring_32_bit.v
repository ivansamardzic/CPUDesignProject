module Non_Restoring_32_bit(
    input wire [31:0] M, 
    input wire [31:0] Q, 
    output reg [31:0] Quotient,
    output reg [31:0] Remainder); 

    integer i;
    reg [64:0] AQ;
	  
	 wire [31:0] M_not; 
    assign M_not = ~M + 1'b1;
	 //Q/W R2/R3
	 
	 
	 always @(*) 
        begin	
		  AQ = {33'b0, Q}; 
            for(i = 0; i < 32; i = i + 1)
                begin
						
                    AQ = AQ << 1; 
						
                    	 ////shift 
                    if (AQ[63] == 1) 
								begin
                        AQ = {AQ[64:32] + M, AQ[31:0]};
								end 
                    else 
								begin
								AQ = {AQ[64:32] + M_not, AQ[31:0]};
								end
   
                    //q0
                    if (AQ[63] == 1)
								AQ[0] = 0;
						  else 
								AQ = AQ + 1;
                end 
            Quotient = AQ[31:0];

            if(AQ[63] == 1)
                begin
                    AQ = {AQ[64:32] + M, AQ[31:0]};
                    Remainder = AQ[64:32];
                end 
            else
				Remainder = AQ[64:32];
        end
endmodule 

