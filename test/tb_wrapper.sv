`timescale 1ns / 1ps

module tb_wrapper #(
    parameter bit WITH_AES = 1'b1
) ();

  localparam int CLK_PERIOD = 10;

  logic clk;
  logic rst_n;

  logic fetch_enable;

  // Instruction memory interface
  logic instr_req;
  logic instr_gnt;
  logic instr_rvalid;
  logic [31:0] instr_addr;
  logic [1:0] instr_memtype;
  logic [2:0] instr_prot;
  logic instr_dbg;
  logic [31:0] instr_rdata;
  logic instr_err;

  // Data memory interface
  logic data_req;
  logic data_gnt;
  logic data_rvalid;
  logic [31:0] data_addr;
  logic [3:0] data_be;
  logic data_we;
  logic [31:0] data_wdata;
  logic [1:0] data_memtype;
  logic [2:0] data_prot;
  logic data_dbg;
  logic [5:0] data_atop;
  logic [31:0] data_rdata;
  logic data_err;
  logic data_exokay;

  memory #(
      .FIRMWARE_FILE(WITH_AES ?
                    "D:/College/GP/aes-coprocessor/test/firmware_aes.mem" :
                    "D:/College/GP/aes-coprocessor/test/firmware.mem")
  ) mem (
      .clk_i (clk),
      .rst_ni(rst_n),

      // Instruction memory interface
      .instr_req_i    (instr_req),
      .instr_gnt_o    (instr_gnt),
      .instr_rvalid_o (instr_rvalid),
      .instr_addr_i   (instr_addr),
      .instr_memtype_i(instr_memtype),
      .instr_prot_i   (instr_prot),
      .instr_dbg_i    (instr_dbg),
      .instr_rdata_o  (instr_rdata),
      .instr_err_o    (instr_err),

      // Data memory interface
      .data_req_i    (data_req),
      .data_gnt_o    (data_gnt),
      .data_rvalid_o (data_rvalid),
      .data_addr_i   (data_addr),
      .data_be_i     (data_be),
      .data_we_i     (data_we),
      .data_wdata_i  (data_wdata),
      .data_memtype_i(data_memtype),
      .data_prot_i   (data_prot),
      .data_dbg_i    (data_dbg),
      .data_atop_i   (data_atop),
      .data_rdata_o  (data_rdata),
      .data_err_o    (data_err),
      .data_exokay_o (data_exokay)
  );

  cv32e40x_core_with_aes #(
      .WITH_AES(WITH_AES),
      .DEBUG(0)
  ) dut (
      // Clock and reset
      .clk_i       (clk),
      .rst_ni      (rst_n),
      .scan_cg_en_i(1'b0),

      // Static configuration
      .boot_addr_i        (32'd0),
      .dm_exception_addr_i(32'd0),
      .dm_halt_addr_i     (32'd0),
      .mhartid_i          (32'd0),
      .mimpid_patch_i     (4'd0),
      .mtvec_addr_i       (32'd640),

      // Instruction memory interface
      .instr_req_o    (instr_req),
      .instr_gnt_i    (instr_gnt),
      .instr_rvalid_i (instr_rvalid),
      .instr_addr_o   (instr_addr),
      .instr_memtype_o(instr_memtype),
      .instr_prot_o   (instr_prot),
      .instr_dbg_o    (instr_dbg),
      .instr_rdata_i  (instr_rdata),
      .instr_err_i    (instr_err),

      // Data memory interface
      .data_req_o    (data_req),
      .data_gnt_i    (data_gnt),
      .data_rvalid_i (data_rvalid),
      .data_addr_o   (data_addr),
      .data_be_o     (data_be),
      .data_we_o     (data_we),
      .data_wdata_o  (data_wdata),
      .data_memtype_o(data_memtype),
      .data_prot_o   (data_prot),
      .data_dbg_o    (data_dbg),
      .data_atop_o   (data_atop),
      .data_rdata_i  (data_rdata),
      .data_err_i    (data_err),
      .data_exokay_i (data_exokay),

      // Cycle count
      .mcycle_o(),

      // Time input
      .time_i(64'd0),

      // eXtension interface
      /*
      .xif_compressed_if(ext_if),
      .xif_issue_if     (ext_if),
      .xif_commit_if    (ext_if),
      .xif_mem_if       (ext_if),
      .xif_mem_result_if(ext_if),
      .xif_result_if    (ext_if),
      */

      // Basic interrupt architecture
      .irq_i(32'd0),

      // Event wakeup signals
      .wu_wfe_i(1'b0),

      // CLIC interrupt architecture
      .clic_irq_i      (1'b0),
      .clic_irq_id_i   (5'd0),
      .clic_irq_level_i(8'd0),
      .clic_irq_priv_i (2'd0),
      .clic_irq_shv_i  (1'b0),

      // Fence.i flush handshake
      .fencei_flush_req_o(),
      .fencei_flush_ack_i(1'b1),

      // Debug interface
      .debug_req_i      (1'b0),
      .debug_havereset_o(),
      .debug_running_o  (),
      .debug_halted_o   (),
      .debug_pc_valid_o (),
      .debug_pc_o       (),

      // CPU control signals
      .fetch_enable_i(fetch_enable),
      .core_sleep_o  ()
  );

  // Clock generation
  initial clk = 1'b0;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    fetch_enable = 1'b0;
    rst_n = 1'b1;

    // Reset
    #5 rst_n = 1'b0;
    #5 rst_n = 1'b1;

    // Enable fetch
    #5 fetch_enable = 1'b1;

    // Wait for program execution to finish
    #(CLK_PERIOD) @(posedge clk);
    repeat (30000) @(posedge clk);

    $finish(2);
  end

  /*
  initial begin
       $dumpfile("tb.vcd");
       $dumpvars(0, tb);
  end
  */

endmodule
