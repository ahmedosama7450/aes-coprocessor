

module aes_mixcolumn_byte_fwd (
  input [7:0]in,
  output [31:0] out
);
  
  function [7:0] mb2; 
	input [7:0] x;
	begin 
			
			if(x[7] == 1) mb2 = ((x << 1) ^ 8'h1b);
			else mb2 = x << 1; 
	end 	
endfunction



function [7:0] mb3; 
	input [7:0] x;
	begin 
			
			mb3 = mb2(x) ^ x;
	end 
endfunction
  assign out ={mb2(in),in,in,mb3(in)};
  
  
endmodule