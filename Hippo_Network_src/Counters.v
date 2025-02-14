//------------------------------------------------------------------------
// Counters.v
//
// HDL for the counters sample.  This HDL describes two counters operating
// on different board clocks and with slightly different functionality.
// The counter controls and counter values are connected to endpoints so
// that FrontPanel may control and observe them.
//
// Copyright (c) 2005-2011
// Opal Kelly Incorporated
//------------------------------------------------------------------------

`default_nettype none

module Counters(
	input  wire [4:0]   okUH,
	output wire [2:0]   okHU,
	inout  wire [31:0]  okUHU,
	inout  wire         okAA,

	input  wire         sys_clkp,
	input  wire         sys_clkn,
	
	output wire [4:0]   led
	);

// Clock
wire sys_clk;
wire sys_clk10M;
IBUFGDS osc_clk(.O(sys_clk), .I(sys_clkp), .IB(sys_clkn));
clk_wiz_4   my_clk  (.clk_in1(sys_clk) ,.clk_out1(sys_clk10M));

// Target interface bus:
wire         okClk;
wire [112:0] okHE;
wire [64:0]  okEH;

// Endpoint connections:
wire [31:0]  ep00wire;
wire [31:0]  ep20wire, ep21wire, ep22wire;
wire [31:0]  ep40wire;
wire [31:0]  ep60trig, ep61trig;

// inputs
wire run;
wire reset_lfsr;
wire The_end;
wire [5:0] InVec;

//outputs
wire [1:0] OutVec;
wire reward;
wire Change_InVec;
wire [31:0] weight_exampel1;
wire [31:0] weight_exampel2;
wire [15:0] NetworkOutput;
wire [1:0] State1;
wire [1:0] State2;


//Control the experiment
assign run          = ep00wire[0];
assign reset_lfsr   = ep00wire[1];
assign The_end      = ep00wire[2];
assign InVec        = ep00wire[8:3];
assign ep20wire     = {7'd0,State2,2'b0,State1, NetworkOutput ,reward ,OutVec};
assign ep22wire     = weight_exampel2;
assign ep21wire     = weight_exampel1;


function [7:0] xem7310_led;
input [7:0] a;
integer i;
begin
	for(i=0; i<8; i=i+1) begin: u
		xem7310_led[i] = (a[i]==1'b1) ? (1'b0) : (1'bz);
	end
end
endfunction

assign led = xem7310_led({2'b00,OutVec});

// Counter #1
// + Counting using a divided sysclk.
// + Reset sets the counter to 0.
// + Disable turns off the counter.
Hippocampal_Network
#(.Neurons_Layer1(Neurons_Layer1),
  .Neurons_Layer2(Neurons_Layer2),
  .Neurons_Layer3(Neurons_Layer3))
  
Item1   
(.clk(sys_clk10M),
 .run(run),
 .reset_lfsr_weight(reset_lfsr),
// .break(break),
 //.finish_replay_phase(finish_replay_phase),
 //.change_InVec(Change_InVec),
 .rewarded(reward),
 .InVec(InVec),
 .OutVec(OutVec),
 .The_end_of_the_experiment(The_end),
 .weight_exampel1(weight_exampel1),
 .weight_exampel2(weight_exampel2),
 .NetworkOutput(NetworkOutput),
 .State1(State1),
 .State2(State2));




// Instantiate the okHost and connect endpoints.
wire [65*5-1:0]  okEHx;
okHost okHI(
	.okUH(okUH),
	.okHU(okHU),
	.okUHU(okUHU),
	.okAA(okAA),
	.okClk(okClk),
	.okHE(okHE), 
	.okEH(okEH)
);

okWireOR # (.N(5)) wireOR (okEH, okEHx);

okWireIn     wi00(.okHE(okHE),                             .ep_addr(8'h00), .ep_dataout(ep00wire));
okWireOut    wo20(.okHE(okHE), .okEH(okEHx[ 0*65 +: 65 ]), .ep_addr(8'h20), .ep_datain(ep20wire));
okWireOut    wo21(.okHE(okHE), .okEH(okEHx[ 1*65 +: 65 ]), .ep_addr(8'h21), .ep_datain(ep21wire));
okWireOut    wo22(.okHE(okHE), .okEH(okEHx[ 2*65 +: 65 ]), .ep_addr(8'h22), .ep_datain(ep22wire));
okTriggerIn  ti40(.okHE(okHE),                             .ep_addr(8'h40), .ep_clk(sys_clk10M), .ep_trigger(ep40wire));
okTriggerOut to60(.okHE(okHE), .okEH(okEHx[ 3*65 +: 65 ]), .ep_addr(8'h60), .ep_clk(sys_clk10M), .ep_trigger(ep60trig));
okTriggerOut to61(.okHE(okHE), .okEH(okEHx[ 4*65 +: 65 ]), .ep_addr(8'h61), .ep_clk(sys_clk10M), .ep_trigger(ep61trig));

endmodule