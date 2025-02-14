
module STDPmodel_4PWL

(reset,clk, A_pre,A_post,start_replay_phase, W_previous, W_new);

	`include "c_constants.v"
	
 	parameter buffer_size=32;
	
	parameter buffer_Time=32;
	
	parameter reset_type = `RESET_TYPE_ASYNC;
	
	parameter W_MAX=32'b00000000001000000000000000000000;
	
	parameter [4:0] nHistory=3'b110;
		
	//// data input  /////   
	input reset; 
	
	input clk;
	
    input A_pre;	
   
    input A_post;
    
    input start_replay_phase;
   //input enable;
   
	//input [buffer_Time-1:0] T_pre;
	
	//input [buffer_Time-1:0] T_post;	
	
	wire   AdaptW;
	wire   AdaptW_2;
	wire   AdaptW_3;
	wire   AdaptW_4;
	
	
	
	input [buffer_size-1:0] W_previous;
	wire  [buffer_size-1:0] W_previous_q1;
	wire  [buffer_size-1:0] W_previous_q2;
	wire  [buffer_size-1:0] W_previous_q3;
	
	
	   
   //// data output /////
   output [buffer_size-1:0] W_new;
	reg    [buffer_size-1:0] W_new;
	
	wire [buffer_Time-1:0] DeltaW;
	wire [buffer_Time-1:0] DeltaW_N;

	
	//// Net declaration ////
	
	wire [buffer_Time-1:0]   DeltaT;
	//wire [buffer_Time-1:0] DeltaW;
	//wire [buffer_Time-1:0] DeltaW1;
	wire [buffer_size-1:0]   abs_DELTA;
	
	wire   [buffer_size-1:0] W_q;	
	wire   [buffer_size-1:0] W_s;	
	wire   [buffer_size-1:0] W_B;	
	
	reg [buffer_size-1:0]  b0 = 32'b00000000111001000000000000000000;
	reg [buffer_size-1:0]  b1 = 32'b00000010100000000000000000000000;
	reg [buffer_size-1:0]  b2 = 32'b00000111100000000000000000000000;
	reg [buffer_size-1:0]  b3 = 32'b00000010101010000000000000000000;
	
   //reg [buffer_size-1:0]  m0 = 32'b0000000000000101 0110101100010000;
	//reg [buffer_size-1:0]  m1 = 32'b0000000000100000 1110000000000000;
	//reg [buffer_size-1:0]  m2 = 32'b0000000001100010 0000000000000000;
	//reg [buffer_size-1:0]  m3 = 32'b0000000000010000 0001111100110000;
	
	//reg [buffer_size-1:0]  b0 = 16'b0000000011100100;
	//reg [buffer_size-1:0]  b1 = 16'b0000001010000000;
	//reg [buffer_size-1:0]  b2 = 16'b0000011110000000;
	//reg [buffer_size-1:0]  b3 = 16'b0000001010101000;	
	

	

	//output [buffer_size-1:0]  f_20;
	//output [buffer_size-1:0]  f_21;
	//output [buffer_size-1:0]  f_22;
	//output [buffer_size-1:0]  f_23;
	
    wire [buffer_size-1:0]  f_20;
    wire [buffer_size-1:0]  f_21;
    wire [buffer_size-1:0]  f_22;
    wire [buffer_size-1:0]  f_23;
		
	wire sign_dt_s1,sign_dt_q2;
	wire sign_dt_q3,sign_dt_q4;
	
	wire  [1:0] region;
	wire  sign_dw;
	
	wire    [buffer_size-1:0]  f_1_q;
	reg     [buffer_size-1:0]  f_2_s;
	wire    [buffer_size-1:0]  f_3_q;
	wire    [buffer_size-1:0]  f_3_q_N;
	generate
	
	//-----------stage 1-----------------------------

   
        reg [2:0] Count_pre; 
        reg [2:0] Count_post;
        wire[2:0] Delta_Count;
        wire[2:0] abs_Delta_Count;
        always @(posedge clk)
        if (reset==1'b1)
          Count_pre=3'b0;
        else
           if (A_pre==1'b1)
               Count_pre=nHistory; 
           else     
               if(Count_pre==3'b0)
                   Count_pre=Count_pre;
               else
                   Count_pre=Count_pre-3'b1;
                   
        always @(posedge clk)
        if (reset==1'b1)
           Count_post=3'b0;
        else
           if (A_post==1'b1)
               Count_post=nHistory; 
           else     
               if(Count_post==3'b0)
                   Count_post=Count_post;
               else
                   Count_post=Count_post-3'b1;                   

	
	assign AdaptW= reset ? 1'b0 : ((Count_pre==3'b0) ? 1'b0 :((Count_post==3'b0)?   1'b0  :   1'b1));
	assign Delta_Count= AdaptW  ? Count_post-Count_pre : {buffer_size{1'b0}};
	assign sign_dt_s1 = AdaptW  ? (( Delta_Count[2])? 1'b1 : 1'b0) : (AdaptW_4 ? sign_dt_s1 : 1'b0);
	assign abs_Delta_Count = AdaptW ? (sign_dt_s1 ?((~Delta_Count)+3'b001) : Delta_Count) :  3'b0;
	assign abs_DELTA = {4'b0,abs_Delta_Count,25'b0000000000000000000000000}; 
	assign region= (32'b00011110000000000000000000000000 <=abs_DELTA && abs_DELTA<=32'b01010000000000000000000000000000) ?  2'b01 :          //15<deltat<40
					  ((32'b00000000000000000000000000000000 <abs_DELTA  && abs_DELTA< 32'b00011110000000000000000000000000) ?  2'b10 :  2'b00	);// 0<deltat<15
	assign W_s= ( AdaptW_4 || AdaptW ) ?(sign_dt_s1 ? W_previous : W_MAX-W_previous) : W_previous;
	assign f_1_q=abs_DELTA >> 3;
	
	
	 
			
	//-----------stage 2-----------------------------
	
	//reg [buffer_size-1:0]  m0 = 32'b0000000000000101 0110101100010000; // 2^-13+2^-15
	//reg [buffer_size-1:0]  m1 = 32'b0000000000100000 1110000000000000; // 2^-10
	//reg [buffer_size-1:0]  m2 = 32'b0000000001100010 0000000000000000; // 2^-9+2^-10+2^-14
	//reg [buffer_size-1:0]  m3 = 32'b0000000000010000 0001111100110000; // 2^-11

	assign f_20=(f_1_q >> 4)+(f_1_q >> 6); //6+3+4=13
	assign f_21=(f_1_q >> 1)+(f_1_q >> 6);
	assign f_22= f_1_q +(f_1_q >> 1)+(f_1_q >> 5);
	assign f_23=(f_1_q >> 2);
	
	
	wire [buffer_size-1:0]  f_2_q;
	always @(posedge clk)begin
	if (reset)
			f_2_s={buffer_size{1'b0}};
	else
	 if (AdaptW )
		case({region,sign_dt_s1})
		3'b011:
			f_2_s=b0-f_20;
		3'b101:
			f_2_s=b1-f_21;
		3'b100:
			f_2_s=b2-f_22;
		3'b010:
			f_2_s=b3-f_23;
		default:
			f_2_s={buffer_size{1'b0}}; 
		endcase
	else
	 f_2_s={buffer_size{1'b0}};
	end
	
	
	
		
		 c_dff
	     #(.width(1),
	       .reset_value(1'b0),
	       .reset_type(reset_type))
	   f2active
	     (.clk(clk),
	      .reset(reset),
	      .active(1'b1),
	      .d(AdaptW),
	      .q(AdaptW_2));
			
		
		c_dff
	     #(.width(1),
	       .reset_value(1'b0),
	       .reset_type(reset_type))
	   s02active
	     (.clk(clk),
	      .reset(reset),
	      .active(1'b1),
	      .d(sign_dt_s1),
	      .q(sign_dt_q2));
			
			 c_dff
	     #(.width(buffer_size),
	       .reset_value({buffer_size{1'b0}}),
	       .reset_type(reset_type))
	   w_1q
	     (.clk(clk),
	      .reset(reset),
	      .active(AdaptW),
	      .d(W_s),
	      .q(W_q));
	
	//-----------stage 3-----------------------------
	
	genvar i,k,l;
	integer j;
	wire  [buffer_size-1:0]  shift_reg_s  [0:buffer_size-1];
	wire  [buffer_size-1:0]  shift_reg_q  [0:buffer_size-1];
	wire  [buffer_size-1:0]  adder1       [0:buffer_size/2-1];
	wire  [buffer_size-1:0]  adder2       [0:buffer_size/2-1];
	wire  [buffer_size-1:0]  f_3_s;
	
	
	for (i = buffer_size-1; i >= 0; i = i -1) begin:WMultF1
		assign shift_reg_s[i]= W_q[i] ? (f_2_s >> (buffer_size-1-i)) : {buffer_size{1'b0}};
	end
	for (k = buffer_size-1; k >= 0; k = k -1) begin:WMult_shift
		 c_dff
	     #(.width(buffer_size),
	       .reset_value({buffer_size{1'b0}}),
	       .reset_type(reset_type))
	   shrq
	     (.clk(clk),
	      .reset(reset),
	      .active(1'b1),
	      .d(shift_reg_s[k]),
	      .q(shift_reg_q[k]));
	end
	c_dff
	     #(.width(1),
	       .reset_value(1'b0),
	       .reset_type(reset_type))
	   f3active
	     (.clk(clk),
	      .reset(reset),
	      .active(1'b1),
	      .d(AdaptW_2),
	      .q(AdaptW_3));
			
			
	c_dff
	     #(.width(1),
	       .reset_value(1'b0),
	       .reset_type(reset_type))
	   s03active
	     (.clk(clk),
	      .reset(reset),
	      .active(1'b1),
	      .d(sign_dt_q2),
	      .q(sign_dt_q3));
		
	assign adder1[0]=shift_reg_q[0];
	assign adder2[0]=shift_reg_q[16];
	for (l = 1; l <= buffer_size/2-1; l = l + 1) begin:WMultadd
			 assign adder1[l]= shift_reg_q[l]+adder1[l-1];
			 assign adder2[l]= shift_reg_q[l+buffer_size/2]+adder2[l-1];
	end
	
	assign f_3_s=adder1[buffer_size/2-1]+adder2[buffer_size/2-1];
	//assign f_3_s=f_2_q;

	
		   c_dff
	     #(.width(buffer_size),
	       .reset_value({buffer_size{1'b0}}),
	       .reset_type(reset_type))
	   f3q
	     (.clk(clk),
	      .reset(reset),
	      .active(1'b1),
	      .d(f_3_s),
	      .q(f_3_q));
	
	
		c_dff
	     #(.width(1),
	       .reset_value(1'b0),
	       .reset_type(reset_type))
	   f4active
	     (.clk(clk),
	      .reset(reset),
	      .active(1'b1),
	      .d(AdaptW_3),
	      .q(AdaptW_4));
			
			
		c_dff
	     #(.width(1),
	       .reset_value(1'b0),
	       .reset_type(reset_type))
	   s04active
	     (.clk(clk),
	      .reset(reset),
	      .active(1'b1),
	      .d(sign_dt_q3),
	      .q(sign_dt_q4));	

	//-------------stage 4--------------------------------
	//assign f_3_q= f_3_q_N >> 9; 
	assign DeltaW = ( AdaptW_4 || AdaptW)  ? (sign_dt_q4 ? (~f_3_q+32'b00000000000000000000000000000001) : f_3_q) : {buffer_size{1'b0}} ;		  
	
	
	
		   c_dff
	     #(.width(buffer_size),
	       .reset_value({buffer_size{1'b0}}),
	       .reset_type(reset_type))
	   w_p_1q
	     (.clk(clk),
	      .reset(reset),
	      .active(AdaptW),
	      .d(W_previous),
	      .q(W_previous_q1));
			
			   c_dff
	     #(.width(buffer_size),
	       .reset_value({buffer_size{1'b0}}),
	       .reset_type(reset_type))
	   w_p_2q
	     (.clk(clk),
	      .reset(reset),
	      .active(AdaptW),
	      .d(W_previous_q1),
	      .q(W_previous_q2));
			
			   c_dff
	     #(.width(buffer_size),
	       .reset_value({buffer_size{1'b0}}),
	       .reset_type(reset_type))
	   w_p_3q
	     (.clk(clk),
	      .reset(reset),
	      .active(AdaptW),
	      .d(W_previous_q2),
	      .q(W_previous_q3));
					

	
	assign   W_B   = AdaptW_4 ? (W_previous_q3 + DeltaW) : (W_previous + DeltaW) ;
	assign   sign_dw = W_B[buffer_size-1];
	
	always @(posedge clk)
	if (start_replay_phase==1'b0)
		W_new= W_previous;
	else
		if ( AdaptW_4 || AdaptW)
			case ({sign_dw,sign_dt_q4})
				2'b00: W_new= W_B;
				2'b01: W_new= W_B;
				2'b10: W_new= W_MAX;
				2'b11: W_new= {buffer_size{1'b0}};
			endcase
		else
		W_new=W_previous;
	
		
		
		endgenerate
	endmodule

