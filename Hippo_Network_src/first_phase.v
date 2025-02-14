module first_phase(clk,run, reset,active,write_percorrect,iTrial, iRun, OutVec,HippoVec,ctrl_iRun, break,dig,InVec,change_InVec,InVecHst,HippoVecHst,OutVecHst);


`include "Net_parameters.v"


input  clk,run,reset,active;

input write_percorrect;

input [Neurons_Layer3-1:0] OutVec;

input [Neurons_Layer2-1:0] HippoVec;

input [Neurons_Layer1-1:0] InVec;

input [9:0] iTrial;

input ctrl_iRun;

input [9:0] iRun;

output break;
reg    break;

input dig;

output change_InVec;
reg    change_InVec;

//output   nHstCount;

output   [nHist*Neurons_Layer1-1:0] InVecHst;

output   [nHist*Neurons_Layer2-1:0] HippoVecHst;

output   [nHist*Neurons_Layer3-1:0] OutVecHst;

reg [Neurons_Layer3-1:0] OutVecH;

wire [Neurons_Layer1-1:0] InVecR;

reg  [Neurons_Layer1-1:0] InVecRP;

reg nHstCount;


integer iTime,iTime1,nDigSpike,nMoveSpike,nThDigSpike,nThMoveSpike;

///*
//reg TraceV_Hippo [0:Neurons_Layer2-1][0:nTimeTrial-1];
integer i,j,ii,c,iLastTime;
integer f0s0,f1s0,f2s0,f3s0,f4s0,f5s0,f6s0,f7s0;
integer f0s1,f1s1,f2s1,f3s1,f4s1,f5s1,f6s1,f7s1;
integer f0s2,f1s2,f2s2,f3s2,f4s2,f5s2,f6s2,f7s2;
integer f0s3,f1s3,f2s3,f3s3,f4s3,f5s3,f6s3,f7s3;
integer f0s4,f1s4,f2s4,f3s4,f4s4,f5s4,f6s4,f7s4;
integer f0s5,f1s5,f2s5,f3s5,f4s5,f5s5,f6s5,f7s5;
integer f0s6,f1s6,f2s6,f3s6,f4s6,f5s6,f6s6,f7s6;
integer f0s7,f1s7,f2s7,f3s7,f4s7,f5s7,f6s7,f7s7;
//*/
generate

/*

always @(posedge clk )
begin
	if (reset && ~run ) begin// faghat baraie raster plot_run=1
	  
	  $display ("Open %d\n"        ,reset,ctrl_iRun);
		f0s0 = $fopen("RP_0_s0.txt","w");
		f1s0 = $fopen("RP_1_s0.txt","w");
		f2s0 = $fopen("RP_2_s0.txt","w");
		f3s0 = $fopen("RP_3_s0.txt","w");
		f4s0 = $fopen("RP_4_s0.txt","w");
		f5s0 = $fopen("RP_5_s0.txt","w");
		f6s0 = $fopen("RP_6_s0.txt","w");
		f7s0 = $fopen("RP_7_s0.txt","w");
		
		f0s1 = $fopen("RP_0_s1.txt","w");
		f1s1 = $fopen("RP_1_s1.txt","w");
		f2s1 = $fopen("RP_2_s1.txt","w");
		f3s1 = $fopen("RP_3_s1.txt","w");
		f4s1 = $fopen("RP_4_s1.txt","w");
		f5s1 = $fopen("RP_5_s1.txt","w");
		f6s1 = $fopen("RP_6_s1.txt","w");
		f7s1 = $fopen("RP_7_s1.txt","w");
		
		f0s2 = $fopen("RP_0_s2.txt","w");
		f1s2 = $fopen("RP_1_s2.txt","w");
		f2s2 = $fopen("RP_2_s2.txt","w");
		f3s2 = $fopen("RP_3_s2.txt","w");
		f4s2 = $fopen("RP_4_s2.txt","w");
		f5s2 = $fopen("RP_5_s2.txt","w");
		f6s2 = $fopen("RP_6_s2.txt","w");
		f7s2 = $fopen("RP_7_s2.txt","w");
	
		f0s3 = $fopen("RP_0_s3.txt","w");
		f1s3 = $fopen("RP_1_s3.txt","w");
		f2s3 = $fopen("RP_2_s3.txt","w");
		f3s3 = $fopen("RP_3_s3.txt","w");
		f4s3 = $fopen("RP_4_s3.txt","w");
		f5s3 = $fopen("RP_5_s3.txt","w");
		f6s3 = $fopen("RP_6_s3.txt","w");
		f7s3 = $fopen("RP_7_s3.txt","w");
		
		f0s4 = $fopen("RP_0_s4.txt","w");
		f1s4 = $fopen("RP_1_s4.txt","w");
		f2s4 = $fopen("RP_2_s4.txt","w");
		f3s4 = $fopen("RP_3_s4.txt","w");
		f4s4 = $fopen("RP_4_s4.txt","w");
		f5s4 = $fopen("RP_5_s4.txt","w");
		f6s4 = $fopen("RP_6_s4.txt","w");
		f7s4 = $fopen("RP_7_s4.txt","w");
		
		f0s5 = $fopen("RP_0_s5.txt","w");
		f1s5 = $fopen("RP_1_s5.txt","w");
		f2s5 = $fopen("RP_2_s5.txt","w");
		f3s5 = $fopen("RP_3_s5.txt","w");
		f4s5 = $fopen("RP_4_s5.txt","w");
		f5s5 = $fopen("RP_5_s5.txt","w");
		f6s5 = $fopen("RP_6_s5.txt","w");
		f7s5 = $fopen("RP_7_s5.txt","w");
		
		f0s6 = $fopen("RP_0_s6.txt","w");
		f1s6 = $fopen("RP_1_s6.txt","w");
		f2s6 = $fopen("RP_2_s6.txt","w");
		f3s6 = $fopen("RP_3_s6.txt","w");
		f4s6 = $fopen("RP_4_s6.txt","w");
		f5s6 = $fopen("RP_5_s6.txt","w");
		f6s6 = $fopen("RP_6_s6.txt","w");
		f7s6 = $fopen("RP_7_s6.txt","w");
		
		f0s7 = $fopen("RP_0_s7.txt","w");
		f1s7 = $fopen("RP_1_s7.txt","w");
		f2s7 = $fopen("RP_2_s7.txt","w");
		f3s7 = $fopen("RP_3_s7.txt","w");
		f4s7 = $fopen("RP_4_s7.txt","w");
		f5s7 = $fopen("RP_5_s7.txt","w");
		f6s7 = $fopen("RP_6_s7.txt","w");
		f7s7 = $fopen("RP_7_s7.txt","w");
		
		iLastTime =0;	
		iTime1=0;
		for (i=0;i<Neurons_Layer2;i=i+1) 
		begin:aa
			for (j=0;j<nTimeTrial;j=j+1)  
			begin:bb
				TraceV_Hippo[i][j]=1'b0;
			end
		end
	end
	else if (run && reset && write_percorrect && ctrl_iRun) begin// faghat baraie raster plot_run=1
	
			$display ("Close %d\n"        ,reset,ctrl_iRun);
		$fclose(f0s0); 
		$fclose(f1s0); 
		$fclose(f2s0); 
		$fclose(f3s0); 
		$fclose(f4s0); 
		$fclose(f5s0); 
		$fclose(f6s0); 
		$fclose(f7s0); 
		
		$fclose(f0s1); 
		$fclose(f1s1); 
		$fclose(f2s1); 
		$fclose(f3s1); 
		$fclose(f4s1); 
		$fclose(f5s1); 
		$fclose(f6s1); 
		$fclose(f7s1);
		
		$fclose(f0s2); 
		$fclose(f1s2); 
		$fclose(f2s2); 
		$fclose(f3s2); 
		$fclose(f4s2); 
		$fclose(f5s2); 
		$fclose(f6s2); 
		$fclose(f7s2);
		
		$fclose(f0s3); 
		$fclose(f1s3); 
		$fclose(f2s3); 
		$fclose(f3s3); 
		$fclose(f4s3); 
		$fclose(f5s3); 
		$fclose(f6s3); 
		$fclose(f7s3);
		
		$fclose(f0s4); 
		$fclose(f1s4); 
		$fclose(f2s4); 
		$fclose(f3s4); 
		$fclose(f4s4); 
		$fclose(f5s4); 
		$fclose(f6s4); 
		$fclose(f7s4);
		
		$fclose(f0s5); 
		$fclose(f1s5); 
		$fclose(f2s5); 
		$fclose(f3s5); 
		$fclose(f4s5); 
		$fclose(f5s5); 
		$fclose(f6s5); 
		$fclose(f7s5);
		
		$fclose(f0s6); 
		$fclose(f1s6); 
		$fclose(f2s6); 
		$fclose(f3s6); 
		$fclose(f4s6); 
		$fclose(f5s6); 
		$fclose(f6s6); 
		$fclose(f7s6);
		
		$fclose(f0s7); 
		$fclose(f1s7); 
		$fclose(f2s7); 
		$fclose(f3s7); 
		$fclose(f4s7); 
		$fclose(f5s7); 
		$fclose(f6s7); 
		$fclose(f7s7);
	end
	
	else begin	
	   if (~active && ~break )	
	           iLastTime =0;
		       
		if(change_InVec || dig) begin
		InVecRP= change_InVec ? ((nHstCount) ? InVecHst[5:0] :  InVecHst[11:6])  :  ((nHstCount) ? InVecHst[11:6] :  InVecHst[5:0]);
			
			 case(InVecRP)
			 6'b010001:begin //s0
				$display ("iTrial s0 %d\n"         ,(iTrial[9:1]) );
				
				$fwrite (f0s0,"%d\n"        ,iRun);
				$fwrite (f1s0,"%d\n"        ,iRun);
				$fwrite (f2s0,"%d\n"        ,iRun);
				$fwrite (f3s0,"%d\n"        ,iRun);
				$fwrite (f4s0,"%d\n"        ,iRun);
				$fwrite (f5s0,"%d\n"        ,iRun);
				$fwrite (f6s0,"%d\n"        ,iRun);
				$fwrite (f7s0,"%d\n"        ,iRun);	
				
			    $fwrite (f0s0,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f1s0,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f2s0,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f3s0,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f4s0,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f5s0,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f6s0,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f7s0,"%d\n"        ,iTrial+10'b0000000001);	
				
			    $fwrite (f0s0,"%d\n"        ,(iTime1));
                $fwrite (f1s0,"%d\n"        ,(iTime1));
                $fwrite (f2s0,"%d\n"        ,(iTime1));
                $fwrite (f3s0,"%d\n"        ,(iTime1));
                $fwrite (f4s0,"%d\n"        ,(iTime1));
                $fwrite (f5s0,"%d\n"        ,(iTime1));
                $fwrite (f6s0,"%d\n"        ,(iTime1));
                $fwrite (f7s0,"%d\n"        ,(iTime1));                
               
                for (ii = 0; ii<iTime1; ii=ii+1) begin
                $fwrite (f0s0,"%b\n"        ,TraceV_Hippo[0][ii]);
                $fwrite (f1s0,"%b\n"        ,TraceV_Hippo[1][ii]);
                $fwrite (f2s0,"%b\n"        ,TraceV_Hippo[2][ii]);
                $fwrite (f3s0,"%b\n"        ,TraceV_Hippo[3][ii]);
                $fwrite (f4s0,"%b\n"        ,TraceV_Hippo[4][ii]);
                $fwrite (f5s0,"%b\n"        ,TraceV_Hippo[5][ii]);
                $fwrite (f6s0,"%b\n"        ,TraceV_Hippo[6][ii]);
                $fwrite (f7s0,"%b\n"        ,TraceV_Hippo[7][ii]);end
													
				
				
			   end
			6'b010010:begin //s1
				$display ("iTrial s1 %d\n"         ,(iTrial) );
				
			   $fwrite (f0s1,"%d\n"        ,iRun);
				$fwrite (f1s1,"%d\n"        ,iRun);
				$fwrite (f2s1,"%d\n"        ,iRun);
				$fwrite (f3s1,"%d\n"        ,iRun);
				$fwrite (f4s1,"%d\n"        ,iRun);
				$fwrite (f5s1,"%d\n"        ,iRun);
				$fwrite (f6s1,"%d\n"        ,iRun);
				$fwrite (f7s1,"%d\n"        ,iRun);	
				
				$fwrite (f0s1,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f1s1,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f2s1,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f3s1,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f4s1,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f5s1,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f6s1,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f7s1,"%d\n"        ,iTrial+10'b0000000001);
				
				$fwrite (f0s1,"%d\n"        ,(iTime1));
                $fwrite (f1s1,"%d\n"        ,(iTime1));
                $fwrite (f2s1,"%d\n"        ,(iTime1));
                $fwrite (f3s1,"%d\n"        ,(iTime1));
                $fwrite (f4s1,"%d\n"        ,(iTime1));
                $fwrite (f5s1,"%d\n"        ,(iTime1));
                $fwrite (f6s1,"%d\n"        ,(iTime1));
                $fwrite (f7s1,"%d\n"        ,(iTime1));                
                               
                for (ii = 0; ii<iTime1; ii=ii+1) begin
                $fwrite (f0s1,"%b\n"        ,TraceV_Hippo[0][ii]);
                $fwrite (f1s1,"%b\n"        ,TraceV_Hippo[1][ii]);
                $fwrite (f2s1,"%b\n"        ,TraceV_Hippo[2][ii]);
                $fwrite (f3s1,"%b\n"        ,TraceV_Hippo[3][ii]);
                $fwrite (f4s1,"%b\n"        ,TraceV_Hippo[4][ii]);
                $fwrite (f5s1,"%b\n"        ,TraceV_Hippo[5][ii]);
                $fwrite (f6s1,"%b\n"        ,TraceV_Hippo[6][ii]);
                $fwrite (f7s1,"%b\n"        ,TraceV_Hippo[7][ii]);end	
				
				
				
				
				end
			6'b010100:begin //s2
				$display ("iTrial s2 %d\n"         ,iTrial);
				
			   $fwrite (f0s2,"%d\n"        ,iRun);
				$fwrite (f1s2,"%d\n"        ,iRun);
				$fwrite (f2s2,"%d\n"        ,iRun);
				$fwrite (f3s2,"%d\n"        ,iRun);
				$fwrite (f4s2,"%d\n"        ,iRun);
				$fwrite (f5s2,"%d\n"        ,iRun);
				$fwrite (f6s2,"%d\n"        ,iRun);
				$fwrite (f7s2,"%d\n"        ,iRun);	
								
				$fwrite (f0s2,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f1s2,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f2s2,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f3s2,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f4s2,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f5s2,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f6s2,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f7s2,"%d\n"        ,iTrial+10'b0000000001);	

                $fwrite (f0s2,"%d\n"        ,(iTime1));
                $fwrite (f1s2,"%d\n"        ,(iTime1));
                $fwrite (f2s2,"%d\n"        ,(iTime1));
                $fwrite (f3s2,"%d\n"        ,(iTime1));
                $fwrite (f4s2,"%d\n"        ,(iTime1));
                $fwrite (f5s2,"%d\n"        ,(iTime1));
                $fwrite (f6s2,"%d\n"        ,(iTime1));
                $fwrite (f7s2,"%d\n"        ,(iTime1));                
                               
                for (ii = 0; ii<iTime1; ii=ii+1) begin
                $fwrite (f0s2,"%b\n"        ,TraceV_Hippo[0][ii]);
                $fwrite (f1s2,"%b\n"        ,TraceV_Hippo[1][ii]);
                $fwrite (f2s2,"%b\n"        ,TraceV_Hippo[2][ii]);
                $fwrite (f3s2,"%b\n"        ,TraceV_Hippo[3][ii]);
                $fwrite (f4s2,"%b\n"        ,TraceV_Hippo[4][ii]);
                $fwrite (f5s2,"%b\n"        ,TraceV_Hippo[5][ii]);
                $fwrite (f6s2,"%b\n"        ,TraceV_Hippo[6][ii]);
                $fwrite (f7s2,"%b\n"        ,TraceV_Hippo[7][ii]);end			
				
				
				
				end
			6'b011000:begin //s3
				$display ("iTrial s3 %d\n"         ,(iTrial[9:1]) );
				
			   $fwrite (f0s3,"%d\n"         ,iRun);
				$fwrite (f1s3,"%d\n"        ,iRun);
				$fwrite (f2s3,"%d\n"        ,iRun);
				$fwrite (f3s3,"%d\n"        ,iRun);
				$fwrite (f4s3,"%d\n"        ,iRun);
				$fwrite (f5s3,"%d\n"        ,iRun);
				$fwrite (f6s3,"%d\n"        ,iRun);
				$fwrite (f7s3,"%d\n"        ,iRun);	
				
				
				$fwrite (f0s3,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f1s3,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f2s3,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f3s3,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f4s3,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f5s3,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f6s3,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f7s3,"%d\n"        ,iTrial+10'b0000000001);	
				
				$fwrite (f0s3,"%d\n"        ,(iTime1));
                $fwrite (f1s3,"%d\n"        ,(iTime1));
                $fwrite (f2s3,"%d\n"        ,(iTime1));
                $fwrite (f3s3,"%d\n"        ,(iTime1));
                $fwrite (f4s3,"%d\n"        ,(iTime1));
                $fwrite (f5s3,"%d\n"        ,(iTime1));
                $fwrite (f6s3,"%d\n"        ,(iTime1));
                $fwrite (f7s3,"%d\n"        ,(iTime1));                
                              
                for (ii = 0; ii<iTime1; ii=ii+1) begin
                $fwrite (f0s3,"%b\n"        ,TraceV_Hippo[0][ii]);
                $fwrite (f1s3,"%b\n"        ,TraceV_Hippo[1][ii]);
                $fwrite (f2s3,"%b\n"        ,TraceV_Hippo[2][ii]);
                $fwrite (f3s3,"%b\n"        ,TraceV_Hippo[3][ii]);
                $fwrite (f4s3,"%b\n"        ,TraceV_Hippo[4][ii]);
                $fwrite (f5s3,"%b\n"        ,TraceV_Hippo[5][ii]);
                $fwrite (f6s3,"%b\n"        ,TraceV_Hippo[6][ii]);
                $fwrite (f7s3,"%b\n"        ,TraceV_Hippo[7][ii]);end
				
				
				
				end
			6'b100001:begin		//s4
				$display ("iTrial s4 %d\n"         ,iTrial );
				
				$fwrite (f0s4,"%d\n"        ,iRun);
				$fwrite (f1s4,"%d\n"        ,iRun);
				$fwrite (f2s4,"%d\n"        ,iRun);
				$fwrite (f3s4,"%d\n"        ,iRun);
				$fwrite (f4s4,"%d\n"        ,iRun);
				$fwrite (f5s4,"%d\n"        ,iRun);
				$fwrite (f6s4,"%d\n"        ,iRun);
				$fwrite (f7s4,"%d\n"        ,iRun);	
				
				$fwrite (f0s4,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f1s4,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f2s4,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f3s4,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f4s4,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f5s4,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f6s4,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f7s4,"%d\n"        ,iTrial+10'b0000000001);
				
				$fwrite (f0s4,"%d\n"        ,(iTime1));
                $fwrite (f1s4,"%d\n"        ,(iTime1));
                $fwrite (f2s4,"%d\n"        ,(iTime1));
                $fwrite (f3s4,"%d\n"        ,(iTime1));
                $fwrite (f4s4,"%d\n"        ,(iTime1));
                $fwrite (f5s4,"%d\n"        ,(iTime1));
                $fwrite (f6s4,"%d\n"        ,(iTime1));
                $fwrite (f7s4,"%d\n"        ,(iTime1));                
                               
                for (ii = 0; ii<iTime1; ii=ii+1) begin
                $fwrite (f0s4,"%b\n"        ,TraceV_Hippo[0][ii]);
                $fwrite (f1s4,"%b\n"        ,TraceV_Hippo[1][ii]);
                $fwrite (f2s4,"%b\n"        ,TraceV_Hippo[2][ii]);
                $fwrite (f3s4,"%b\n"        ,TraceV_Hippo[3][ii]);
                $fwrite (f4s4,"%b\n"        ,TraceV_Hippo[4][ii]);
                $fwrite (f5s4,"%b\n"        ,TraceV_Hippo[5][ii]);
                $fwrite (f6s4,"%b\n"        ,TraceV_Hippo[6][ii]);
                $fwrite (f7s4,"%b\n"        ,TraceV_Hippo[7][ii]);end	
		
				end
			6'b100010:begin //s5
				$display ("iTrial s5 %d\n"         ,(iTrial) );
				
			    $fwrite (f0s5,"%d\n"        ,iRun);
				$fwrite (f1s5,"%d\n"        ,iRun);
				$fwrite (f2s5,"%d\n"        ,iRun);
				$fwrite (f3s5,"%d\n"        ,iRun);
				$fwrite (f4s5,"%d\n"        ,iRun);
				$fwrite (f5s5,"%d\n"        ,iRun);
				$fwrite (f6s5,"%d\n"        ,iRun);
				$fwrite (f7s5,"%d\n"        ,iRun);				
				
				$fwrite (f0s5,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f1s5,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f2s5,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f3s5,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f4s5,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f5s5,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f6s5,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f7s5,"%d\n"        ,iTrial+10'b0000000001);
				
			    $fwrite (f0s5,"%d\n"        ,(iTime1));
                $fwrite (f1s5,"%d\n"        ,(iTime1));
                $fwrite (f2s5,"%d\n"        ,(iTime1));
                $fwrite (f3s5,"%d\n"        ,(iTime1));
                $fwrite (f4s5,"%d\n"        ,(iTime1));
                $fwrite (f5s5,"%d\n"        ,(iTime1));
                $fwrite (f6s5,"%d\n"        ,(iTime1));
                $fwrite (f7s5,"%d\n"        ,(iTime1));                
                               
                for (ii = 0; ii<iTime1; ii=ii+1) begin
                $fwrite (f0s5,"%b\n"        ,TraceV_Hippo[0][ii]);
                $fwrite (f1s5,"%b\n"        ,TraceV_Hippo[1][ii]);
                $fwrite (f2s5,"%b\n"        ,TraceV_Hippo[2][ii]);
                $fwrite (f3s5,"%b\n"        ,TraceV_Hippo[3][ii]);
                $fwrite (f4s5,"%b\n"        ,TraceV_Hippo[4][ii]);
                $fwrite (f5s5,"%b\n"        ,TraceV_Hippo[5][ii]);
                $fwrite (f6s5,"%b\n"        ,TraceV_Hippo[6][ii]);
                $fwrite (f7s5,"%b\n"        ,TraceV_Hippo[7][ii]);end    	
				
				
				end
			6'b100100:begin //s6
				$display ("iTrial s6 %d\n"         ,(iTrial) );
				
			    $fwrite (f0s6,"%d\n"        ,iRun);
				$fwrite (f1s6,"%d\n"        ,iRun);
				$fwrite (f2s6,"%d\n"        ,iRun);
				$fwrite (f3s6,"%d\n"        ,iRun);
				$fwrite (f4s6,"%d\n"        ,iRun);
				$fwrite (f5s6,"%d\n"        ,iRun);
				$fwrite (f6s6,"%d\n"        ,iRun);
				$fwrite (f7s6,"%d\n"        ,iRun);
				
				$fwrite (f0s6,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f1s6,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f2s6,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f3s6,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f4s6,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f5s6,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f6s6,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f7s6,"%d\n"        ,iTrial+10'b0000000001);
				
			    $fwrite (f0s6,"%d\n"        ,(iTime1));
                $fwrite (f1s6,"%d\n"        ,(iTime1));
                $fwrite (f2s6,"%d\n"        ,(iTime1));
                $fwrite (f3s6,"%d\n"        ,(iTime1));
                $fwrite (f4s6,"%d\n"        ,(iTime1));
                $fwrite (f5s6,"%d\n"        ,(iTime1));
                $fwrite (f6s6,"%d\n"        ,(iTime1));
                $fwrite (f7s6,"%d\n"        ,(iTime1));                
               
                for (ii = 0; ii<iTime1; ii=ii+1) begin
                $fwrite (f0s6,"%b\n"        ,TraceV_Hippo[0][ii]);
                $fwrite (f1s6,"%b\n"        ,TraceV_Hippo[1][ii]);
                $fwrite (f2s6,"%b\n"        ,TraceV_Hippo[2][ii]);
                $fwrite (f3s6,"%b\n"        ,TraceV_Hippo[3][ii]);
                $fwrite (f4s6,"%b\n"        ,TraceV_Hippo[4][ii]);
                $fwrite (f5s6,"%b\n"        ,TraceV_Hippo[5][ii]);
                $fwrite (f6s6,"%b\n"        ,TraceV_Hippo[6][ii]);
                $fwrite (f7s6,"%b\n"        ,TraceV_Hippo[7][ii]);end	
				
				
				end
			6'b101000:begin //s7
				$display ("iTrial s7 %d\n"         ,(iTrial) );
				
				$fwrite (f0s7,"%d\n"        ,iRun);
				$fwrite (f1s7,"%d\n"        ,iRun);
				$fwrite (f2s7,"%d\n"        ,iRun);
				$fwrite (f3s7,"%d\n"        ,iRun);
				$fwrite (f4s7,"%d\n"        ,iRun);
				$fwrite (f5s7,"%d\n"        ,iRun);
				$fwrite (f6s7,"%d\n"        ,iRun);
				$fwrite (f7s7,"%d\n"        ,iRun);
			
			    $fwrite (f0s7,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f1s7,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f2s7,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f3s7,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f4s7,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f5s7,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f6s7,"%d\n"        ,iTrial+10'b0000000001);
				$fwrite (f7s7,"%d\n"        ,iTrial+10'b0000000001);	
				
				$fwrite (f0s7,"%d\n"        ,(iTime1));
                $fwrite (f1s7,"%d\n"        ,(iTime1));
                $fwrite (f2s7,"%d\n"        ,(iTime1));
                $fwrite (f3s7,"%d\n"        ,(iTime1));
                $fwrite (f4s7,"%d\n"        ,(iTime1));
                $fwrite (f5s7,"%d\n"        ,(iTime1));
                $fwrite (f6s7,"%d\n"        ,(iTime1));
                $fwrite (f7s7,"%d\n"        ,(iTime1));                
                               
                for (ii = 0; ii<iTime1; ii=ii+1) begin
                $fwrite (f0s7,"%b\n"        ,TraceV_Hippo[0][ii]);
                $fwrite (f1s7,"%b\n"        ,TraceV_Hippo[1][ii]);
                $fwrite (f2s7,"%b\n"        ,TraceV_Hippo[2][ii]);
                $fwrite (f3s7,"%b\n"        ,TraceV_Hippo[3][ii]);
                $fwrite (f4s7,"%b\n"        ,TraceV_Hippo[4][ii]);
                $fwrite (f5s7,"%b\n"        ,TraceV_Hippo[5][ii]);
                $fwrite (f6s7,"%b\n"        ,TraceV_Hippo[6][ii]);
                $fwrite (f7s7,"%b\n"        ,TraceV_Hippo[7][ii]);end    
				
				
				end
			
			endcase	
					
			
			iLastTime = iTime;
			iTime1=0;
			
		end
		
		if (~break) begin		    
			for (i=0;i<Neurons_Layer2;i=i+1) 
			begin:cc
				TraceV_Hippo[i][iTime]= HippoVec[i];
			end
			iTime1=iTime1+1;end
		else
		    iTime1=iTime1;
		
		
		
	
end	
end
*/
always @(posedge clk, posedge reset)

	    if (reset) 
		 begin
	   	    iTime=0;
			nMoveSpike=0;
			nDigSpike=0;
			nThMoveSpike=5;
			nThDigSpike=5;
			change_InVec=1'b0;
			break=1'b0;
			OutVecH=2'b00;	
			nHstCount=1'b0;

   		 end
		 else if ( ~active  ) 
		 begin
	   	iTime=0;
			nMoveSpike=0;
			nDigSpike=0;
			nThMoveSpike=5;
			nThDigSpike=5;
			change_InVec=1'b0;
			break=1'b0;
			OutVecH=2'b00;
			nHstCount=1'b0;

   		 end
		 else
		 begin
			iTime=iTime+1;
			nDigSpike = OutVec[0]?(nDigSpike+1):nDigSpike;
			nMoveSpike= OutVec[1]?(nMoveSpike+1):nMoveSpike;	
			change_InVec=1'b0;
		
			
			if(nMoveSpike>=nThMoveSpike)
				begin				
					nThMoveSpike    = 5;
					nThDigSpike     = (nThDigSpike - 1>0) ? (nThDigSpike-1) : 0;
					nMoveSpike=0;

					change_InVec=1'b1;
					OutVecH=2'b10;
					case (nHstCount)
						1'b0:	
								nHstCount=1'b1;
	
						1'b1:	
								nHstCount=1'b0;
		
					endcase
				end
				
			if(nDigSpike>=nThDigSpike)
				begin				
					OutVecH=2'b01;
					break=1'b1;						
					nDigSpike=0;					
				end
		end
		

/*
parameter nThMove=3;
parameter nThDig=3;
always @(posedge clk, posedge reset)
	    if (reset) 
		 begin
	   	iTime=0;
			nMoveSpike=0;
			nDigSpike=0;
			nThMoveSpike=nThMove;
			nThDigSpike=nThDig;
			change_InVec=1'b0;
			break=1'b0;
			OutVecH=2'b00;	
			nHstCount=1'b0;
			//InVecHstR={{(nHist-1)*Neurons_Layer1{1'b0}},InVec};
   		 end
		 else if ( active==1'b0  ) 
		 begin
	   	    iTime=0;
			nMoveSpike=0;
			nDigSpike=0;
			nThMoveSpike=nThMove;
			nThDigSpike=nThDig;
			change_InVec=1'b0;
			break=1'b0;
			OutVecH=2'b00;
			nHstCount=1'b0;
			//InVecHstR={{(nHist-1)*Neurons_Layer1{1'b0}},InVec};
   		 end
		 else
		 begin
			iTime=iTime+1;
			nDigSpike = (~break && OutVec[0]) ? (nDigSpike+1) : nDigSpike;
			nMoveSpike= (~break && OutVec[1]) ? (nMoveSpike+1): nMoveSpike;	
			change_InVec=1'b0;
			//nHstCount=1'b0;
			
			if(nMoveSpike>=nThMoveSpike)
				begin				
					nThMoveSpike    = nThMove;
					nThDigSpike     = (nThDigSpike - 1>0) ? (nThDigSpike-1) : 0;
					nMoveSpike=0;
					//iLastTime = iTime;
					change_InVec=1'b1;
					OutVecH[1]=1'b1;
				    if(nDigSpike>=nThDigSpike)
				       nHstCount=nHstCount;
				    else	
					  case (nHstCount)
						  1'b0:	
								nHstCount=1'b1;
								//InVecHstR = { InVec , InVecHstR[Neurons_Layer1-1 -:Neurons_Layer1]};end
						  1'b1:	
								nHstCount=1'b0;
								//InVecHstR = { InVecHstR[nHist*Neurons_Layer1-1 -:Neurons_Layer1], InVec };end
					  endcase
				end
				
			if(nDigSpike>=nThDigSpike)
				begin				
					OutVecH=2'b01;
					break=1'b1;						
					nDigSpike=0;					
				end
		end
*/		


		 
		
		InOutHistory
		#(.Neurons_Layer1(Neurons_Layer1),
		  .Neurons_Layer3(Neurons_Layer3),
		  .nHist(nHist))
		INOUTHIST
		(.clk(clk),
		 .reset(reset),
		 .break(break),
		 .change_InVec(change_InVec),
		 .OutVecH(OutVecH),
		 .OutVec(OutVec),
		 .InVec(InVec),
		 .HippoVec(HippoVec),
		 .nHstCount(nHstCount),
		 .OutVecHst(OutVecHst),
		 .InVecHst(InVecHst),
		 .HippoVecHst(HippoVecHst));
		 
		
		
		endgenerate	

	endmodule
	
