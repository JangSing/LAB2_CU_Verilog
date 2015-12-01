module LAB2_CU(
  input   [7:5]IR,
  input   Aeq0,Apos,Enter,Clk,Reset,
  output IRload,JMPmux,PCload,Meminst,MemWr,Aload,Sub,Halt,
  output reg [1:0]Asel,
  output [3:0]stateOut
  );
  
  reg       [7:0]AllOut;
  reg       [3:0]next_state,state;
  parameter START=4'b0000, FETCH=4'b0001, DECODE=4'b0010;  
  parameter LOAD=4'b1000, STORE=4'b1001, ADD=4'b1010;
  parameter SUB=4'b1011, INPUT=4'b1100, JZ=4'b1101, JPOS=4'b1110, HALT=4'b1111;
  assign {IRload,JMPmux,PCload,Meminst,MemWr,Aload,Sub,Halt}=AllOut;
  
  assign stateOut=state;
  
  always@(posedge Clk, posedge Reset)
   begin
    if(Reset)
      state<=START;
    else 
      state<=next_state;
   end 
   
  always@(state,IR,Aeq0,Apos)
   begin
    
    case(state)
      START:
       begin
        AllOut=8'b00000000;
        Asel=2'b00;
        next_state=FETCH; 
       end
       
      FETCH:
       begin
        AllOut=8'b10100000;
        Asel=2'b00;
        next_state=DECODE;       
       end
       
      DECODE:
       begin
        AllOut=8'b00010000;
        Asel=2'b00;
        case(IR)
          3'b000  :next_state=LOAD;   
          3'b001  :next_state=STORE;   
          3'b010  :next_state=ADD;   
          3'b011  :next_state=SUB;   
          3'b100  :next_state=INPUT;   
          3'b101  :next_state=JZ;   
          3'b110  :next_state=JPOS;   
          3'b111  :next_state=HALT;
          default :next_state=DECODE;    
         endcase
        end
        
      LOAD:
       begin
        AllOut=8'b00000100;
        Asel=2'b10;
        next_state=START;    
       end 
       
      STORE:
       begin
        AllOut=8'b00011000;
        Asel=2'b00;
        next_state=START;    
       end 
       
      ADD:
       begin
        AllOut=8'b00000100;
        Asel=2'b00;
        next_state=START; 
       end    
            
      SUB:
       begin
        AllOut=8'b00000110;
        Asel=2'b00;
        next_state=START; 
       end   
                     
      INPUT:
       begin
        AllOut=8'b00000100;
        Asel=2'b01;
        if(Enter)
          next_state=START; 
        else
          next_state=INPUT; 
       end   
                             
      JZ:
       begin
        if(Aeq0)
          AllOut=8'b01100000;        
        else
          AllOut=8'b01000000;
        Asel=2'b00;
        next_state=START; 
       end  
                              
      JPOS:
       begin
        if(Apos)
          AllOut=8'b01100000;        
        else
          AllOut=8'b01000000;      
        Asel=2'b00;
        next_state=START; 
       end 
                               
      HALT:
       begin
        AllOut=8'b00000001;
        Asel=2'b00;
        next_state=HALT; 
       end
       
    endcase 
    end 
  
  endmodule 