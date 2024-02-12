module CarrySelectAdder_4_bit(
    input Cin, 
    input [3:0]a, 
    input [3:0]b, 
    output Cout, 
    output [3:0]sum
    );
    wire [3:0]S0, S1, C0, C1;

    //sum, c_out, c_in, a, b
    FullAdder F1(S0[0], C0[0], 1'b0, a[0], b[0]);
    FullAdder F2(S0[1], C0[1], C0[0], a[1], b[1]);
    FullAdder F3(S0[2], C0[2], C0[1], a[2], b[2]);
    FullAdder F4(S0[3], C0[3], C0[2], a[3], b[3]);

    FullAdder F5(S1[0], C1[0], 1'b1, a[0], b[0]);
    FullAdder F6(S1[1], C1[1], C1[0], a[1], b[1]);
    FullAdder F7(S1[2], C1[2], C1[1], a[2], b[2]);
    FullAdder F8(S1[3], C1[3], C1[2], a[3], b[3]);

    //c, a0, b1, select
    Mux_2_to_1 M1(sum[0], S0[0], S1[0], Cin);
    Mux_2_to_1 M2(sum[1], S0[1], S1[1], Cin);
    Mux_2_to_1 M3(sum[2], S0[2], S1[2], Cin);
    Mux_2_to_1 M4(sum[3], S0[3], S1[3], Cin);

    Mux_2_to_1 M5(Cout, C0[3], C1[3], Cin);
endmodule
