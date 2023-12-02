`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Nbit_Mux.v
* Project: Single Cycle RISC-V processor
* Description: this module is for a normal nbit multiplexer, it uses a 1 bit mux as a submodule
*
* Change history: 
*    10/29/23 - imported
*
**********************************************************************/



module Nbit_Mux #(parameter n = 8) (
input sel, 
input [n-1:0] q,
input [n-1:0] d,
output [n-1:0] y);

genvar i;
generate

for(i = 0; i < n; i=i+1)begin
 Multiplexer_2x1 obj(sel, q[i], d[i],y[i]);

end
endgenerate

endmodule