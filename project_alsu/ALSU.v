
module ALSU (
input [2:0] A, B, opcode,
input cin, serial_in, direction,
input red_op_A, red_op_B,
input bypass_A, bypass_B,
input CLK, RST_n,
output reg [5:0] out,
output reg [15:0] leds
);
reg[3:0]counter;
reg done;
reg [3:0]current_state,next_state;
parameter INPUT_PERIORITY="A",FULL_ADDER="ON";


////////////////////////////////////////////////////////////
///////   make  all inputs & outputs registered    ////////
///////////////////////////////////////////////////////////


reg [2:0] A_internal, B_internal, opcode_internal;
reg cin_internal, serial_in_internal, direction_internal;
reg red_op_A_internal, red_op_B_internal;
reg bypass_A_internal, bypass_B_internal;
reg [5:0] out_internal;
reg [15:0] leds_internal;


/////////////////////////////////////////////////////////
////////////////   state_encoding     ///////////////////
///////////////////////////////////////////////////////

localparam AND=0,XOR=1,ADD=2,MULTIPLY=3,SHIFT=4,ROTATE=5,INVALID=6,RED_A=7,RED_B=8,BYPASS_A=9,BYPASS_B=10,IDLE=11;


 
//////////////////////////////////////////////////////////
/////////////      state_memory       ////////////////////
//////////////////////////////////////////////////////////

always@(posedge CLK ,negedge RST_n)
begin
  if(!RST_n)
    
   
    current_state<=IDLE;  //s11 is the idle state
    
  else
    
     current_state<=next_state;
     red_op_A_internal<=red_op_A;
     red_op_B_internal<=red_op_B;
     bypass_A_internal<=bypass_A;
     bypass_B_internal<=bypass_B;
     A_internal<=A;
     B_internal<=B;
     opcode_internal<=opcode;
     cin_internal <=cin;
     serial_in_internal<= serial_in;
     direction_internal<=direction;
     out<=out_internal;
     leds<=leds_internal;

     
   

end

//////////////////////////////////////////////////////////
///////////     next_state_logic     /////////////////////
//////////////////////////////////////////////////////////

always@(*)
begin     
case(current_state)
AND,XOR,ADD,MULTIPLY,SHIFT,ROTATE,INVALID,RED_A,RED_B,BYPASS_A,BYPASS_B,IDLE:
begin
        
if((red_op_A_internal || red_op_B_internal ) && ((opcode_internal!=0) && (opcode_internal!=1 )) )

next_state=INVALID;
                 
          
else if( bypass_A_internal && bypass_B_internal)
begin
      
         if(INPUT_PERIORITY=="A")
      
            next_state=BYPASS_A;

          else 
            next_state=BYPASS_B; 
end
            
else if(bypass_A_internal) 
begin
    
    next_state=BYPASS_A;
end
                    
else if(bypass_B_internal)
begin
    
    next_state=BYPASS_B; 
end
                     
else if(red_op_A_internal && red_op_B_internal)
begin
      
         if(INPUT_PERIORITY=="A")
              next_state=RED_A;
           else 
              next_state=RED_B;              
end
              
else if(red_op_A_internal) 
begin
    next_state=RED_A;  
end   
 
                      
else if (red_op_B_internal)   
begin    
    next_state=RED_B;    
end 

                             
else  
begin
       
              case(opcode_internal)
                  3'b000:
                    next_state=AND;
                  3'b001:
                    next_state=XOR;
                  3'b010:
                    next_state=ADD;
                  3'b011:
                    next_state=MULTIPLY;
                  3'b100:
                    next_state=SHIFT;
                  3'b101:
                    next_state=ROTATE;
                  3'b110:
                    next_state=INVALID;
                 3'b111:
                    next_state=INVALID;
               endcase
               
end
          
end

endcase
  
end
//////////////////////////////////////////////////////////
///////////    output_logic          /////////////////////
//////////////////////////////////////////////////////////

always@(*)
begin
  leds_internal=0;
case(current_state) 
  
AND:
     out_internal=(A_internal) & (B_internal); 

XOR:

   out_internal=(A_internal) ^ (B_internal);

ADD:
begin
    if(FULL_ADDER=="ON")
      
        out_internal= (cin_internal) + (A_internal) + (B_internal);
        
    else if(FULL_ADDER=="OFF")
      
        out_internal=A_internal+B_internal;
end


MULTIPLY:
     
        out_internal=(A_internal) * (B_internal);


SHIFT:
/////shift
   
if (direction_internal) 
    
    out_internal = {out_internal[4:0],serial_in_internal};
                     
else 
  
   out_internal = {serial_in_internal, out_internal[5:1]}; 
  
   
ROTATE: begin
   ////rotate

          if(direction_internal)
             out_internal={out_internal[4:0],out_internal[5]};
          else
             out_internal={out_internal[0],out_internal[5:1]};
        end



INVALID: begin
       
          out_internal=0;
          leds_internal=1; 
          end

RED_A: begin
        
           if(opcode_internal==3'b000)
              out_internal= &(A_internal);
            else if(opcode_internal==3'b001)
                 out_internal= ^(A_internal);
        end


RED_B: begin
          if(opcode_internal==0)
                out_internal=&(B_internal);
          else if(opcode_internal==1)
                out_internal= ^(B_internal);
       end 
 
BYPASS_A:
     out_internal=A_internal ;
 
BYPASS_B:
      out_internal=B_internal ;
  
IDLE: begin
       out_internal=0;
       leds_internal=0;
      end
      
 endcase
end


endmodule
