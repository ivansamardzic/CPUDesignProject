module MAR(
    input wire clear, clock, MARin,
    input wire [31:0] BusMuxOut,
    output wire [8:0] address
);
        reg [8:0] q;
    
        always @(posedge clock) begin
            if(clear) begin
                q <= 9'b0;
            end
            else if (MARin) begin
                q <= BusMuxOut[8:0];
            end
        end
        assign address = q;
endmodule