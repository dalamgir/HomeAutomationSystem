module CONTROL_UNIT(
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
   
   parameter word_size = 32, opcode_size = 4, state_size = 4, mode_size = 2;
   parameter register_size = 5, A_Bus_select_size = 2, B_Bus_select_size = 1;
   
   /* Various State Codes for the Control Unit State Machine */
   
   parameter IDLE = 0, FETCH1 = 1, FETCH2 = 2, DECODE = 3;
   parameter EXECUTE = 4, WRITEBACK = 5, BRANCH = 6, BR_ROUTE1 = 7, BR_ROUTE2 = 8;
   parameter JUMP_RT = 9, JUMP_RT2 = 10;
   parameter HALT = 11;
   
   /* Different Opcodes */
   
   parameter NOP = 0, ADD = 1, SUB = 2, XOR = 8, LW = 4;
   parameter SGT = 5, CMP = 6, MV = 7, SW = 3, LWI = 9;
   parameter BR = 10; 
   
   parameter USER = 0, JUMP = 1, INTERRUPT = 2;
   
   output reg [register_size-1:0] rs_address, rt_address, rd_address;
   output reg load_reg, store_reg, load_mem, store_mem;
   output reg load_pc, load_ir, load_ar, load_wr, increment_pc, shifter_enable, shift_direction, load_ar_i, load_pc_i;
   output reg [A_Bus_select_size-1:0] select_A_Bus_Mux;
   output reg [B_Bus_select_size-1:0] select_B_Bus_Mux;
   output reg alu_enable, load_reg_i, load_rd_i;
   output reg comp_enable;
   
   input [word_size-1:0] instruction;
   input clock, reset;
   output reg interrupt_disable;
   
   reg [state_size-1:0] state, next_state;
   
   wire [opcode_size-1:0] opcode = instruction[29:26];
   wire [mode_size-1:0] mode = instruction[31:30];
   
   always @ (posedge clock or negedge reset) begin: State_transitions
     if (reset == 0) state <= IDLE; else state <= next_state; end
       
   always @ (state or opcode) begin: Output_and_next_state
     
     load_reg <= 0; store_reg <= 0; load_mem <= 0; store_mem <= 0;
     load_pc <= 0; load_ir <= 0; load_ar <= 0; load_wr <= 0; load_reg_i <= 0; load_rd_i <= 0;
     increment_pc <= 0; load_ar_i <= 0; load_pc_i <= 0; alu_enable <=0; interrupt_disable<=0;
     
     case (state) 
     IDLE:     next_state <= FETCH1;
      
     FETCH1:   begin
                  next_state <= FETCH2;
				  interrupt_disable <= 1;
                  load_ar <= 1;
				  load_mem <= 1;
                  select_A_Bus_Mux <= 1;
               end
     FETCH2:   begin
				  next_state <= DECODE;
				  load_ir <= 1;
				  interrupt_disable <= 1;
				  increment_pc <= 1;
			   end
	
     DECODE:   case(mode)
			   USER:	begin case(opcode)
						NOP: next_state <= FETCH1;
						ADD, SUB: begin												/* ADD and SUB instructions rd = rs +/- rt */
									next_state <= EXECUTE;
									load_reg <= 1;
									rs_address <= instruction[25:21];
									rt_address <= instruction[20:16];
									select_B_Bus_Mux <= 0;
									shifter_enable <= 0;
								  end
						MV:	  	  begin												/* Load rt into rs */
									next_state <= FETCH1;
									load_reg_i <= 1;
									rs_address <= instruction[25:21];
									rt_address <= instruction[20:16];
									load_ar <= 1;
									load_mem <= 1;
									select_A_Bus_Mux <= 1;
								  end
						LW:	  	  begin												/* Load rt into rs */
									next_state <= FETCH1;
									load_reg <= 1;
									rs_address <= instruction[25:21];
									load_ar <= 1;
									load_mem <= 1;
									select_A_Bus_Mux <= 1;
								  end
						SW:	  	  begin												/* Load rt into rs */
									next_state <= FETCH1;
									load_reg <= 1;
									rd_address <= instruction[15:11];
									load_ar <= 1;
									store_mem <= 1;
									select_B_Bus_Mux <= 1;
								  end
						LWI:	  begin												/* Load rs with the value in the 21 bit offset */
									next_state <= FETCH1;
									load_rd_i <= 1;
									rd_address <= instruction[25:21];
									load_ar <= 1;
									load_mem <= 1;
									select_A_Bus_Mux <= 1;
								  end
						BR:		  begin 											/* Branch to the address specified in the offset */
									next_state <= BRANCH;
									load_pc_i <= 1;
									select_A_Bus_Mux <= 1;
								  end
						endcase
						end
				JUMP:	begin
							next_state <= JUMP_RT;
							load_reg <= 1;
							rs_address <= instruction[29:25];
							rt_address <= instruction[24:20];
							select_B_Bus_Mux <= 0;
							shifter_enable <= 0;
						end
				endcase
     EXECUTE:  	begin
                  next_state <= WRITEBACK;
				  rd_address <= instruction[15:11];					
				  alu_enable <= 1;
				  load_ar <= 1;
				  load_mem <= 1;
				  select_A_Bus_Mux <= 1;
				end
	 BRANCH:	begin
				   next_state <= BR_ROUTE1;
                   load_ar_i <= 1;
				   load_mem <= 1;
                   select_A_Bus_Mux <= 1;
				end
	 BR_ROUTE1:	begin
				   next_state <= BR_ROUTE2;
				   load_ir <= 1;
				   load_mem <= 1;
                   select_A_Bus_Mux <= 1;
				end
	 BR_ROUTE2:	begin
				   next_state <= DECODE;
				   load_ir <= 1;
				   increment_pc <= 1;
				end
	 JUMP_RT:	begin
				next_state <= JUMP_RT2;
				comp_enable <= 1;
				end
	 JUMP_RT2:	begin
				next_state <= BRANCH;
				select_A_Bus_Mux <= 2;
				load_pc_i <= 1;
				end
	 WRITEBACK:	begin
				   next_state <= FETCH1;
				   store_reg <= 1;
				   select_A_Bus_Mux <= 0;
				   
				end
	 HALT:	   	next_state <= HALT;
     endcase
    end
 endmodule