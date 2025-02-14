module STDPmodel

( reset,clk, T_pre,T_post,W_previous, W_new);
 
   
	parameter buffer_size=32;
	parameter buffer_Time=32;
	parameter A_PLUS      = 16'b0000000000000011;  // Amplitude for long term potentation (LTP).
	parameter A_MINUS     = 16'b0000000011110000;  // Amplitude for long term depression (LTD).
	//parameter alpha= 32'b00000000000000000000010100000000;//0.019
	//parameter betta= 32'b00000000000000000000111011000000;//0.057
	//parameter alpha= 32'b00000000000000000000000000011111;//0.019/40
	//parameter alpha= 32'b11111111111111111111111111100001;//-0.019/40
	//parameter betta= 32'b00000000000000000000000001011100;//0.057/40
	//parameter betta= 32'b11111111111111111111111110100100;//-0.057/40
	//parameter margin_t= 32'b00000000001010000000000000000000;//40
	//parameter W_min= 32'b00000000000000000000000000000000;//0
	//parameter W_max= 32'b00000000000000010000000000000000;//1
	
	//// data input  /////   
	input reset;
	
	input clk;
	
   //input enable;
   
	input [buffer_Time-1:0] T_pre;
	
	input [buffer_Time-1:0] T_post;	
	
	input [buffer_size-1:0] W_previous;
	
	   
   //// data output /////
   output [buffer_size-1:0] W_new;

	
	//// Net declaration ////
	
	reg  [buffer_Time-1:0] DeltaT;
	wire [buffer_Time-1:0] DeltaW;
	wire [buffer_Time-1:0] DeltaW1;
	reg AdaptW;
	
	wire [buffer_size-1:0] W;	
	wire [buffer_size-1:0] W_B;	
	wire  [buffer_size-1:0] Z1;
	wire  [buffer_size-1:0] Z2;
	wire [buffer_size-1:0] res1;
	wire [buffer_size-1:0] res2;
	wire [buffer_size-1:0] res3;
	wire  [buffer_size-1:0] DELTA;
	
	//reg [buffer_size-1:0] m_minus = 32'b00000000000011111001100000000000;//0.019/40=0.000475
	reg [buffer_size-1:0] m_minus   = 32'b00000000000000000000000000011111;//0.019/40=0.000475
	//reg [buffer_size-1:0] m_plus  = 32'b00000000001011101101100000000000;//0.057/40=0.001425
	reg [buffer_size-1:0] m_plus   = 32'b00000000000000000000000001011100;//0.057/40=0.001425
	reg [buffer_size-1:0] margin_t= 32'b00000000001010000000000000000000;//40
	reg [buffer_size-1:0] W_min   = 32'b00000000000000000000000000000000;//0
	reg [buffer_size-1:0] W_max   = 32'b00000000000000010000000000000000;//1
	
	
	
	assign W={{buffer_size/2-1{1'b0}},W_previous[buffer_size-1 -: buffer_size/2],1'b0};
	
	always @(posedge clk)
		begin	
		if (reset)begin
				DeltaT={buffer_Time{1'b0}};
				AdaptW  =1'b0;
				//Z1={buffer_Time{1'b0}};
				//Z2={buffer_Time{1'b0}};
				//DELTA={buffer_Time{1'b0}};
				end
		else
						
				if (T_pre) begin 
								DeltaT=(T_post)?(T_post-T_pre):{buffer_Time{1'b0}};
								AdaptW  =(T_post)?1'b1:1'b0;
						  end
				
				else    begin
								DeltaT={buffer_Time{1'b0}};
								AdaptW  =1'b0;
							end
										
		end
		
		
		
		assign DELTA =AdaptW ?(( DeltaT[buffer_Time-1]) ? (~DeltaT)+32'b00000000000000000000000000000001 : DeltaT ):{buffer_Time{1'b0}}; 
		assign Z1    =AdaptW ?((DeltaT[buffer_Time-1])  ?  W	  : W_max-W ):{buffer_Time{1'b0}}; 
		assign Z2    =AdaptW ?((DeltaT[buffer_Time-1])  ?  m_minus : m_plus   ):{buffer_Time{1'b0}}; 
	
		assign res1=margin_t-DELTA;
		
			STDP_multiplier 
			  #(.n(buffer_size))
			  mult1
			 (.a(Z2), 
			  .b(res1),
			  .result(res2));
			  
			
	
	      STDP_multiplier 
			  #(.n(buffer_size))
			  mult2
			 (.a(Z1), 
			  .b(res2),
			  .result(res3));
			  
			 assign DeltaW1 = (DeltaT[buffer_Time-1]) ? (~res3 +32'b00000000000000000000000000000001) : res3 ;
	
			 assign DeltaW =  (DeltaT[buffer_Time-1]? (DeltaW1[buffer_Time-1]?DeltaW1:{buffer_Time{1'b0}}): (DeltaW1[buffer_Time-1]?{buffer_Time{1'b0}}:DeltaW1));
	//////////////////////////////Output assignment 
   
   assign W_B = (AdaptW && Z1>={buffer_size{1'b0}})? (W + DeltaW ): W;
	
	assign W_new= {W_B[buffer_size/2:0],{buffer_size/2-1{1'b0}}};
	
	
	

	endmodule

