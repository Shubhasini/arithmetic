`timescale 1ns / 1ps
module symbol_8_bit_adder(num1, num2, sum,carry);
    input [7:0] num1;
    input [7:0] num2;
    output [8:0] sum;
    output carry;
    
  assign  sum = num1 + num2;
  assign carry = sum[8];
endmodule 
