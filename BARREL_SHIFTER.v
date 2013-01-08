module BARREL_SHIFTER(shifter_out, shifter_enable, shift_direction, data_1);
  
  parameter word_size = 32;                       /* Size of an instruction */
  parameter LEFT = 1;
  parameter RIGHT = 0;
    
  input shift_direction;                          /* Specifies direction of the shift, 1 for left shift and 0 for right */
  input shifter_enable;                           /* Signal used to activate the barrel shifter */
  input [word_size-1:0] data_1;                   /* The data to be shifted, which can be from the registers or immediate */
  
  output reg [word_size-1:0] shifter_out;         /* The output result after a specified shift either left or right */  
  
  always @ (*)
  if (shifter_enable)
    begin
      case(shift_direction)
      LEFT: shifter_out = data_1 << 1;
      RIGHT: shifter_out = data_1 >> 1;
      default: shifter_out = data_1;
    endcase
    end
  else
    shifter_out = data_1;
endmodule