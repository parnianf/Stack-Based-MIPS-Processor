`timescale 1ns/1ns

module Controller(clk, rst, OPC, push, pop, tos, PCWrite, PCWriteCond, IorD, MemWrite, MemRead, IRWrite, StackSrc, ldA, ldB, ALUSrcB, PCSrc,ALUSrcA, ALUControl);
  input clk, rst;
  input [2:0] OPC;
  output push, pop, tos, PCWrite, PCWriteCond, IorD, MemWrite, MemRead, IRWrite, StackSrc, ldA, ldB, ALUSrcB, PCSrc;
  reg push, pop, tos, PCWrite, PCWriteCond, IorD, MemWrite, MemRead, IRWrite, StackSrc, ldA, ldB, ALUSrcB, PCSrc;
  output [1:0] ALUSrcA, ALUControl;
  reg [1:0] ALUSrcA, ALUControl;
  reg [4:0] ns, ps;
  parameter [4:0] IF = 0, ID = 1, A = 2, B = 3, C = 4, D = 5, E = 6, F = 7, G = 8, H = 9, I = 10,
                  J = 11, K = 12, L = 13, M = 14, N = 15, O = 16, P = 17, Q = 18, R = 19, S = 20, T = 21;
  always@(ps, OPC)begin
    ns = IF;
    case(ps)
      IF : ns = ID;
      ID : 
        case(OPC)
          3'b000 : ns = A;
          3'b001 : ns = A;
          3'b010 : ns = A;
          3'b011 : ns = I;
          3'b100 : ns = O;
          3'b101 : ns = L;
          3'b110 : ns = T;
          3'b111 : ns = Q;     
        endcase
      A : ns = B;
      B : ns = C;
      C : ns = D;
      D : 
        case(OPC)
          3'b000 : ns = E;
          3'b001 : ns = F;
          3'b010 : ns = G;
        endcase
      E : ns = H;
      F : ns = H;
      G : ns = H;
      H : ns = IF;
      I : ns = J;
      J : ns = K;
      K : ns = H;
      L : ns = M;
      M : ns = N;
      N : ns = IF;
      O : ns = P;
      P : ns = IF; 
      Q : ns = R;
      R : ns = S;
      S : ns = IF;
      T : ns = IF;
    endcase
  end
  always@(ps)begin
    {push, pop, tos, PCWrite, PCWriteCond, IorD, MemWrite, MemRead, IRWrite, StackSrc, ldA, ldB, ALUSrcB, PCSrc, ALUSrcA, ALUControl} = 18'd0;
    case(ps)
      IF : {MemRead, IRWrite, ALUSrcB,PCWrite} = 4'b1111;
      ID : ;
      A : pop = 1'b1;
      B : ldA = 1'b1;
      C : pop = 1'b1;
      D : ldB = 1'b1;
      E : ALUSrcA = 2'b10;
      F : begin ALUSrcA = 2'b10; ALUControl = 2'b01; end
      G : begin ALUSrcA = 2'b10; ALUControl = 2'b10; end
      H : push = 1'b1;
      I : pop = 1'b1;
      J : ldB = 1'b1;
      K : begin ALUSrcA = 2'b01; ALUControl = 2'b01; end
      L : pop = 1'b1;
      M : ldA = 1'b1;
      N : {IorD, MemWrite} = 2'b11;
      O : {IorD, MemRead} = 2'b11;
      P : {StackSrc, push} = 2'b11;
      Q : tos = 1'b1;
      R : ldA = 1'b1;
      S : {PCWriteCond, PCSrc} = 2'b11;
      T : {PCSrc, PCWrite} = 2'b11;
    endcase
  end
  always@(posedge clk, posedge rst)begin
    if(rst)
      ps <= IF;
    else
      ps <= ns;
  end
endmodule

      
        
      
        
