/*******************************************************************
*
* Module: ALU_ControlUnit.v
* Project: Single Cycle RISC-V processor
* Description: this module manages the control signals that determine the ALU functionality for the curr instruction
*
* Change history: 
*    11/02/23 - added signals for i and r instructions
*    11/04/23 - added lui and its signals
*
**********************************************************************/

module ALU_ControlUnit(input [2:0] ALUOp, input [2:0] inst14_12, input inst30, input bit25,
output reg [3:0] ALU_select, output reg signe, output reg [1:0] mul_op);

    always @ (*) begin
        case(ALUOp)
            
            3'b101: ALU_select = 4'b0010; //lui
            3'b000: ALU_select = 4'b0000; //add
            3'b001: ALU_select = 4'b0001; //sub
            
            3'b010: //r format
            begin
                case(bit25) 
                    1'b0: begin    
                    case({inst14_12, inst30})
                        4'b0000: ALU_select = 4'b0000; //add
                        4'b0001: ALU_select = 4'b0001; //sub
                        4'b1110: ALU_select = 4'b0101; //AND
                        4'b1100: ALU_select = 4'b0100; //OR
                        4'b1000: ALU_select = 4'b0111; //XOR
                        4'b1010: ALU_select = 4'b1000; //SRL
                        4'b1011: ALU_select = 4'b1010; //SRA
                        4'b0010: ALU_select = 4'b1001; //SLL
                        4'b0100: ALU_select = 4'b1101; //SLT
                        4'b0110: ALU_select = 4'b1111; //SLTU
                        endcase
                        end
                   1'b1: begin
                   case(inst14_12)
                        3'b000:  begin ALU_select = 4'b1011; mul_op = 2'b00; end //mul
                        3'b001:  begin ALU_select = 4'b1011; mul_op = 2'b01; end  //mulh
                        3'b010:  begin ALU_select = 4'b1011; mul_op = 2'b10; end  //mulhsu
                        3'b011:  begin ALU_select = 4'b1011; mul_op = 2'b11; end  //mulhu
                        3'b100:  begin ALU_select = 4'b0011; signe = 1'b0; end  //div
                        3'b101:  begin ALU_select = 4'b0011; signe = 1'b1; end  //divu
                        3'b110:  begin ALU_select = 4'b0110; signe = 1'b0; end   //rem
                        3'b111:  begin ALU_select = 4'b0110; signe = 1'b1; end  //remu
 
                   
                        endcase
                   end               
                endcase
            end
            3'b011:
            begin
                case({inst14_12})
                    3'b000: ALU_select = 4'b0000; //addi
                    3'b111: ALU_select = 4'b0101; //ANDi
                    3'b110: ALU_select = 4'b0100; //ORi
                    3'b100: ALU_select = 4'b0111; //XORi
                    3'b010: ALU_select = 4'b1101; //SLTI
                    3'b011: ALU_select = 4'b1111; //SLTIU
                    3'b001: ALU_select = 4'b1001; //SLLI
                    3'b101: begin
                        case(inst30)
                            1'b0: ALU_select = 4'b1000; //SRLI
                            1'b1: ALU_select = 4'b1010; //SRAI
                        endcase
                        end
                endcase
            end
        endcase
    end


endmodule
