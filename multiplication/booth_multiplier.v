`timescale 1ns / 1ps

module booth_multiplier(num1,num2,prod);
     parameter n=8;
    input [7:0]num1;
    input [7:0]num2;
    output [15:0]prod;
    
    wire signed [7:0] A1,A3,A2;
	wire signed [7:0] A4,A5,A6,A7;
    wire signed [7:0]Q1,Q2,Q3,Q4,Q5,Q6,Q7;
    wire signed[6:0] q0;
    wire qout;
    
    booth_substep step1(.a(8'b00000000),.num1(num1),.num2(num2),.q0(1'b0),.msb8(A1),.lsb8(Q1),.cq0(q0[0]));
	booth_substep step2(.a(A1),.num1(num1),.num2(Q1),.q0(q0[0]),.msb8(A2),.lsb8(Q2),.cq0(q0[1]));
	booth_substep step3(.a(A2),.num1(num1),.num2(Q2),.q0(q0[1]),.msb8(A3),.lsb8(Q3),.cq0(q0[2]));
	booth_substep step4(.a(A3),.num1(num1),.num2(Q3),.q0(q0[2]),.msb8(A4),.lsb8(Q4),.cq0(q0[3]));
	booth_substep step5(.a(A4),.num1(num1),.num2(Q4),.q0(q0[3]),.msb8(A5),.lsb8(Q5),.cq0(q0[4]));
	booth_substep step6(.a(A5),.num1(num1),.num2(Q5),.q0(q0[4]),.msb8(A6),.lsb8(Q6),.cq0(q0[5]));
	booth_substep step7(.a(A6),.num1(num1),.num2(Q6),.q0(q0[5]),.msb8(A7),.lsb8(Q7),.cq0(q0[6]));
	booth_substep step8(.a(A7),.num1(num1),.num2(Q7),.q0(q0[6]),.msb8(prod[15:8]),.lsb8(prod[7:0]),.cq0(qout));
   
    
endmodule

module booth_substep(a,num1,num2,q0,msb8,lsb8,cq0);   //substep of booth algorithm
  input wire signed [7:0]a,num1,num2;      // a= initializing register
  input wire signed q0;            // one bit register
  output reg signed [7:0] msb8;    //msb bits of output
  output reg signed [7:0] lsb8;   //lsb bits of output
  output reg cq0;           //lsb
	wire [7:0] addam,subam;
	n_bit_adder i_n_bit_adder(.num1(a),.num2(num1),.sum(addam));
	subtractor i_subtractor(.num1(a),.num2(num1),.sub(subam));
	always @(*) 
	   begin	
		if(num2[0] == q0) 
		begin   //00 or 11 condition
			 cq0 = num2[0];        //lsb bit in right shift 
			lsb8 = num2>>1;          //right shift
			 lsb8[7] = a[0];      //msb of l8 is taking lsb bit of A (For right shift)
			 msb8 = a>>1;         //right shift 
			if (a[7] == 1)
			msb8[7] = 1;          //msb is same as previous msb (Before right shift)
		end

		else if(num2[0] == 1 && q0 ==0)   //10 condition
		begin      // 10 condition
			 cq0 = num2[0];                      //lsb bit in right shift
				lsb8 = num2>>1;                    //right shift  
			 lsb8[7] = subam[0];                // msb of l8 is taking lsb bit of (A-M)
			 msb8 = subam>>1;                    //right shift of A-M
			if (subam[7] == 1)      
			msb8[7] = 1;                     //msb bit 
	    end

		else 
		begin                        //01 condition
			 cq0 = num2[0];                   //lsb in right shift
				lsb8 = num2>>1;                //right shift
			 lsb8[7] = addam[0];            //msb of l8 is the lsb of A+M
			 msb8 = addam>>1;               //right shift of A+M
			if (addam[7] == 1)
			msb8[7] = 1;
	   end
	  end	
endmodule 

module n_bit_adder(num1, num2,sum, carry);
  parameter n = 8;
  input [n-1:0]num1, num2;
  output [n-1:0]sum;
  output carry;
  wire [n-1:0]carry_out;
  //wire [n-1:0]y;
  
  genvar i;
//  assign carry_in[0] = 0;
   //generate 
   for (i=0;i<n;i=i+1)
    begin
    if (i == 0)
    full_adder i_full_adder0 (.num1(num1[i]), .num2(num2[i]), .carry_in(0), .sum(sum[i]), .carry(carry_out[i]));
    else	
	full_adder i_full_adder1 (.num1(num1[i]), .num2(num2[i]), .carry_in(carry_out[i-1]), .sum(sum[i]), .carry(carry_out[i]));
	end
	
  assign carry = carry_out[n-1];
  //assign sum[n] = carry_out[n-1];
  //endgenerate	
endmodule

module subtractor(num1,num2,sub);   //subtractor
	input [7:0] num1,num2;
	output [7:0]sub;
	wire [7:0] inum2;
	wire cout;
	assign inum2[0] = ~num2[0];
	assign inum2[1] = ~num2[1];
	assign inum2[2] = ~num2[2];
	assign inum2[3] = ~num2[3];
	assign inum2[4] = ~num2[4];
	assign inum2[5] = ~num2[5];
	assign inum2[6] = ~num2[6];
	assign inum2[7] = ~num2[7];
	wire [7:0] q;
	full_adder fa1(num1[0],inum2[0],1'b1,sub[0],q[0]);
	full_adder fa2(num1[1],inum2[1],q[0],sub[1],q[1]);
	full_adder fa3(num1[2],inum2[2],q[1],sub[2],q[2]);
	full_adder fa4(num1[3],inum2[3],q[2],sub[3],q[3]);
	full_adder fa5(num1[4],inum2[4],q[3],sub[4],q[4]);
	full_adder fa6(num1[5],inum2[5],q[4],sub[5],q[5]);
	full_adder fa7(num1[6],inum2[6],q[5],sub[6],q[6]);
	full_adder fa8(num1[7],inum2[7],q[6],sub[7],cout);

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





//testbench

module tb_multi();
reg [7:0]num1;
reg [7:0]num2;
wire [15:0]prod;

booth_multiplier i_booth_multiplier(.num1(num1),.num2(num2),.prod(prod));

initial 
  begin
    num1 <= 8'h00;
    num2 <= 8'h00;
   
   #5
    num1 <= 8'h1;
    num2 <= 8'h1;
    #5
    num1 <= 8'ha;
    num2 <= 8'h1;
    #5
    num1 <= 8'h9;
    num2 <= 8'h1;
    #5
    num1 <= 8'h5;
    num2 <= 8'h1;
    #5
    num1 <= 8'h5;
    num2 <= 8'ha;
    #5
    num1 <= 8'h6;
    num2 <= 8'ha;
    #5
    num1 <= 8'ha;
    num2 <= 8'hb;
    #5
    num1 <= 8'hf;
    num2 <= 8'hf;
    #5
    $finish;
  end

endmodule