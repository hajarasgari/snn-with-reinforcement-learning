
module STDPmodel_4PWL

(reset,clk, A_pre,A_post,start_replay_phase, W_previous, W_new_o);

	`include "c_constants.v"
	`include "Net_parameters.v"
	
 	
	parameter reset_type = `RESET_TYPE_ASYNC;
	
	parameter [3:0] nHistory=4'b0110;
		
	//// data input  /////   
	input reset;  
	wire  reset; 
	
	input clk;
	wire  clk;
	 
   input A_pre;	
   wire  A_pre;
   
   input A_post;
   wire  A_post;
    
   input start_replay_phase;
   wire  start_replay_phase;
  	
	wire   AdaptW;
	wire   AdaptW_1;
	
	input [buffer_size-1:0] W_previous;
   wire  [buffer_size-1:0] W_previous;
	wire  [buffer_size-1:0] W_previous_q1;
	   
   //// data output /////
   output [buffer_size-1:0] W_new_o;
	wire   [buffer_size-1:0] W_new_o;
	
	reg    [buffer_size-1:0] W_new;
	
	wire   [buffer_size-1:0] DeltaW;
	

	
	//// Net declaration ////

	wire [buffer_Time-1:0]   abs_DELTA;
	
	wire   [buffer_size-1:0] W_B;
	wire   [buffer_size-1:0] W_BS;	
	
	wire sign_dt_s1,sign_dt_q1;
	wire sign_dt_q3,sign_dt_q4;
	
	wire  [1:0] region;
	wire  sign_dw;
	
	wire    [buffer_size-1:0]  f_1_q_pos;
	wire    [buffer_size-1:0]  f_1_q_neg;
	reg     [buffer_size-1:0]  f_2_s;

	generate
	
	//-----------stage 1-----------------------------

   
        reg [3:0] Count_pre; 
        reg [3:0] Count_post;
        wire[3:0] Delta_Count;
        wire[3:0] abs_Delta_Count;
        always @(posedge clk)
        if (reset==1'b1)
          Count_pre=4'b0;
        else
           if (A_pre==1'b1)
               Count_pre=nHistory; 
           else     
               if(Count_pre==4'b0)
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
               if(Count_post==4'b0)
                   Count_post=Count_post;
               else
                   Count_post=Count_post-3'b1;                   
 
	
	assign AdaptW= reset ? 1'b0 : ((Count_pre==4'b0) ? 1'b0 :((Count_post==4'b0)?   1'b0  :   1'b1));
	assign Delta_Count= AdaptW  ? Count_post-Count_pre : 4'b0;
	assign sign_dt_s1 = AdaptW  ? (( Delta_Count[3])? 1'b1 : 1'b0) : (AdaptW_1 ? sign_dt_s1 : 1'b0);
	assign abs_Delta_Count = AdaptW ? (sign_dt_s1 ?((~Delta_Count)+4'b0001) : Delta_Count) :  3'b0;
	assign abs_DELTA = {4'b0,abs_Delta_Count,8'b0}; 
	assign region= (16'b0001111000000000 <=abs_DELTA && abs_DELTA<=16'b0101000000000000) ?  2'b01 :          //15<deltat<40
				  ((16'b0000000000000000 <abs_DELTA  && abs_DELTA< 16'b0001111000000000) ?  2'b10 :  2'b00	);// 0<deltat<15
	
	assign f_1_q_pos =  W_MAX - W_previous;
	assign f_1_q_neg =  W_previous;
	

	//-----------stage 2-----------------------------
	
	//wire [buffer_size-1:0]  f_2_q;
	always @(*)begin
	if (reset)
			f_2_s={buffer_size{1'b0}};
	else
	 if (AdaptW==1'b1 )
		case({region,sign_dt_s1})
		3'b011:
			f_2_s={buffer_size{1'b0}};
		3'b101:
			f_2_s=(f_1_q_neg >> 5);
		3'b100:
			f_2_s=(f_1_q_pos >> 4);
		3'b010:
			f_2_s={buffer_size{1'b0}};
		default:
			f_2_s={buffer_size{1'b0}}; 
		endcase
	else
	 f_2_s={buffer_size{1'b0}};
	end


					
	//-------------stage 4--------------------------------
	assign DeltaW  = ( AdaptW)  ? (sign_dt_s1 ? (~f_2_s+one) : f_2_s) : {buffer_size{1'b0}} ;		  
	assign W_B     =   W_previous + DeltaW ;
	assign W_BS    =   W_B - W_MAX;
	assign sign_dw =   W_BS[buffer_size-1];
	
	always @(posedge clk)
	if (start_replay_phase==1'b0)
		W_new= W_previous;
	else
		if (  AdaptW==1'b1)
			case (sign_dw)
			1'b0:
			     case (sign_dt_s1)
			     1'b0:
			          W_new= W_MAX;
			     1'b1:
			          W_new= W_B;
			     endcase
			1'b1:
			     case (sign_dt_s1)
                 1'b0:
                      W_new=  W_B;
                 1'b1:
                        if (W_B[buffer_size-1]==1'b1)
                              W_new= {buffer_size{1'b0}};
                        else
                              W_new= W_B;
                 endcase
            endcase		     
	    else
		      W_new=W_previous;
	
	assign W_new_o = AdaptW ? W_new : W_previous;	
		
		endgenerate
	endmodule

