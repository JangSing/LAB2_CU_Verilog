module LAB2_CU_tb();
  reg   [7:5]IR;
  reg   Aeq0,Apos,Enter,Clk,Reset;
  wire  IRload,JMPmux,PCload,Meminst,MemWr,Aload,Sub,Halt;
  wire  [1:0]Asel;
  wire  [3:0]stateOut;

  wire IRload_st, JMPmux_st, PCload_st, Meminst_st, MemWr_st, Aload_st, Sub_st, Halt_st;
  wire [1:0] Asel_st;
  wire [3:0] outState_st;
  
  
  
  integer i;
  
  initial
    begin 
      IR=3'b000;
      Clk=0;
      {Aeq0,Apos,Enter,Reset}=4'b0001;
      #2  Reset=0;
      
      for(i=0;i<8;i=i+1)
      begin 
      #16;
      
      IR=IR+3'b001;
      end
      
      
    end 
    
    always #1 {Aeq0,Apos,Enter}=~{Aeq0,Apos,Enter};
    always #2 Clk=~Clk;
    
    LAB2_CU CUtest_JS(IR,Aeq0,Apos,Enter,Clk,Reset,IRload,JMPmux,PCload,Meminst,MemWr,Aload,Sub,Halt,Asel,stateOut);
    
    uP_CU CUtest_Steven(Reset,Clk,IR,Aeq0,Apos,Enter,IRload_st,JMPmux_st,PCload_st,Meminst_st,MemWr_st,Aload_st,Sub_st,Halt_st,Asel_st,outState_st);

    always #1 
      begin 
        if({IRload,JMPmux,PCload,Meminst,MemWr,Aload,Sub,Halt,Asel,stateOut}==
            {IRload_st,JMPmux_st,PCload_st,Meminst_st,MemWr_st,Aload_st,Sub_st,Halt_st,Asel_st,outState_st})
          $display("SimulationTime %t : The result for JS and Steven matches",$time);
          
        else
          begin
            $display("SimulationTime %t : The result for JS and Steven does not match",$time);
            $finish;
          end
          
      end
    
    

    
    
    endmodule 
    