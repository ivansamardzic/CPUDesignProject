module RAM(
    input Read, Write, Clock,
    input wire [31:0] DataIn, 
    input wire [8:0] address,
    output wire [31:0] DataOut
); 

    reg [31:0] ram[511:0];
	 reg [31:0] temp;

    initial begin : INIT
		$readmemh("ram.mif", ram); 
	end

    always @(posedge Clock) begin
        if(Write) begin
            ram[address] <= DataIn;
        end
        if(Read) begin
            temp <= ram[address];
        end
    end
	 
	 assign DataOut = temp;

	 
endmodule

