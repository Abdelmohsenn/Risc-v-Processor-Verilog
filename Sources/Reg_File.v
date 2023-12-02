/*******************************************************************
*
* Module: Reg_File.v
* Project: Single Cycle RISC-V processor
* Description: this module imitates how the register file work in a processor, having the reg as a submodule
*
* Change history: 
* 10/29/23: - imported

**********************************************************************/

module Reg_File #(parameter n = 32) (input clk, input RegWrite, input [4:0] reg1, input [4:0] reg2, input [4:0] regW,  
input [n-1:0] data, input reset, output [n-1:0] readData1, output [n-1:0] readData2);
    
    reg [n-1:0] registers[31:0];
        integer i;

    always @ (posedge clk) begin
    if(reset == 1'b0) begin
        if(RegWrite == 1'b1 && regW != 0) registers[regW] <= data;
   
        end else if(reset == 1'b1) begin
             for(i = 0; i < n; i=i+1) begin
              registers[i] <= 32'b0;
             end
        end    
    end
        
 assign readData1 = registers[reg1];
 assign readData2 = registers[reg2];   
    
endmodule
