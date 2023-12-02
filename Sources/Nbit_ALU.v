/*******************************************************************
*
* Module: NBit_ALU.v
* Project: Single Cycle RISC-V processor
* Description: this module takes the required ALU function and performs it and returns the value in reg r
*
* Change history: 
* 11/04/23: - added AUIPC and LUI

**********************************************************************/

module Nbit_ALU(input wire [31:0] a, b,input wire [3:0] alufn, input wire [4:0]  shamt, input signe, input [1:0] mul_op,
output  reg  [31:0] r, output  wire cf, zf, vf, sf);

    wire [31:0] add, op_b;
    reg signed [31:0] DIV, DIVU;
    reg signed [63:0] product; 
    reg [31:0] remu, rem;
    
    wire signed [31:0] As, Bs;
    assign As = a; 
    assign Bs = b;
    
    wire [63:0] A64, B64;
    assign A64 = {{32{a[31]}}, a};
    assign B64 = {{32{1'b0}}, b};
    
    assign op_b = (~b);
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
    
    wire[31:0] sh;
    Shifter shifter0(.A(a), .shamt(shamt), .type(alufn[1:0]),  .out(sh));

    always @ * begin
        r = 0;
        product = 0;
        remu = 0; rem = 0;
        DIV = 0; DIVU = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            4'b00_00 : r = add;
            4'b00_01 : r = add;
            // logic
            4'b01_00:  r = a | b;
            4'b01_01:  r = a & b;
            4'b01_11:  r = a ^ b;
            // shift
            4'b10_00:  r=sh;
            4'b10_01:  r=sh;
            4'b10_10:  r=sh;
            // slt & sltu
            4'b11_01:  r = {31'b0,(sf != vf)}; 
            4'b11_11:  r = {31'b0,(~cf)};      
            4'b00_10: r = b;  //lui
            //remainder
            4'b01_10: begin
            rem = As % Bs; 
            remu = a % b;
            r = (signe)? remu : rem;
            end
            //divide
            4'b00_11: begin
            DIV = As / Bs;
            DIVU = a / b;
            r = (signe)? DIVU : DIV;
            end
            //multiply
            4'b1011: begin
                case(mul_op)
                2'b00: begin //mul
                product = (As * Bs);
                r = product[31:0]; end
                2'b01: begin //mulh
                product = (As * Bs); 
                r = product[63:32]; end
                2'b10: begin //mulhsu
                product = (A64 * B64); 
                r = product[63:32];                
                end
                2'b11: begin //mulhu
                product = a * b;
                r = product[63:32];                
                end
                endcase
            end
        endcase
    end
endmodule