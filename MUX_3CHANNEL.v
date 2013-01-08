module MUX_3CHANNEL (mux_out, data_a, data_b, data_c, select);
  
  parameter word_size = 32;
  
  output [word_size-1:0] mux_out;
  
  input [word_size-1:0] data_a, data_b, data_c;
  input [1:0] select;
  
  assign mux_out = (select == 0) ? data_a : (select == 1) ? data_b : (select == 2) ? data_c : 32'bx;
  
endmodule