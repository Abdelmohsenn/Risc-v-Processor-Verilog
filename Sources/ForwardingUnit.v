`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2023 06:05:14 PM
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit(input [4:0] ID_EX_Rs1, ID_EX_Rs2, EX_MEM_Rd, MEM_WB_Rd, input EX_MEM_RegW, MEM_WB_RegW,
output reg [1:0] ForwardA, ForwardB);

always @ (*) begin
    if(EX_MEM_RegW && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs1)) 
    ForwardA = 2'b10; //EX_MEM_ALU_out
    
    else if(MEM_WB_RegW && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs1))
    ForwardA = 2'b01; //MEM_MUX
   
    else  ForwardA = 2'b00; //Reg1
    
    end
always @ (*) begin

    if(EX_MEM_RegW && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs2))
        ForwardB = 2'b10; //EX_MEM_ALU_out
        
    else if(MEM_WB_RegW && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs2) )
        ForwardB = 2'b01; //MEM_MUX
        
    else ForwardB = 2'b00; //Reg2

end



endmodule
