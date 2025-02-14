module Hippocampal_Network(clk,
		 run,
		 reset,
		 reset_lfsr_weight,
		 active,
		 break,
	    finish_replay_phase,
		 change_InVec,
		 iTrial,
		 ctrl_iRun,
		 iRun,
		 write_percorrect,
		 rewarded,
		 InVec,
		 OutVec,
		 The_end_of_the_experiment);

input clk;
wire clk;

input reset,active;
wire reset,active;
input run;
wire run;
input reset_lfsr_weight;
wire reset_lfsr_weight;
input  The_end_of_the_experiment;
wire  The_end_of_the_experiment;
output finish_replay_phase;

output break;
wire break;
input write_percorrect;
wire write_percorrect;
//output   finish_replay_phase;

output change_InVec;
wire change_InVec;

output rewarded;
wire   rewarded;


wire   en_initializing;


input [Neurons_Layer1-1:0] InVec;

wire [9:0] iRun;

output [Neurons_Layer3-1:0] OutVec;

//output [buffer_size-1:0] weight_exampel1;
wire [buffer_size-1:0] weight_exampel1;

//output [buffer_size-1:0] weight_exampel2;
wire [buffer_size-1:0] weight_exampel2;

//output [Num_Neurons-1:0] NetworkOutput;
wire   [Num_Neurons-1:0] NetworkOutput;

//output [1:0] State1 ;
wire [1:0] State1 ;

//output [1:0] State2 ;
wire [1:0] State2 ;

input  [9:0] iTrial;
wire   [9:0] iTrial;

reg    ctrl_iTrial;

wire   finish_replay_phase;

input  ctrl_iRun;
wire   ctrl_iRun;
input  [9:0] iRun;

