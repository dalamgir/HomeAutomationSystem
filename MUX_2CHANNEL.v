module MUX_2CHANNEL (mux_out, data_a, data_b, select);
  
  parameter word_size = 32;
  
  output [word_size-1:0] mux_out;
  
  input [word_size-1:0] data_a, data_b;
  input select;
  
  assign mux_out = (select == 0) ? data_a : (select == 1) ? data_b : 'bx;
  
endmodule
