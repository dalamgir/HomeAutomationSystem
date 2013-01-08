module PROCESSOR (
  interrupt_enable, interrupt_address, interrupt_address_2, interrupt_disable,
  instruction, address, rs_address, rt_address, rd_address, B_Bus,       /* Outputs from the processor module */
  mem_instruction,                                                       /* Inputs from the processor module */  
  load_reg, store_reg, load_mem, store_mem,
  load_pc, load_ir, load_ar, load_wr,
  load_ar_i, load_pc_i, 
  alu_one, alu_zero, alu_enable, load_reg_i, load_rd_i, 
  comp_enable, comp_out,
  increment_pc, shifter_enable, shift_direction,
  select_A_Bus_Mux, select_B_Bus_Mux,
  write_register_out, clock, reset
  );
  
  parameter word_size = 32;
  parameter opcode_size = 4;
  parameter mode_size = 2;
  parameter register_size = 5;
  parameter select_A_Bus_size = 2;
  parameter select_B_Bus_size = 1;
  
  output [word_size-1:0] instruction;       							/* 32 bit instruction that goes to the control block */
  output [word_size-1:0] address;           							/* 32 bit address going from the Address Register to memory */
  output [word_size-1:0] B_Bus;             							/* 32 bit line for the B Bus */
  output [word_size-1:0] write_register_out;
  output alu_one, alu_zero;
  output [word_size-1:0] comp_out;
  
  input [word_size-1:0] mem_instruction;   								/* 32 bit instruction that is loaded from memory */
  input [register_size-1:0] rs_address, rt_address, rd_address;			/* 5 bit lines for the register addresses */
  input load_reg, store_reg;                							/* 1 bit signals for loading and storing to and from registers */
  input load_mem, store_mem, alu_enable;   	 							/* 1 bit signals for loading and storing to and from memory */
  input comp_enable;
  input interrupt_enable, interrupt_disable;
  input [19:0] interrupt_address, interrupt_address_2;
  
  /* A bus and B bus select lines */
  
  input [select_A_Bus_size-1:0] select_A_Bus_Mux;						/* A Bus select line */
  input [select_B_Bus_size-1:0] select_B_Bus_Mux;						/* B Bus select line */
  
  input load_pc, increment_pc;              							/* Signals to load program counter and increment program counter */
  input load_ir, load_ar, load_wr;          							/* Signals to load instruction, address and write registers */
  input shifter_enable, shift_direction;	   							/* Enable bit for the barrel shifter and 1 bit for the shift direction */
  input load_ar_i, load_pc_i, load_reg_i, load_rd_i;
  
  input clock, reset;
  
  // Might need to declare some inputs as wires
  
  wire [word_size-1:0] A_Bus;               							/* 32 Bit line for the A Bus */
  wire [word_size-1:0] rs_data_out, rt_data_out;        				/* 32 Bit line for the register bank output */
  wire [word_size-1:0] pc_count;            							/* 32 Bit line for the output of the program counter */
  wire [word_size-1:0] alu_out;             							/* 32 Bit line for the output of the ALU */
  wire [word_size-1:0] shifter_out;			      						/* 32 Bit line for the output of the Barrel Shifter */
  
  wire [opcode_size-1:0] opcode = instruction[29:26];            		/* 4 Bit line for the opcode */ 
  wire [mode_size-1:0] mode = instruction[31:30];
  
  /* Instantiations of the different modules */
  
  REGISTER_BANK RegisterBank (rs_data_out, rt_data_out, A_Bus, rs_address, rt_address, rd_address, load_reg, load_reg_i, load_rd_i, store_reg, clock, reset);
  
  INSTRUCTION_REGISTER InstructionRegister (instruction, A_Bus, load_ir, clock, reset);
  PROGRAM_COUNTER ProgramCounter (pc_count, A_Bus, load_pc, load_pc_i, increment_pc, alu_one, alu_zero, clock, reset, interrupt_enable, 
										interrupt_address, interrupt_address_2, interrupt_disable);
										
  ADDRESS_REGISTER AddressRegister (address, pc_count, load_ar, load_ar_i, clock, reset);
  
  WRITE_REGISTER WriteRegister (write_register_out, A_Bus, load_wr, clock, reset);
  BARREL_SHIFTER BarrelShifter (shifter_out, shifter_enable, shift_direction, B_Bus); 
  
  COMPARATOR Comparator (comp_out, pc_count, instruction, rs_data_out, shifter_out, comp_enable);
  ALU Alu (alu_out, alu_one, alu_zero, rs_data_out, shifter_out, alu_enable, mode, opcode);
  
  MUX_3CHANNEL Mux_A_Bus(A_Bus, alu_out, mem_instruction, comp_out, select_A_Bus_Mux); 
  MUX_2CHANNEL Mux_B_Bus(B_Bus, rt_data_out, write_register_out, select_B_Bus_Mux);
  
endmodule
