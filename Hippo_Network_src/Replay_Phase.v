module Replay_Phase(clk, reset,rewarded,InVecHst,HippoVecHst,OutVecHst,NetworkOutput,Iin_replay_phase,learning_rest,start_replay_phase,finish_replay_phase);
//module Replay_Phase(clk, reset,rewarded,InVecHst,HippoVecHst,OutVecHst,NetworkOutput,Tpre_W12_array,Iin_replay_phase_out);

///////////////////////

`include "Net_parameters.v"



parameter [4:0] nHistory=5'b00110;
//parameter [4:0] nHistory=5'b11111;

parameter nWindow = 16'b0000000000001010;



/////////////////////////

input  clk;

input reset;//~break

input rewarded;

input [nHist*Neurons_Layer1-1:0] InVecHst;

input [nHist*Neurons_Layer2-1:0] HippoVecHst;

input [nHist*Neurons_Layer3-1:0] OutVecHst;

input [Num_Neurons-1:0] NetworkOutput;


//////////////////////////////////////////////
output   [buffer_size*Num_Neurons-1:0] Iin_replay_phase;
reg      [buffer_size*Num_Neurons-1:0] Iin_replay_phase;


output finish_replay_phase;
reg    finish_replay_phase;

output learning_rest;	
reg learning_rest;	

reg    start_replay_phase;
output    start_replay_phase;


///////////////////////////////////////
reg [Neurons_Layer1-1:0] InVec;

reg [Neurons_Layer3-1:0] OutVec;

reg [Neurons_Layer2-1:0] HippoVec;

//wire rewarded;

reg [Neurons_Layer1*buffer_size-1:0] Iin_Layer1;

reg [Neurons_Layer2*buffer_size-1:0] Iin_Layer2;

reg [Neurons_Layer3*buffer_size-1:0] Iin_Layer3;


reg [buffer_Time-1:0] iTime;
reg In_Neurons;

reg [buffer_Time-1:0] T1 [0:Neurons_Layer1-1] ;
reg [buffer_Time-1:0] T2 [0:Neurons_Layer2-1] ;
reg [buffer_Time-1:0] T3 [0:Neurons_Layer3-1] ;

reg [4:0] StackT1 [0:Neurons_Layer1-1] ;
reg [4:0] StackT2 [0:Neurons_Layer2-1] ;
reg [4:0] StackT3 [0:Neurons_Layer3-1] ;



integer  iHist,l1,l2,l3;
integer iIn,iHipp,iOut;



generate
always @(posedge clk)
begin
	    if (In_Neurons ) begin
	   	//iTime=0;
		   Iin_replay_phase={Num_Neurons*buffer_size{1'b0}};
		   {Iin_Layer3,Iin_Layer2,Iin_Layer1}={Num_Neurons*buffer_size{1'b0}};
		   InVec={Neurons_Layer1{1'b0}}; 	
		   HippoVec={Neurons_Layer2{1'b0}};	
		   OutVec={Neurons_Layer3{1'b0}};	
			end 
	    else 
		 begin
			// Replay the sequence with the last 1+nHistCount steps.
						
				InVec=InVecHst[(iHist+1)*Neurons_Layer1-1 -:Neurons_Layer1];
    			HippoVec=HippoVecHst[(iHist+1)*Neurons_Layer2-1 -:Neurons_Layer2];
				OutVec=OutVecHst[(iHist+1)*Neurons_Layer3-1 -:Neurons_Layer3];
		 
				//iTime=iTime+1;
				
			case (rewarded)
				1'b0:begin
					
					for (l1=0;l1<Neurons_Layer1;l1=l1+1)begin:a
						if (InVec[l1]) 
							Iin_Layer1[(l1+1)*buffer_size-1 -:buffer_size]=I_sensory_NR;
						else 
						   Iin_Layer1[(l1+1)*buffer_size-1 -:buffer_size]={buffer_size{1'b0}};    end
					
					for (l2=0;l2<Neurons_Layer2;l2=l2+1)begin:b				
						if (HippoVec[l2])
							Iin_Layer2[(l2+1)*buffer_size-1 -:buffer_size]=I_hippo_NR;
						else
						   Iin_Layer2[(l2+1)*buffer_size-1 -:buffer_size]={buffer_size{1'b0}};    end
					
					for (l3=0;l3<Neurons_Layer3;l3=l3+1)begin:c				
						if (OutVec[l3])
							Iin_Layer3[(l3+1)*buffer_size-1 -:buffer_size]=I_motor_NR;
						else
							Iin_Layer3[(l3+1)*buffer_size-1 -:buffer_size]={buffer_size{1'b0}};	  end					
				
				end
				1'b1:begin
					for (l1=0;l1<Neurons_Layer1;l1=l1+1)begin:aa
						if (InVec[l1]) 
							Iin_Layer1[(l1+1)*buffer_size-1 -:buffer_size]=I_sensory_R;
						else 
						   Iin_Layer1[(l1+1)*buffer_size-1 -:buffer_size]={buffer_size{1'b0}};     end
					
					for (l2=0;l2<Neurons_Layer2;l2=l2+1)begin:bb				
						if (HippoVec[l2])
							Iin_Layer2[(l2+1)*buffer_size-1 -:buffer_size]=I_hippo_R;
						else
						   Iin_Layer2[(l2+1)*buffer_size-1 -:buffer_size]={buffer_size{1'b0}};  	end
					
					for (l3=0;l3<Neurons_Layer3;l3=l3+1)begin:cc				
						if (OutVec[l3])
							Iin_Layer3[(l3+1)*buffer_size-1 -:buffer_size]=I_motor_R;
						else
							Iin_Layer3[(l3+1)*buffer_size-1 -:buffer_size]={buffer_size{1'b0}};	   end
				   end
				
					
			endcase
		end
	
		 Iin_replay_phase= start_replay_phase ? {Iin_Layer3,Iin_Layer2,Iin_Layer1}: {Num_Neurons{1'b0}};	
		
		end

	
always @(posedge clk)
begin
		 if (reset ) 
		    begin
				iTime={buffer_Time{1'b0}};
				start_replay_phase=1'b0;
   			    finish_replay_phase=1'b0;
				iHist=0;	
				In_Neurons=1'b1;
				learning_rest=1'b0;
		    end
		 else
		  In_Neurons=1'b0;
		  learning_rest=1'b0;
	  		if (iTime>nWindow) begin
				start_replay_phase=1'b1;  
		      if (iTime>=nTimeReplay) begin
						finish_replay_phase=(iHist==1)?1'b1:1'b0;
						iHist=(iHist==0)?1:0;
						start_replay_phase=1'b0;
						iTime={buffer_Time{1'b0}};
						In_Neurons=1'b1;
						learning_rest=1'b1;end
			   else 			
						iTime=iTime+one;
		   end
		   else	
			   iTime=iTime+one;  
end
	
///////////save Pre and Post Spikes times for nHistory time
	
		
  endgenerate	
endmodule
