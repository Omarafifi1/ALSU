`timescale 1ns / 1ps

module ALSU_tb;

reg [2:0] A_tb, B_tb, opcode_tb;
reg cin_tb, serial_in_tb, direction_tb;
reg red_op_A_tb, red_op_B_tb;
reg bypass_A_tb, bypass_B_tb;
reg CLK_tb,RST_n_tb ;
wire [5:0] out_tb;
wire [15:0] leds_tb;



ALSU dut(

.A(A_tb), 
.B(B_tb), 
.opcode(opcode_tb),
.cin(cin_tb),
.serial_in(serial_in_tb), 
.direction(direction_tb),
.red_op_A(red_op_A_tb), 
.red_op_B(red_op_B_tb),       
.bypass_A(bypass_A_tb),
.bypass_B(bypass_B_tb),       
.CLK(CLK_tb),
.RST_n(RST_n_tb),               
.out(out_tb), 
.leds(leds_tb)
);


localparam T=10;
always
begin
  CLK_tb=0;
  #(T / 2);
  CLK_tb=1;
  #(T / 2);
end

initial
begin
RST_n_tb=0;
#2;
RST_n_tb=1;
end


initial
begin 
 red_op_A_tb=0;
 red_op_B_tb=0;
 bypass_A_tb=0;
 bypass_B_tb=0;
 #160;

 red_op_A_tb=0;
 red_op_B_tb=1;
 bypass_A_tb=1;
 bypass_B_tb=1;
 #80;
 
 red_op_A_tb=1;
 red_op_B_tb=1;
 bypass_A_tb=0;
 bypass_B_tb=0;
 #80;
 
 red_op_A_tb=0;
 red_op_B_tb=0;
 bypass_A_tb=1;
 bypass_B_tb=1;
 #80;
 
 red_op_A_tb=0;
 red_op_B_tb=1;
 bypass_A_tb=0;
 bypass_B_tb=0;
 #80;
 
 red_op_A_tb=1;
 red_op_B_tb=0;
 bypass_A_tb=0;
 bypass_B_tb=0;
 #80;
 
 red_op_A_tb=0;
 red_op_B_tb=0;
 bypass_A_tb=1;
 bypass_B_tb=0;
 #80;
 
  
 red_op_A_tb=0;
 red_op_B_tb=0;
 bypass_A_tb=0;
 bypass_B_tb=1;
 #80;
 
 red_op_A_tb=1;
 red_op_B_tb=1;
 bypass_A_tb=1;
 bypass_B_tb=1;
#80;
end


initial
begin
serial_in_tb=0;
direction_tb =0;
cin_tb=0;
#80;
serial_in_tb=1;
direction_tb=1;
cin_tb=1;
end


initial 
begin 
A_tb=110;
B_tb=011;
#800;
$stop;
end
 
integer i,j;
initial
begin
opcode_tb=0;
#10;
 for(j=0;j<10;j=j+1)
   begin
      for(i=0;i<8;i=i+1)
         begin
           opcode_tb=opcode_tb+1;
           #10;
         end
    end      
end
endmodule











