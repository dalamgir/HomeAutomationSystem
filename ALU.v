module ALU (alu_out, alu_one, alu_zero, data_1, data_2, alu_enable, mode, opcode);
  
  parameter word_size = 32;        /* size of an instruction */
  parameter opcode_size = 4;       /* size of the incoming opcode */
  parameter mode_size = 2;
  
  /* Various opcodes used for the instruction set */
  
  parameter NOP = 4'b0000;         /* No instruction performed */
  parameter ADD = 4'b0001;         /* Add the contents of two registers */ 
  parameter SUB = 4'b0010;         /* Subtract the contents of two registers */ 
  parameter XOR = 4'b0011;         /* Exclusive OR operation on the two register values */ 
  parameter XNOR = 4'b0100;        /* Exclusive NOR operation on the two register values */ 
  parameter SGT = 4'b0101;         /* Set Greater Than instruction sets alu_out = 1 if true */
  parameter CMP = 4'b0110;         /* Compare instruction sets alu_out = 1 if true */ 
  
  parameter USER = 0, JUMP = 1;
  output reg [word_size-1:0] alu_out;
  output reg alu_one;
  
  input [word_size-1:0] data_1, data_2;
  input [opcode_size-1:0] opcode; 
  input [mode_size-1:0] mode;
  input alu_zero;
  input alu_enable;
  
  always @ (opcode or data_1 or data_2 or mode or alu_zero or alu_enable)
  if (alu_enable)
  begin
  case(mode)
	USER: 	begin
			case(opcode)
				NOP: alu_out = 0; 
				ADD: alu_out = data_1 + data_2; 
				SUB: alu_out = data_2 - data_1; 
				XOR: alu_out = (data_1 ^ data_2); 
				XNOR: alu_out = (data_1 ~^ data_2);  
				SGT: if (data_1 > data_2) alu_out = 1; else alu_out = 0; 
				default: alu_out = 0;
			endcase
			alu_one = 0;
			end		
	JUMP:	if (data_1 == data_2) begin alu_one = 1; end else alu_one = 0;
  endcase
  if (alu_zero == 1) alu_one = 0;
  end
endmodule
