
//==============================================================================
// generic Move to other position
//==============================================================================

module movement
  (clk,reset,active,break,change_InVec,iTrial,InVec);

   `include "Net_parameters.v"
      
 
	input clk,reset,active,break;
    input change_InVec;
	input [9:0] iTrial;
   // vector of inputs
   
   
   // output data
   output [Neurons_Layer1-1:0] InVec;
   reg    [Neurons_Layer1-1:0] InVec;
	
	wire   [Neurons_Layer1-1:0] StartingTrial;
	
	wire Start_points_ready;
	
   reg 	   [1:0]    Tmp;
	
	 StartPoint
	 #(.Neurons_Layer1(Neurons_Layer1))
   StartTrial
	(.clk(clk),
	 .reset (reset),
	 .active(~active),
	 .iTrial(iTrial),
	 .InVec(StartingTrial)
	 );
   
   always @(reset,break,change_InVec,StartingTrial)
     begin
	  
	 if ((reset || break) && ~change_InVec) begin
	   InVec=StartingTrial;
	   //InVec=6'b100010;
		Tmp=2'b00; end 
	  
	 else if (change_InVec)
	  begin
		
		      Tmp = InVec[3-:2];
            InVec[3-:2] = InVec[1-:2];
            InVec[1-:2] = Tmp;
            // Then percept changes too.
            InVec[4] = InVec[5];
            InVec[5] = ~InVec[4];end	
	   
	  
	    // InVec_next = data_out + data_in[i*buffer_size +: buffer_size];
	  else 
		      InVec = InVec;
	  
     end
   
endmodule