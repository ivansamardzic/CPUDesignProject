module RAM(
    input Read, Write, clock,
    input wire [31:0] DataIn, 
    input wire [8:0] address,
    output wire [31:0] DataOut
); 

    reg [31:0] ram[0:511];
	 reg [31:0] temp;

    initial begin
	    $readmemh("C:/Users/QueensWin10x64/Documents/PersonalProjects/CPUDesignProject/ram.mem", ram); 
	end

    always @(posedge clock) begin
        if(Write) begin
            ram[address] <= DataIn;
        end
        if(Read) begin
            temp <= ram[address];
        end
		  //temp <= ram[0];
    end
	 
	 assign DataOut = temp;

	 
endmodule

