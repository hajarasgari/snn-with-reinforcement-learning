
module randn #(parameter n = 2,parameter buffer_size=16) (clk, init, en,seed,poly, Q);

input clk, init, en;
wire  clk, init, en;
input [n-1:0] seed;
input [n-1:0] poly;
output [buffer_size-1:0] Q;
reg [n-1:0] Q_lfsr;
integer i;
	
	always @(posedge clk, posedge init) begin
		if (init == 1'b1) 
				Q_lfsr <= seed;		
		else 
				if (en == 1'b1) begin
					Q_lfsr[n-1] <= Q_lfsr[0];
					for (i=0; i<n-1 ; i=i+1 ) begin
						Q_lfsr[i] <= (Q_lfsr[0] & poly[i] ) ^ Q_lfsr[i+1];
					end //for
				end
	end
	
	assign Q=Q_lfsr[n-1] ? {{buffer_size-n{1'b1}},Q_lfsr} : {{buffer_size-n{1'b0}},Q_lfsr};
	endmodule