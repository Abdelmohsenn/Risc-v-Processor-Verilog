`timescale 1ns / 1ps
/*******************************************************************
*
* Module: DataMemory.v
* Project: Project_Name
* Author: name and email
* Description: this module manages the memory and the loading and storing procedures
*
* Change history: 
11/02/23: - added a branching unit module
          - removed the AND gate as it's now implemented inside the BU

11/03/23 - something is wrong with the PC signal passed after we use i format, it seems that the branching unit's always block had to only work when branching is 1 as it affected the PC
           shamt had to be edited as it is not always instr [20:24] as sometimes it could be r format

11/04/23 - editted some wires being passed such as PC to the ALU,
         - now that the memory accomadtes more addresses, it's byte addressable not word addressable so address = alures[9:0] instead of alures[11:2]
           we have a byte addressable memory, so now we have 1024 locations
           and so now we have the address as 10 bits
         - branching unit now takes branch as input too
**********************************************************************/

module DataPath(input clock, input reset, input [1:0] ledSel, input [3:0] ssdSel, input SSD_Clock, 
output reg [15:0] leds, output reg [12:0] ssd);

wire [31:0] PCout, instruction, immediate, readData1, readData2, dataIn, ALU_InputB, memOut, ALURes,
sumPC, PCin, PC4, ALU_InputA, nop;
wire branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, zf, cf, vf, sf, BranchOUT, jump;
wire [2:0] ALUOp;
wire [3:0] ALU_select;
wire [4:0] shamt;
wire Slowclock;
wire [10:0]Addr;
wire [7:0]SingMemMuxOut;
wire [31:0] singlememout;
assign nop = 32'h00000033;

//-------------------------------------------------------------------------------
wire [31:0] IF_ID_PC, IF_ID_Instruction;
assign PC4 = PCout + 4;


Nbit_4x1MUX #(32) PCMux(.sel({jump, BranchOUT}), .a(PC4), .b(EX_MEM_BranchAddOut), .c(EX_MEM_ALU_out), .d(PC4), .out(PCin)); //alu res of ex/mem, sum pc of ec/mem

wire halt, IF_ID_halt;
assign halt = ((singlememout[6:2]==5'b11100) || (singlememout[6:2]==5'b00011) || EX_MEM_halt || ID_EX_halt) ? 1 : 0; //accounting for ebreak, ecall, fence
Nbit_reg#(32) PC(.clk(clock), .rst(reset),.load(~halt), .D(PCin), .Q(PCout)); 

//EBREAK works by checking the opcode and seeing if it means to halt, then load signal = 0
 Nbit_Mux#(32) NOP(.sel((BranchOUT || jump || EX_MEM_halt)&& clock == 0),.q(singlememout),.d(nop),.y(instruction)); // added a Mux for choosing 

Nbit_reg #(65) IF_ID (.clk(!clock),.rst(reset),.load(1'b1),.D( {PCout, instruction, halt}),
 .Q({IF_ID_PC, IF_ID_Instruction, IF_ID_halt}));
//------------------------------------------------------------------------------ IF/ID

Reg_File #(32) RF(.clk(~clock), .RegWrite(MEM_WB_Ctrl[1]), .reg1(IF_ID_Instruction[19:15]), .reg2(IF_ID_Instruction[24:20]), .regW(MEM_WB_Rd_address),
.data(dataIn), .reset(reset), .readData1(readData1), .readData2(readData2));

ImmGen immedia (.gen_out(immediate), .inst(IF_ID_Instruction));

ControlUnit CU(.instruction(IF_ID_Instruction[6:2]), .branch(branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .ALUOp(ALUOp), .MemWrite(MemWrite),
 .ALUSrc(ALUSrc), .RegWrite(RegWrite));

wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm;
wire [4:0] ID_EX_Opcode;
wire [8:0] ID_EX_Ctrl_input;
wire [8:0] ID_EX_Ctrl;
wire [3:0] ID_EX_Func;
wire ID_EX_bit25, ID_EX_halt;
wire [4:0] ID_EX_Rs1_address, ID_EX_Rs2_address, ID_EX_Rd_address;

assign ID_EX_Ctrl_input = (BranchOUT || jump || IF_ID_halt)? 9'd0 : {RegWrite, MemtoReg, MemWrite, MemRead, branch, ALUSrc, ALUOp} ;

Nbit_reg #(163) ID_EX (.clk(clock),.rst(reset),.load(1'b1),
.D({ID_EX_Ctrl_input, IF_ID_PC, readData1, readData2, immediate, {IF_ID_Instruction [14:12],IF_ID_Instruction[30]} 
,IF_ID_Instruction[19:15],IF_ID_Instruction[24:20],IF_ID_Instruction [11:7], IF_ID_Instruction[6:2], IF_ID_Instruction[25], IF_ID_halt})

,.Q({ID_EX_Ctrl, ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2,ID_EX_Imm, ID_EX_Func, ID_EX_Rs1_address, ID_EX_Rs2_address, ID_EX_Rd_address, ID_EX_Opcode, ID_EX_bit25, ID_EX_halt}) );

//------------------------------------------------------------------------------ ID/EX

wire signe, EX_MEM_halt; 
wire [1:0] mul_op;

ALU_ControlUnit ALU_CU(.ALUOp(ID_EX_Ctrl[2:0]), .inst14_12(ID_EX_Func[3:1]), .inst30(ID_EX_Func[0]), .ALU_select(ALU_select), .bit25(ID_EX_bit25), .signe(signe), .mul_op(mul_op));

wire [1:0] FA, FB;
wire [31:0] ForwardRegA, ForwardRegB;

ForwardingUnit FU(.ID_EX_Rs1(ID_EX_Rs1_address), .ID_EX_Rs2(ID_EX_Rs2_address), .EX_MEM_Rd(EX_MEM_Rd_address), .MEM_WB_Rd(MEM_WB_Rd_address),
.EX_MEM_RegW(EX_MEM_Ctrl[4]), .MEM_WB_RegW(MEM_WB_Ctrl[1]), .ForwardA(FA), .ForwardB(FB));

Nbit_4x1MUX ForwA(FA, ID_EX_RegR1, dataIn, EX_MEM_ALU_out, 32'b0, ForwardRegA);
Nbit_4x1MUX ForwB(FB, ID_EX_RegR2, dataIn, EX_MEM_ALU_out, 32'b0, ForwardRegB);

Nbit_Mux#(32) Rs1MUX(.sel((((ID_EX_Opcode == 5'b11011) || ID_EX_Opcode == 5'b00101)?1:0)), .q(ForwardRegA), .d(ID_EX_PC), .y(ALU_InputA)); //if inst = JAL or AUIPC, then ALU_A = currPC
Nbit_Mux#(32) Rs2MUX(.sel(ID_EX_Ctrl[3]), .q(ForwardRegB), .d(ID_EX_Imm), .y(ALU_InputB));
assign shamt = (ID_EX_Opcode[3]==1'b0) ? ID_EX_Rs2_address : ALU_InputB[4:0];
//shamt won't always be instr [20:24] as sometimes it could be r format

Nbit_ALU ALU(.a(ALU_InputA),.b(ALU_InputB), .alufn(ALU_select), .shamt(shamt), .r(ALURes), .cf(cf), .zf(zf), .vf(vf), .sf(sf), .mul_op(mul_op), .signe(signe));

wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_PC; 
wire [4:0] EX_MEM_Ctrl, EX_MEM_Ctrl_input;
wire [4:0] EX_MEM_Rd_address;
wire [3:0] EX_MEM_flags;
wire [2:0] EX_MEM_Func3;
wire [4:0] EX_MEM_Opcode;
RCA #(32) PC_Adder (.a(ID_EX_PC),.b(ID_EX_Imm),.sum(sumPC));

Nbit_Mux#(5) EX_MEM_CtrlSigs(.sel(BranchOUT || jump || ID_EX_halt),.q({ID_EX_Ctrl[8:4]}),.d(5'd0),.y(EX_MEM_Ctrl_input)); // added a Mux for choosing 

Nbit_reg #(151) EX_MEM (.clk (!clock),.rst(reset),.load(1'b1),
.D({EX_MEM_Ctrl_input, sumPC, {sf,vf,cf,zf}, ALURes, ForwardRegB, ID_EX_Rd_address, ID_EX_Func[3:1], ID_EX_Opcode, ID_EX_PC, ID_EX_halt}),

.Q({EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_flags, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd_address, EX_MEM_Func3, EX_MEM_Opcode, EX_MEM_PC, EX_MEM_halt}) );

//------------------------------------------------------------------------------ EX/MEM

//branching control

BranchingControl BU (.zf(EX_MEM_flags[0]),.cf(EX_MEM_flags[1]),.vf(EX_MEM_flags[2]),.sf(EX_MEM_flags[3]),
.branch(EX_MEM_Ctrl[0]),.func3(EX_MEM_Func3),.branchRes(BranchOUT)); //branchout to be passed to the PC MUX

assign jump = ((EX_MEM_Opcode == 5'b11011) || (EX_MEM_Opcode == 5'b11001)) ? 1 : 0;

wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_PC;
wire [1:0] MEM_WB_Ctrl;
wire [4:0] MEM_WB_Rd_address;
wire WB_jump;
Nbit_reg #(104) MEM_WB (.clk(clock),.rst(reset),.load(1'b1),
.D({{EX_MEM_Ctrl[4:3]}, singlememout, EX_MEM_ALU_out, EX_MEM_Rd_address, EX_MEM_PC, jump}),

.Q({MEM_WB_Ctrl, MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Rd_address, MEM_WB_PC, WB_jump} ));

//------------------------------------------------------------------------------ MEM/WB

assign MEM_WB_PC = MEM_WB_PC + 4;

Nbit_4x1MUX #(32) datamem_Mux(.sel({WB_jump, MEM_WB_Ctrl[0]}), .a(MEM_WB_ALU_out), .b(MEM_WB_Mem_out), .c(MEM_WB_PC), .d(32'd0), .out(dataIn));

//------------------------------------------------------------------------------
 
Nbit_Mux#(8) singlememmux(.sel(clock),.q(EX_MEM_ALU_out[7:0]),.d(PCout[7:0]),.y(SingMemMuxOut)); // added a Mux for choosing 
 
 SingleMem Smem(.clk(clock), .reset(reset),  .mem_addr(SingMemMuxOut), .data_in(EX_MEM_RegR2), .func3(EX_MEM_Func3),  .MemWrite(EX_MEM_Ctrl[2]), .MemRead(EX_MEM_Ctrl[1]),
.data_out(singlememout));
//now that the memory accomadtes more addresses, it's byte addressable not word addressable so address = alures[9:0] instead of alures[11:2]


always @ (*) begin
case(ledSel) 
2'b00: begin
leds = instruction[15:0];
end
2'b01: begin
leds = instruction[31:16];
end
2'b10: begin 
//leds = {2'b00,branch, MemRead, MemtoReg,ALUOp, MemWrite, ALUSrc, RegWrite, ALU_select, zf, BranchOUT};//help
end
endcase
end

always @ (*) 
    begin
        case(ssdSel) 
            4'b0000:begin
            ssd = PCout;
            end
            4'b0001: begin
            ssd = PC4;
            end
            4'b0010: begin
            ssd = branch;
            end
            4'b0011: begin
            ssd = sumPC;
            end
            4'b0100: begin
            ssd = readData1;
            end
            4'b0101: begin
            ssd = readData2;
            end
            4'b0110: begin
            ssd = dataIn;
            end
            4'b0111: begin
            ssd = immediate;
            end
            4'b1000: begin
            ssd = immediate;
            end
            4'b1001: begin
            ssd = ALU_InputB;
            end
            4'b1010: begin
            ssd = ALURes;
            end
            4'b1011: begin
            ssd = memOut;
            end
        endcase
    end
    
endmodule
