module test_bench();

  reg [127:0] in;
  reg [127:0] key;
  reg [127:0] fin;
  reg [31:0] R[0:3];
  reg [31:0] t[0:3];
  reg [1:0] bs;
  reg [31:0] rd_E_M,rd_E_F,rd_D_M,rd_D_F,rs1,rs2,temp_1,temp_2;
  reg[31:0] En_Round [0:43];
  reg[31:0] De_Round [0:43];
  reg[31:0] rconx [1:10]={32'h01000000,32'h02000000,32'h04000000,32'h08000000,32'h10000000,32'h20000000,32'h40000000,32'h80000000,32'h1b000000,32'h36000000};
  
  aes32esmi aes_E_M (bs,rs1,rs2,rd_E_M);
  aes32esi aes_E_F (bs,rs1,rs2,rd_E_F);
   aes32dsmi aes_D_M (bs,rs1,rs2,rd_D_M);
  aes32dsi aes_D_F (bs,rs1,rs2,rd_D_F);
  int i;
  initial
    begin
      key =128'h_000102030405060708090a0b0c0d0e0f;
      in =  128'h_00112233445566778899aabbccddeeff;
      #1
      //////////////////////////////////////////get RoundKey for En
      En_Round[0]=key[127:96];
      En_Round[1]=key[95:64];
      En_Round[2]=key[63:32];
      En_Round[3]=key[31:0];
      #1
      for (i=4;i<41;i=i+4)
        begin
          //rotate left by one byte
          //slli a0, En_Round[i-1] ,8
          //srli a1, En_Round[i-1] ,24
          // or temp_1,a0,a1
          temp_1[31 :8] =En_Round[i-1][23:0];
          temp_1[7 :0] =En_Round[i-1][31:24];    
          /////////
          temp_2 =rconx[i/4];
          #1
            bs=0;
            rs2=temp_1;
            rs1=temp_2;
            #1
            temp_2=rd_E_F;
            #1
            bs=1;
            rs2=temp_1;
            rs1=temp_2;
            #1
           temp_2=rd_E_F;
            #1
           bs=2;
            rs2=temp_1;
            rs1=temp_2;
            #1
           temp_2=rd_E_F;
            #1
           bs=3;
            rs2=temp_1;
            rs1=temp_2;
            #1
           temp_2=rd_E_F;
            #1
          En_Round[i]=En_Round[i-4]^temp_2;#1
          En_Round[i+1]=En_Round[i-3]^En_Round[i];#1
          En_Round[i+2]=En_Round[i-2]^En_Round[i+1];#1
          En_Round[i+3]=En_Round[i-1]^En_Round[i+2];
          #1;
          
          
        end
       //////////////////////////////////////////get RoundKey for DE
      De_Round[0]=En_Round[0];
      De_Round[1]=En_Round[1];
      De_Round[2]=En_Round[2];
      De_Round[3]=En_Round[3];
      for (i=4;i<40;i=i+1)
        begin   
        #1
         
          temp_1=0;
          #1
            bs=0;
          rs2=En_Round[i];
            rs1=temp_1;
            #1
            temp_1=rd_E_F;
            #1
            bs=1;
            rs2=En_Round[i];
            rs1=temp_1;
            #1
           temp_1=rd_E_F;
            #1
           bs=2;
            rs2=En_Round[i];
            rs1=temp_1;
            #1
           temp_1=rd_E_F;
            #1
           bs=3;
            rs2=En_Round[i];
            rs1=temp_1;
            #1
           temp_1=rd_E_F;
          
          
          
          
          
          /////////////////////////////////
          De_Round[i]=0;
            #1
            bs=0;
          rs2=temp_1;
            rs1=De_Round[i];
            #1
          De_Round[i]=rd_D_M;
            #1
            bs=1;
            rs2=temp_1;
            rs1=De_Round[i];
            #1
          De_Round[i]=rd_D_M;
            #1
           bs=2;
            rs2=temp_1;
            rs1=De_Round[i];
            #1
          De_Round[i]=rd_D_M;
            #1
           bs=3;
            rs2=temp_1;
            rs1=De_Round[i];
            #1
          De_Round[i]=rd_D_M;
            #1;
          
          
          
        end
      De_Round[40]=En_Round[40];
      De_Round[41]=En_Round[41];
      De_Round[42]=En_Round[42];
      De_Round[43]=En_Round[43];
      
       //////////////////////////////////////////Encryption
      #1
      t[0]=key[127:96]^in[127:96];
      t[1]=key[95:64]^in[95:64];
      t[2]=key[63:32]^in[63:32];
      t[3]=key[31:0]^in[31:0];
      
      for(i=1;i<10;i++)
        begin
          #1
          R[0]=En_Round[i*4];
          R[1]=En_Round[i*4+1];
          R[2]=En_Round[i*4+2];
          R[3]=En_Round[i*4+3];
    
      #1
      /////////////////row 1
          bs=0;
      rs2=t[0];
      rs1=R[0];
      #1
      R[0]=rd_E_M;
      #1
          bs=1;
      rs2=t[1];
      rs1=R[0];
      #1
      R[0]=rd_E_M;
      #1
          bs=2;
      rs2=t[2];
      rs1=R[0];
      #1
      R[0]=rd_E_M;
      #1
          bs=3;
      rs2=t[3];
      rs1=R[0];
      #1
      R[0]=rd_E_M;
      #1
      
      
       /////////////////row 2
      
      bs=0;
      rs2=t[1];
      rs1=R[1];
      #1
      R[1]=rd_E_M;
      #1
          bs=1;
      rs2=t[2];
      rs1=R[1];
      #1
      R[1]=rd_E_M;
      #1
          bs=2;
      rs2=t[3];
      rs1=R[1];
      #1
      R[1]=rd_E_M;
      #1
          bs=3;
      rs2=t[0];
      rs1=R[1];
      #1
      R[1]=rd_E_M;
      #1
      
       /////////////////row 3
      
           bs=0;
      rs2=t[2];
      rs1=R[2];
      #1
      R[2]=rd_E_M;
      #1
          bs=1;
      rs2=t[3];
      rs1=R[2];
      #1
      R[2]=rd_E_M;
      #1
          bs=2;
      rs2=t[0];
      rs1=R[2];
      #1
      R[2]=rd_E_M;
      #1
          bs=3;
      rs2=t[1];
      rs1=R[2];
      #1
      R[2]=rd_E_M;
      #1
      
      
      
       /////////////////row 4
      
            bs=0;
      rs2=t[3];
      rs1=R[3];
      #1
      R[3]=rd_E_M;
      #1
          bs=1;
      rs2=t[0];
      rs1=R[3];
      #1
      R[3]=rd_E_M;
      #1
          bs=2;
      rs2=t[1];
      rs1=R[3];
      #1
      R[3]=rd_E_M;
      #1
          bs=3;
      rs2=t[2];
      rs1=R[3];
      #1
      R[3]=rd_E_M;
     #1
          t[0]=R[0];
          t[1]=R[1];
          t[2]=R[2];
          t[3]=R[3];

        end
       #1
      R[0]=En_Round[40];
      R[1]=En_Round[41];
      R[2]=En_Round[42];
      R[3]=En_Round[43];
      
      
       #1
       
      /////////////////row 1
          bs=0;
      rs2=t[0];
      rs1=R[0];
      #1
      R[0]=rd_E_F;
      #1
          bs=1;
      rs2=t[1];
      rs1=R[0];
      #1
      R[0]=rd_E_F;
      #1
          bs=2;
      rs2=t[2];
      rs1=R[0];
      #1
      R[0]=rd_E_F;
      #1
          bs=3;
      rs2=t[3];
      rs1=R[0];
      #1
      R[0]=rd_E_F;
      #1
      
      
       /////////////////row 2
      
      bs=0;
      rs2=t[1];
      rs1=R[1];
      #1
      R[1]=rd_E_F;
      #1
          bs=1;
      rs2=t[2];
      rs1=R[1];
      #1
      R[1]=rd_E_F;
      #1
          bs=2;
      rs2=t[3];
      rs1=R[1];
      #1
      R[1]=rd_E_F;
      #1
          bs=3;
      rs2=t[0];
      rs1=R[1];
      #1
      R[1]=rd_E_F;
      #1
      
       /////////////////row 3
      
           bs=0;
      rs2=t[2];
      rs1=R[2];
      #1
      R[2]=rd_E_F;
      #1
          bs=1;
      rs2=t[3];
      rs1=R[2];
      #1
      R[2]=rd_E_F;
      #1
          bs=2;
      rs2=t[0];
      rs1=R[2];
      #1
      R[2]=rd_E_F;
      #1
          bs=3;
      rs2=t[1];
      rs1=R[2];
      #1
      R[2]=rd_E_F;
      #1
      
      
      
       /////////////////row 4
      
            bs=0;
      rs2=t[3];
      rs1=R[3];
      #1
      R[3]=rd_E_F;
      #1
          bs=1;
      rs2=t[0];
      rs1=R[3];
      #1
      R[3]=rd_E_F;
      #1
          bs=2;
      rs2=t[1];
      rs1=R[3];
      #1
      R[3]=rd_E_F;
      #1
          bs=3;
      rs2=t[2];
      rs1=R[3];
      #1
      R[3]=rd_E_F;
     #1
      
       fin ={R[0],R[1],R[2],R[3]};
      #1
      $display("%0h", fin);
      
       #1
      //////////////////////////////////////////////Decryption
      t[0]=De_Round[40]^R[0];
      t[1]=De_Round[41]^R[1];
      t[2]=De_Round[42]^R[2];
      t[3]=De_Round[43]^R[3];
       
     for(i=9;i>0;i--)
        begin
          #1
          R[0]=De_Round[i*4];
          R[1]=De_Round[i*4+1];
          R[2]=De_Round[i*4+2];
          R[3]=De_Round[i*4+3];
    
      #1
      /////////////////row 1
          bs=0;
      rs2=t[0];
      rs1=R[0];
      #1
      R[0]=rd_D_M;
      #1
          bs=1;
          rs2=t[3];
      rs1=R[0];
      #1
      R[0]=rd_D_M;
      #1
          bs=2;
      rs2=t[2];
      rs1=R[0];
      #1
      R[0]=rd_D_M;
      #1
          bs=3;
          rs2=t[1];
      rs1=R[0];
      #1
      R[0]=rd_D_M;
      #1
      
      
       /////////////////row 2
      
      bs=0;
          rs2=t[1];
      rs1=R[1];
      #1
      R[1]=rd_D_M;
      #1
          bs=1;
          rs2=t[0];
      rs1=R[1];
      #1
      R[1]=rd_D_M;
      #1
          bs=2;
          rs2=t[3];
      rs1=R[1];
      #1
      R[1]=rd_D_M;
      #1
          bs=3;
          rs2=t[2];
      rs1=R[1];
      #1
      R[1]=rd_D_M;
      #1
      
       /////////////////row 3
      
           bs=0;
      rs2=t[2];
      rs1=R[2];
      #1
      R[2]=rd_D_M;
      #1
          bs=1;
          rs2=t[1];
      rs1=R[2];
      #1
      R[2]=rd_D_M;
      #1
          bs=2;
      rs2=t[0];
      rs1=R[2];
      #1
      R[2]=rd_D_M;
      #1
          bs=3;
          rs2=t[3];
      rs1=R[2];
      #1
      R[2]=rd_D_M;
      #1
      
      
      
       /////////////////row 4
      
            bs=0;
          rs2=t[3];
      rs1=R[3];
      #1
      R[3]=rd_D_M;
      #1
          bs=1;
          rs2=t[2];
      rs1=R[3];
      #1
      R[3]=rd_D_M;
      #1
          bs=2;
          rs2=t[1];
      rs1=R[3];
      #1
      R[3]=rd_D_M;
      #1
          bs=3;
          rs2=t[0];
      rs1=R[3];
      #1
      R[3]=rd_D_M;
     #1
          t[0]=R[0];
          t[1]=R[1];
          t[2]=R[2];
          t[3]=R[3];

        end
      R[0]=De_Round[0];
      R[1]=De_Round[1];
      R[2]=De_Round[2];
      R[3]=De_Round[3];
      
      
       #1
      /////////////////row 1
          bs=0;
      rs2=t[0];
      rs1=R[0];
      #1
      R[0]=rd_D_F;
      #1
          bs=1;
      rs2=t[3];
      rs1=R[0];
      #1
      R[0]=rd_D_F;
      #1
          bs=2;
      rs2=t[2];
      rs1=R[0];
      #1
      R[0]=rd_D_F;
      #1
          bs=3;
      rs2=t[1];
      rs1=R[0];
      #1
      R[0]=rd_D_F;
      #1
      
      
       /////////////////row 2
      
      bs=0;
      rs2=t[1];
      rs1=R[1];
      #1
      R[1]=rd_D_F;
      #1
          bs=1;
      rs2=t[0];
      rs1=R[1];
      #1
      R[1]=rd_D_F;
      #1
          bs=2;
      rs2=t[3];
      rs1=R[1];
      #1
      R[1]=rd_D_F;
      #1
          bs=3;
      rs2=t[2];
      rs1=R[1];
      #1
      R[1]=rd_D_F;
      #1
      
       /////////////////row 3
      
           bs=0;
      rs2=t[2];
      rs1=R[2];
      #1
      R[2]=rd_D_F;
      #1
          bs=1;
      rs2=t[1];
      rs1=R[2];
      #1
      R[2]=rd_D_F;
      #1
          bs=2;
      rs2=t[0];
      rs1=R[2];
      #1
      R[2]=rd_D_F;
      #1
          bs=3;
      rs2=t[3];
      rs1=R[2];
      #1
      R[2]=rd_D_F;
      #1
      
      
      
       /////////////////row 4
      
            bs=0;
      rs2=t[3];
      rs1=R[3];
      #1
      R[3]=rd_D_F;
      #1
          bs=1;
      rs2=t[2];
      rs1=R[3];
      #1
      R[3]=rd_D_F;
      #1
          bs=2;
      rs2=t[1];
      rs1=R[3];
      #1
      R[3]=rd_D_F;
      #1
          bs=3;
      rs2=t[0];
      rs1=R[3];
      #1
      R[3]=rd_D_F;
     #1
      
       fin ={R[0],R[1],R[2],R[3]};
      #1
      $display("%0h", fin);
      
      
      
      
    end
  
 
  
endmodule