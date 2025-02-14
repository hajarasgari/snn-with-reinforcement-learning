module Hippocampal_Network(clk,
                           run,
                           reset_lfsr_weight,
                           start_Trial,
                           change_InVec,
                           dig,
                           rewarded,
                           Starting_Point,
                           //InVec,
                           InVec_OUT,
                           OutVec,
                           The_end_of_the_experiment,
                           weight_exampel1,
                           weight_exampel2,
                           NetworkOutput,
                           State1,
                           State2,
                           active,
                           start_replay_phase);

`include "Net_parameters.v"

input clk;
wire clk;
input run;
wire run;
input reset_lfsr_weight;
wire reset_lfsr_weight;

input start_Trial;
wire  start_Trial;

input  The_end_of_the_experiment;
wire  The_end_of_the_experiment;

output dig;
wire   dig;


//output   finish_replay_phase;

output change_InVec;
wire change_InVec;

output rewarded;
wire   rewarded;
//input rewarded;

wire   en_initializing;

input [Neurons_Layer1-1:0] Starting_Point;
wire  [Neurons_Layer1-1:0] Starting_Point;

//input [Neurons_Layer1-1:0] InVec;
wire  [Neurons_Layer1-1:0] InVec;

output  [Neurons_Layer1-1:0] InVec_OUT;
wire  [Neurons_Layer1-1:0] InVec;


wire [9:0] iRun;

output [buffer_size-1:0] weight_exampel1;
wire [buffer_size-1:0] weight_exampel1;

output [buffer_size-1:0] weight_exampel2;
wire [buffer_size-1:0] weight_exampel2;

output [Num_Neurons-1:0] NetworkOutput;
wire   [Num_Neurons-1:0] NetworkOutput;

output [2:0] State1 ;
wire [2:0] State1 ;

output [2:0] State2 ;
wire [2:0] State2 ;

//output ctrl_iTrial;
reg ctrl_iTrial;

output [Neurons_Layer3-1:0] OutVec;

reg  reset;

output  active;
reg  active;

output start_replay_phase; 
wire   start_replay_phase;

wire finish_replay_phase;

wire ctrl_iRun;


/////////////////////////////////////////////////////////
/////Registers and nets definition////////////////////
//////////////////////////////////////////////////////
wire [Num_Neurons*buffer_size-1:0] noise_array;

wire [Neurons_Layer2-1:0] HippoVec;

//wire [buffer_size-1:0] W [0:Num_Neurons-1][0:Num_Neurons-1];

wire  [buffer_size-1:0] W12_init [0:Neurons_Layer1-1][0:Neurons_Layer2-1];

wire  [buffer_size-1:0] W12_check [0:Neurons_Layer1-1][0:Neurons_Layer2-1];

reg   [buffer_size-1:0] W12_previous [0:Neurons_Layer1-1][0:Neurons_Layer2-1];

wire  [buffer_size-1:0] W23_init [0:Neurons_Layer2-1][0:Neurons_Layer3-1];

wire  [buffer_size-1:0] W23_check [0:Neurons_Layer2-1][0:Neurons_Layer3-1];

reg   [buffer_size-1:0] W23_previous      [0:Neurons_Layer2-1][0:Neurons_Layer3-1];

wire  [buffer_size*Num_Neurons-1:0] Synapses [0:Num_Neurons-1];

wire  [Num_Neurons*Num_Neurons*buffer_size-1:0] Synapses_value;

reg   [buffer_size-1:0] Vj_previous [0:Num_Neurons-1];

wire  [buffer_size-1:0] V_mem [0:Num_Neurons-1];

//wire  [buffer_size-1:0] V_mem_n [0:Num_Neurons-1];

wire  Raster_Plot [0:Num_Neurons-1];

wire  Just_noise [0:Num_Neurons-1];

reg   [Neurons_Layer1-1:0] InVecR;

wire   rest;//

wire [Num_Neurons*buffer_size-1:0] Iinvector;//

wire [Num_Neurons*buffer_size-1:0] Iin_first_phase;//

wire [Num_Neurons*buffer_size-1:0] Iin_replay_phase;//

reg  [buffer_size*Neurons_Layer1-1:0] IinLayer1 ;//

wire [buffer_size*Neurons_Layer2-1:0] IinLayer2 ;//

wire [buffer_size*Neurons_Layer3-1:0] IinLayer3 ;//

wire [nHist*Neurons_Layer1-1:0] InVecHst;//

wire [nHist*Neurons_Layer2-1:0] HippoVecHst;//

wire [nHist*Neurons_Layer3-1:0] OutVecHst;//

wire [Neurons_Layer1-1:0] InVec_Replay;//

reg    break_dly;

wire break;

reg end_replay_phase;

integer n;
generate
genvar i,j,k,l;
genvar l1,l2,l3;
genvar l4,l5,l6;
genvar iHipp,iOut;


//////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////Control unit///////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
movement m
   (.clk(clk),
   .reset(reset),
   .active(active),
   .break(break),
   .change_InVec(change_InVec),
   .Starting_Point(Starting_Point),
   .InVec(InVec)); 
   
assign InVec_OUT=InVec;   
always @(posedge clk ) begin
		  case (run)
		  1'b0: begin 

					active <= 1'b0;
				    ctrl_iTrial<=1'b0;
        			reset<=1'b1;
					end
		  1'b1:

				case (reset)
				1'b1: begin
							active <= 1'b0;
							ctrl_iTrial<=1'b0;
							reset<=1'b0;
							end_replay_phase=1'b0;
   					   end
						
				1'b0: begin
								reset<=1'b0;
								if (start_Trial==1'b1)
								   if (finish_replay_phase==1'b1 )
                                      end_replay_phase=1'b1;
                                   else 
                                      end_replay_phase=end_replay_phase;  
                                   
                                else
                                   end_replay_phase=1'b0;     
								
								ctrl_iTrial<=start_Trial ^ end_replay_phase;
								active <=(ctrl_iTrial)? 1'b1:1'b0;
						
							end
						
				endcase
			endcase
		  end
  
	
                       
assign rest= ~active | change_InVec | dig | learning_rest;	
	  
wire [2:0] nDigSpike,nMoveSpike,nThDigSpike,nThMoveSpike;	


 first_phase
# (.Neurons_Layer1(Neurons_Layer1),
   .Neurons_Layer3(Neurons_Layer3)
   )
	FirstPhase
	(.clk(clk),
	 .run(run),
	 .reset(reset),
	 .active(active),
	 .OutVec(OutVec),
	 .HippoVec(HippoVec),
	 .InVec(InVec),
	 .break(break),
	 .dig(dig),
	 .change_InVec(change_InVec),
	 .InVecHst(InVecHst),
	 .HippoVecHst(HippoVecHst),
	 .OutVecHst(OutVecHst),
	 .nDigSpike(nDigSpike),
	 .nMoveSpike(nMoveSpike),
	 .nThDigSpike(nThDigSpike),
	 .nThMoveSpike(nThMoveSpike)
	 );
	 
	always @ (posedge clk) begin
			break_dly = break;
	end  
	
	assign dig = ~break_dly & break;
	
	 
	 always @(OutVecHst,break)
	 begin
		if (break) begin
		        InVecR=(OutVecHst[1:0]==2'b01) ? InVecHst[5:0] : ((OutVecHst[3:2]==2'b01) ? InVecHst [11:6] : 6'b000000);
		end
		else
			    InVecR=6'b0;
			
	 end 
	assign rewarded=(InVecR[0] & InVecR[4]) | (InVecR[2] & InVecR[4]) | (InVecR[1] & InVecR[5]) | (InVecR[3] & InVecR[5]);
	//assign break=1'b1;
	//assign InVecHst=12'b100001100001;
	//assign HippoVecHst=16'b0000001000000010;
	//assign OutVecHst=4'b1010;
	//assign rewarded=1'b1;
	
	
	 wire learning_rest;
	 Replay_Phase   
	 # (.buffer_size(buffer_size))
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
		  .finish_replay_phase(finish_replay_phase),
		  .iTime(iTime));            		  
wire [buffer_size-1:0] iTime;		  
	
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
  
  assign en_initializing	= ~The_end_of_the_experiment & reset_dly2;  
  

		 
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
                                    #(.buffer_size(buffer_size))
                                    PlasticW12
                                    ( .reset(reset),
                                      .clk(clk),
                                      .A_pre (Raster_Plot[p1]),
                                      .A_post(Raster_Plot[p2+Neurons_Layer1]),
                                      .start_replay_phase(start_replay_phase),
                                      .W_previous(W12_previous[p1][p2]),
                                      .W_new_o(S_G[p1][p2+Neurons_Layer1]),
                                      .check(W12_check[p1][p2]));   
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
                                     .A_pre (Raster_Plot [p3+Neurons_Layer1]),
                                     .A_post(Raster_Plot [p4+Neurons_Layer1+Neurons_Layer2]),
                                     .start_replay_phase(start_replay_phase),
                                     .W_previous(W23_previous[p3][p4]),
                                     .W_new_o(S_G[p3+Neurons_Layer1][p4+Neurons_Layer1+Neurons_Layer2]),
                                     .check(W23_check[p3][p4]));
				end
	  end

      
      
      genvar n1,n2;
	  for( n1=0; n1<Num_Neurons;n1=n1+1)
	  begin:synapses_matrix
				for( n2=0; n2<Num_Neurons;n2=n2+1)
				begin:synapses_array
				
				    assign Sj_G [n1][(((n2+1)*buffer_size)-1) -: buffer_size] = S_G[n2][n1];
				    assign W_ij [n1][n2] = S_G[n2][n1] ? 1'b1 : 1'b0;
				    
				end 
	  end
				
  
	
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////	

	///////////// Input I///////
	//////////////////////////////////////////////
	///////////////Layer 1////////////////////////
	integer ll;
	always @ (posedge clk)
	if (reset==1'b1)	
		for (ll=0; ll<Neurons_Layer1; ll=ll+1)
		begin :Layer11
		       IinLayer1[(ll+1)*buffer_size-1 -:buffer_size] <= {buffer_size{1'b0}};
		end	
	else
	    for (ll=0; ll<Neurons_Layer1; ll=ll+1)
        begin :Layer111
               IinLayer1[(ll+1)*buffer_size-1 -:buffer_size] <= InVec[ll] ? I_sensory : {buffer_size{1'b0}};
        end    
		

	assign IinLayer2 = {Neurons_Layer2*buffer_size{1'b0}};
	assign IinLayer3 = {Neurons_Layer3*buffer_size{1'b0}};


		
assign Iin_first_phase=break ? {buffer_size*Num_Neurons{1'b0}} : {IinLayer3,IinLayer2,IinLayer1};

assign Iinvector=(break ) ? Iin_replay_phase : Iin_first_phase;

wire [buffer_size-1 : 0] input_neurons [0 : Num_Neurons-1];
genvar n3;
	  for( n3=0; n3<Num_Neurons;n3=n3+1)
	  begin:Neurons_input_bias				
			    assign input_neurons [n3] = Iinvector [(((n3+1)*buffer_size)-1) -: buffer_size];					
	  end
		

	

	
/////////////////////////////////////////////////////////////
//////////	generate neurons noise //////////////////////////
/////////////////////////////////////////////////////////////		
/*	Neurons_noise #(.buffer_size(buffer_size),
						 .Neurons_Layer1(Neurons_Layer1),
						 .Neurons_Layer2(Neurons_Layer2),
						 .Neurons_Layer3(Neurons_Layer3))
	NoiseNeurons
		(.clk(clk),
		 .reset(reset),
		 .active(active&&clk),
		 .noise_array(noise_array));*/
		 
////////////////////////////////////////////////////////////////
//////////  Network Configuration  /////////////////////////////
////////////////////////////////////////////////////////////////

reg  [Num_Neurons-1 : 0] Ai ;
wire [Num_Neurons-1 : 0] Ao ;
wire [1:0] State [0:Num_Neurons-1];
wire [buffer_size-1 : 0] Ca          [0 : Num_Neurons-1];
reg  [buffer_size-1 : 0] Ca_previous [0 : Num_Neurons-1];
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

//assign weight_exampel1={1'b0,nThDigSpike,1'b0,nDigSpike,1'b0,nThMoveSpike,1'b0,nMoveSpike};
assign State1=nMoveSpike;
assign State2=nDigSpike;

assign weight_exampel1=Ca[5];
assign weight_exampel2=V_mem[5];



endgenerate

  
endmodule



