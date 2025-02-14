module STDP_multiplier 
#(parameter n = 3)(a, b, result);
        input  [n-1:0]  a;
        input  [n-1:0]  b;
        output [n-1:0] result;
		  wire    [2*n-1:0] res;

           assign res = a * b;

			  assign result = res[n/2 +: n];
			  
 endmodule