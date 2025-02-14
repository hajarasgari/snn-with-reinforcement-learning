////////////////////////////////////////////////////////////////////////
//In the begining initial value for synapses extract using this mudule//
/////////////Initializing_sunapses.v////////////////////////////////////
/////////////Hajar Asgari///////////////////////////////////////////////

module Initializing_synapses
(clk,reset,active,Synapses_value );

//`define  ADD_PARAM		1        
//`include "parameters.v"

////////parameters//////////////////
`include "Net_parameters.v"


input clk;
wire clk;
input reset;
wire reset;

input active;
wire active;

output [Num_Neurons*Num_Neurons*buffer_size-1:0] Synapses_value;

///////////////////////Reg and net definition/////////////////////////////////

wire [buffer_size-1:0] Synapses [0:Num_Neurons-1] [0:Num_Neurons-1];

wire [Num_Neurons*buffer_size-1:0] Synapses_type [0:Num_Neurons-1];

wire [Neurons_Layer1*Neurons_Layer2*(buffer_size-1)-1:0] out_lfsr1;

wire [Neurons_Layer2*(buffer_size-1)-1:0] out_lfsr2[0:Neurons_Layer1-1];
////////////////////////////////////////////////////////////////////////////

generate
genvar i,j,k,l,m,n,o,p,q,r,s,t;
////////////////////////////////////////////////////////////////////////////////
/////////////W11,W12,W21,W13,W31//// fromLayer1	To Layer 1 and Layer2 and Layer3
					c_lfsr #(.buffer_size(buffer_size))
			RNG1  (.clk(clk),
					 .init(reset),  
					 .en(active),
					 .seed(16'b0101110001110000),
					 .poly(16'b1010101010101010),
					 .Q(Synapses[0][6]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG2	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0110001001001000),
					 .poly(16'b0100010001000100),
					 .Q(Synapses[0][7]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG3	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0111100001110000),
					 .poly(16'b1100110011001100),
					 .Q(Synapses[0][8]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG4	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0101000001111100),
					 .poly(19'b1011101110111011),
					 .Q(Synapses[0][9]));
					 
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG5	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0110100111110000),
					 .poly(16'b0100010001000100),
					 .Q(Synapses[0][10]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG6	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0111001100011100),
					 .poly(16'b1001100110011001),
					 .Q(Synapses[0][11]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG7	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0110110000110100),
					 .poly(16'b1010101010101010),
					 .Q(Synapses[0][12]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG8 	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0110111101101100),
					 .poly(16'b0011001100110011),
					 .Q(Synapses[0][13]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG9	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0110111101101111),
					 .poly(16'b1001100110011001),
					 .Q(Synapses[1][6]));
					
				c_lfsr #(.buffer_size(buffer_size))
			RNG10	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0101101001011100),
					 .poly(16'b1010101010101010),
					 .Q(Synapses[1][7]));	
				
					 c_lfsr #(.buffer_size(buffer_size))
			RNG12	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0111010001000100),
					 .poly(16'b0101010101010101),
					 .Q(Synapses[1][8]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG13	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0110101000110110),
					 .poly(16'b0101010101010101),
					 .Q(Synapses[1][9]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG14	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0111001001110100),
					 .poly(16'b1101110111011101),
					 .Q(Synapses[1][10]));
					 
					c_lfsr #(.buffer_size(buffer_size))
			RNG15	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0111101000110000),
					 .poly(16'b1010101010101010),
					 .Q(Synapses[1][11]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG16	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0110010111111100),
					 .poly(16'b1011101110111011),
					 .Q(Synapses[1][12]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG17	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0111011000011100),
					 .poly(16'b1000100010001000),
					 .Q(Synapses[1][13]));
					 
					 
					  c_lfsr #(.buffer_size(buffer_size))
			RNG18	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0101101001110100),
					 .poly(16'b0101010101010101),
					 .Q(Synapses[2][6]));
					
				c_lfsr #(.buffer_size(buffer_size))
			RNG19	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0110010111111100),
					 .poly(16'b1110111011101110),
					 .Q(Synapses[2][7]));	
				
					 c_lfsr #(.buffer_size(buffer_size))
			RNG20	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0111000010100000),
					 .poly(16'b1011101110111011),
					 .Q(Synapses[2][8]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG21	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0100110011001000),
					 .poly(16'b1011101110111011),
					 .Q(Synapses[2][9]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG22	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0101010100110100),
					 .poly(16'b1101110111011101),
					 .Q(Synapses[2][10]));
					 
					c_lfsr #(.buffer_size(buffer_size))
			RNG23	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0101100110010100),
					 .poly(16'b1000100010001000),
					 .Q(Synapses[2][11]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG24	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0101000111100100),
					 .poly(16'b1000100010001000),
					 .Q(Synapses[2][12]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG25	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0110010001001000),
					 .poly(16'b0101010101010101),
					 .Q(Synapses[2][13]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG26	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0111010101011010),
					 .poly(16'b1001100110011001),
					 .Q(Synapses[3][6]));
					
				c_lfsr #(.buffer_size(buffer_size))
			RNG27	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0111100000001000),
					 .poly(16'b1011101110111011),
					 .Q(Synapses[3][7]));	
				
					 c_lfsr #(.buffer_size(buffer_size))
			RNG28	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0110001100010110),
					 .poly(16'b1101110111011101),
					 .Q(Synapses[3][8]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG29	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0110001000000110),
					 .poly(16'b1111110111011101),
					 .Q(Synapses[3][9]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG30	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0111101101100000),
					 .poly(16'b1101110111011101),
					 .Q(Synapses[3][10]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG31	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0110001111001000),
					 .poly(16'b1101110111011011),
					 .Q(Synapses[3][11]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG32	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0111111000101000),
					 .poly(16'b1101110111011011),
					 .Q(Synapses[3][12]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG33	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0011110000011000),
					 .poly(16'b1001110111011101),
					 .Q(Synapses[3][13]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG34	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0011111010000100),
					 .poly(16'b1101110111011101),
					 .Q(Synapses[4][6]));
					
				c_lfsr #(.buffer_size(buffer_size))
			RNG35	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0100101001010100),
					 .poly(16'b0101010101010101),
					 .Q(Synapses[4][7]));	
				
					 c_lfsr #(.buffer_size(buffer_size))
			RNG36	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0111010100000100),
					 .poly(16'b1111010101010101),
					 .Q(Synapses[4][8]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG37	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0010010001110000),
					 .poly(16'b1001010101010101),
					 .Q(Synapses[4][9]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG38	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0111101011101000),
					 .poly(16'b1101110111011101),
					 .Q(Synapses[4][10]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG39	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0111001011110000),
					 .poly(16'b1001110111011101),
					 .Q(Synapses[4][11]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG40	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0110000100111100),
					 .poly(16'b1110111011101101),
					 .Q(Synapses[4][12]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG41	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0111110110100010),
					 .poly(16'b1011110111011101),
					 .Q(Synapses[4][13]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG42	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0100111001001100),
					 .poly(16'b1000110111011101),
					 .Q(Synapses[5][6]));
					
				    c_lfsr #(.buffer_size(buffer_size))
			RNG43	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0101111010000100),
					 .poly(16'b1011101110111011),
					 .Q(Synapses[5][7]));	
				
					 c_lfsr #(.buffer_size(buffer_size))
			RNG44	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0010010111101000),
					 .poly(16'b1101111011011011),
					 .Q(Synapses[5][8]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG45	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0110111001110110),
					 .poly(16'b0111011101110111),
					 .Q(Synapses[5][9]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG46	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0001100000011100),
					 .poly(16'b0111011101110101),
					 .Q(Synapses[5][10]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG47	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0100100111110010),
					 .poly(16'b1111011101110111),
					 .Q(Synapses[5][11]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG48	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b0110011010111000),
					 .poly(16'b1001011101110111),
					 .Q(Synapses[5][12]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG49	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b011001100001110),
					 .poly(16'b1011011101110111),
					 .Q(Synapses[5][13]));
					 
					 
					 
					 
					 
					 
 for (m=0; m<Neurons_Layer1; m=m+1)
 begin: W11W21
//////////////////////W11//////////////////////////////		
		
		for (r=0;r< Neurons_Layer1; r=r+1)
		begin: W11
			assign Synapses[m][r]={buffer_size{1'b0}}; 
		end
/////////////////////W12,W21///////////////////////////
	   
		//assign out_lfsr2[m]=out_lfsr1[(m+1)*Neurons_Layer2*(buffer_size-1)-1 -:Neurons_Layer2*(buffer_size-1)];
		for (n=Neurons_Layer1; n< Neurons_Layer1+Neurons_Layer2; n=n+1)
		begin: W21
			assign Synapses[n][m]={buffer_size{1'b0}}; //W21				 
		//			 assign Synapses[m][n][buffer_size-1:0]=out_lfsr2[m][((n-Neurons_Layer1+1)*(buffer_size-1))-1 -: (buffer_size-1)];
		//					 assign Synapses[m][n][buffer_size-1]=1'b0;
		
		/*c_lfsr #(.buffer_size(buffer_size),
			         .n(buffer_size-1))
			RNG2
					(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed({buffer_size-1 {3'b011}}),
					 .poly({buffer_size-1 {3'b101}}),
					 .Q(Synapses[m][n]));*/
		end
////////////////////W13,W31///////////////////////////////
		for (q=Neurons_Layer1+Neurons_Layer2; q< Num_Neurons; q=q+1)
		begin: W13W31
			assign Synapses[m][q]={buffer_size{1'b0}}; //W13
			assign Synapses[q][m]={buffer_size{1'b0}}; //W31			
		end
		
  end
	
///////////////////////////////////////////////////////////////////	
//////////////W22: fromLayer2 To Layer2////////////////////////////
 for (i=Neurons_Layer1; i< Neurons_Layer1+Neurons_Layer2; i=i+1)
 begin: from2toLayer2
		for (j=Neurons_Layer1;j< Neurons_Layer1+Neurons_Layer2 ; j=j+1)
		begin: W22
			assign Synapses[i][j]=(i!=j)? Inh :{buffer_size{1'b0}};//W22
		   //assign Synapses[j][i]=(i!=j)?16'b1000000000000000:{buffer_size{1'b0}};//W22
		end
 end
///////////////////////////////////////////////////////////////////
//////////////W23,W32: fromLayer2	To Layer3/////////////////////////
 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG50	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b1010100000101000),
					 .poly(16'b0101011101110111),
					 .Q(Synapses[6][14]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG51	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b1101101110000010),
					 .poly(16'b0110011001100110),
					 .Q(Synapses[6][15]));
					 
					c_lfsr #(.buffer_size(buffer_size))
			RNG52	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b1100010111110110),
					 .poly(16'b0101011001100110),
					 .Q(Synapses[7][14]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG53	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b1101000011100000),
					 .poly(16'b1100011001100110),
					 .Q(Synapses[7][15]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG54	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b1110001010101100),
					 .poly(16'b1110011001100110),
					 .Q(Synapses[8][14]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG55	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b1110100010001000),
					 .poly(16'b0110011010010110),
					 .Q(Synapses[8][15]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG56	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b1011111000010000),
					 .poly(16'b1110110110010110),
					 .Q(Synapses[9][14]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG57	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b1101100001110110),
					 .poly(16'b1100011001100110),
					 .Q(Synapses[9][15]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG58	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b1101001110111000),
					 .poly(16'b1101110111011101),
					 .Q(Synapses[10][14]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG59	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b11101000101010100),
					 .poly(16'b1111110111011101),
					 .Q(Synapses[10][15]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG60	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b1101101100010100),
					 .poly(16'b1011110111011101),
					 .Q(Synapses[11][14]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG61	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b1110011111101100),
					 .poly(16'b1010110111011101),
					 .Q(Synapses[11][15]));
					 
					c_lfsr #(.buffer_size(buffer_size))
			RNG62	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b1100111001000100),
					 .poly(16'b1111011101110101),
					 .Q(Synapses[12][14]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG63	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b1110011010011010),
					 .poly(16'b1011111110111011),
					 .Q(Synapses[12][15]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG64	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b1110011110101000),
					 .poly(16'b1111110111011101),
					 .Q(Synapses[13][14]));
					 
					 c_lfsr #(.buffer_size(buffer_size))
			RNG65	(.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(16'b1101101001101000),
					 .poly(16'b1011110111011101),
					 .Q(Synapses[13][15]));
					 
 for (o=Neurons_Layer1; o< Neurons_Layer1+Neurons_Layer2; o=o+1)
 begin: fromtoLayer23
		for (p= Neurons_Layer1+Neurons_Layer2; p<Num_Neurons; p=p+1)
		begin: W23W32
			assign Synapses[p][o]={buffer_size{1'b0}};//W32
		end
 end
////////////////////////////////////////////////////////////////////
/////////////W33: from Layer3 To Layer3//////////////////////////////
  for (k=Neurons_Layer1+Neurons_Layer2; k< Num_Neurons; k=k+1)
  begin: fromtoLayer33
		for (l=Neurons_Layer1+Neurons_Layer2;l< Num_Neurons; l=l+1)
		begin: W33
			assign Synapses[k][l]=(l!=k)? Inh :{buffer_size{1'b0}}; //W33
			//assign Synapses[l][k]=(l!=k)?16'b1000000000000000:{buffer_size{1'b0}}; //W33
		end
  end
///////////////////////////////////////////////////////////////////////

	//Output array
  for (s=0; s<Num_Neurons; s=s+1)
  begin:SynapticMatrox
		for (t=0; t<Num_Neurons; t=t+1)
		begin:Synaptic_out
			assign Synapses_type[s][((t+1)*buffer_size)-1 -: buffer_size] = Synapses[t][s];
		end
		
		assign Synapses_value [((s+1)*buffer_size*Num_Neurons)-1 -: buffer_size*Num_Neurons] = Synapses_type[s];
  end
endgenerate
endmodule 