module StartPoint
(clk,reset,active,iTrial,InVec );

`include "Net_parameters.v"

parameter buffer_index=10;

parameter A1X=6'b010001;
parameter A2X=6'b010100;
parameter A1Y=6'b100001;
parameter A2Y=6'b100100;
parameter B1X=6'b010010;
parameter B2X=6'b011000;
parameter B1Y=6'b100010;
parameter B2Y=6'b101000;

input clk, reset;

input active;

input [9:0] iTrial;

output [Neurons_Layer1-1:0] InVec;
reg    [Neurons_Layer1-1:0] InVec;

wire    [buffer_index-1:0] Index1;
wire    [buffer_index-1:0] Index2;

wire [5:0]Starting_point[0:nTrial];

assign Starting_point[1]=A1X;
assign Starting_point[2]=A2X;
assign Starting_point[3]=A1Y;
assign Starting_point[4]=A2Y;
assign Starting_point[5]=B1X;
assign Starting_point[6]=B2X;
assign Starting_point[7]=B1Y;
assign Starting_point[8]=B2Y;

assign Starting_point[9] =A2X;
assign Starting_point[10]=B2X;
assign Starting_point[11]=A1Y;
assign Starting_point[12]=B2Y;
assign Starting_point[13]=B1X;
assign Starting_point[14]=A1X;
assign Starting_point[15]=B1Y;
assign Starting_point[16]=A2Y;

assign Starting_point[17]=B2Y;
assign Starting_point[18]=A2X;
assign Starting_point[19]=A1Y;
assign Starting_point[20]=B1Y;
assign Starting_point[21]=B1X;
assign Starting_point[22]=A1X;
assign Starting_point[23]=A2Y;
assign Starting_point[24]=B2X;

assign Starting_point[25]=B2Y;
assign Starting_point[26]=B2X;
assign Starting_point[27]=B1Y;
assign Starting_point[28]=A1Y;
assign Starting_point[29]=A2X;
assign Starting_point[30]=B1X;
assign Starting_point[31]=A2Y;
assign Starting_point[32]=A1X;

assign Starting_point[33]=B1Y;
assign Starting_point[34]=A2X;
assign Starting_point[35]=B2Y;
assign Starting_point[36]=A1Y;
assign Starting_point[37]=A1X;
assign Starting_point[38]=B2X;
assign Starting_point[39]=A2Y;
assign Starting_point[40]=B1X;

assign Starting_point[41]=B1Y;
assign Starting_point[42]=A1X;
assign Starting_point[43]=B2Y;
assign Starting_point[44]=A2Y;
assign Starting_point[45]=A2X;
assign Starting_point[46]=B2X;
assign Starting_point[47]=A1Y;
assign Starting_point[48]=B1X;

assign Starting_point[49]=B2Y;
assign Starting_point[50]=A1Y;
assign Starting_point[51]=B1Y;
assign Starting_point[52]=B1X;
assign Starting_point[53]=A2X;
assign Starting_point[54]=B2X;
assign Starting_point[55]=A1X;
assign Starting_point[56]=A2Y;


assign Starting_point[57]=A2Y;
assign Starting_point[58]=A2X;
assign Starting_point[59]=B2Y;
assign Starting_point[60]=B1X;
assign Starting_point[61]=A1X;
assign Starting_point[62]=B2X;
assign Starting_point[63]=A1Y;
assign Starting_point[64]=B1Y;

assign Starting_point[65]=A2Y;
assign Starting_point[66]=A1X;
assign Starting_point[67]=B1Y;
assign Starting_point[68]=B2X;
assign Starting_point[69]=A2X;
assign Starting_point[70]=B1X;
assign Starting_point[71]=A1Y;
//assign Starting_point[72]=B2Y;

assign Starting_point[72]=B1Y;
assign Starting_point[73]=A1X;
assign Starting_point[74]=B2Y;
assign Starting_point[75]=A2Y;
assign Starting_point[76]=A2X;
assign Starting_point[77]=B2X;
assign Starting_point[78]=A1Y;
assign Starting_point[79]=B1X;

assign Starting_point[80]=A1Y;
assign Starting_point[81]=B1X;
assign Starting_point[82]=A2Y;
assign Starting_point[83]=B2Y;
assign Starting_point[84]=A2X;
assign Starting_point[85]=B2X;
assign Starting_point[86]=B1Y;
assign Starting_point[87]=A1X;

assign Starting_point[88]=A2X;
assign Starting_point[89]=A1X;
assign Starting_point[90]=B2Y;
assign Starting_point[91]=A1Y;
assign Starting_point[92]=B1Y;
assign Starting_point[93]=B2X;
assign Starting_point[94]=A2Y;
assign Starting_point[95]=B1X;

assign Starting_point[96] =A1X;
assign Starting_point[97] =B1X;
assign Starting_point[98] =B2Y;
assign Starting_point[99] =A2Y;
assign Starting_point[100]=B1Y;
assign Starting_point[101]=B2X;
assign Starting_point[102]=A1Y;
assign Starting_point[103]=A2X;

assign Starting_point[104]=A2Y;
assign Starting_point[105]=A2X;
assign Starting_point[106]=B2Y;
assign Starting_point[107]=B1X;
assign Starting_point[108]=A1X;
assign Starting_point[109]=B2X;
assign Starting_point[110]=A1Y;
assign Starting_point[111]=B1Y;

assign Starting_point[112]=A2Y;
assign Starting_point[113]=A1X;
assign Starting_point[114]=B1Y;
assign Starting_point[115]=B2X;
assign Starting_point[116]=A2X;
assign Starting_point[117]=B1X;
assign Starting_point[118]=A1Y;
assign Starting_point[119]=B2Y;


assign Starting_point[120]=B1Y;
assign Starting_point[121]=A2X;
assign Starting_point[122]=A2Y;
assign Starting_point[123]=B1X;
assign Starting_point[124]=A1X;
assign Starting_point[125]=B2X;
assign Starting_point[126]=A1Y;
assign Starting_point[127]=B2Y;

assign Starting_point[128]=A1X;
assign Starting_point[129]=A1Y;
assign Starting_point[130]=B2Y;

reg [9:0] start;
always @(iTrial)
	begin
				start=iTrial /2 + 10'b1;
				InVec=Starting_point[start];
		
	end
/*			c_lfsr_start_point #(.buffer_size(buffer_index),
										  .n(buffer_index))
			indexx1 (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b1110110101),
					 .poly(iTrial),
					 .Q(Index1));
					 
					 
			c_lfsr_start_point #(.buffer_size(buffer_index),
					                 .n(buffer_index))
			indexx2 (.clk(clk),
					 .init(reset), 
					 .en(active),
					 .seed(10'b1101110101),
					 .poly(iTrial),
					 .Q(Index2));
	
	 
	always @(Index1,Index2)
	begin
		case (Index1[buffer_index-1:buffer_index-2])
			2'b00: InVec[3:0]=4'b0001;
			2'b01: InVec[3:0]=4'b0010;
			2'b10: InVec[3:0]=4'b0100;
			2'b11: InVec[3:0]=4'b1000;
		endcase
		
		if (Index2<=10'b1000000000)
				 InVec[5:4]=2'b01;
		else
				 InVec[5:4]=2'b10;
		
	end*/
					 
	endmodule				 