module T();
  reg [127:0] in;
  reg [127:0] key;
  reg [127:0] out,fin;
  reg [31:0] R[0:3];
  reg [31:0] t[0:3];
  reg [1:0] bs;
  reg [31:0] rd,rs1,rs2,rdF;
  wire [0:(128*(10+1))-1 ] fullkeys;
  wire[0:127] Round [0:10];
 assign Round[0]=fullkeys[0 +:128];
 assign Round[10]=fullkeys[128*10 +:128];
  genvar j;

generate 
  for(j=1;j< 10;j=j+1) begin 
    
    mix_round a(fullkeys[128*j +:128],Round[j]);

end

endgenerate
  
  
  
  int i;
keyExpansion  ke (key,fullkeys);
  aes32dsmi aes (bs,rs1,rs2,rd);
  aes32dsi aesF (bs,rs1,rs2,rdF);
  initial 
    begin
      key =128'h_000102030405060708090a0b0c0d0e0f;
      in = 128'h_69c4e0d86a7b0430d8cdb78070b4c55a;
      #1
      out = in^Round[10];
      #1
      t[0]=out[127:96];
      t[1]=out[95:64];
      t[2]=out[63:32];
      t[3]=out[31:0];
      
      for(i=9;i>0;i--)
        begin
          #1
          R[0]=Round[i][0+:32];
          R[1]=Round[i][32 +:32];
          R[2]=Round[i][64 +:32];
          R[3]=Round[i][96 +:32];
    
      #1
      /////////////////row 1
          bs=0;
      rs2=t[0];
      rs1=R[0];
      #1
      R[0]=rd;
      #1
          bs=1;
          rs2=t[3];
      rs1=R[0];
      #1
      R[0]=rd;
      #1
          bs=2;
      rs2=t[2];
      rs1=R[0];
      #1
      R[0]=rd;
      #1
          bs=3;
          rs2=t[1];
      rs1=R[0];
      #1
      R[0]=rd;
      #1
      
      
       /////////////////row 2
      
      bs=0;
          rs2=t[1];
      rs1=R[1];
      #1
      R[1]=rd;
      #1
          bs=1;
          rs2=t[0];
      rs1=R[1];
      #1
      R[1]=rd;
      #1
          bs=2;
          rs2=t[3];
      rs1=R[1];
      #1
      R[1]=rd;
      #1
          bs=3;
          rs2=t[2];
      rs1=R[1];
      #1
      R[1]=rd;
      #1
      
       /////////////////row 3
      
           bs=0;
      rs2=t[2];
      rs1=R[2];
      #1
      R[2]=rd;
      #1
          bs=1;
          rs2=t[1];
      rs1=R[2];
      #1
      R[2]=rd;
      #1
          bs=2;
      rs2=t[0];
      rs1=R[2];
      #1
      R[2]=rd;
      #1
          bs=3;
          rs2=t[3];
      rs1=R[2];
      #1
      R[2]=rd;
      #1
      
      
      
       /////////////////row 4
      
            bs=0;
          rs2=t[3];
      rs1=R[3];
      #1
      R[3]=rd;
      #1
          bs=1;
          rs2=t[2];
      rs1=R[3];
      #1
      R[3]=rd;
      #1
          bs=2;
          rs2=t[1];
      rs1=R[3];
      #1
      R[3]=rd;
      #1
          bs=3;
          rs2=t[0];
      rs1=R[3];
      #1
      R[3]=rd;
     #1
          t[0]=R[0];
          t[1]=R[1];
          t[2]=R[2];
          t[3]=R[3];

        end
      #1
      R[0]=Round[0][0+:32];
      R[1]=Round[0][32 +:32];
      R[2]=Round[0][64 +:32];
      R[3]=Round[0][96 +:32];
      
      
       #1
      /////////////////row 1
          bs=0;
      rs2=t[0];
      rs1=R[0];
      #1
      R[0]=rdF;
      #1
          bs=1;
      rs2=t[3];
      rs1=R[0];
      #1
      R[0]=rdF;
      #1
          bs=2;
      rs2=t[2];
      rs1=R[0];
      #1
      R[0]=rdF;
      #1
          bs=3;
      rs2=t[1];
      rs1=R[0];
      #1
      R[0]=rdF;
      #1
      
      
       /////////////////row 2
      
      bs=0;
      rs2=t[1];
      rs1=R[1];
      #1
      R[1]=rdF;
      #1
          bs=1;
      rs2=t[0];
      rs1=R[1];
      #1
      R[1]=rdF;
      #1
          bs=2;
      rs2=t[3];
      rs1=R[1];
      #1
      R[1]=rdF;
      #1
          bs=3;
      rs2=t[2];
      rs1=R[1];
      #1
      R[1]=rdF;
      #1
      
       /////////////////row 3
      
           bs=0;
      rs2=t[2];
      rs1=R[2];
      #1
      R[2]=rdF;
      #1
          bs=1;
      rs2=t[1];
      rs1=R[2];
      #1
      R[2]=rdF;
      #1
          bs=2;
      rs2=t[0];
      rs1=R[2];
      #1
      R[2]=rdF;
      #1
          bs=3;
      rs2=t[3];
      rs1=R[2];
      #1
      R[2]=rdF;
      #1
      
      
      
       /////////////////row 4
      
            bs=0;
      rs2=t[3];
      rs1=R[3];
      #1
      R[3]=rdF;
      #1
          bs=1;
      rs2=t[2];
      rs1=R[3];
      #1
      R[3]=rdF;
      #1
          bs=2;
      rs2=t[1];
      rs1=R[3];
      #1
      R[3]=rdF;
      #1
          bs=3;
      rs2=t[0];
      rs1=R[3];
      #1
      R[3]=rdF;
     #1
      
       fin ={R[0],R[1],R[2],R[3]};
      #1
      $display("%0h", fin);
      
    end

  
  
  
  

  
endmodule