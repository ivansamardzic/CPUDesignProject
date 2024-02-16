module Non_Restoring_32_bit(
    input wire [31:0] Min, 
    input wire [31:0] Qin, 
    output reg [31:0] Quotient,
    output reg [31:0] Remainder); 

    integer i, flagQ, flagM;
    reg [64:0] AQ;
    reg [31:0] M_not;
    reg [31:0] M, Q;	 
	 //Q/M R2/R3
	always @(*) 
        begin	
		  //NEG CASE
		   if(Min[31] && Qin[31])
			begin
				M = -Min;
				M_not = Min; 
				flagM = 1;
				Q = -Qin;
				flagQ = 1;
			end
			else if((Min[31] == 1) && (Qin[31] == 0))
			begin
				M = -Min;
				M_not = Min; 
				flagM = 1;
				flagQ = 0;
				Q = Qin; 
			end 
			else if((Qin[31] == 1) && (Min[31] == 0))
			begin
				M = Min;
				M_not = -Min; 
				flagM = 0;
				Q = -Qin;
				flagQ = 1;
			end 
			else if((Min[31] == 0) && (Qin[31] == 0))
			begin
				M = Min; 
				Q = Qin;
				M_not = -Min;
				flagM = 0;
				flagQ = 0; 
			end
		
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
				
		if(flagQ && flagM)
			Quotient = AQ[31:0];
				
		else if(flagQ || flagM)
			Quotient = -AQ[31:0];
		else
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

