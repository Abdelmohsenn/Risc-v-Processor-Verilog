`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2023 11:43:23 AM
// Design Name: 
// Module Name: main
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


//
module main(input clock, input reset, input [1:0] ledSel, 
input [3:0] ssdSel, input ssdClock, output [15:0] leds,
 output [3:0] anode, output [6:0] LED_out);

wire [12:0] ssd;

DataPath inst(clock, reset, ledSel, ssdSel, ssdClock, leds, ssd);
Four_Digit_Seven_Segment_Driver_Optimized ssg(ssdClock, ssd, anode, LED_out);

endmodule
