
module Multiplexer_2x1(
input sel,
input q,
input d,
output reg y
);
    
    always @ (*) begin
     if(sel==1'b0)
         y = q;
     else
         y = d;
     end
    
endmodule
