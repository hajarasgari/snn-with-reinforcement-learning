// $Id: c_dff.v 5188 2012-08-30 00:31:31Z dub $

/*
 Copyright (c) 2007-2012, Trustees of The Leland Stanford Junior University
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 Redistributions of source code must retain the above copyright notice, this 
 list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this
 list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

//==============================================================================
// configurable register
//==============================================================================

module Simple_lifneuron
  (clk, reset, rest, Ai, W_ij, Sj_G,V_in, V_mem_previous,Calcium_previous, Calcium, V_mem,sum, Ao,state);
   	
   /////////////////////////// parameters //////////////////////////////////
	`include "Net_parameters.v"
      parameter C_peak    = 16'b0001000000000000;
      parameter Resting=0, Waiting_for_Input_spikes=1, Integrating=2, Firing=3;

	/////////////////////////////////////////////////////////////////////
    input clk;
    wire  clk;
    
    input reset;
    wire reset;
    
    input rest;
    wire rest;
   
	///////////////// data input////////////////////////
   
	input  [Num_Neurons-1:0] Ai;
	//wire   [Num_Neurons-1:0] Ai;   
	
	input  [Num_Neurons-1:0] W_ij;
    
    input  [Num_Neurons*buffer_size-1:0] Sj_G;
    
    input  [buffer_size-1:0] V_in;
	
	input  [buffer_size-1:0] V_mem_previous ;
	
	input  [buffer_Time-1:0] Calcium_previous;
   
   /////////////////data output////////////////////////
   
    output [buffer_Time-1:0] Calcium;
    
    reg    [buffer_Time-1:0] Calcium1;

    output [buffer_size-1:0] V_mem;
    reg    [buffer_size-1:0] V_mem1;
    
	output  Ao;
	reg     Ao;
	
	output [1:0] state;
	reg    [1:0] state;
   //////////signal diclaration///////
	
	
	integer i,j;
	
	wire [Num_Neurons-1:0] Input_spikes; 
	   
   reg  [Num_Neurons*buffer_size-1:0] W_exi;
	reg  [Num_Neurons*buffer_size-1:0] W_inh;
	reg  [Num_Neurons*buffer_size-1:0] W;
    
	wire [buffer_size-1:0] sum_exi1,sum_exi2;
	
	wire [buffer_size-1:0] sum_inh1, sum_inh2;
	
	output [buffer_size-1:0] sum;
	wire   [buffer_size-1:0] sum,sum_exi,sum_inh;
	
	wire Aboveth;
	
	
//------------------------------------------------------
	always @(Ai)begin            
               for (i=0;i<Num_Neurons;i=i+1)
               begin
                    if (Ai[i]==1'b1) 
													W [((i+1)*buffer_size)-1 -: buffer_size]=Sj_G[((i+1)*buffer_size)-1 -: buffer_size];
												  /*if (Sj_G[((i+1)*buffer_size)-1]==1'b0)begin
												       W_exi [((i+1)*buffer_size)-1 -: buffer_size]=Sj_G[((i+1)*buffer_size)-1 -: buffer_size];
														 W_inh [((i+1)*buffer_size)-1 -: buffer_size]={buffer_size{1'b0}};end
												  else begin
														 W_exi [((i+1)*buffer_size)-1 -: buffer_size]={buffer_size{1'b0}};
														 W_inh [((i+1)*buffer_size)-1 -: buffer_size]=Sj_G[((i+1)*buffer_size)-1 -: buffer_size];end*/
                    else              
													W [((i+1)*buffer_size)-1 -: buffer_size]={buffer_size{1'b0}};
													
               end                
     end
	
	 /*  c_add_nto1
	     #(.n(Num_Neurons))
	   integrate_exi1
		(  .data_in (W_exi[(buffer_size*Num_Neurons)-1:0]), 
         .data_out(sum_exi)
			
			);
         
      c_add_nto1
        #(.n(Num_Neurons/2))
         integrate_exi2
          (.data_in (W_exi[(buffer_size*Num_Neurons)-1:(buffer_size*Num_Neurons/2)]), 
           .data_out(sum_exi2)			  
			  );
			  
	   c_add_nto1
	     #(.n(Num_Neurons))
	   integrate_inh1
		(  .data_in (W_inh[(buffer_size*Num_Neurons)-1:0]), 
         .data_out(sum_inh)
			
			);*/
 /*        
      c_add_nto1
        #(.n(Num_Neurons/2))
         integrate_inh2
          (.data_in (W_inh[(buffer_size*Num_Neurons)-1:(buffer_size*Num_Neurons/2)]), 
           .data_out(sum_inh2)			  
			  );	*/		  
           
//assign sum= (Double_Inh1 | Double_Inh2) ? sum1+sum2-Inh  : sum1+sum2;           
//assign sum_exi = sum_exi1+ sum_exi2;           
//assign sum_inh = sum_inh1+ sum_inh2;  
//assign sum     = sum_exi - sum_inh;           
c_add_nto1
	     #(.n(Num_Neurons))
	   integrate
		( .data_in (W[(buffer_size*Num_Neurons)-1:0]), 
         .data_out_exi(sum_exi),
         .data_out_inh(sum_inh));         

 assign sum = (sum_exi >>5) + sum_inh;       
//--------------------------------------------------------
genvar m;
generate

        for (m=0;m<Num_Neurons;m=m+1)
        begin
             assign Input_spikes[m] = (W_ij[m]==1'b1 && Ai[m]==1'b1) ? 1'b1 : 1'b0;   
        end

endgenerate
//--------------------------------------------------------
/*
	always @(posedge clk)
            begin    
            if (reset==1'b1 || rest==1'b1)
                Calcium = {buffer_size{1'b0}};
            else
                //if (Ao==1'b1)
                //            Calcium = Calcium1;
                //else
                            Calcium = Calcium_previous - ((Calcium_previous >>7) + (Calcium_previous >>9)); //tau_c=10 ms                
                
     end*/
assign Calcium = (Ao) ? Calcium1 : (Calcium_previous - ((Calcium_previous >>7) + (Calcium_previous >>9))); //tau_c=10 ms    
assign V_mem   = (state == Waiting_for_Input_spikes || state == Integrating) ?  ( (V_mem_previous <= V_RESET) ? V_RESET : (V_mem_previous - V_leakage)) : V_mem1 ;
//assign V_mem   = (state == Waiting_for_Input_spikes) ?  ( (V_mem_previous <= V_RESET) ? V_RESET : (V_mem_previous - V_leakage)) : V_mem1 ;            

	always @(state) 
              begin
                   case (state)
                        Resting:begin
                                V_mem1 = V_RESET;
                                Ao=1'b0;
                                Calcium1 = {buffer_size{1'b0}}; 
                             end
                        Waiting_for_Input_spikes: begin
                                V_mem1 = V_mem_previous ;
                                Ao=1'b0;
                                Calcium1 = Calcium_previous;
                                //Calcium = Calcium - (Calcium >>9) ; //tau_c=60 ms
                             end
                        Integrating: begin
                                V_mem1 = V_mem_previous + sum + V_in ;
                                Ao=1'b0;
                                Calcium1 = Calcium_previous;
                                //Calcium = Calcium - (Calcium >>9) ; //tau_c=60 ms
                             end
                        Firing:begin
                                V_mem1 = V_RESET;
                                Ao=1'b1; 
                                Calcium1 = Calcium_previous + C_peak;
                             end
                        default:begin
                                V_mem1 = V_mem_previous ;
                                Ao=1'b0;
                                Calcium1 = Calcium_previous;
                             end
                   endcase
              end
  
  
              
  onORoff
                #(.buffer_size(buffer_size))  
                 vmargine
                ( .V_mem(V_mem),
                  .NonORoff(Aboveth));            
//----------------------------------------------------------------	
	always @(posedge clk or posedge reset)
                   begin
                        if (reset==1'b1 || rest==1'b1)
                             state = Resting;
                        else
                             case (state)
                                  Resting:
                                       state = Waiting_for_Input_spikes;
                                  Waiting_for_Input_spikes:
                                       if ( Input_spikes!={Num_Neurons{1'b0}} || V_in)
                                            state = Integrating;
                                       else
                                            state = Waiting_for_Input_spikes;
                                  Integrating:
                                       if (Aboveth ==1'b1)
                                            state = Firing;
                                       else if (V_mem < V_RESET)
                                            state = Resting;
                                       else
                                            state = Waiting_for_Input_spikes; 
                                  Firing:
                                       state = Waiting_for_Input_spikes;
                             endcase
                   end

//------------------------------------------------------------------	
		

endmodule
