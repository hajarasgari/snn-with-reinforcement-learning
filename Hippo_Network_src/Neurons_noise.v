module Neurons_noise
(clk,reset,active,noise_array );

//`define  ADD_PARAM		1        
//`include "parameters.v"

////////parameters//////////////////

parameter buffer_size=32;

parameter Neurons_Layer1=6;

parameter Neurons_Layer2=8;

parameter Neurons_Layer3=2;

parameter Num_Layers=3;

parameter Num_Neurons=Neurons_Layer1+Neurons_Layer2+Neurons_Layer3;

////////////////Input/Output declaration////////////////////

input clk, reset;
wire  clk, reset;

input active;
wire  active; 

//output [Num_Neurons*buffer_size-1:0] Synapses_value;

///////////////////////Reg and net definition/////////////////////////////////

wire [buffer_size-1:0] noise [0:Num_Neurons-1];

output [Num_Neurons*buffer_size-1:0] noise_array;


////////////////////////////////////////////////////////////////////////////
generate
genvar t;

			randn #(.buffer_size(buffer_size),
			         .n(10))
			RANDN0  (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b0110011001),
					 .poly(10'b1110000011),
					 .Q(noise[0]));


			randn #(.buffer_size(buffer_size),
			         .n(10))
			RANDN1  (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b1100111000),
					 .poly(10'b1010010101),
					 .Q(noise[1]));
					 
					 randn #(.buffer_size(buffer_size),
			         .n(10))
			RANDN2  (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b1010111010),
					 .poly(10'b1101011011),
					 .Q(noise[2]));
					 
					 randn #(.buffer_size(buffer_size),
			         .n(10))
			RANDN3  (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b1000000010),
					 .poly(10'b1111000101),
					 .Q(noise[3]));
					 
					  randn #(.buffer_size(buffer_size),
			         .n(10))
			RANDN4  (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b1101100011),
					 .poly(10'b1010111111),
					 .Q(noise[4]));
					 
					 
					 randn #(.buffer_size(buffer_size),
			         .n(10))
			RANDN5  (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b1011011100),
					 .poly(10'b1100111001),
					 .Q(noise[5]));
					 
					 randn #(.buffer_size(buffer_size),
			         .n(10))
			RANDN6  (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b1010100011),
					 .poly(10'b1000110011),
					 .Q(noise[6]));
					 
					 randn #(.buffer_size(buffer_size),
			         .n(10))
			RANDN7  (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b1110001111),
					 .poly(10'b1100001001),
					 .Q(noise[7]));
					 
					 
					 randn #(.buffer_size(buffer_size),
			         .n(10))
			RANDN8  (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b1100011001),
					 .poly(10'b1001110111),
					 .Q(noise[8]));
					 
					 randn #(.buffer_size(buffer_size),
			         .n(10))
			RANDN9  (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b1110010011),
					 .poly(10'b1001111001),
					 .Q(noise[9]));
					
				randn #(.buffer_size(buffer_size),
			         .n(10))
			RANDN10  (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b1110000011),
					 .poly(10'b1010111001),
					 .Q(noise[10]));	
				
				
				randn #(.buffer_size(buffer_size),
			         .n(10))
			RANDN11  (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b1110010011),
					 .poly(10'b1001011001),
					 .Q(noise[11]));

					 
					 randn #(.buffer_size(buffer_size),
			         .n(10))
			RANDN12  (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b1010011011),
					 .poly(10'b1100010011),
					 .Q(noise[12]));

					 
					 	 
					 randn #(.buffer_size(buffer_size),
			         .n(10))
			RANDN13  (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b1011111111),
					 .poly(10'b1010011001),
					 .Q(noise[13]));
					 
					 	
				randn #(.buffer_size(buffer_size),
			         .n(10))
			RANDN14  (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b1001101111),
					 .poly(10'b1001010101),
					 .Q(noise[14]));	
					 
						 
					randn #(.buffer_size(buffer_size),
			         .n(10))
			RANDN15  (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b1000111000),
					 .poly(10'b1101110001),
					 .Q(noise[15]));
					 
					 	 
						
		
		for (t=0; t<Num_Neurons; t=t+1)
		begin:noise_out
			assign noise_array[((t+1)*buffer_size)-1 -: buffer_size] = noise[t];
		end
	
	endgenerate	

		endmodule 