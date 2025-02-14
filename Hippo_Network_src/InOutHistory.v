
//==============================================================================
// generic Save in History
//==============================================================================

module InOutHistory
  (clk,reset,break,change_InVec,OutVecH,OutVec,InVec, HippoVec,nHstCount,OutVecHst,InVecHst,HippoVecHst);

   // width of each input

      `include "Net_parameters.v"
     
   
   // vector of inputs
   
   input clk,reset;
   wire clk,reset;
	
	input break;
	wire  break;
   
	input change_InVec;
	wire change_InVec;
	
	input [Neurons_Layer3-1:0] OutVecH;
	
	input [Neurons_Layer3-1:0] OutVec;
	
	input [Neurons_Layer1-1:0] InVec;
	
	input  [Neurons_Layer2-1:0]  HippoVec;

   input  nHstCount;
   wire  nHstCount;
	   // output data
	//output nHstCount;
	//reg nHstCount=1'b0;
	
   output   [nHist*Neurons_Layer1-1:0] InVecHst;
   reg      [nHist*Neurons_Layer1-1:0] InVecHst={nHist*Neurons_Layer1{1'b0}};
	
	output  [nHist*Neurons_Layer3-1:0] OutVecHst;
	reg     [nHist*Neurons_Layer3-1:0] OutVecHst={nHist*Neurons_Layer3{1'b0}};
	
	output  [nHist*Neurons_Layer2-1:0] HippoVecHst;
	reg     [nHist*Neurons_Layer2-1:0] HippoVecHst={nHist*Neurons_Layer2{1'b0}};
	
	reg 	       Hst_reset;
   
  always @(posedge clk)
  begin
  if (reset)
  begin
	      //nHstCount=1'b0;
		    InVecHst={{(nHist-1)*Neurons_Layer1{1'b0}},InVec};
			OutVecHst={nHist*Neurons_Layer3{1'b0}};
			HippoVecHst={nHist*Neurons_Layer2{1'b0}};
			Hst_reset=1'b0;    end
	  
 else
	 case(break)
	 1'b0:
			case(Hst_reset) 
			1'b0:	begin
				//nHstCount=1'b0;
				InVecHst={{(nHist-1)*Neurons_Layer1{1'b0}},InVec};
				OutVecHst={nHist*Neurons_Layer3{1'b0}};
				HippoVecHst={nHist*Neurons_Layer2{1'b0}};
				Hst_reset=1'b1;end
		
			1'b1: 	
					case (nHstCount)
					1'b0:begin
								
								OutVecHst[nHist*Neurons_Layer3-1 -:Neurons_Layer3]= (OutVecH)?  OutVecH : OutVecHst[nHist*Neurons_Layer3-1 -:Neurons_Layer3]; 
								//OutVecHst[Neurons_Layer3-1:0]=(change_InVec)?  OutVecH: OutVecHst[Neurons_Layer3-1:0];
								
								InVecHst =  { InVecHst[nHist*Neurons_Layer1-1 -:Neurons_Layer1], InVec };
								
								HippoVecHst[Neurons_Layer2-1:0]= (HippoVec)? HippoVec:HippoVecHst[Neurons_Layer2-1:0];
								
							
								//nHstCount=(change_InVec)?1'b1:nHstCount;
								end
					
					1'b1:begin
								
								OutVecHst[Neurons_Layer3-1:0]=(OutVecH)?  OutVecH: OutVecHst[Neurons_Layer3-1:0];
								//OutVecHst[nHist*Neurons_Layer3-1 -:Neurons_Layer3]= (change_InVec)?  OutVecH : OutVecHst[nHist*Neurons_Layer3-1 -:Neurons_Layer3]; 
							
								InVecHst =  { InVec , InVecHst[Neurons_Layer1-1 -:Neurons_Layer1]};
								
								HippoVecHst[nHist*Neurons_Layer2-1 -: Neurons_Layer2]= (HippoVec)? HippoVec : HippoVecHst[nHist*Neurons_Layer2-1 -: Neurons_Layer2];
							
								//nHstCount=(change_InVec)?1'b0:nHstCount; 
								end
				   endcase
			endcase
	 1'b1:	begin
			Hst_reset=1'b0;
			
			OutVecHst = (nHstCount)?{OutVecH,OutVecHst[Neurons_Layer3-1:0]} : {OutVecHst[nHist*Neurons_Layer3-1 -:Neurons_Layer3],OutVecH};
			/*case (nHstCount)
					1'b0:
						OutVecHst[Neurons_Layer3-1:0]=(OutVecH)?  OutVecH: OutVecHst[Neurons_Layer3-1:0];
					1'b1:
			   		OutVecHst[nHist*Neurons_Layer3-1 -:Neurons_Layer3]= (OutVecH)?  OutVecH : OutVecHst[nHist*Neurons_Layer3-1 -:Neurons_Layer3];
			endcase*/
			end
	endcase
				  
     end
   
endmodule