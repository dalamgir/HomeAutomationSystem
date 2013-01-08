module INTERRUPT_PRIORITY_ENCODER(interrupt_1, interrupt_2, interrupt_enable, interrupt_disable, interrupt_address, interrupt_address_2);

	parameter word_size = 32;
	parameter total_interrupt_registers = 2;
	
    input [word_size-1:0] interrupt_1, interrupt_2;    					/* Interrupt Instruction */
    output reg [19:0] interrupt_address, interrupt_address_2;
	output reg interrupt_enable;
	
	input interrupt_disable;
	
	reg [word_size-1:0] InterruptRegister [total_interrupt_registers-1:0];
	integer index;
   
	initial begin 
		for (index = 0; index < total_interrupt_registers ; index = index + 1) InterruptRegister[index] = 0; 
	end
	
	always @ (interrupt_1 or interrupt_2)
	if ((interrupt_1[31:30] == 2'b10) || (interrupt_2[31:30] == 2'b10))
	begin	
		if (interrupt_1[29:25] > interrupt_2[29:25]) 
		begin
			InterruptRegister[0] <= interrupt_1[19:0];
			InterruptRegister[1] <= interrupt_2[19:0];
			interrupt_address <= interrupt_1[19:0];
			interrupt_address_2 <= interrupt_2[19:0];
			interrupt_enable <= 1;
		end
		else if (interrupt_2[29:25] > interrupt_1[29:25])
		begin
			InterruptRegister[0] <= interrupt_1[19:0];
			InterruptRegister[1] <= interrupt_2[19:0];	
			interrupt_address <= interrupt_2[19:0];
			interrupt_address_2 <= interrupt_1[19:0];
			interrupt_enable <= 1;
		end
		else
		begin
				interrupt_address <= 0;
				interrupt_enable <= 0;
		end
	end
	
	always @ (interrupt_disable)
	begin
		interrupt_enable = 0;
	end

endmodule
