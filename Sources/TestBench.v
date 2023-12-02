`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2023 06:30:37 PM
// Design Name: 
// Module Name: tb_lab0601
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


module tb_lab0601;

    parameter t=10;
    reg clk;
    reg reset, SSD_Clock;
    wire [15:0] leds;
    wire [12:0] ssd;
    reg [1:0] ledSel;
    reg [3:0] ssdSel;

    initial begin
        clk =1'b0;
        forever begin
            #(t/2) clk=~clk;
        end
    end

    initial begin
        reset = 1'b1;
        #(t)
        reset = 1'b0;
        #(t)

        ledSel = 2'b00;
        ssdSel = 4'b0000;
        #(t)

        ledSel = 2'b01;
        ssdSel = 4'b0001;
        #(t)

        ledSel = 2'b10;
        ssdSel = 4'b0010;
        #(t)

        ssdSel = 4'b0011;
        #(t)

        ssdSel = 4'b0100;
        #(t);

        ssdSel = 4'b0101;
        #(t);

        ssdSel = 4'b0110;
        #(t);

        ssdSel = 4'b0111;
        #(t);

        ssdSel = 4'b1000;
        #(t);

        ssdSel = 4'b1001;
        #(t);

        ssdSel = 4'b1010;
        #(t);

        ssdSel = 4'b1011;
        #(t);


    end

    DataPath Full(clk, reset, ledSel, ssdSel, SSD_Clock, leds, ssd);

endmodule
