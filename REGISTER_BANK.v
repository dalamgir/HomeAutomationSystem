module REGISTER_BANK(rs_data_out, rt_data_out, data_in, rs_address, rt_address, rd_address, load, load_reg_i, load_rd_i, store, clock, reset);
  
  parameter word_size = 32;
  parameter reg_address_size = 5;
  parameter total_registers = 32;
  
  output reg [word_size-1:0] rs_data_out, rt_data_out;
  
  input [word_size-1:0] data_in;
  input [reg_address_size-1:0] rs_address, rt_address, rd_address;
  input load, store, clock, reset, load_reg_i, load_rd_i;
  
  reg [word_size-1:0] RegisterBank [total_registers-1:0];
  integer index;
   
  initial begin 
    for (index = 0; index < total_registers ; index = index + 1) RegisterBank[index] = 0; 
  end
  
  always @ (posedge clock or load or reset or store)
    if (reset == 0) begin rs_data_out <= 0; rt_data_out <= 0; end  
    else if (load) begin rs_data_out <= RegisterBank[rs_address]; rt_data_out <= RegisterBank[rt_address]; end  
	else if (store) RegisterBank[rd_address] <= data_in;
	else if (load_reg_i) RegisterBank[rs_address] <= RegisterBank[rt_address];
	else if (load_rd_i) RegisterBank[rd_address] <= data_in[19:0];

endmodule 