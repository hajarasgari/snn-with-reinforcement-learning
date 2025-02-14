`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:09:05 04/11/2018
// Design Name:   Experiment
// Module Name:   H:/PHD/Thesis/Implementation/Hippocampal/ISE_Hippo/Hippocampal_Network/2-Hippocampal_Network/TB_Experiment.v
// Project Name:  Hippocampal_Network
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Experiment
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TB_Experiment;
 
	// Inputs 
	reg clk;
	reg run;
	reg reset_lfsr_weight;

	// Outputs
	wire [1:0] OutVec;

	// Instantiate the Unit Under Test (UUT)
	Experiment uut (
		.clk(clk), 
		.run(run),
		.reset_lfsr_weight(reset_lfsr_weight),
		.OutVec(OutVec)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		run = 0;
		reset_lfsr_weight=1;
		// Wait 100 ns for global reset to finish
		#100;
		reset_lfsr_weight=0;
		
		//#2700;
		#500;
        run = 1;  
		// Add stimulus here

	end
	
	always
	  #50 clk= !clk ; 
      
      
endmodule

