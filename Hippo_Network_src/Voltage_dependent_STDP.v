//////////////////////////////////////////////////////////////////////////////////
module Voltage_dependent_STDP(
  reset,clk,learning_phase, W_previous, A_pre,V_mem_post, Ca_post, W_new);
  
	`include "c_constants.v"
	
 	parameter buffer_size=32;
	
	parameter reset_type = `RESET_TYPE_ASYNC;
	
	parameter V_PEAK =32'b00000000000000000000000000000000;
	//parameter V_PEAK=16'b1111111111111111;
	parameter V_RESET=32'b11110111000010100000000000000000;
	
	parameter V_TH   =32'b11111001101000000000000000000000;
	//Imax_post=2 for depresion
	
	//for depresion 
	//parameter V_max    =32'b00000000000000001001000100010000;//V_max=dt*Imax/C=0.1(ms)*2(nA)/5.5(nF)= 3.6364e-05 == 2^-15+2^-18+2^-19+2^-23+2^-27
	//reg	[buffer_size-1:0] W_init   = 16'b0011100110011000;// W_init=0.45=2^-2+2^-3+2^-4+2^-7+2^-8+2^-11+2^-12
	//parameter V_sensory=32'b00000000000000011100100110010000;//V_max=dt*Imax/C=0.1(ms)*3(nA)/5.5(nF)= 5.4545e-05 == 2^-15+2^-16+2^-17+2^-20+2^-23+2^-24+2^-27
	
	
	//for potentiation 
	parameter V_max    =32'b00000000001000000000000000000000;//V_max=dt*Imax/C=0.1(ms)*2.6667(nA)/5.5(nF)= 4.8485e-05 == 2^-15+2^-16+2^-19+2^-21+2^-22+2^-24+2^-26+2^-27
	//  parameter	[buffer_size-1:0] W_init   = 16'b0100011001101000;// W_init=0.55=2^-1+2^-5+2^-6+2^-9+2^-10+2^-12
	//parameter V_sensory=32'b000000000000001001100010000010000;//V_max=dt*Imax/C=0.1(ms)*4(nA)/5.5(nF)=  7.2727e-05 == 2^-14+2^-17+2^-18+2^-22
	
	 
			
	//// data input  /////   
	input    reset; 
	
	input    clk;
	
	input    learning_phase;
	
	input    [buffer_size-1:0] W_previous;
	
   input    A_pre;
	//reg      A_pre_q;
	
	input    [buffer_size-1:0] V_mem_post;
	
	input    [buffer_size/2-1:0] Ca_post;	
		   
   //// data output /////
	//output   spike;
	//reg      spike;
    //output   [buffer_size-1:0] V_stim_post;
	//wire     [buffer_size-1:0] V_stim_post_s;
	//wire     [buffer_size-1:0] V_stim_post;
	
	output      [buffer_size-1:0]    W_new;
	//wire      [buffer_size-1:0]    W_new;
	
	//output   [buffer_size-1:0]    W;
	//reg      [buffer_size-1:0]    W;
	wire       [buffer_size-1:0]    W_s;
	reg      [buffer_size-1:0]    delta_w;
	reg      [buffer_size-1:0]    drift_w;
	//wire     [buffer_size-1:0]    Wq;
	//wire     [buffer_size-1:0]    W_s;
	//reg      [buffer_size-1:0]    W_s_q;	
	//wire     [buffer_size-1:0]    W_q;
	//wire     [buffer_size-1:0]    W_qq;
	//reg      [buffer_size-1:0]    W_qq_q;
	//wire     [buffer_size-1:0]    W_qqq;
	


	
	//// Net declaration ////
		
	reg	    [buffer_size-1:0]   C_peak   = 16'b0001000000000000;// to avoid overflow --> fixed point bit=[4:12]
	reg 		 [buffer_size/2-1:0] Tetta_l_p= 16'b0000010011001101;//=0.3;	//Tetta_l_p=0.3; to avoid overflow --> fixed point bit=[4:12]
	reg 		 [buffer_size/2-1:0] Tetta_h_p= 16'b0001010011001101;//=1.3;	//Tetta_h_p=1.3; to avoid overflow --> fixed point bit=[4:12]
	reg	    [buffer_size/2-1:0] Tetta_l_d= 16'b0000000110011100;//=0.1;	//Tetta_l_d=0.1; to avoid overflow --> fixed point bit=[4:12]
	reg	    [buffer_size/2-1:0] Tetta_h_d= 16'b0000011001100110;//=0.4;	//Tetta_h_d=0.4; to avoid overflow --> fixed point bit=[4:12]
	reg 		 [buffer_size-1:0]   Tetta_v  = 32'b11111001000110000000000000000000;//Tetta_v=V_RESET+0.8*(V_TH-V_RESET)=-0.054;//
	reg 		 [buffer_size-1:0]   W_max    = 32'b00000000001000000000000000000000;//=1e-3; 			//W_max=1; 
	reg	    [buffer_size-1:0]   W_min    = 32'b00000000000000000000000000000000;//=0;			//W_min=0;
	wire    	 [buffer_size-1:0]   Tetta_w;
	assign  	 Tetta_w  = ( W_max >> 1 ); //=0.5*W_max;//Tetta_w=0.5*W_max; % ya Tetta_x
	wire 		 [buffer_size-1:0]   a        ;//=0.1*W_max;		//a=0.1*W_max;
	assign 	 a =  ( W_max >> 4 ) + ( W_max >> 5 ) + ( W_max >> 8 ) + ( W_max >> 9 ) + ( W_max >> 11 );// 0.1 = 2^-4+2^-5+2^-8+2^-9+2^-11
	wire		 [buffer_size-1:0]   b        ;//=0.1*W_max;		//b=0.1*W_max;
	assign    b = a;
	wire		 [buffer_size-1:0]   alpha    ;//=3.5*10^-3*W_max;//alpha=3.5*10^-3*W_max;
	assign    alpha  ={buffer_size{1'b0}};
	//assign    alpha  = ( W_max >> 9 ) + ( W_max >> 10 ) + ( W_max >> 11 ) + ( W_max >> 14 ) + ( W_max >> 15 );//3.5*10^-3 = 2^-9+2^-10+2^-11+2^-14+2^-15
	wire		 [buffer_size-1:0]   betta    ; //=3.5*10^-3*W_max;//alpha=3.5*10^-3*W_max;
	//assign    betta  = ( W_max >> 9 ) + ( W_max >> 10 ) + ( W_max >> 11 ) + ( W_max >> 14 ) + ( W_max >> 15 );//3.5*10^-3 = 2^-9+2^-10+2^-11+2^-14+2^-15
	assign    betta  = {buffer_size{1'b0}};
	generate
//-------------stage 1--------------------------------	
	always @(posedge clk)begin
	if (reset==1'b1)begin
		delta_w = {buffer_size{1'b0}}; 
		drift_w =  {buffer_size{1'b0}};  end
	else
	   if (learning_phase == 1'b1) begin
		      if (A_pre == 1'b1) begin
	            if ( W_max >= W_previous && W_previous >= a)				
				       if ( V_mem_post	> Tetta_v)
			               if  (	Tetta_l_p <	Ca_post  &&  Ca_post	<	Tetta_h_p )
						       delta_w =  a;
				            else
						       delta_w =   {buffer_size{1'b0}};
				       else
				            if  ( Tetta_l_d < Ca_post  &&  Ca_post  <  Tetta_h_d )
					          delta_w =  ~b + 32'b00000000000000000000000000000001;
			               else
						       delta_w =  {buffer_size{1'b0}};	 			
               else			  
                   delta_w =   {buffer_size{1'b0}};
						 
						 
					if ( W_max >= W_previous && W_previous >= a)			 
								if ( W_max > W_previous && W_previous >= Tetta_w)
									drift_w =    alpha;
								else if ( W_min < W_previous && W_previous < Tetta_w)
									drift_w =  ~ betta + 32'b00000000000000000000000000000001;
								else
									drift_w =  {buffer_size{1'b0}};					
			      else begin
				           drift_w =  {buffer_size{1'b0}};					
				                end  
			  end
	        else begin
				  delta_w =  {buffer_size{1'b0}};
			     drift_w =  {buffer_size{1'b0}};					
	           end
	    end
		 else begin
	  		   delta_w =   {buffer_size{1'b0}};
			   drift_w =   {buffer_size{1'b0}};end
	end
	
//-------------stage 2--------------------------------
/*	
	always @(posedge clk)begin
	if (reset==1'b1)
		W = W1_s;
	else 
		if (A_pre_q == 1'b1) begin	       
			 if ( W_max >= W1_s && W1_s >= alpha)
			 
				if ( W_max > W1_s && W1_s >= Tetta_w)
					W =  (W1_s + alpha);
				else if ( W_min < W1_s && W1_s < Tetta_w)
					W =  (W1_s - betta);
				else
					W =  W1_s;
					
			 else
				W =  W1_s;					
		end
        
	  else  
			W = W1_s;  
			
	end*/
	//-------------stage 3--------------------------------
		
		
		assign W_s   = W_previous + drift_w + delta_w ;
		
		assign W_new = (W_s  >= W_max) ?  W_max :
							  ( a >= W_s )  ?  a     : W_s;
							
		/*assign W_s  = W;
		assign W_q = W_s-32'b00000000000010100000000000000000;//(W-0.3e-3)
		assign W_qq=(  W_q << 1 );//2W_M*(W-0.3) W_M=32'b00000000001000000000000000000000;//=1e-3; 
	
	//-------------stage 4--------------------------------
		
	always @(posedge clk)begin
	if (reset==1'b1) begin
		W_qq_q = W_init;
		W_s_q  = {buffer_size{1'b0}}; end
	else begin
		W_qq_q = W_qq;
		W_s_q =  W_s; end
	end

		
		//for depresion 
		// parameter V_sensory=32'b0 0000 0000 0000 0011 1001 0011 0010 000;//V_max=dt*Imax/C=0.1(ms)*3(nA)/5.5(nF)= 5.4545e-05 == 2^-15+2^-16+2^-17+2^-20+2^-23+2^-24+2^-27
		//parameter V_max    =32'b0 0000 0000 0000 0001 0010 0010 0010 000; 
		//assign W_qqq= (W_qq>>1) + (W_qq>>4) + (W_qq>>8) + (W_qq>>11);		//2*Vmax*(W-0.3)    0.3=2^-2+2^-5+2^-6+2^-9+2^-10+2^-12
		
		
		//for potentiation 
		//parameter V_sensory=32'b000000000000001001100010000010000;//V_max=dt*Imax/C=0.1(ms)*4(nA)/5.5(nF)=  7.2727e-05 == 2^-14+2^-17+2^-18+2^-22
		//parameter V_max    =32'b0 0000 0000 0000 0011 001011010100000;//V_max=dt*Imax/C=0.1(ms)*2.6667(nA)/5.5(nF)= 4.8485e-05 == 2^-15+2^-16+2^-19+2^-21+2^-22+2^-24+2^-26+2^-27
    
    //-------------stage --------------------------------
		
		//assign W_qqq= W_qq_q + (W_qq_q>>1) + (W_qq_q>>2) + (W_qq_q>>4);// + (W_qq_q>>6)+(W_qq_q>>7);		//Vmax*(2*(W-0.3))    0.3=2^-2+2^-5+2^-6+2^-9+2^-10+2^-12		
		
		assign V_stim_post_s=     (  W_qq >= 32'b00000000000110101000000000000000 )? V_max    : //W>0.8e-3= 2^-11+2^-12+2^-14+2^-16 
								  ( (W_qq <  32'b00000000000010100000000000000000 )? 32'b00000000000000000000000000000000 : W_q);//W< 0.3e-3 = 2^-12+2^-14
			
		c_dff 
	     #(.width(buffer_size),
	       .reset_value({buffer_size{1'b0}}),
	       .reset_type(reset_type))
	   V_stim
	     (.clk(clk),
	      .reset(reset),
	      .active(1'b1),
	      .d(V_stim_post_s),
	      .q(V_stim_post)); 
	      
	      	
         c_dff 
            #(.width(buffer_size),
              .reset_value({buffer_size{1'b0}}),
              .reset_type(reset_type))
          W_neww
             (.clk(clk),
              .reset(reset),
              .active(1'b1),
              .d(W_qq),
              .q(W_new));*/
		
		endgenerate
	endmodule

