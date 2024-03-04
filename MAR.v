module MAR(
    input wire Clear, Clock, MARIn,
    input wire [31:0] BusMuxOut,
    output wire [8:0] address
);
    
        reg [8:0] q;
    
        always @(posedge Clock) begin
            if(Clear) begin
                q <= 9'b0;
            end
            else if (MARIn) begin
                q <= BusMuxOut[8:0];
            end
        end
        assign address = q;
endmodule