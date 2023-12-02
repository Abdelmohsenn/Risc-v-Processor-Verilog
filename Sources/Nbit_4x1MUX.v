`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2023 12:41:43 AM
// Design Name: 
// Module Name: Nbit_4x1MUX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Nbit_4x1MUX #(parameter n=32) (input [1:0] sel, input [n-1:0] a, input [n-1:0] b, input [n-1:0] c, input [n-1:0] d,
output reg [n-1:0] out );

always @ (*) begin
case(sel)
2'b00: out = a;
2'b01: out = b;
2'b10: out = c;
2'b11: out = d;
default: out = a; 

endcase
end

endmodule