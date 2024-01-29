module Mux_2_to_1 (output c, input a, b, select);
  wire w1, w2, w3; 
  not g1(w1, select);
  and g2(w2, w1, a); 
  and g3(w3, select, b);
  or g4(c, w2, w3); 
endmodule 
