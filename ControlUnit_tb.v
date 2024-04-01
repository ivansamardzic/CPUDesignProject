`timescale 1ns/10ps
module ControlUnit_tb;

	reg clock, reset, stop;
	reg [31:0] INPUT_UNIT;
	wire [31:0] OUTPUT_UNIT;
	
	DataPath DUT(.clock(clock), .reset(reset), .stop(stop), .INPUT_UNIT(INPUT_UNIT), .OUTPUT_UNIT(OUTPUT_UNIT));
						
    initial
		begin
		    clock = 0;
			 INPUT_UNIT = 32'h80;
		forever #10 clock = ~ clock;
		end

endmodule
	