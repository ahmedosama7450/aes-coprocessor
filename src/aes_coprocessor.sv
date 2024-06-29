module aes_coprocessor #(
    // parameter bit                 X_EXT       = 1'b1,
    parameter int unsigned        X_NUM_RS    = 2,
    parameter int unsigned        X_ID_WIDTH  = 4,
    parameter int unsigned        X_MEM_WIDTH = 32,
    parameter int unsigned        X_RFR_WIDTH = 32,
    parameter int unsigned        X_RFW_WIDTH = 32,
    parameter logic        [31:0] X_MISA      = 32'h00000000,
    parameter logic        [ 1:0] X_ECS_XS    = 2'b00
) (
    // Clock and reset
    input logic clk_i,  // TODO should this be the gated clk ???
    input logic rst_ni,

    // eXtension interface
    cv32e40x_if_xif.coproc_compressed xif_compressed_if,
    cv32e40x_if_xif.coproc_issue      xif_issue_if,
    cv32e40x_if_xif.coproc_commit     xif_commit_if,
    cv32e40x_if_xif.coproc_mem        xif_mem_if,
    cv32e40x_if_xif.coproc_mem_result xif_mem_result_if,
    cv32e40x_if_xif.coproc_result     xif_result_if
);

  // =======================================================================
  // Issue interface transaction
  // =======================================================================

  // Decode the instruction
  logic [31:0] instr;
  logic [6:0] opcode;
  logic [2:0] funct3;
  logic [4:0] funct5;
  logic [4:0] rd_id;
  logic [1:0] bs;

  logic is_aes32;
  logic is_aes32dsi;
  logic is_aes32dsmi;
  logic is_aes32esi;
  logic is_aes32esmi;
  logic instr_accepted;

  assign instr = xif_issue_if.issue_req.instr;
  assign opcode = instr[6:0];
  assign funct3 = instr[14:12];
  assign funct5 = instr[29:25];
  assign rd_id = instr[11:7];
  assign bs = instr[31:30];

  assign is_aes32 = (opcode == 7'b0110011) & (funct3 == 3'b000);
  assign is_aes32dsi = funct5 == 5'b10101;
  assign is_aes32dsmi = funct5 == 5'b10111;
  assign is_aes32esi = funct5 == 5'b10001;
  assign is_aes32esmi = funct5 == 5'b10011;
  assign instr_accepted = is_aes32 & (is_aes32dsi | is_aes32dsmi | is_aes32esi | is_aes32esmi);

  // Populate the response
  always_comb begin
    xif_issue_if.issue_resp.accept = instr_accepted;
    xif_issue_if.issue_resp.writeback = 1'b1;
    xif_issue_if.issue_resp.dualwrite = 1'b0;
    xif_issue_if.issue_resp.dualread = '0;
    xif_issue_if.issue_resp.loadstore = 1'b0;
    xif_issue_if.issue_resp.ecswrite = 1'b0;
    xif_issue_if.issue_resp.exc = 1'b0;
  end

  // Pipeline control signals
  logic result_stage_available_q, result_stage_available_d;
  logic is_first_instr;
  logic is_first_instr_previous;
  logic actual_issue_ready;
  logic delay_issue_ready;
  logic result_hs;

  assign result_hs = xif_result_if.result_valid & xif_result_if.result_ready;

  always_comb begin
    delay_issue_ready = 1'b0;
    if (result_hs) delay_issue_ready = 1'b1;
    else if (actual_issue_ready) delay_issue_ready = 1'b0;
  end

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      result_stage_available_q <= 1'b1;
    end else begin
      result_stage_available_q <= result_stage_available_d;
    end
  end

  always_comb begin
    result_stage_available_d = result_stage_available_q;

    if (actual_issue_ready && ~delay_issue_ready) begin
      result_stage_available_d = 1'b0;
    end else if (is_first_instr | result_hs) begin
      result_stage_available_d = 1'b1;
    end
  end

  // TODO refactor and separate the next state logic
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      is_first_instr <= 1'b1;
      is_first_instr_previous <= 1'b1;
    end else begin
      if (is_first_instr_previous & actual_issue_ready) begin
        is_first_instr <= 1'b0;
        is_first_instr_previous <= 1'b0;
      end
    end
  end

  // Handshake
  always_comb begin
    xif_issue_if.issue_ready = 1'b0;
    actual_issue_ready = 1'b0;

    if (xif_issue_if.issue_valid &
        xif_issue_if.issue_req.rs_valid[0] & xif_issue_if.issue_req.rs_valid[1]) begin
      xif_issue_if.issue_ready = result_stage_available_q;
      actual_issue_ready = 1'b1;
    end
  end

  // Pipeline the issue transaction request (instr, id, rs)
  logic [           4:0]                  rd_id_issued;
  logic [           1:0]                  bs_issued;

  logic                                   is_aes32dsi_issued;
  logic                                   is_aes32dsmi_issued;
  logic                                   is_aes32esi_issued;
  logic                                   is_aes32esmi_issued;
  logic                                   instr_accepted_issued;

  logic [X_ID_WIDTH-1:0]                  id_issued;
  logic [X_NUM_RS  -1:0][X_RFR_WIDTH-1:0] rs_issued;

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      rd_id_issued <= '0;
      bs_issued <= '0;

      is_aes32dsi_issued <= 1'b0;
      is_aes32dsmi_issued <= 1'b0;
      is_aes32esi_issued <= 1'b0;
      is_aes32esmi_issued <= 1'b0;
      instr_accepted_issued <= 1'b0;

      id_issued <= '0;
      rs_issued <= '{'0, '0};
    end else if (result_stage_available_q) begin
      rd_id_issued <= rd_id;
      bs_issued <= bs;

      is_aes32dsi_issued <= is_aes32dsi;
      is_aes32dsmi_issued <= is_aes32dsmi;
      is_aes32esi_issued <= is_aes32esi;
      is_aes32esmi_issued <= is_aes32esmi;
      instr_accepted_issued <= instr_accepted;

      id_issued <= xif_issue_if.issue_req.id;
      rs_issued <= xif_issue_if.issue_req.rs;
    end
  end

  // =======================================================================
  // Commit interface transaction
  // =======================================================================
  // TODO Do we need to flush succeeding instructions in pipeline ??? is there any ?

  logic result_valid;

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      result_valid <= 1'b0;
    end else if (result_valid) begin
      if (xif_result_if.result_ready) begin
        result_valid <= 1'b0;
      end
    end else if (instr_accepted_issued & xif_commit_if.commit_valid & ~xif_commit_if.commit.commit_kill) begin
      // TODO Do we need to check `instr_accepted_issued` ?
      // I think `xif_commit_if.commit.commit_kill` will be 1 for unaccepted instructions, but it's not mentioned in the spec
      result_valid <= 1'b1;
    end
  end

  assign xif_result_if.result_valid = result_valid;

  /*
  always_comb begin
    xif_result_if.result_valid = 1'b0;

    if (instr_accepted_issued & xif_commit_if.commit_valid & ~xif_commit_if.commit.commit_kill) begin
      xif_result_if.result_valid = 1'b1;
    end
  end
  */

  // =======================================================================
  // Result interface transaction
  // =======================================================================
  logic [X_RFW_WIDTH-1:0] result_data;
  logic [X_RFW_WIDTH-1:0] aes32dsi_result_data;
  logic [X_RFW_WIDTH-1:0] aes32dsmi_result_data;
  logic [X_RFW_WIDTH-1:0] aes32esi_result_data;
  logic [X_RFW_WIDTH-1:0] aes32esmi_result_data;

  always_comb begin
    xif_result_if.result.id = xif_commit_if.commit.id;
    xif_result_if.result.data = result_data;
    xif_result_if.result.rd = rd_id_issued;
    xif_result_if.result.we = 1'b1;
    xif_result_if.result.ecsdata = '0;
    xif_result_if.result.ecswe = '0;
    xif_result_if.result.exc = 1'b0;
    xif_result_if.result.exccode = '0;
    xif_result_if.result.err = 1'b0;
    xif_result_if.result.dbg = 1'b0;
  end

  aes32dsi aes32dsi_inst (
      .bs (bs_issued),
      .rs1(rs_issued[0]),
      .rs2(rs_issued[1]),
      .rd (aes32dsi_result_data)
  );

  aes32dsmi aes32dsmi_inst (
      .bs (bs_issued),
      .rs1(rs_issued[0]),
      .rs2(rs_issued[1]),
      .rd (aes32dsmi_result_data)
  );

  aes32esi aes32esi_inst (
      .bs (bs_issued),
      .rs1(rs_issued[0]),
      .rs2(rs_issued[1]),
      .rd (aes32esi_result_data)
  );

  aes32esmi aes32esmi_inst (
      .bs (bs_issued),
      .rs1(rs_issued[0]),
      .rs2(rs_issued[1]),
      .rd (aes32esmi_result_data)
  );

  always_comb begin
    result_data = '0;
    
    if (is_aes32dsi_issued) begin
      result_data = aes32dsi_result_data;
    end else if (is_aes32dsmi_issued) begin
      result_data = aes32dsmi_result_data;
    end else if (is_aes32esi_issued) begin
      result_data = aes32esi_result_data;
    end else if (is_aes32esmi_issued) begin
      result_data = aes32esmi_result_data;
    end
  end

  // =======================================================================
  // Unused interfaces
  // =======================================================================
  always_comb begin
    xif_compressed_if.compressed_ready = 1'b0;
    xif_mem_if.mem_valid = 1'b0;
  end

endmodule
