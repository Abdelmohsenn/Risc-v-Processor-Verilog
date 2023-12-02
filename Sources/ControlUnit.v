/*******************************************************************
 *
 * Module: ControlUnit.v
 * Project: Single Cycle RISC-V processor
 * Description: this module manages the control signals the processor needs based on the instruction's opcode
 *
 * Change history: 
 *  11/02/23 - changed the ALU_OP to 3 bits to accomodate the instructions
 *  11/04/23 - added lui and its signals
 *
 **********************************************************************/
module ControlUnit(input [4:0] instruction, output reg branch, output reg MemRead, output reg MemtoReg,
    output reg [2:0] ALUOp,output reg MemWrite, output reg ALUSrc, output reg RegWrite);

    always @ (*) begin
        case(instruction)
        
            5'b00000: begin //load
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                MemWrite = 1'b0;
                ALUOp = 3'b000;
                MemtoReg = 1'b1;
                MemRead = 1'b1;
                branch = 1'b0;
            end

             5'b00011: begin // FENCE
                RegWrite = 1'b0;
                ALUSrc = 1'b0; //takes the immediate
                MemWrite = 1'b0;
                ALUOp = 3'b000; //doesn't matter
                MemtoReg = 1'b0;
                MemRead = 1'b0;
                branch = 1'b0;
            end

            5'b01000: begin //stores
                RegWrite = 1'b0;
                ALUSrc = 1'b1;
                MemWrite = 1'b1;
                ALUOp = 3'b000;
                MemRead = 1'b0;
                MemtoReg = 1'b0; // added this
                branch = 1'b0;
            end
         5'b11100: begin // ECALL
                RegWrite = 1'b0;
                ALUSrc = 1'b0; //takes the immediate
                MemWrite = 1'b0;
                ALUOp = 3'b000; //doesn't matter
                MemtoReg = 1'b0;
                MemRead = 1'b0;
                branch = 1'b0;
            end            
     
        5'b00101: begin // AUIPC
                RegWrite = 1'b1;
                ALUSrc = 1'b1; //takes the immediate
                MemWrite = 1'b0;
                ALUOp = 3'b000;
                MemtoReg = 1'b0;
                MemRead = 1'b0;
                branch = 1'b0;
            end
            
            5'b11011: begin //JAL --> PC = PC + Immediate
              RegWrite = 1'b1;
              ALUSrc = 1'b1; //takes the immediate
              MemWrite = 1'b0;
              ALUOp = 3'b000;
              MemtoReg = 1'b0;
              MemRead = 1'b0;
              branch = 1'b1;
            end
            
            5'b11001: begin //JALR --> PC = Rs1 + Immediate
              RegWrite = 1'b1;
              ALUSrc = 1'b1; //takes the immediate
              MemWrite = 1'b0;
              ALUOp = 3'b000;
              MemtoReg = 1'b0;
              MemRead = 1'b0;
              branch = 1'b1;
            end            
  
            5'b01100: begin //r format
                RegWrite = 1'b1;
                ALUSrc = 1'b0;
                MemWrite = 1'b0;
                ALUOp = 3'b010;
                MemtoReg = 1'b0;
                MemRead = 1'b0;
                branch = 1'b0;
            end
            
            5'b00100: begin // I format
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                MemWrite = 1'b0;
                ALUOp = 3'b011;
                MemtoReg = 1'b0;
                MemRead = 1'b0;
                branch = 1'b0;
            end            
            
            5'b11000: begin //beq
                RegWrite = 1'b0;
                ALUSrc = 1'b0;
                MemWrite = 1'b0;
                ALUOp = 3'b001;
                MemRead = 1'b0;
                branch = 1'b1;
            end

            5'b01101: begin //LUI
                RegWrite = 1'b1;
                ALUSrc = 1'b1; //takes the immediate
                MemWrite = 1'b0;
                ALUOp = 3'b101;
                MemtoReg = 1'b0;
                MemRead = 1'b0;
                branch = 1'b0;
            end
        endcase
    end

endmodule
