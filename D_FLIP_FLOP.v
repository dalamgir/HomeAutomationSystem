module D_FLIP_FLOP (data_out, data_in, load, clock, reset);
 
  output reg data_out;
  
  input data_in;
  input load, clock, reset;
  
  always @ (posedge clock or negedge reset)
    if (reset == 0) data_out <= 0;
    else if (load) data_out <= data_in;
      
endmodule