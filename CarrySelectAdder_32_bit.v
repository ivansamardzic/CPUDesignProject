module CarrySelectAdder_32_bit(
    input Cin, 
    input [31:0]a, 
    input [31:0]b, 
    output Cout, 
    output [31:0]sum
    );
    wire [7:0]M; 
    //input Cin is optional, it will most likely be 0

    //cin, a, b, cout, sum 

    CarrySelectAdder_4_bit C1(Cin, a[3:0], b[3:0], M[0], sum[3:0]);
    CarrySelectAdder_4_bit C2(M[0], a[7:4], b[7:4], M[1], sum[7:4]); 
    CarrySelectAdder_4_bit C3(M[1], a[11:8], b[11:8], M[2], sum[11:8]); 
    CarrySelectAdder_4_bit C4(M[2], a[15:12], b[15:12], M[3], sum[15:12]); 

    CarrySelectAdder_4_bit C5(M[3], a[19:16], b[19:16], M[4], sum[19:16]); 
    CarrySelectAdder_4_bit C6(M[4], a[23:20], b[23:20], M[5], sum[23:20]); 
    CarrySelectAdder_4_bit C7(M[5], a[27:24], b[27:24], M[6], sum[27:24]); 
    CarrySelectAdder_4_bit C8(M[6], a[31:28], b[31:28], M[7], sum[31:28]); 
    
    assign Cout = M[7]; 
endmodule
