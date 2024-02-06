module ArrayDividerModule(
    input wire bin, 
    input wire a,
    input wire modein,
    input wire cin,

    output wire modeout,
    output wire cout,
    output wire sum,
    output wire bout
    );

    wire tempxor; 

    xor g1(tempxor, modein, bin);
    FullAdder g2(sum, cout, cin, tempxor, a); 
    assign modeout = modein; 
    assign bout = bin; 
    
endmodule
