module role32 (
    input  [31:0] mixed,
    input  [ 4:0] shamt,
    output [31:0] H
);
  wire [31:0] X, Y;
  wire [5:0] Z;
  assign Z = 32 - shamt;
  assign X = mixed >> shamt;
  assign Y = mixed << Z;
  assign H = X | Y;
endmodule
