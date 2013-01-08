module PROGRAM_COUNTER(count, data_in, load_pc, load_pc_i, increment_pc, alu_one, alu_zero, clock, reset, interrupt_enable, interrupt_address, interrupt_address_2, interrupt_disable);
  
  parameter word_size = 32;
  
  output reg [word_size-1:0] count;
  output reg alu_zero;
  
  input [word_size-1:0] data_in;
  input load_pc, increment_pc, clock, reset, load_pc_i;
  input alu_one;
  
  input interrupt_enable, interrupt_disable;
  input [19:0] interrupt_address, interrupt_address_2;
  
  reg [word_size-1:0] SPSR;
  
  integer toggle = 1;
  integer toggle2 = 1;
  integer first_run=1;
  
  always @ (posedge clock or negedge reset)
  begin
    if (reset == 0) count <= 0;
	else if (alu_one) begin count <= data_in[19:0]; alu_zero = 1; end
	else if (load_pc_i) 
	begin 
		if(toggle ==0)
		begin
				
				count <=interrupt_address_2; 
				alu_zero <= 0;
				toggle <= 1;
				toggle2<=0;
				first_run<=0;
		end
		
		else
		begin
			count <= data_in[19:0]; 
			alu_zero = 0; 
		end
	end
    else if (load_pc) begin count <= data_in; alu_zero = 0; end
    else if (increment_pc) 
	begin 
		if (interrupt_disable ==0 && count == 32'd20)
			begin
			if(toggle2 == 0)
			count <= SPSR;
			else
			begin
			count<=count;
			end
			alu_zero <= 0;
			end
		
		else begin  count <= count + 1; alu_zero <= 0; end 
	end
	else if (interrupt_enable) 
	begin
		if (toggle == 1)
		begin 
			SPSR <= count;
			count <= interrupt_address; 
			alu_zero <= 0;
			toggle <= 0;
		end
	end
  end
  
endmodule