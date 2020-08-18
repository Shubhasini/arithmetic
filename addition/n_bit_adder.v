//full_adder.v
`timescale 1ns / 1ps
module n_bit_adder(num1, num2,carry_in sum, carry);
  parameter n = 8;
  input [n-1:0]num1, num2;
  input carry_in
  output [n-1:0]sum;
  output carry;
 
	wire carry_in;
	full_adder i_full_adder (.carry_in(0), .num1(num1[0]), .num2(num2[0]), .sum(sum[0]), .carry(carry[0]));
	full_adder i_full_adder [0:n-1] (.carry_in(carry[n-1]), .num1(num1[n+1]), .num2(num2[n+1]), .sum(sum[n+1]), .carry(y[n]));
	full_adder i_full_adder (.carry_in(y[n]), .num1(num1[n-1]), .num2(num2[n-1]), .sum(sum[n]), .carry(carry));

endmodule

module full_adder (num1,num2,carry_in,sum,carry);
	input  carry_in, num1, num2;
	output sum,carry;
	wire   y1,y2,y3;
 //instantiating gates
 
	xor (sum, num1, num2,carry_in);
	and A1 (y1,num1,num2);
	and A2 (y2,num1,carry_in);
	and A3 (y3,num2,carry_in);
	or (carry, y1,y2,y3);
  
endmodule