// $Id: c_lfsr.v 5188 2012-08-30 00:31:31Z dub $

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
// generic multi-input linear feedback shift register register
//==============================================================================
module c_lfsr_start_point 
 ( clk, init, en,seed,poly, Q);

parameter buffer_size = 32; 
parameter n = 32;

input clk, init, en;
input [n-1:0] seed;
input [n-1:0] poly;
output  [buffer_size-1:0] Q;
reg     [n-1:0] Qlfsr;

integer i;

always @(posedge clk, posedge init) begin
	if (init == 1'b1) Qlfsr <= seed;
	
	else begin
		if (en == 1'b1) begin
		
			Qlfsr[n-1] <= Qlfsr[0];
			
			for (i=0; i<n-1 ; i=i+1 ) begin
		
				Qlfsr[i] <= (Qlfsr[0] & poly[i] ) ^ Qlfsr[i+1];
			end //for
		end
		else Qlfsr<=Qlfsr;
		
		end
	//Q[n-1:0]<=Qlfsr;
	
end
assign Q[buffer_size-1:0]=Qlfsr;

endmodule


