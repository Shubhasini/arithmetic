`timescale 1ns / 1ps
module multiplier_2bit(num1,num2,prod);  //should write num1,num2,prod
    input [1:0] num1;        
    input [1:0] num2;
    output [3:0] prod;
    //wire [3:0] C;
    wire p1,p2,p3,c1;
    
  and (prod[0],num1[0],num2[0]);
  and (p1,num1[1],num2[0]);
  and (p2,num1[0],num2[1]);
  and (p3,num1[1],num2[1]);
  
adder a1(.S(prod[1]), .Cout(c1), .num1(p2), .num2(p1));
adder a2(.S(prod[2]), .Cout(prod[3]), .num1(p3), .num2(c1));
 //or (C[2], p3,c1);
endmodule

module adder(S, Cout, num1, num2); //half adder
   output S;
   output Cout;
   input  num1;
   input  num2;
   
   and(Cout,num1, num2);
   xor(S,num1,num2);
endmodule  
