module INTERRUPT_REGISTERS(ir_data_out, ir_data_in, ir_address, load, store, clock, reset);
  
  parameter word_size = 32;
  parameter reg_address_size = 5;
  parameter total_registers = 5;
  
  output reg [word_size-1:0] ir_data_out;
  
  input [word_size-1:0] ir_data_in;
  input [reg_address_size-1:0] ir_address;
  input load, store, clock, reset;
  
  reg [word_size-1:0] InterruptRegisters [total_registers-1:0];
  integer index;
   
  initial begin 
    for (index = 0; index < total_registers ; index = index + 1) InterruptRegisters[index] = 0; 
  end
  
  always @ (posedge clock or load or reset or store)
    if (reset == 0) ir_data_out <= 0;
    else if (load) ir_data_out <= InterruptRegisters[ir_address];
	else if (store) InterruptRegisters[ir_address] <= ir_data_in;
    
endmodule 
