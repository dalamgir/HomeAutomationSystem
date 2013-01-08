module RISC_PROCESSOR (clock, reset, interrupt_1, interrupt_2);
  
  parameter word_size = 32;
  parameter select_size = 1;
  parameter select_size_A = 2;
  parameter register_size = 5;
  
  input clock, reset;
  
  wire load_reg, store_reg, load_mem, store_mem, load_pc, load_ir, load_ar, load_wr, increment_pc, load_pc_i, load_ar_i; 
  wire shifter_enable, shift_direction;
  wire [select_size_A-1:0] select_A_Bus_Mux; 
  wire [select_size-1:0] select_B_Bus_Mux;
  wire [register_size-1:0] rs_address, rt_address, rd_address;
  wire [word_size-1:0] address, B_Bus, write_register_out, instruction, mem_instruction;
  wire alu_one, alu_zero, alu_enable, load_reg_i, load_rd_i, comp_enable;
  wire [word_size-1:0] comp_out;
  
  input [word_size-1:0] interrupt_1, interrupt_2;
  wire [19:0] interrupt_address, interrupt_address_2;
  wire interrupt_enable, interrupt_disable;
  
  INTERRUPT_PRIORITY_ENCODER PriorityEncoderUnit(interrupt_1, interrupt_2, interrupt_enable, interrupt_disable, interrupt_address, interrupt_address_2);
  
  CONTROL_UNIT ControlUnit (
   interrupt_disable,
   rs_address, rt_address, rd_address, 
   load_reg, store_reg,
   load_mem, store_mem, 
   load_pc, load_ir, load_ar, load_wr, shifter_enable, shift_direction,
   load_ar_i, load_pc_i,
   comp_enable,
   alu_enable, load_reg_i, load_rd_i,
   increment_pc, select_A_Bus_Mux, select_B_Bus_Mux, 
   instruction, clock, reset);
  
  PROCESSOR ProcessorUnit (
   interrupt_enable, interrupt_address, interrupt_address_2, interrupt_disable,
   instruction, address, rs_address, rt_address, rd_address, B_Bus,      		      
   mem_instruction,                          
   load_reg, store_reg, load_mem, store_mem,
   load_pc, load_ir, load_ar, load_wr,
   load_ar_i, load_pc_i,
   alu_one, alu_zero, alu_enable, load_reg_i, load_rd_i,
   comp_enable, comp_out,
   increment_pc, shifter_enable, shift_direction,
   select_A_Bus_Mux, select_B_Bus_Mux,
   write_register_out, clock, reset);
  
  MEMORY MemoryUnit(
   .i_address(interrupt_address),
   .i_enable(interrupt_enable),
   .data_out(mem_instruction),
   .data_in (B_Bus),
   .address (address),
   .load(load_mem),
   .store(store_mem),
   .clock(clock) );
  
endmodule
