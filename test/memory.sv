module memory #(
    parameter string FIRMWARE_FILE = "D:/College/GP/aes-coprocessor/tb/firmware.mem"
) (
    input clk_i,
    input rst_ni,

    // Instruction memory interface
    input  logic        instr_req_i,
    output logic        instr_gnt_o,
    output logic        instr_rvalid_o,
    input  logic [31:0] instr_addr_i,
    input  logic [ 1:0] instr_memtype_i,  // ignored
    input  logic [ 2:0] instr_prot_i,     // ignored
    input  logic        instr_dbg_i,      // ignored
    output logic [31:0] instr_rdata_o,
    output logic        instr_err_o,

    // Data memory interface
    input  logic        data_req_i,
    output logic        data_gnt_o,
    output logic        data_rvalid_o,
    input  logic [31:0] data_addr_i,
    input  logic [ 3:0] data_be_i,
    input  logic        data_we_i,
    input  logic [31:0] data_wdata_i,
    input  logic [ 1:0] data_memtype_i,  // ignore
    input  logic [ 2:0] data_prot_i,     // ignore
    input  logic        data_dbg_i,      // ignore
    input  logic [ 5:0] data_atop_i,     // ignore
    output logic [31:0] data_rdata_o,
    output logic        data_err_o,
    output logic        data_exokay_o
);

  //---------------------------------------------------------------------------------
  // Instruction memory
  //---------------------------------------------------------------------------------
  localparam int unsigned INSTR_MEM_SIZE = 2048;
  logic [31:0] instr_mem[INSTR_MEM_SIZE-1];

  // Enforce memory alignment, ignore compressed instructions
  // logic [29:0] instr_word_addr = instr_addr_i[31:2]; // TODO instr_word_addr is a bunch of Xs, why? Should we use `assign`? maybe because of optimizations ?

  initial begin
    /*
    for (int i = 0; i < INSTR_MEM_SIZE; i = i + 1) begin
      instr_mem[i] <= 32'd0;
    end
    */

    $readmemh(FIRMWARE_FILE, instr_mem);
  end

  always @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      instr_rdata_o  <= 32'd0;
      instr_rvalid_o <= 1'b0;
    end else begin
      if (instr_req_i) begin
        instr_rdata_o  <= instr_mem[instr_addr_i[31:2]];
        instr_rvalid_o <= 1'b1;
      end else begin
        instr_rvalid_o <= 1'b0;
      end
    end
  end

  assign instr_gnt_o = 1'b1;
  assign instr_err_o = 1'b0;

  //---------------------------------------------------------------------------------
  // Data memory
  //---------------------------------------------------------------------------------
  localparam int unsigned DATA_MEM_SIZE = 2048;
  logic [31:0] data_mem[0:DATA_MEM_SIZE-1];

  // Enfore memory alignment
  // logic [29:0] data_word_addr = data_addr_i[31:2]; // TODO does this give the same problem as instr_word_addr ?

  always @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      data_rdata_o  <= 32'd0;
      data_rvalid_o <= 1'b0;

      // Reset data memory
      for (int i = 0; i < DATA_MEM_SIZE; i = i + 1) begin
        data_mem[i] <= 32'd0;
      end
    end else begin
      if (data_req_i) begin
        if (data_we_i) begin
          if (data_be_i[0]) data_mem[data_addr_i[31:2]][7:0] <= data_wdata_i[7:0];
          if (data_be_i[1]) data_mem[data_addr_i[31:2]][15:8] <= data_wdata_i[15:8];
          if (data_be_i[2]) data_mem[data_addr_i[31:2]][23:16] <= data_wdata_i[23:16];
          if (data_be_i[3]) data_mem[data_addr_i[31:2]][31:24] <= data_wdata_i[31:24];
          // $display("written data: %0d", data_wdata_i);
        end else begin
          data_rdata_o <= data_mem[data_addr_i[31:2]];
        end
        data_rvalid_o <= 1'b1;
      end else begin
        data_rvalid_o <= 1'b0;
      end
    end
  end

  assign data_gnt_o = 1'b1;
  assign data_err_o = 1'b0;
  assign data_exokay_o = 1'b1;

endmodule
