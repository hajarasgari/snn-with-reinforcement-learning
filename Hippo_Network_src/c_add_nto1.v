// $Id: c_add_nto1.v 5188 2012-08-30 00:31:31Z dub $

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
// generic n-input adder
//==============================================================================

module c_add_nto1
  (data_in, data_out_exi,data_out_inh);
//`define  ADD_FUNCTION 		1        
//`include "c_functions.v"
   
   // width of each input
   `include "Net_parameters.v"
   
   // number of inputs
   parameter n = 2;
   
   // result width
   //localparam out_width = clogb(num_ports * (1 << width - 1) + 1);
   
   // vector of inputs
   input  [buffer_size*n-1:0] data_in;
   
   // output data
   output [buffer_size-1:0] data_out_exi;
   output [buffer_size-1:0] data_out_inh;
    reg    [buffer_size-1:0] data_out_exi;
    reg    [buffer_size-1:0] data_out_inh;
	reg    [buffer_size-1:0] data_out_abs;
	reg    [buffer_size-1:0] abs_data_in;
	reg    count_inh;
	
	//output  Double_Inh;

   
   integer 	       i,j;
   
   always @(data_in)
     begin
		data_out_exi      =  {buffer_size{1'b0}};
		data_out_inh      =  {buffer_size{1'b0}};
		data_out_abs =  {buffer_size{1'b0}};
		abs_data_in  =  {buffer_size{1'b0}};
		count_inh    = 1'b0;
	  for(i = 0; i < n; i = i + 1)
	  begin
	  		abs_data_in  =  data_in[(i+1)*buffer_size-1] ?  {buffer_size{1'b0}} : data_in[(i+1)*buffer_size-1 -: buffer_size];
			data_out_abs     =  data_out_abs + abs_data_in;
			count_inh  =     data_in[(i+1)*buffer_size-1] ?  1'b1 : count_inh;
		   /*if (data_in[(i+1)*buffer_size-1]==1'b1)begin
			     abs_data_in  =  abs_data_in ;		
				  count_inh   = 1'b1; end
		   else begin
				  count_inh = count_inh ;
				  abs_data_in  =  abs_data_in + data_in[(i+1)*buffer_size-1] ;	end	*/
	  end
	  
	  data_out_exi     =   data_out_abs;
	  if (count_inh==1'b0) 		begin		  
		  data_out_inh     =   {buffer_size{1'b0}}; end
	  else begin
		  data_out_inh     =    Inh;  end
   end
   
endmodule