////////////////Parameters/////////////////////////////////////
`include "Net_parameters.v"
	
parameter dtWindow=10;

parameter nMaxTime= 1200;

parameter nMaxSample= 100;

parameter [4:0] nHistory=5'b01010;

wire [Num_Neurons*buffer_size-1:0] noise_array;

/////////////////////////////////////////////////////////
/////Registers and nets definition////////////////////
//////////////////////////////////////////////////////

wire  [Neurons_Layer2-1:0] HippoVec;

wire  [buffer_size-1:0] W [0:Num_Neurons-1][0:Num_Neurons-1];

wire  [buffer_size-1:0] W12_init [0:Neurons_Layer1-1][0:Neurons_Layer2-1];

reg   [buffer_size-1:0] W12_previous [0:Neurons_Layer1-1][0:Neurons_Layer2-1];

wire  [buffer_size-1:0] W23_init [0:Neurons_Layer2-1][0:Neurons_Layer3-1];

reg   [buffer_size-1:0] W23_previous      [0:Neurons_Layer2-1][0:Neurons_Layer3-1];

wire  [buffer_size*Num_Neurons-1:0] Synapses [0:Num_Neurons-1];

wire  [Num_Neurons*Num_Neurons*buffer_size-1:0] Synapses_value;

reg   [buffer_size-1:0] Vj_previous [0:Num_Neurons-1];

wire  [buffer_size-1:0] V_mem [0:Num_Neurons-1];

wire  [buffer_size-1:0] V_mem_n [0:Num_Neurons-1];

wire  Raster_Plot [0:Num_Neurons-1];

wire  Just_noise [0:Num_Neurons-1];

reg   [Neurons_Layer1-1:0] InVecR;

wire   rest;//

wire  [Num_Neurons*buffer_size-1:0] Iinvector;//

wire  [Num_Neurons*buffer_size-1:0] Iin_first_phase;//

wire  [Num_Neurons*buffer_size-1:0] Iin_replay_phase;//

reg   [buffer_size*Neurons_Layer1-1:0] IinLayer1 ;//

wire  [buffer_size*Neurons_Layer2-1:0] IinLayer2 ;//

wire  [buffer_size*Neurons_Layer3-1:0] IinLayer3 ;//

wire  [nHist*Neurons_Layer1-1:0] InVecHst;//

wire  [nHist*Neurons_Layer2-1:0] HippoVecHst;//

wire  [nHist*Neurons_Layer3-1:0] OutVecHst;//

wire  [Neurons_Layer1-1:0] InVec_Replay;//

reg   break_dly;

wire  dig;

integer m,n,h;
generate
genvar i,j,k,l;
genvar l1,l2,l3;
genvar l4,l5,l6;
genvar iHipp,iOut;
integer o,p,q,oo,pp;

//////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////Control unit///////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

 
	
 first_phase
# (.Neurons_Layer1(Neurons_Layer1),
   .Neurons_Layer3(Neurons_Layer3),
   .buffer_Time(10))
	FirstPhase
	(.clk(clk),
	 .run(run),
	 .reset(reset),
	 .active(active),
	 .write_percorrect(write_percorrect),
	 .iTrial(iTrial),
	 .iRun(iRun),
	 .OutVec(OutVec),
	 .HippoVec(HippoVec),
	 .InVec(InVec),
	 .ctrl_iRun(ctrl_iRun),
	 .break(break),
	 .dig(dig),
	 .change_InVec(change_InVec),
	 .InVecHst(InVecHst),
	 .HippoVecHst(HippoVecHst),
	 .OutVecHst(OutVecHst));
	 
	always @ (posedge clk) begin
			break_dly = break;
	end  
	
	assign dig = break & ~break_dly;
	assign rest= change_InVec | dig | learning_rest;
	 
	 always @(OutVecHst,break)
	 begin
		if (break) begin
		    InVecR=(OutVecHst[1:0]==2'b01)?InVecHst[5:0]:((OutVecHst[3:2]==4'b01)?InVecHst [11:6]:6'b0);		  
			end
		else
			InVecR=6'b0;
			
	 end 
	 assign rewarded=(InVecR[0] & InVecR[4]) | (InVecR[2] & InVecR[4]) | (InVecR[1] & InVecR[5]) | (InVecR[3] & InVecR[5]);
	
	
	 wire start_replay_phase;
	 wire learning_rest;
	 Replay_Phase   
	 # (.buffer_size(buffer_size),
		.nHistory(nHistory))
		 ReplayPhase
		 (.clk(clk),
		  .reset(~break),
		  .rewarded(rewarded),
		  .InVecHst(InVecHst),
		  .HippoVecHst(HippoVecHst),
		  .OutVecHst(OutVecHst),
		  .NetworkOutput(NetworkOutput),
		  .Iin_replay_phase(Iin_replay_phase),
		  .learning_rest(learning_rest),
		  .start_replay_phase(start_replay_phase),
		  .finish_replay_phase(finish_replay_phase));            		  
		  
	
/////////////// Initial value for Synapses ///////////////////////////////////////
///////////////// Synaptic_Weight_array //////////////////////////////////////////
///////////////////////////  Matrix Initial Weight  //////////////////////////////
	Initializing_synapses #(.buffer_size(buffer_size),
							.Neurons_Layer1(Neurons_Layer1),
							.Neurons_Layer2(Neurons_Layer2),
							.Neurons_Layer3(Neurons_Layer3)) 
	Init_W
		(.clk(clk),
		 .reset(reset_lfsr_weight),
		 .active(en_initializing),
		 .Synapses_value(Synapses_value));
		 
  reg reset_dly;
  reg reset_dly2;
  always@(posedge clk)begin
         reset_dly=reset;
         reset_dly2=reset_dly;
         end
  
  
  

		 
////////////////////////////////////////////////////////////////////////////////////		
////////////////Static Weights nad initial plastic weights /////////////////////////
////////////////////////////////////////////////////////////////////////////////////

      wire [Num_Neurons*buffer_size-1:0] Sj_G [0 : Num_Neurons-1];
      wire [buffer_size-1:0] S_G [0 : Num_Neurons-1][0 : Num_Neurons-1];
      wire [Num_Neurons-1 : 0] W_ij [0 : Num_Neurons-1];


	   for (k=0; k<Num_Neurons; k=k+1)
		begin:Init_Weight_Matrix
			assign Synapses[k]=Synapses_value [((k+1)*buffer_size*Num_Neurons)-1 -: buffer_size*Num_Neurons];
			for (l=0; l<Num_Neurons; l=l+1)
			begin: Weight_matrix
			if ( (l<Neurons_Layer1) && (k>=Neurons_Layer1) && (k<Neurons_Layer1+Neurons_Layer2))
				assign W12_init [l][k-Neurons_Layer1]=Synapses [k][((l+1)*buffer_size)-1 -: buffer_size];
			else if ( (l>=Neurons_Layer1) && (l<Neurons_Layer1+Neurons_Layer2) && (k<Num_Neurons) &&(k>=Neurons_Layer1+Neurons_Layer2) )
				assign W23_init [l-Neurons_Layer1][k-Neurons_Layer1-Neurons_Layer2]=Synapses [k][((l+1)*buffer_size)-1 -: buffer_size];
			else
				assign S_G[l][k]=Synapses [k][((l+1)*buffer_size)-1 -: buffer_size];
			end
		end 

//--------------------------------------------------------
/////Plastic Weights 
//--------------------------------------------------------
assign en_initializing	= ~The_end_of_the_experiment & (reset | reset_dly2);    

  integer pr1,pr2,pr3,pr4;	
		always @(posedge clk)
	    if ( en_initializing==1'b1 ) begin
	     
			for( pr1=0; pr1<Neurons_Layer1;pr1=pr1+1)
			begin:plasticW12
				for( pr2=0; pr2<Neurons_Layer2;pr2=pr2+1)
				begin:Plastic_W12
					 W12_previous[pr1][pr2]=  (reset ==1'b1) ? W12_init[pr1][pr2] : W12_previous[pr1][pr2];
				end
			end
			
			for( pr3=0; pr3<Neurons_Layer2;pr3=pr3+1)
			begin:plasticW23
				for( pr4=0; pr4<Neurons_Layer3;pr4=pr4+1)
				begin:Plastic_W23
					 W23_previous[pr3][pr4]= (reset ==1'b1) ? W23_init[pr3][pr4] : W23_previous[pr3][pr4] ;
				end
			end			
			
			
			end
			
	    else		 begin	       
			

			for( pr1=0; pr1<Neurons_Layer1;pr1=pr1+1)
			begin:plastiicW12
				for( pr2=0; pr2<Neurons_Layer2;pr2=pr2+1)
				begin:Plastiic_W12
					 W12_previous[pr1][pr2]= S_G[pr1][pr2+Neurons_Layer1] ;
				end
			end
			
			for( pr3=0; pr3<Neurons_Layer2;pr3=pr3+1)
			begin:plastiicW23
				for( pr4=0; pr4<Neurons_Layer3;pr4=pr4+1)
				begin:Plastiic_W23
						W23_previous[pr3][pr4]= S_G[pr3+Neurons_Layer1][pr4+Neurons_Layer1+Neurons_Layer2] ;
				end
			end
				
	  end	
	  
	  
      genvar p1,p2,p3,p4;
	  for( p1=0; p1<Neurons_Layer1;p1=p1+1)
	  begin:plasticcW12
				for( p2=0; p2<Neurons_Layer2;p2=p2+1)
				begin:Plasticc_W12

		STDPmodel_4PWL
                                    #(.buffer_size(buffer_size),
                                      .buffer_Time(buffer_Time))
                                    PlasticW12
                                    ( .reset(reset),
                                      .clk(clk),
                                      .A_pre (Ai[p1]),
                                      .A_post(Ai[p2+Neurons_Layer1]),
                                      .start_replay_phase(start_replay_phase),
                                      .W_previous(W12_previous[p1][p2]),
                                      .W_new_o(S_G[p1][p2+Neurons_Layer1]));   
			   end
	 end
		
	  for( p3=0; p3<Neurons_Layer2;p3=p3+1)
	  begin:plasticcW23
				for( p4=0; p4<Neurons_Layer3;p4=p4+1)
				begin:Plasticc_W23	
        
        STDPmodel_4PWL
                                 
                                    #(.buffer_size(buffer_size))

                                        PlasticW23
                                    (.reset(reset),
                                     .clk(clk),
                                     .A_pre (Ai [p3+Neurons_Layer1]),
                                     .A_post(Ai[p4+Neurons_Layer1+Neurons_Layer2]),
                                     .start_replay_phase(start_replay_phase),
                                     .W_previous(W23_previous[p3][p4]),
                                     .W_new_o(S_G[p3+Neurons_Layer1][p4+Neurons_Layer1+Neurons_Layer2]));
				end
	  end

      
      
      genvar n1,n2;
	  for( n1=0; n1<Num_Neurons;n1=n1+1)
	  begin:synapses_matrix
				for( n2=0; n2<Num_Neurons;n2=n2+1)
				begin:synapses_array
				
				    assign Sj_G [n1][(((n2+1)*buffer_size)-1) -: buffer_size] = S_G[n2][n1];
				    assign W_ij [n1][n2] = (S_G[n2][n1]=={buffer_size{1'b0}}) ? 1'b0 : 1'b1;
				    
				end 
	  end
				
  
	
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////	

	///////////// Input I///////
	//////////////////////////////////////////////
	///////////////Layer 1////////////////////////
	always @(InVec)
	begin:Layer1
	integer ll;
	
		for (ll=0; ll<Neurons_Layer1; ll=ll+1)
		begin :Layer11
		 IinLayer1[(ll+1)*buffer_size-1 -:buffer_size] <= (InVec[ll]==1'b1) ? I_sensory : {buffer_size{1'b0}};
		end	
	
	end	

	assign IinLayer2 = {Neurons_Layer2*buffer_size{1'b0}};
	assign IinLayer3 = {Neurons_Layer3*buffer_size{1'b0}};
		
assign Iin_first_phase = ( break  )? {buffer_size*Num_Neurons{1'b0}} : {IinLayer3,IinLayer2,IinLayer1};



////////////////////////////////////////////////////////////////////////

assign Iinvector=(break) ? Iin_replay_phase : Iin_first_phase;



wire [ buffer_size-1 : 0] input_neurons [0 : Num_Neurons-1];
genvar n3;
	  for( n3=0; n3<Num_Neurons;n3=n3+1)
	  begin:Neurons_input_bias				
			    assign input_neurons [n3] = Iinvector [(((n3+1)*buffer_size)-1) -: buffer_size];					
	  end
		

	

	
/////////////////////////////////////////////////////////////
//////////	generate neurons noise //////////////////////////
/////////////////////////////////////////////////////////////		
	Neurons_noise #(.buffer_size(buffer_size),
						 .Neurons_Layer1(Neurons_Layer1),
						 .Neurons_Layer2(Neurons_Layer2),
						 .Neurons_Layer3(Neurons_Layer3))
	NoiseNeurons
		(.clk(clk),
		 .reset(reset),
		 .active( active & clk),
		 .noise_array(noise_array));
		 
////////////////////////////////////////////////////////////////
//////////  Network Configuration  /////////////////////////////
////////////////////////////////////////////////////////////////

reg  [Num_Neurons-1 : 0] Ai ;
wire [Num_Neurons-1 : 0] Ao ;
wire [1:0] State [0:Num_Neurons-1];
wire [buffer_Time-1 : 0] Ca          [0 : Num_Neurons-1];
reg  [buffer_Time-1 : 0] Ca_previous [0 : Num_Neurons-1];
wire [buffer_size-1 : 0] sum [0 : Num_Neurons-1];
always @(posedge clk)	
    if (reset==1'b1)
				  for (n=0; n<Num_Neurons; n=n+1)
				  begin:saving_Vmem_reset
						Vj_previous[n] = V_RESET;
						Ai [n]         = 1'b0  ;
						Ca_previous[n] = {buffer_size{1'b0}};    
			      end
    else 
                  for (n=0; n<Num_Neurons; n=n+1)
                  begin:saving_Vmem
                        Vj_previous[n] =  V_mem[n];
                        Ai [n]         =  Ao[n];
                        Ca_previous[n] =  Ca[n];
                  end

for (i=0; i<Num_Neurons; i=i+1) 
begin :Neurons
       Simple_lifneuron
                    #(.buffer_size(buffer_size),
                      .Num_Neurons(Num_Neurons))
                   Neurons         
                      (.clk (clk),
                       .reset(reset),
                       .rest(rest),
                       .Ai (Ai), 
                       .W_ij (W_ij[i]),
                       .Sj_G(Sj_G[i]),
                       .V_in(input_neurons [i]),
                       .V_mem_previous (Vj_previous[i]),
                       .Calcium_previous(Ca_previous[i]),
                       .Calcium (Ca[i]),
                       .V_mem (V_mem[i]),
                       .sum(sum[i]),
                       .Ao (Ao[i]),
                       .state(State[i])
                       );
    	 //assign V_mem[i]=(break) ? V_mem_n[i] : V_mem_n[i]+noise_array[((i+1)*buffer_size)-1 -: buffer_size];	
		 assign Raster_Plot[i]= Ao[i];		 
		 assign NetworkOutput [i]=Raster_Plot[i];
end


assign HippoVec[0]=Raster_Plot[6];
assign HippoVec[1]=Raster_Plot[7];
assign HippoVec[2]=Raster_Plot[8];
assign HippoVec[3]=Raster_Plot[9];
assign HippoVec[4]=Raster_Plot[10];
assign HippoVec[5]=Raster_Plot[11];
assign HippoVec[6]=Raster_Plot[12];
assign HippoVec[7]=Raster_Plot[13];

assign OutVec[0]=Raster_Plot[14];/// Dig
assign OutVec[1]=Raster_Plot[15];/// move

assign weight_exampel1=V_mem[6];
assign State1=State[6];
assign weight_exampel2=V_mem[14];
assign State2=State[14];



endgenerate

  
endmodule



