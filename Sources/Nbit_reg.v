`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Nbit_reg.v
* Project: Single Cycle RISC-V processor
* Description: this module mimics how a register works
*
* Change history: 
*   10/29/23 - imported
*
**********************************************************************/


module Nbit_reg#(parameter N=32)( input clk, input rst, input load, input [N-1:0] D, output [N-1:0] Q );
    
    genvar i;
    wire [N-1:0] val;
    
generate 


for(i = 0; i < N; i = i + 1) begin
    Nbit_Mux #(32) mux(load, Q[i], D[i], val[i]);
    DFlipFlop obj(clk, rst, val[i], Q[i]);
  end
endgenerate

endmodule
