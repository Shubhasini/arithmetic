`timescale 1ns / 1ps

 module n_bit_adder(num1, num2,sum, carry);
  parameter n = 8;
  input [n-1:0]num1, num2;
  output [n:0]sum;
  output carry;
  wire [n-1:0]carry_out;
  
  genvar i;
   for (i=0;i<n;i=i+1)
    begin
    if (i == 0)
    full_adder i_full_adder0 (.num1(num1[i]), .num2(num2[i]), .carry_in(0), .sum(sum[i]), .carry(carry_out[i]));
    else	
	full_adder i_full_adder (.num1(num1[i]), .num2(num2[i]), .carry_in(carry_out[i-1]), .sum(sum[i]), .carry(carry_out[i]));
	end
	
  assign carry = carry_out[n-1];
  assign sum[n] = carry_out[n-1];
  	
endmodule

module full_adder (num1,num2,carry_in,sum,carry);  //full adder
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
