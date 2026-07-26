`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2026 22:52:42
// Design Name: 
// Module Name: mips_implementation
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


module mips_implementation(
input clk1,clk2
    );
    reg[31:0] IF_ID_NPC, PC, IF_ID_IR;// VAR FOR IF
   
    reg[31:0] ID_EX_A, ID_EX_B, ID_EX_IR, ID_EX_IMM,ID_EX_BRANCH,ID_EX_NPC; // VAR FOR ID
   
    reg[31:0] EX_MEM_ALUOUT,EX_MEM_IR,EX_MEM_B; // VAR FOR EX
    reg EX_MEM_COND;
   
    reg[31:0] MEM_WB_IR,MEM_WB_LMD,MEM_WB_ALUOUT; // VAR FOR MEM
    
    reg HALTED,TAKEN_BRANCH;
    
    reg[31:0] REG[0:31];
    reg[31:0] DATA_MEMORY[0:1023];
    reg[31:0] INST_MEMORY[0:1023];
   reg [2:0] ID_EX_TYPE,EX_MEM_TYPE,MEM_WB_TYPE;
// OPCODES
parameter ADD   = 6'b000000,
          SUB   = 6'b000001,
          ANDD  = 6'b000010,
          ORR   = 6'b000011,
          SLT   = 6'b000100,
          MUL   = 6'b000101,

          LW    = 6'b001000,
          SW    = 6'b001001,

          ADDI  = 6'b001010,
          SUBI  = 6'b001011,
          SLTI  = 6'b001100,

          BNEQZ = 6'b001101,
          BEQZ  = 6'b001110,

          HLT   = 6'b111111;
          
       
// INSTRUCTION TYPES
parameter RR_ALU = 3'b000,   // Register-Register ALU
          RM_ALU = 3'b001,   // Register-Immediate ALU
          LOAD   = 3'b010,   // Load instruction
          STORE  = 3'b011,   // Store instruction
          BRANCH = 3'b100,   // Branch instruction
          HALT   = 3'b101;   // Halt instruction
       
    
// IF STAGE
always @(posedge clk1)
begin

if(HALTED==0)
begin


if(((EX_MEM_IR[31:26]==BEQZ)&&(EX_MEM_COND==1)||
(EX_MEM_IR[31:26]==BNEQZ)&&(EX_MEM_COND==0)))
begin
TAKEN_BRANCH<=1'b1;
IF_ID_IR<=INST_MEMORY[EX_MEM_ALUOUT];
IF_ID_NPC<=EX_MEM_ALUOUT+1;
PC<=EX_MEM_ALUOUT+1;
end

else
begin
IF_ID_IR<=INST_MEMORY[PC];
TAKEN_BRANCH<=1'b0;
IF_ID_NPC<=PC+1;
PC<=PC+1;
end

end   

end

//ID STAGE 
always @(posedge clk2)
begin
if(HALTED==0)
begin
ID_EX_IR<=IF_ID_IR;
ID_EX_A<=REG[IF_ID_IR[25:21]];
ID_EX_B<=REG[IF_ID_IR[20:16]];
ID_EX_IMM<={16'h0000,IF_ID_IR[15:0]};
ID_EX_BRANCH<={6'b000000,IF_ID_IR[25:0]};
ID_EX_NPC<=IF_ID_NPC;
case(IF_ID_IR[31:26])

ADD, SUB, ANDD, ORR, SLT, MUL:
    ID_EX_TYPE <= RR_ALU;

ADDI, SUBI, SLTI:
    ID_EX_TYPE <= RM_ALU;

LW:
    ID_EX_TYPE <= LOAD;

SW:
    ID_EX_TYPE <= STORE;

BEQZ, BNEQZ:
    ID_EX_TYPE <= BRANCH;

HLT:
    ID_EX_TYPE <= HALT;

default: ID_EX_TYPE <= 3'bxxx;
endcase

end    

end

//EX STAGE 
always @(posedge clk1)
begin
if(HALTED==0)
begin
EX_MEM_TYPE<=ID_EX_TYPE;
EX_MEM_IR<=ID_EX_IR;

case(ID_EX_TYPE)

RR_ALU: begin

    case (ID_EX_IR[31:26])   
        ADD: EX_MEM_ALUOUT <=  ID_EX_A + ID_EX_B;
        SUB: EX_MEM_ALUOUT <=  ID_EX_A - ID_EX_B;
        ANDD: EX_MEM_ALUOUT <=  ID_EX_A & ID_EX_B;
        ORR: EX_MEM_ALUOUT <=  ID_EX_A | ID_EX_B;
        SLT: EX_MEM_ALUOUT <=  ID_EX_A < ID_EX_B;
        MUL: EX_MEM_ALUOUT <=  ID_EX_A * ID_EX_B;
        default: EX_MEM_ALUOUT <=   32'hxxxxxxxx;

    endcase

end


RM_ALU: begin

    case (ID_EX_IR[31:26]) 

        ADDI: EX_MEM_ALUOUT <= ID_EX_A + ID_EX_IMM;
        SUBI: EX_MEM_ALUOUT <= ID_EX_A - ID_EX_IMM;
        SLTI: EX_MEM_ALUOUT <= ID_EX_A < ID_EX_IMM;

        default:  EX_MEM_ALUOUT <=  32'hxxxxxxxx;

    endcase

end

LOAD:
EX_MEM_ALUOUT<=ID_EX_A + ID_EX_IMM;

STORE:
begin
EX_MEM_B<=ID_EX_B;
EX_MEM_ALUOUT<=ID_EX_A + ID_EX_IMM;
end

BRANCH:
begin
EX_MEM_ALUOUT<=ID_EX_NPC + ID_EX_IMM;
EX_MEM_COND<= (ID_EX_A==0);
end
endcase  
 
end


end

//mem stage 
always @(posedge clk2)
begin
if(HALTED==0)
begin
MEM_WB_TYPE<=EX_MEM_TYPE;
MEM_WB_IR<=EX_MEM_IR;
case(EX_MEM_TYPE)
RR_ALU,RM_ALU:
MEM_WB_ALUOUT<=EX_MEM_ALUOUT;
LOAD:
begin
MEM_WB_LMD<=DATA_MEMORY[EX_MEM_ALUOUT];
end
STORE:
DATA_MEMORY[EX_MEM_ALUOUT]<=EX_MEM_B;
endcase

end

end

//WB STAGE
always@(posedge clk1)
begin
if(HALTED==0)
begin
case(MEM_WB_TYPE)
RR_ALU:
REG[MEM_WB_IR[15:11]]<=MEM_WB_ALUOUT;
RM_ALU:
REG[MEM_WB_IR[20:16]]<=MEM_WB_ALUOUT;
LOAD:
REG[MEM_WB_IR[20:16]]<=MEM_WB_LMD;
HALT: 
HALTED<= 1'b1;
endcase
end

end

endmodule
