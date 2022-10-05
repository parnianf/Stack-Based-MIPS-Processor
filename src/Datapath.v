`timescale 1ns/1ns
module Stack(clk, rst, d_in , push, pop, tos, d_out); 
	input clk, rst, push, pop, tos;
	input [7:0] d_in;
	output [7:0] d_out;
	reg [7:0] d_out, ptr;
	reg [7:0] stack [0:255];

	always @(posedge clk, posedge rst) begin
		if (rst)
			ptr <= 8'd0;
		else if (push)begin
		  stack[ptr] <= d_in;
			ptr <= ptr + 1;
		end
		else if (pop)begin
		  d_out <= stack[ptr - 1];
			ptr <= ptr - 1;
		end
		else if(tos)
		  d_out <= stack[ptr - 1];
	end
endmodule

module ALU(A, B, ALUControl, ALUResult);
  input [7:0] A, B;
  input [1:0] ALUControl;
  output [7:0] ALUResult;
  reg [7:0] ALUResult;
  always @(ALUControl, A, B)begin
    case(ALUControl)
        2'b00 : ALUResult = A + B;
        2'b01 : ALUResult = A - B;
        2'b10 : ALUResult = A & B;
    endcase
  end
endmodule

module Memory(Address, WriteData, MemWrite, MemRead, clk, ReadData);
  input [4:0] Address; 
  input [7:0] WriteData;
  input MemWrite, MemRead, clk;
  output [7:0] ReadData;
  reg [7:0] memory [0:31];
  always @(posedge clk)begin
    if(MemWrite)
      memory[Address] <= WriteData;
  end
  assign ReadData = MemRead ? memory[Address] : 8'd0;
  initial begin
    $readmemb("test2.txt",memory);
  end    
endmodule

module SignExtend (in, out);
  input [4:0] in;
  output [7:0] out;
  assign out = {3'b000, in};
endmodule

module PC(clk, rst, ld,pc, next_pc);
  input [4:0] pc;
  input clk, rst, ld;
  output [4:0] next_pc;
  reg [4:0] next_pc;
  always @(posedge clk, posedge rst)begin
    if(rst)
      next_pc <= 5'd0;
    else if(ld)
      next_pc <= pc;
  end
endmodule

module Register(clk, ld, in, out);
  input clk, ld;
  input [7:0] in;
  output [7:0] out;
  reg [7:0] out;
  always@(posedge clk)begin
    if(ld)
      out <= in;
  end
endmodule

module Multiplexer2to1 #(parameter N = 2)(A, B, sel, out);
  input [N-1:0] A, B;
  input sel;
  output [N-1:0] out;
  assign out = sel ? B : A;
endmodule

module Multiplexer3to1 #(parameter N = 2)(A, B, C, sel, out);
  input [N-1:0] A, B, C;
  input [1:0] sel;
  output [N-1:0] out;
  reg [N-1:0] out;
  always @(A, B, C, sel)begin
    case(sel)
      2'b00: out = A;
      2'b01: out = B;
      2'b10: out = C;
    endcase
  end
endmodule

module Datapath(clk, rst, push, pop, tos, PCWrite, PCWriteCond, IorD, MemWrite, MemRead, IRWrite, StackSrc, ldA, ldB, ALUSrcB,PCSrc,ALUSrcA, ALUControl, OPC);
  input clk, rst, push, pop, tos, PCWrite, PCWriteCond, IorD, MemWrite, MemRead, IRWrite, StackSrc, ldA, ldB, ALUSrcB, PCSrc;
  input [1:0] ALUSrcA, ALUControl;
  output [2:0] OPC;
  wire [4:0] pcIn, pcOut, Address;
  wire [7:0] WriteData, ReadData, MDROut, inst, d_in, d_out, AOut, BOut, A, B, ALUResult, ALUOut, pcOutSE;
  wire ldPC;
  PC pc(clk, rst,ldPC, pcIn, pcOut);
  Memory memory(Address, AOut, MemWrite, MemRead, clk, ReadData);
  Register MDR(clk, 1'b1, ReadData, MDROut);
  Register IR(clk, IRWrite, ReadData, inst);
  Stack stack(clk, rst, d_in , push, pop, tos, d_out); 
  Register AReg(clk, ldA, d_out, AOut);
  Register BReg(clk, ldB, d_out, BOut);
  ALU alu(A, B, ALUControl, ALUResult);
  Register ALUReg(clk, 1'b1, ALUResult, ALUOut);
  SignExtend SE(pcOut, pcOutSE);
  Multiplexer2to1 #5 mux1(pcOut, inst[4:0], IorD, Address);
  Multiplexer2to1 #8 mux2(ALUOut, MDROut, StackSrc, d_in);
  Multiplexer3to1 #8 mux3(pcOutSE, 8'd255, AOut, ALUSrcA, A);
  Multiplexer2to1 #8 mux4(BOut, 8'd1, ALUSrcB, B);
  Multiplexer2to1 #5 mux5(ALUResult, inst[4:0], PCSrc, pcIn);
  assign ldPC = (PCWrite || (PCWriteCond && ~(8'd0 || AOut)));
  assign OPC = inst[7:5];
endmodule
  
  
  
  
  
  
  
  
  
  
  
  

