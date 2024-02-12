module Non_Restoring_32_bit(
    input reg [31:0] M, 
    input reg [31:0] Q, 
    output reg [31:0] Quotient,
    output reg [31:0] Remainder); 

    integer i; 
    integer Qbit = $bits(Q); 

    reg [31:0] t_Q; 
    reg [31:0] A = 32'b0; 

    always @(*) 
        begin
        t_Q = Q; 
            for(i = 0; i < Qbit; i++)
                begin
                    A = A << 1; 
                    A[0] = t_Q[Qbit-1]; 
                    t_Q = t_Q << 1; 
                    //shift 
                    if (A >= 0) 
                        A = A - M; 
                    else 
                        A = A + M; 
                    //q0
                    if (A >= 0)
                        t_Q[0] = 1;
                    else
                        t_Q[0] = 0;
                end 
            Quotient = 32'b0 | t_Q[Qbit - 1:0];

            if(A < 0)
                begin
                    A = A + M;
                    Remainder = A;
                end 
            else
                Remainder = A;
        end
endmodule 
