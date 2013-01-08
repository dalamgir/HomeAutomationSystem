module ADDRESS_REGISTER(data_out, data_in, load, load_ar_i, clock, reset);
  
  parameter word_size = 32;
  
  output reg [word_size-1:0] data_out;
  
  input [word_size-1:0] data_in;
  input load, clock, reset, load_ar_i;
  
  always @ (posedge clock or negedge reset)
    if (reset == 0) data_out <= 0;
	else if (load_ar_i) data_out <= data_in[19:0]; 
    else if (load) data_out <= data_in;
    
endmodule