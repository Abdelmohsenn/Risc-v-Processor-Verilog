`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2023 09:05:10 PM
// Design Name: 
// Module Name: SingleMem
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


module SingleMem( input clk, reset, input [7:0] mem_addr, input [31:0] data_in, input [2:0] func3, input MemWrite, MemRead,
    output reg [31:0] data_out);

    wire [10:0] offset = 11'd100;
    wire [10:0] inst_addr = mem_addr + offset;
    reg [7:0] mem [0:200];
    integer i;

    initial begin
        for(i = 0; i < 201; i=i+1) begin
            mem[i] = 0;
        end
        {mem[3],mem[2],mem[1],mem[0]} = 32'd17;
        {mem[7],mem[6],mem[5],mem[4]} =32'd9;
        {mem[11],mem[10],mem[9],mem[8]} =32'd25;
                             
          
//// testing data dependencies          
//        {mem[offset+3],mem[offset+2],mem[offset+1],mem[offset]} =          32'h00002103;   //lw x2, 0(x0)
//        {mem[offset+7],mem[offset+6],mem[offset+5],mem[offset+4]} =        32'h00402203;   //lw x4, 4(x0)
//        {mem[offset+11],mem[offset+10],mem[offset+9],mem[offset+8]} =      32'h004101b3;   //add x3, x2, x4
//        {mem[offset+15],mem[offset+14],mem[offset+13],mem[offset+12]} =    32'h00018463;   //beq x3, x0, L1
//        {mem[offset+19],mem[offset+18],mem[offset+17],mem[offset+16]} =    32'h002081b3;   //add x3 x1 x2
//        {mem[offset+23],mem[offset+22],mem[offset+21],mem[offset+20]} =    32'h002182b3;   //L1: add x5 x3 x2                    
                     
//     = 32'b000000000000_00000_000_00000_1110011; //ECALL
//     = 32'b000000000001_00000_000_00000_1110011; //Ebreak
//     = 32'b0000_00_00_00000_000_00000_0001111; //FENCE
                           
//testing jal and jalr  
//{mem[offset+3],mem[offset+2],mem[offset+1],mem[offset]} =       32'h00900113;  // addi x2 x0 9 
//{mem[offset+7],mem[offset+6],mem[offset+5],mem[offset+4]} =     32'h00800093;  // addi x1 x0 8     
//{mem[offset+11],mem[offset+10],mem[offset+9],mem[offset+8]} =   32'h00c0006f;// jal x0 L2  
//{mem[offset+15],mem[offset+14],mem[offset+13],mem[offset+12]} = 32'h00000033;  // add x0 x0 x0     
//{mem[offset+19],mem[offset+18],mem[offset+17],mem[offset+16]} = 32'h00000663;  // beq x0 x0 L1     
//{mem[offset+23],mem[offset+22],mem[offset+21],mem[offset+20]} = 32'h00008193;  // L2: addi x3 x1 0 
//{mem[offset+27],mem[offset+26],mem[offset+25],mem[offset+24]} = 32'h00408067;  // jalr x0, 4(x1)    

////  testing the branching instructions      
//{mem[offset+3],mem[offset+2],mem[offset+1],mem[offset]} =       32'h00100093;    //addi x1 x0 1          
//{mem[offset+7],mem[offset+6],mem[offset+5],mem[offset+4]} =     32'hffe00113;    //addi x2 x0 -2         
//{mem[offset+11],mem[offset+10],mem[offset+9],mem[offset+8]} =   32'h00000463;    //beq x0 x0 L1          
//{mem[offset+15],mem[offset+14],mem[offset+13],mem[offset+12]} = 32'h00100113;    //addi x2 x0 1          
//{mem[offset+19],mem[offset+18],mem[offset+17],mem[offset+16]} = 32'h00101463;    //L1: bne x0 x1 L2      
//{mem[offset+23],mem[offset+22],mem[offset+21],mem[offset+20]} = 32'h00100193;    //addi x3 x0 1          
//{mem[offset+27],mem[offset+26],mem[offset+25],mem[offset+24]} = 32'h00114463;    //L2: blt x2 x1 L3      
//{mem[offset+31],mem[offset+30],mem[offset+29],mem[offset+28]} = 32'h00100213;    //addi x4 x0 1          
//{mem[offset+35],mem[offset+34],mem[offset+33],mem[offset+32]} = 32'h0000d463;    //L3: bge x1 x0 L4      
//{mem[offset+39],mem[offset+38],mem[offset+37],mem[offset+36]} = 32'h00100293;    //addi x5 x0 1          
//{mem[offset+43],mem[offset+42],mem[offset+41],mem[offset+40]} = 32'h0020e463;    //L4: bltu x1 x2 L5     
//{mem[offset+47],mem[offset+46],mem[offset+45],mem[offset+44]} = 32'h00100313;    //addi x6 x0 1          
//{mem[offset+51],mem[offset+50],mem[offset+49],mem[offset+48]} = 32'h00117463;    //L5: bgeu x2 x1 L6     
//{mem[offset+55],mem[offset+54],mem[offset+53],mem[offset+52]} = 32'h00100393;    //addi x7 x0 1          
//{mem[offset+59],mem[offset+58],mem[offset+57],mem[offset+56]} = 32'h00100413;    //L6: addi x8 x0 1      

 //testing the r instructions      
{mem[offset+3],mem[offset+2],mem[offset+1],mem[offset]} =       32'h01100093; //addi x1, x0, 17  
{mem[offset+7],mem[offset+6],mem[offset+5],mem[offset+4]} =     32'h00100a93; //addi x21, x0, 1  
{mem[offset+11],mem[offset+10],mem[offset+9],mem[offset+8]} =   32'hfeb00b13; //addi x22 x0 -21  
{mem[offset+15],mem[offset+14],mem[offset+13],mem[offset+12]} = 32'h00108133; //add x2 x1 x1     
{mem[offset+19],mem[offset+18],mem[offset+17],mem[offset+16]} = 32'h401081b3; //sub x3 x1 x1     
{mem[offset+23],mem[offset+22],mem[offset+21],mem[offset+20]} = 32'h01509233; //sll x4 x1 x21    
{mem[offset+27],mem[offset+26],mem[offset+25],mem[offset+24]} = 32'h0150a2b3; //slt x5 x1 x21    
{mem[offset+31],mem[offset+30],mem[offset+29],mem[offset+28]} = 32'h0150b333; //sltu x6 x1 x21   
{mem[offset+35],mem[offset+34],mem[offset+33],mem[offset+32]} = 32'h016ac3b3; //xor x7 x21 x22   
{mem[offset+39],mem[offset+38],mem[offset+37],mem[offset+36]} = 32'h015b5433; //srl x8 x22 x21   
{mem[offset+43],mem[offset+42],mem[offset+41],mem[offset+40]} = 32'h416b54b3; //sra x9 x22 x22   
{mem[offset+47],mem[offset+46],mem[offset+45],mem[offset+44]} = 32'h015b6533; //or x10 x22 x21   
{mem[offset+51],mem[offset+50],mem[offset+49],mem[offset+48]} = 32'h015af5b3; //and x11 x21 x21  

// // testing mul and div extension
//{mem[offset+3],mem[offset+2],mem[offset+1],mem[offset]} =       32'h01000093;  //addi x1, x0, 16
//{mem[offset+7],mem[offset+6],mem[offset+5],mem[offset+4]} =     32'h00900113;  //addi x2 x0 9
//{mem[offset+11],mem[offset+10],mem[offset+9],mem[offset+8]} =   32'h022081b3;  //mul x3  x1 x2
//{mem[offset+15],mem[offset+14],mem[offset+13],mem[offset+12]} = 32'h02209233;  //mulh x4 x1 x2
//{mem[offset+19],mem[offset+18],mem[offset+17],mem[offset+16]} = 32'h021122b3;  //mulhsu x5 x2 x1
//{mem[offset+23],mem[offset+22],mem[offset+21],mem[offset+20]} = 32'h02113333;  //mulhu x6 x2 x1
//{mem[offset+27],mem[offset+26],mem[offset+25],mem[offset+24]} = 32'h0220c3b3;  //div x7 x1 x2
//{mem[offset+31],mem[offset+30],mem[offset+29],mem[offset+28]} = 32'h0220d433;  //divu x8 x1 x2
//{mem[offset+35],mem[offset+34],mem[offset+33],mem[offset+32]} = 32'h0220e4b3;  //rem x9 x1 x2
//{mem[offset+39],mem[offset+38],mem[offset+37],mem[offset+36]} = 32'h0220f533;  //remu x10 x1 x2

// //testing the immediate instructions      
//{mem[offset+3],mem[offset+2],mem[offset+1],mem[offset]} =        32'hffb00093;		// addi x1, x0, -5	 
//{mem[offset+7],mem[offset+6],mem[offset+5],mem[offset+4]} =      32'h00608113;      // addi x2 x1, 6
//{mem[offset+11],mem[offset+10],mem[offset+9],mem[offset+8]} =    32'h0060a193;      // slti x3, x1, 6
//{mem[offset+15],mem[offset+14],mem[offset+13],mem[offset+12]} =  32'h0040e213;      // ori x4, x1, 4
//{mem[offset+19],mem[offset+18],mem[offset+17],mem[offset+16]} =  32'h0020f293;      // andi x5, x1, 2
//{mem[offset+23],mem[offset+22],mem[offset+21],mem[offset+20]} =  32'h0020c313;		// xori x6, x1, 2 	 
//{mem[offset+27],mem[offset+26],mem[offset+25],mem[offset+24]} =  32'h00109413;		// slli x8, x1, 1 	 
//{mem[offset+31],mem[offset+30],mem[offset+29],mem[offset+28]} =  32'h0010d493;		// srli x9, x1, 1 	 
//{mem[offset+35],mem[offset+34],mem[offset+33],mem[offset+32]} =  32'h4010d513;		// srai x10, x1, 1	 
//{mem[offset+39],mem[offset+38],mem[offset+37],mem[offset+36]} =  32'h4010d513;		// srai x10, x1, 1	 
//{mem[offset+43],mem[offset+42],mem[offset+41],mem[offset+40]} =  32'hffd0b393;		// sltiu x7, x1, -3		

////testing store and load and lui and auipc, LITTLE Endian
//  {mem[offset+3],mem[offset+2],mem[offset+1],mem[offset]} =         32'h0000c297;     // auipc x5, 12 			               
//  {mem[offset+7],mem[offset+6],mem[offset+5],mem[offset+4]} =       32'h040300b7;     // lui x1, 16432                    
//  {mem[offset+11],mem[offset+10],mem[offset+9],mem[offset+8]} =     32'h20108093;     // addi x1, x1, 513                 
//  {mem[offset+15],mem[offset+14],mem[offset+13],mem[offset+12]} =   32'h0010202;      // sw x1, 0(x0)                     
//  {mem[offset+19],mem[offset+18],mem[offset+17],mem[offset+16]} =   32'h00101223;     // sh x1, 4(x0)                     
//  {mem[offset+23],mem[offset+22],mem[offset+21],mem[offset+20]} =   32'h00100423;     // sb x1, 8(x0)                     
//  {mem[offset+27],mem[offset+26],mem[offset+25],mem[offset+24]} = 32'h00002103;       // lw x2, 0(x0)                     
//  {mem[offset+31],mem[offset+30],mem[offset+29],mem[offset+28]} = 32'h00001183;       // lh x3, 0(x0                      
//  {mem[offset+35],mem[offset+34],mem[offset+33],mem[offset+32]} = 32'h00401183;       // lh x3, 4(x0)                     
//  {mem[offset+39],mem[offset+38],mem[offset+37],mem[offset+36]} = 32'h00000203;       // lb x4, 0(x0)                     

//corner case
//{mem[offset+3],mem[offset+2],mem[offset+1],mem[offset]} =     32'h00000263; //beq x0 x0 L1
//{mem[offset+7],mem[offset+6],mem[offset+5],mem[offset+4]} =   32'b000000000000_00000_000_00000_1110011; //Ebreak/Ecall
//{mem[offset+11],mem[offset+10],mem[offset+9],mem[offset+8]} = 32'h00900093;     //L1: addi x1, x0 9
//{mem[offset+15],mem[offset+14],mem[offset+13],mem[offset+12]} = 32'h00108133; //add x2 x1 x1       
//{mem[offset+19],mem[offset+18],mem[offset+17],mem[offset+16]} = 32'h401081b3; //sub x3 x1 x1       
//{mem[offset+23],mem[offset+22],mem[offset+21],mem[offset+20]} = 32'h01509233; //sll x4 x1 x21      
//{mem[offset+27],mem[offset+26],mem[offset+25],mem[offset+24]} = 32'h0150a2b3; //slt x5 x1 x21    

end  

    always @ (posedge reset) begin

        for(i = 0; i < 100; i=i+1) begin
            mem[i] = 0;
        end
        {mem[3],mem[2],mem[1],mem[0]} = 32'd17;
        {mem[7],mem[6],mem[5],mem[4]} =32'd9;
        {mem[11],mem[10],mem[9],mem[8]} =32'd25;
    end

    always @ (posedge clk) begin
        if(MemWrite) begin
            case(func3)
                3'b010: begin
                    mem[mem_addr] = data_in[7:0];
                    mem[mem_addr+1] = data_in[15:8];
                    mem[mem_addr+2] = data_in[23:16];
                    mem[mem_addr+3] = data_in[31:24]; //store word
                end

                3'b000: begin
                    mem[mem_addr] = {data_in[7:0]}; //store byte
                end

                3'b001: begin
                    mem[mem_addr] = data_in[7:0];
                    mem[mem_addr+1] = data_in[15:8]; //store half word 
                end
            endcase
        end
    end


    always @ (*)
    begin
        if (~clk)
            begin

                if (MemRead)
                begin
                    case(func3)
                        3'b010: data_out = {mem[mem_addr+3],mem[mem_addr+2],mem[mem_addr+1],mem[mem_addr]}; //load word
                        3'b001: data_out = $signed({mem[mem_addr+1],mem[mem_addr]}); //load half word  
                        3'b000: data_out = $signed(mem[mem_addr]); //load byte
                        3'b100: data_out = {24'h000000, mem[mem_addr+3], mem[mem_addr+2]}; //load byte unsigned
                        3'b101: data_out = {16'h0000, mem[mem_addr+3]}; //load half word unsigned
                    endcase
                end

            end
        else if(clk)
        begin
            data_out <= {mem[inst_addr+3], mem[inst_addr+2], mem[inst_addr+1], mem[inst_addr]};
        end

    end

endmodule                                                                    
                                                                             
                                                                             
                                                                             
