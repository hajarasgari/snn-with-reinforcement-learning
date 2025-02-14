
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:22:12 04/10/2018 
// Design Name: 
// Module Name:    Experiment 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////
module Experiment(clk,run,reset_lfsr_weight,OutVec
    ); 
    
`include "Net_parameters.v"

input clk,run;

output  [Neurons_Layer3-1:0] OutVec;

reg reset;

input reset_lfsr_weight;

reg active;

reg write_percorrect;

reg iTrial_ctrl;

reg ctrl_iRun;

reg  [9:0] iTrial;

wire break;

wire finish_replay_phase;

wire  change_InVec;

wire  [Neurons_Layer1-1:0] InVec;

reg   PerCorrect  [0:nTrial-1];

reg   The_end_of_the_experiment;

wire  rewarded;

integer iRun;

integer f,ff,jj,ii;



		  always @(posedge clk ) begin
		  case (run)
		  1'b0: begin 
					ff = $fopen("Run_Output.txt","w");
					iRun=0;
					active = 1'b0;
				    iTrial_ctrl=1'b0;
					ctrl_iRun=1'b0;
					//reset_lfsr_weight<=1'b1;
					iTrial={10{1'b0}};
					write_percorrect=1'b0;
					//reset_lfsr_weight=1'b1;
					reset=1'b1;
					The_end_of_the_experiment=1'b0;end
		  1'b1:
				//reset<=1'b0;
				case (reset)
				1'b1: begin
							active = 1'b0;
							iTrial_ctrl=1'b0;
							if (iRun<nRun) begin
							//if (iTrial<=10'b0100000110) begin
									iRun=iRun+1;
									reset<=1'b0;
							        iTrial={10{1'b0}};
							        write_percorrect=1'b0;
									The_end_of_the_experiment=1'b0;end
							else begin
									iRun=iRun;
									The_end_of_the_experiment=1'b1;
									reset=1'b1;
									iTrial={10{1'b0}};
									ctrl_iRun=1'b1;
									write_percorrect=1'b1;
									//reset_lfsr_weight=1;
									$fclose(ff); 
									end
								
						end
						
				1'b0: begin
							//change_weights<=0;
							
							if (iTrial<2*nTrial) begin
								reset=1'b0;
								iTrial_ctrl=active & finish_replay_phase;
								active =(iTrial_ctrl)? 1'b0:1'b1;
								PerCorrect[iTrial/2]=rewarded;	
								iTrial=(iTrial_ctrl)?iTrial+10'b0000000001:iTrial;end
							else begin
								reset=1'b1;
								active = 1'b0;
								iTrial_ctrl=1'b0;
								write_percorrect=1'b1;// faghat baraie raster plot_run=1
								for (jj = 0; jj<nTrial; jj=jj+1) begin
										$fwrite (ff,"%b\n"     , PerCorrect[jj]);
								end
							end
							/*
							if (write_percorrect) begin
								f = $fopen("output.txt","w");
								for (ii = 0; ii<nTrial; ii=ii+1) begin
								
								$display("rewarded %b",PerCorrect[ii]);
								$fwrite (f,"%b\n"     , PerCorrect[ii]);
								end
							$fclose(f); 
							
							end*/
						end
				endcase
			endcase
		  end
		  
		  	 
		 initial begin
   		 f = $fopen("output.txt","w");
				
				@(posedge write_percorrect )
				
				for (ii = 0; ii<nTrial; ii=ii+1) begin
			   	$display("rewarded %b",PerCorrect[ii]);
					$fwrite (f,"%b\n"     , PerCorrect[ii]);
				end
				$fclose(f);  
		   end
			

		Hippocampal_Network
		#(.Neurons_Layer1(Neurons_Layer1),
		  .Neurons_Layer2(Neurons_Layer2),
		  .Neurons_Layer3(Neurons_Layer3))
		  
		Item1   
		(.clk(clk),
		 .run(run),
		 .reset(reset),
		 .reset_lfsr_weight(reset_lfsr_weight),
		 .active(active),
		 .break(break),
		 .finish_replay_phase(finish_replay_phase),
		 .change_InVec(change_InVec),
		 .iTrial(iTrial),
		 .ctrl_iRun(ctrl_iRun),
		 .iRun(iRun),
		 .write_percorrect(write_percorrect),
		 .rewarded(rewarded),
		 .InVec(InVec),
		 .OutVec(OutVec),
		 .The_end_of_the_experiment(The_end_of_the_experiment));


		movement
		#(.Neurons_Layer1(Neurons_Layer1))
		
		changePosition
		(.clk(clk),
		 .reset(reset),
		 .active(active),
		 .break(break),
		 .change_InVec(change_InVec),
		 .iTrial(iTrial),
		 .InVec(InVec));   
	


endmodule
