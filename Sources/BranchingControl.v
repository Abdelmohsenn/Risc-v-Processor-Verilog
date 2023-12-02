`timescale 1ns / 1ps
`include "defines.v"

/*******************************************************************
*
* Module: BranchingControl.v
* Project: Single Cycle RISC-V processor
* Description: this module manages the branching instructions
*
* Change history: 
*   11/03/23 - added branch condition
*   11/04/23 - edited some conditions condition
*
**********************************************************************/


module BranchingControl(input zf, cf, vf, sf, branch, input [2:0] func3, output reg branchRes);

//we need to only check the branching unit when we have a branch instruction becuase otherwise func3 might correlate with another 
    always @(*)
    begin
    if(branch) begin
        case (func3)
        
            `BR_BEQ: branchRes = (zf)? 1 : 0;           //BEQ: Branch if Z
            `BR_BNE: branchRes = (~zf) ? 1 : 0;         //BNE: Branch if ~Z;
            `BR_BLT: branchRes = (sf != vf)? 1 : 0;           //BLT: Branch if (S != V)
            `BR_BGE: branchRes = (sf == vf) ? 1 : 0;         //BGE: Branch if (S == V)
            `BR_BLTU: branchRes = (~cf)? 1 : 0;                        // BLTU: Branch if ~C
            `BR_BGEU: branchRes = (cf)? 1 : 0;                           //BGEU: Branch if C
            
            default: branchRes=0;
        endcase
        end
        
    else branchRes=0;
    end

endmodule
