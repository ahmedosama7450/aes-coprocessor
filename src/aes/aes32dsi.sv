module aes32dsi (
  input [1:0] bs,
  input [31:0] rs1,
  input [31:0] rs2,
  output [31:0] rd

);
  wire [4:0] shamt ={bs,3'b000};
  wire [7:0] si,so;
  wire [31:0] Ty =(rs2<<shamt);
  assign si =Ty[31:24];
  sbox_inv s(si,so);

  wire [31:0] mixed;
  wire [31:0] H;
  assign mixed ={so,24'h_000000};
  role32 rol (mixed,shamt,H);
  assign rd = H^rs1;
endmodule