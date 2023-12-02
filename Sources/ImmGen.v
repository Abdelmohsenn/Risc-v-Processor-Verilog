`include "defines.v"
/*******************************************************************
*
* Module: ImmGen.v
* Project: Single Cycle RISC-V processor
* Description: this module manages what gets put in the immediate reg based on the instruction being executed
*
* Change history: 
*    10/29/23 - imported
**********************************************************************/

module ImmGen (output reg [31:0] gen_out, input wire [31:0] inst);

always @(*) begin
	case (`OPCODE)
		`OPCODE_Arith_I   : 	gen_out = { {21{inst[31]}}, inst[30:25], inst[24:21], inst[20] };
		`OPCODE_Store     :     gen_out = { {21{inst[31]}}, inst[30:25], inst[11:8], inst[7] };
		`OPCODE_LUI       :     gen_out = { inst[31], inst[30:20], inst[19:12], 12'b0 };
		`OPCODE_AUIPC     :     gen_out = { inst[31], inst[30:20], inst[19:12], 12'b0 };
		`OPCODE_JAL       : 	gen_out = { {12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0 };
		`OPCODE_JALR      : 	gen_out = { {21{inst[31]}}, inst[30:25], inst[24:21], inst[20] };
		`OPCODE_Branch    : 	gen_out = { {20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
		default           : 	gen_out = { {21{inst[31]}}, inst[30:25], inst[24:21], inst[20] }; // IMM_I
	endcase 
end

endmodule