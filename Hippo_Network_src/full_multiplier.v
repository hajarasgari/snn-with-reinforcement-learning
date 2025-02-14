module full_multiplier 
#(parameter n = 3)(a, b, result);
        input  [n-1:0]  a;
        input  [n-1:0]  b;
        output [2*n-1:0] result;
		  //wire    [2*n-1:0] res;

           assign result = a * b;

			  //assign result = res[2*n-2-:n];
			  
 endmodule