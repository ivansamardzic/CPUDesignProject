module Non_Restoring_32_bit(
    input reg [31:0] M, 
    input reg [31:0] Q, 
    output reg [31:0] Quotient,
    output reg [31:0] Remainder); 

    integer i; 
    intger Qbit = $bits(Q); 

    always @(*) 
        begin
            for(i = 0; i < Qbit; i++)
                begin
                    Q = Q << 1; 
                    if (Q[Qbit*2] == 0) 
                        Q = Q - (M << Qbit); 
                    else 
                        Q = Q + (M << Qbit); 
                    
                    if (Q[Qbit*2] == 0)
                        Q[0] = 1;
                    else
                        Q[0] = 0;
                end 
            Quotient = Q[Qbit - 1:0];

            if(Q[bit*2] == 1)
                begin
                    Q = Q + (M << Qbit);
                    Remainder = Q >> Qbit;
                end 
            else
                Remainder = Q >> Qbit;
        end
endmodule 
