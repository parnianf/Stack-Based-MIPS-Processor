`timescale 1ns/1ns

module Processor(clk, rst);
  input clk, rst;
  wire push, pop, tos, PCWrite, PCWriteCond, IorD, MemWrite, MemRead, IRWrite, StackSrc, ldA, ldB, ALUSrcB,PCSrc;
  wire [1:0] ALUSrcA, ALUControl;
  wire [2:0] OPC;
  Datapath DP(clk, rst, push, pop, tos, PCWrite, PCWriteCond, IorD, MemWrite, MemRead, IRWrite, StackSrc, ldA, ldB, ALUSrcB,PCSrc,ALUSrcA, ALUControl, OPC);
  Controller CU(clk, rst, OPC, push, pop, tos, PCWrite, PCWriteCond, IorD, MemWrite, MemRead, IRWrite, StackSrc, ldA, ldB, ALUSrcB, PCSrc,ALUSrcA, ALUControl);
endmodule

module Processor_TB();
  reg clk = 1'b0, rst = 1'b1;
  always #10 clk = ~clk;
  Processor CUT(clk, rst);
  initial begin
    #51 rst = 1'b0;
    #1000 $stop;
  end
endmodule
    