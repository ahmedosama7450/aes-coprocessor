module aes_mixcolumn_byte_inv (
    input  [ 7:0] in,
    output [31:0] out
);

  function [7:0] mb2;
    input [7:0] x;
    begin

      if (x[7] == 1) mb2 = ((x << 1) ^ 8'h1b);
      else mb2 = x << 1;
    end
  endfunction

  function [7:0] mb_b(input [7:0] x);
    begin

      mb_b = x ^ mb2(x) ^ mb2(mb2(mb2(x)));
    end
  endfunction

  function [7:0] mb_d(input [7:0] x);
    begin

      mb_d = x ^ mb2(mb2(x)) ^ mb2(mb2(mb2(x)));
    end
  endfunction

  function [7:0] mb_e(input [7:0] x);
    begin

      mb_e = mb2(x) ^ mb2(mb2(x)) ^ mb2(mb2(mb2(x)));
    end
  endfunction

  function [7:0] mb_9(input [7:0] x);
    begin

      mb_9 = x ^ mb2(mb2(mb2(x)));
    end
  endfunction
  
  assign out = {mb_e(in), mb_9(in), mb_d(in), mb_b(in)};


endmodule
