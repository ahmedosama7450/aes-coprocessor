module cv32e40x_core_with_aes
  import cv32e40x_pkg::*;
#(
    parameter bit                 WITH_AES                              = 1'b1,
    parameter                     LIB                                   = 0,
    parameter rv32_e              RV32                                  = RV32I,
    parameter a_ext_e             A_EXT                                 = A_NONE,
    parameter b_ext_e             B_EXT                                 = B_NONE,
    parameter m_ext_e             M_EXT                                 = M,
    parameter bit                 DEBUG                                 = 1,
    parameter logic        [31:0] DM_REGION_START                       = 32'hF0000000,
    parameter logic        [31:0] DM_REGION_END                         = 32'hF0003FFF,
    parameter int                 DBG_NUM_TRIGGERS                      = 1,
    parameter int                 PMA_NUM_REGIONS                       = 0,
    parameter pma_cfg_t           PMA_CFG         [PMA_NUM_REGIONS-1:0] = '{default: PMA_R_DEFAULT},
    parameter bit                 CLIC                                  = 0,
    parameter int unsigned        CLIC_ID_WIDTH                         = 5,
    /*
    parameter bit                 X_EXT                                 = 0,
    parameter int unsigned        X_NUM_RS                              = 2,
    parameter int unsigned        X_ID_WIDTH                            = 4,
    parameter int unsigned        X_MEM_WIDTH                           = 32,
    parameter int unsigned        X_RFR_WIDTH                           = 32,
    parameter int unsigned        X_RFW_WIDTH                           = 32,
    parameter logic [31:0]        X_MISA                                = 32'h00000000,
    parameter logic [1:0]         X_ECS_XS                              = 2'b00,
    */
    parameter int unsigned        NUM_MHPMCOUNTERS                      = 1
) (
    // Clock and reset
    input logic clk_i,
    input logic rst_ni,
    input logic scan_cg_en_i, // Enable all clock gates for testing

    // Static configuration
    input logic [31:0] boot_addr_i,
    input logic [31:0] dm_exception_addr_i,
    input logic [31:0] dm_halt_addr_i,
    input logic [31:0] mhartid_i,
    input logic [ 3:0] mimpid_patch_i,
    input logic [31:0] mtvec_addr_i,

    // Instruction memory interface
    output logic        instr_req_o,
    input  logic        instr_gnt_i,
    input  logic        instr_rvalid_i,
    output logic [31:0] instr_addr_o,
    output logic [ 1:0] instr_memtype_o,
    output logic [ 2:0] instr_prot_o,
    output logic        instr_dbg_o,
    input  logic [31:0] instr_rdata_i,
    input  logic        instr_err_i,

    // Data memory interface
    output logic        data_req_o,
    input  logic        data_gnt_i,
    input  logic        data_rvalid_i,
    output logic [31:0] data_addr_o,
    output logic [ 3:0] data_be_o,
    output logic        data_we_o,
    output logic [31:0] data_wdata_o,
    output logic [ 1:0] data_memtype_o,
    output logic [ 2:0] data_prot_o,
    output logic        data_dbg_o,
    output logic [ 5:0] data_atop_o,
    input  logic [31:0] data_rdata_i,
    input  logic        data_err_i,
    input  logic        data_exokay_i,

    // Cycle count
    output logic [63:0] mcycle_o,

    // Time input
    input logic [63:0] time_i,

    // eXtension interface
    /*
    cv32e40x_if_xif.cpu_compressed        xif_compressed_if,
    cv32e40x_if_xif.cpu_issue             xif_issue_if,
    cv32e40x_if_xif.cpu_commit            xif_commit_if,
    cv32e40x_if_xif.cpu_mem               xif_mem_if,
    cv32e40x_if_xif.cpu_mem_result        xif_mem_result_if,
    cv32e40x_if_xif.cpu_result            xif_result_if,
    */

    // Basic interrupt architecture
    input logic [31:0] irq_i,

    // Event wakeup signals
    input logic wu_wfe_i,  // Wait-for-event wakeup

    // CLIC interrupt architecture
    input logic                     clic_irq_i,
    input logic [CLIC_ID_WIDTH-1:0] clic_irq_id_i,
    input logic [              7:0] clic_irq_level_i,
    input logic [              1:0] clic_irq_priv_i,
    input logic                     clic_irq_shv_i,

    // Fence.i flush handshake
    output logic fencei_flush_req_o,
    input  logic fencei_flush_ack_i,

    // Debug interface
    input  logic        debug_req_i,
    output logic        debug_havereset_o,
    output logic        debug_running_o,
    output logic        debug_halted_o,
    output logic        debug_pc_valid_o,
    output logic [31:0] debug_pc_o,

    // CPU control signals
    input  logic fetch_enable_i,
    output logic core_sleep_o
);

  localparam bit X_EXT = WITH_AES ? 1'b1 : 1'b0;
  localparam int unsigned X_NUM_RS = 2;
  localparam int unsigned X_ID_WIDTH = 4;
  localparam int unsigned X_MEM_WIDTH = 32;
  localparam int unsigned X_RFR_WIDTH = 32;
  localparam int unsigned X_RFW_WIDTH = 32;
  localparam logic [31:0] X_MISA = 32'h00000000;
  localparam logic [1:0] X_ECS_XS = 2'b00;

  cv32e40x_if_xif #(
      .X_NUM_RS   (X_NUM_RS),
      .X_ID_WIDTH (X_ID_WIDTH),
      .X_MEM_WIDTH(X_MEM_WIDTH),
      .X_RFR_WIDTH(X_RFR_WIDTH),
      .X_RFW_WIDTH(X_RFW_WIDTH),
      .X_MISA     (X_MISA),
      .X_ECS_XS   (X_ECS_XS)
  ) xif ();

  if (WITH_AES) begin : gen_aes_coprocessor
    aes_coprocessor #(
        // .X_EXT      (X_EXT),
        .X_NUM_RS   (X_NUM_RS),
        .X_ID_WIDTH (X_ID_WIDTH),
        .X_MEM_WIDTH(X_MEM_WIDTH),
        .X_RFR_WIDTH(X_RFR_WIDTH),
        .X_RFW_WIDTH(X_RFW_WIDTH),
        .X_MISA     (X_MISA),
        .X_ECS_XS   (X_ECS_XS)
    ) aes_coproc (
        .*,
        .xif_compressed_if(xif),
        .xif_issue_if     (xif),
        .xif_commit_if    (xif),
        .xif_mem_if       (xif),
        .xif_mem_result_if(xif),
        .xif_result_if    (xif)
    );
  end

  cv32e40x_core #(
      .LIB             (LIB),
      .RV32            (RV32),
      .A_EXT           (A_EXT),
      .B_EXT           (B_EXT),
      .M_EXT           (M_EXT),
      .DEBUG           (DEBUG),
      .DM_REGION_START (DM_REGION_START),
      .DM_REGION_END   (DM_REGION_END),
      .DBG_NUM_TRIGGERS(DBG_NUM_TRIGGERS),
      .PMA_NUM_REGIONS (PMA_NUM_REGIONS),
      .PMA_CFG         (PMA_CFG),
      .CLIC            (CLIC),
      .CLIC_ID_WIDTH   (CLIC_ID_WIDTH),
      .X_EXT           (X_EXT),
      .X_NUM_RS        (X_NUM_RS),
      .X_ID_WIDTH      (X_ID_WIDTH),
      .X_MEM_WIDTH     (X_MEM_WIDTH),
      .X_RFR_WIDTH     (X_RFR_WIDTH),
      .X_RFW_WIDTH     (X_RFW_WIDTH),
      .X_MISA          (X_MISA),
      .X_ECS_XS        (X_ECS_XS),
      .NUM_MHPMCOUNTERS(NUM_MHPMCOUNTERS)
  ) core (
      .*,
      .xif_compressed_if(xif),
      .xif_issue_if     (xif),
      .xif_commit_if    (xif),
      .xif_mem_if       (xif),
      .xif_mem_result_if(xif),
      .xif_result_if    (xif)
  );

endmodule
