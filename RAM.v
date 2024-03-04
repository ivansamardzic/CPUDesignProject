module RAM(
    input Read, Write, Clock,
    input [31:0] DataIn, 
    input [8:0] address,
    output [31:0] DataOut
); 

    reg [31:0] ram[0:511];

    initial begin : INIT
		$readmemh("ram.mif", ram); 
	end

    always @(posedge Clock) begin
        if(Write) begin
            ram[address] <= DataIn;
        end
        if(Read) begin
            DataOut <= ram[address];
        end
    end

endmodule 