module TESTBENCH();
  
  reg clock, reset;
  reg [31:0] interrupt_1, interrupt_2;
  
  RISC_PROCESSOR ARM (clock, reset, interrupt_1, interrupt_2);
  
  initial begin
	
	$dumpfile("TESTBENCH.vcd");
	$dumpvars(0, TESTBENCH);    

	clock = 0;
	reset = 0;
	
	#10 	reset <= 1;
	#1500 	interrupt_1 <= 32'b10_00010_0_0000_1111_1011_0000_0000_0101;	//HT
			interrupt_2 <= 32'b10_00100_0_0000_01110_000_0000_0000_0111;	//TS
	#1500	interrupt_1 <= 32'b10_01000_0_0000_1011_0111_0000_0000_0100;	//GD
			interrupt_2 <= 32'b10_10000_0_0000_0011_1000_0000_0000_0100;	//HS
//	#1000	interrupt <= 32'b10_00001_0_0000_0000_1110_0000_0000_0011; 		//USB

  end
 
  initial begin forever #10 clock = ~clock; end
  
  initial #7000 $stop;
  
endmodule
