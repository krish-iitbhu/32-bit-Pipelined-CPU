`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2026 16:55:53
// Design Name: 
// Module Name: tb_mips
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


module tb_mips(



);
reg clk1;
reg clk2;
integer i;
mips_implementation DUT(
    .clk1(clk1),
    .clk2(clk2)
);

//clk
initial
begin
    clk1 = 0;
    clk2 = 0;

    forever
    begin
        #5 clk1 = 1;
        #5 clk1 = 0;

        #5 clk2 = 1;
        #5 clk2 = 0;
    end
end
  
  
  // intilizing values to soem registers 
initial
begin
    

    DUT.PC = 0;
    DUT.HALTED = 0;
    DUT.TAKEN_BRANCH = 0;

    // Clear Registers
    for(i=0;i<32;i=i+1)
        DUT.REG[i]=0;

    // Clear Memories
    for(i=0;i<1024;i=i+1)
    begin
        DUT.INST_MEMORY[i]=0;
        DUT.DATA_MEMORY[i]=0;
    end

    DUT.REG[1]=10;
    DUT.REG[2]=20;
    DUT.REG[3]=5;

    // ADD  R4 = R1 + R2
    DUT.INST_MEMORY[0]={6'b000000,5'd1,5'd2,5'd4,11'd0};

    // SUB R5 = R2 - R3
    DUT.INST_MEMORY[1]={6'b000001,5'd2,5'd3,5'd5,11'd0};

    // AND R6 = R1 & R2
    DUT.INST_MEMORY[2]={6'b000010,5'd1,5'd2,5'd6,11'd0};

    // OR R7 = R1 | R2
    DUT.INST_MEMORY[3]={6'b000011,5'd1,5'd2,5'd7,11'd0};

    // ADDI R8 = R1 + 15
    DUT.INST_MEMORY[4]={6'b001010,5'd1,5'd8,16'd15};

    // SW R8 -> MEM[100]
    DUT.INST_MEMORY[5]={6'b001001,5'd0,5'd8,16'd100};

    // LW MEM[100] -> R9
    DUT.INST_MEMORY[6]={6'b001000,5'd0,5'd9,16'd100};

    // SLT R10 = (R1<R2)
    DUT.INST_MEMORY[7]={6'b000100,5'd1,5'd2,5'd10,11'd0};

    // MUL R11 = R1 * R3
    DUT.INST_MEMORY[8]={6'b000101,5'd1,5'd3,5'd11,11'd0};

    // HLT
    DUT.INST_MEMORY[9]={6'b111111,26'd0};

end


// display
initial
begin

$display("---------------------------------------------------------");
$display("Time\tPC\tR4\tR5\tR8\tR9\tMEM100");
$display("---------------------------------------------------------");

$monitor("%0t\t%d\t%d\t%d\t%d\t%d\t%d",
$time,
DUT.PC,
DUT.REG[4],
DUT.REG[5],
DUT.REG[8],
DUT.REG[9],
DUT.DATA_MEMORY[100]);

end

initial
begin
    #500;

 
    $display("R4  = %d",DUT.REG[4]);
    $display("R5  = %d",DUT.REG[5]);
    $display("R6  = %d",DUT.REG[6]);
    $display("R7  = %d",DUT.REG[7]);
    $display("R8  = %d",DUT.REG[8]);
    $display("R9  = %d",DUT.REG[9]);
    $display("R10 = %d",DUT.REG[10]);
    $display("R11 = %d",DUT.REG[11]);

    $display("Memory[100] = %d",DUT.DATA_MEMORY[100]);

    $finish;
end


endmodule
