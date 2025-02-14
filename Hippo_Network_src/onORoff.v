module onORoff
  ( V_mem, NonORoff);
  

`include "Net_parameters.v"
//parameter buffer_size = 32;

//parameter ETA       = 32'b00000000110000010000000000000000;
//parameter ETA       = 16'b0000000000110000;



//parameter V_th      = 32'b01111110000000000000000000000000;    //V_TH=-0.05-------0.05=16'b0000011001100000

//parameter one       = 32'b00000000000000000000000000000001;
//wire   v_TH;
//assign v_TH=16'b0111111000000000;

input [buffer_size-1:0] V_mem; 

output NonORoff;

wire  [buffer_size-1:0] dV; 

wire  [buffer_size-1:0] abs_dV; 

assign dV=V_th-V_mem;

assign abs_dV= dV[buffer_size-1] ? (~dV + one) : dV ;

assign NonORoff= (V_mem>(V_th+ETA )) ? 1'b1 : ((abs_dV<ETA) ? 1'b1 : 1'b0) ;


endmodule 