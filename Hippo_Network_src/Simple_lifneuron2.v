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
  (clk, reset, rest, Ai, W_ij, Sj_G,V_in, V_mem_previous, Calcium, V_mem, Ao);
   	
   /////////////////////////// parameters //////////////////////////////////
	
    `include "Net_parameters.v"
       
    parameter V_RESET   = 32'b11110111000010000000000000000000; //V_RESET=-0.07-----0.07=16'b0000100100000000
   
    parameter ETA       = 32'b00000000000000001000100000000000;
    
    parameter V_th      = 32'b11111001101010000000000000000000;    //V_TH=-0.05-------0.05=16'b0000011001100000
    
    parameter V_leakage = 32'b00000000000000001000100000000000;
    
    parameter C_peak    = 16'b0001000000000000;
       
    parameter Idle=0, Waiting_for_Input_spikes=1, Integrating=2, Firing=3, Reseting=4;

	/////////////////////////////////////////////////////////////////////
    input clk;
    wire  clk;
    
    input reset;
    wire  reset;
    
    input rest;
    wire  rest;
   
	///////////////// data input////////////////////////
   
	input  [Num_Neurons-1:0] Ai;  
	
	input  [Num_Neurons-1:0] W_ij;
    
    input  [Num_Neurons*buffer_size-1:0] Sj_G;
    
    input  [buffer_size-1:0] V_in;
	
	input  [buffer_size-1:0] V_mem_previous ;
   
   /////////////////data output////////////////////////
   
    output [buffer_size/2-1:0] Calcium;
    reg    [buffer_size/2-1:0] Calcium;

    output [buffer_size-1:0] V_mem;
    reg    [buffer_size-1:0] V_mem;
    
	output  Ao;
	reg     Ao;
	
   //////////signal diclaration///////
	
	
	integer i;
	
	wire [Num_Neurons-1:0] Input_spikes; 
	   
    reg  [Num_Neurons*buffer_size-1:0] Wij_wire;
    
	reg [1:0] state;	

	wire [buffer_size-1:0] sum;
	
//------------------------------------------------------
	always @*
            begin    
               for (i=0;i<Num_Neurons;i=i+1)
               begin
                    if (Ai[i])  Wij_wire[((i+1)*buffer_size)-1 -: buffer_size]<=Sj_G[((i+1)*buffer_size)-1 -: buffer_size];
                    else        Wij_wire[((i+1)*buffer_size)-1 -: buffer_size]<={buffer_size{1'b0}};
                     
                    
               end                
     end
	
	   c_add_nto1
	     #(.buffer_size(buffer_size),
	       .n(Num_Neurons))
	   integrate
		(
		 .data_in (Wij_wire), 
         .data_out(sum));
         
         
//--------------------------------------------------------
genvar m;
generate

        for (m=0;m<Num_Neurons;m=m+1)
        begin
             assign Input_spikes[m] = (W_ij[m] && Ai[m]) ? 1'b1 : 1'b0;   
        end

endgenerate
//--------------------------------------------------------

/*	always @(state) 
              begin
                   case (state)
                        Idle:begin
                                V_mem = V_RESET;
                                Ao=1'b0;
                                Calcium = {buffer_size/2{1'b0}}; 
                             end
                        Waiting_for_Input_spikes: begin
                                V_mem = V_mem_previous ;
                                Ao=1'b0;
                                Calcium = Calcium - ((Calcium >>7) + (Calcium >>9) + (Calcium >>12)); //tau_c=10 ms
                                //Calcium = Calcium - (Calcium >>9) ; //tau_c=60 ms
                             end
                        Integrating: begin
                                V_mem = V_mem_previous + sum + V_in - V_leakage;
                                Ao=1'b0;
                                Calcium = Calcium - ((Calcium >>7) + (Calcium >>9) + (Calcium >>12));  //tau_c=10 ms
                                //Calcium = Calcium - (Calcium >>9) ; //tau_c=60 ms
                             end
                        Firing:begin
                                V_mem = V_RESET;
                                Ao=1'b1; 
                                Calcium = Calcium + C_peak;
                             end
                                   
                        default:begin
                                V_mem = V_mem_previous ;
                                Ao=1'b0;
                                Calcium = Calcium;
                             end
                   endcase
              end*/
//----------------------------------------------------------------	
	always @(posedge clk or posedge reset)
                   begin
                        if (reset==1'b1 || rest==1'b1)
                             state = Idle;
                        else
                             case (state)
                                  Idle:begin
                                            state = Waiting_for_Input_spikes;
                                            V_mem = V_RESET;
                                            Ao=1'b0;
                                            Calcium = {buffer_size/2{1'b0}}; 
                                       end
                                  Waiting_for_Input_spikes:begin
                                            if ( Input_spikes || V_in)
                                               state = Integrating;
                                            else
                                               state = Waiting_for_Input_spikes;
                                            V_mem = V_mem_previous ;
                                            Ao=1'b0;
                                            Calcium = Calcium - ((Calcium >>7) + (Calcium >>9) + (Calcium >>12)); //tau_c=10 ms
                                            //Calcium = Calcium - (Calcium >>9) ; //tau_c=60 ms
                                       end
                                  Integrating:begin
                                            if (V_mem >= V_th)
                                              state = Firing;
                                            else if (V_mem < V_RESET)
                                              state = Idle;
                                            else
                                              state = Waiting_for_Input_spikes;
                                              
                                            V_mem = V_mem_previous + sum + V_in - V_leakage;
                                            Ao=1'b0;
                                            Calcium = Calcium - ((Calcium >>7) + (Calcium >>9) + (Calcium >>12));  //tau_c=10 ms
                                            //Calcium = Calcium - (Calcium >>9) ; //tau_c=60 ms
                                       end
                                  Firing:begin
                                            state = Waiting_for_Input_spikes;
                                            V_mem = V_RESET;
                                            Ao=1'b1; 
                                            Calcium = Calcium + C_peak;
                                       end
                              
                             endcase
                   end

//------------------------------------------------------------------	
		

endmodule
