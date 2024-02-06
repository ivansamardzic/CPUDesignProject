module Non_Restoring_32_bit(
    input reg [31:0] M, 
    input reg [31:0] Q, 
    output reg [31:0] Quotient,
    output reg [31:0] Remainder); 

    integer i; 
    integer Qbit = $bits(Q); 

    reg [31:0] t_Q; 

    always @(*) 
        begin
        t_Q = Q; 
            for(i = 0; i < Qbit; i++)
                begin
                    t_Q = t_Q << 1; 
                    if (t_Q[Qbit * 2] == 0) 
                        t_Q = t_Q - (M << Qbit); 
                    else 
                        t_Q = t_Q + (M << Qbit); 
                    
                    if (t_Q[Qbit * 2] == 0)
                        t_Q[0] = 1;
                    else
                        t_Q[0] = 0;
                end 
            Quotient = t_Q[Qbit - 1:0];

            if(Q[Qbit * 2] == 1)
                begin
                    t_Q = t_Q + (M << Qbit);
                    Remainder = t_Q >> Qbit;
                end 
            else
                Remainder = t_Q >> Qbit;
        end
endmodule 
