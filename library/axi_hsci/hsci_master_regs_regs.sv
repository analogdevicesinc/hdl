///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
/// SPDX short identifier: ADIBSD
///////////////////////////////////////////////////////////////////////////////


`include "hsci_master_regs_defs.vh"

/*
+----------+----------------------------+---------+-----------------------------------------------------------------------+
|  ADDRESS | REG NAME                   |  BITS   |  BITFIELD                                                             |
+----------+----------------------------+---------+-----------------------------------------------------------------------+
| 00000000 | REVISION_ID                |         |                                                                       |
|          |                            |  [15:0] | hsci_revision_id                                         (r)          |
| 00008001 | HSCI_MASTER_MODE           |         |                                                                       |
|          |                            |   [1:0] | hsci_xfer_mode                                         (r/w)          |
|          |                            |     [4] | ver_b__na                                              (r/w)          |
| 00008002 | HSCI_MASTER_XFER_NUM       |         |                                                                       |
|          |                            |  [15:0] | hsci_xfer_num                                          (r/w)          |
| 00008003 | HSCI_MASTER_ADDR_SIZE      |         |                                                                       |
|          |                            |   [2:0] | hsci_addr_size                                         (r/w)          |
| 00008004 | HSCI_MASTER_BYTE_NUM       |         |                                                                       |
|          |                            |  [16:0] | hsci_byte_num                                          (r/w)          |
| 00008005 | HSCI_MASTER_TARGET         |         |                                                                       |
|          |                            |  [31:0] | spi_target                                             (r/w)          |
| 00008006 | HSCI_MASTER_CTRL           |         |                                                                       |
|          |                            |   [1:0] | hsci_cmd_sel                                           (r/w)          |
|          |                            |   [5:4] | hsci_slave_ahb_tsize                                   (r/w)          |
| 00008007 | HSCI_MASTER_BRAM_ADDRESS   |         |                                                                       |
|          |                            |  [15:0] | hsci_bram_start_address                                (r/w)          |
| 00008008 | HSCI_MASTER_RUN            |         |                                                                       |
|          |                            |     [0] | hsci_run                                               (r/w)          |
| 00008009 | HSCI_MASTER_STATUS         |         |                                                                       |
|          |                            |     [0] | master_done                                              (r) Volatile |
|          |                            |     [1] | master_running                                           (r) Volatile |
|          |                            |     [2] | master_wr_in_prog                                        (r) Volatile |
|          |                            |     [3] | master_rd_in_prog                                        (r) Volatile |
|          |                            |     [4] | miso_test_lfsr_acq                                       (r) Volatile |
| 0000800a | HSCI_MASTER_LINKUP_CTRL    |         |                                                                       |
|          |                            |   [9:0] | hsci_man_linkup_word                                   (r/w)          |
|          |                            |    [10] | hsci_man_linkup                                        (r/w)          |
|          |                            |    [11] | hsci_auto_linkup                                       (r/w)          |
|          |                            |    [12] | mosi_clk_inv                                           (r/w)          |
|          |                            |    [13] | miso_clk_inv                                           (r/w)          |
| 0000800b | HSCI_MASTER_TEST_CTRL      |         |                                                                       |
|          |                            |     [0] | hsci_mosi_test_mode                                    (r/w)          |
|          |                            |     [1] | hsci_miso_test_mode                                    (r/w)          |
|          |                            |     [2] | hsci_capture_mode                                      (r/w)          |
| 0000800c | HSCI_MASTER_LINKUP_STATUS  |         |                                                                       |
|          |                            |     [0] | link_active                                              (r) Volatile |
|          |                            |   [7:4] | alink_txclk_adj                                          (r) Volatile |
|          |                            |     [8] | alink_txclk_inv                                          (r) Volatile |
|          |                            |    [10] | txclk_adj_mismatch                                       (r) Volatile |
|          |                            |    [11] | txclk_inv_mismatch                                       (r) Volatile |
| 0000800d | HSCI_MASTER_LINKUP_STATUS2 |         |                                                                       |
|          |                            |  [15:0] | alink_table                                              (r) Volatile |
|          |                            | [19:16] | alink_fsm                                                (r) Volatile |
| 0000800e | HSCI_DEBUG_STATUS          |         |                                                                       |
|          |                            |   [3:0] | enc_fsm                                                  (r) Volatile |
|          |                            |   [6:4] | dec_fsm                                                  (r) Volatile |
|          |                            |  [17:8] | capture_word                                             (r) Volatile |
|          |                            |    [18] | parity_error                                             (r) Volatile |
|          |                            |    [19] | unkown_instruction_error                                 (r) Volatile |
|          |                            | [27:20] | slave_error_code                                         (r) Volatile |
| 0000800f | MISO_TEST_BER              |         |                                                                       |
|          |                            |  [31:0] | miso_test_ber                                            (r) Volatile |
| 00008010 | HSCI_MASTER_LINK_ERR_INFO  |         |                                                                       |
|          |                            |  [30:0] | hsci_link_err_info                                       (r) Volatile |
| 00008011 | HSCI_RATE_CTRL             |         |                                                                       |
|          |                            |     [0] | hsci_mmcm_drp_trig                                     (r/w)          |
|          |                            |   [2:1] | hsci_rate_sel                                          (r/w)          |
|          |                            |     [8] | hsci_pll_reset                                         (r/w)          |
| 00008012 | HSCI_MASTER_RST            |         |                                                                       |
|          |                            |     [4] | hsci_master_clear_errors                               (r/w)          |
|          |                            |     [8] | hsci_master_rstn                                       (r/w)          |
| 00008013 | HSCI_PHY_STATUS            |         |                                                                       |
|          |                            |     [0] | hsci_reset_seq_done                                      (r) Volatile |
|          |                            |     [1] | hsci_phy_pll_locked                                      (r) Volatile |
|          |                            |     [2] | hsci_vtc_rdy_tx                                          (r) Volatile |
|          |                            |     [3] | hsci_vtc_rdy_rx                                          (r) Volatile |
|          |                            |     [4] | hsci_dly_rdy_tx                                          (r) Volatile |
|          |                            |     [5] | hsci_dly_rdy_rx                                          (r) Volatile |
| 0000801f | HSCI_MASTER_SCRATCH        |         |                                                                       |
|          |                            |  [31:0] | scratch_reg                                            (r/w)          |
+----------+----------------------------+---------+-----------------------------------------------------------------------+
*/

module hsci_master_regs_regs(
  input                     clk,
  input                     srstn,
  input       [15:0]        I_rd_addr,
  input                     I_wr_stb,
  input       [15:0]        I_wr_addr,
  input       [31:0]        I_wr_data,
  output reg  [31:0]        O_read_data,
  input  hsci_master_regs_pkg::hsci_master_regs_status_t I,
  output hsci_master_regs_pkg::hsci_master_regs_regs_t O
);

  import hsci_master_regs_pkg::*;

  wire wr_HSCI_MASTER_REGS_HSCI_MASTER_MODE;
  wire wr_HSCI_MASTER_REGS_HSCI_MASTER_XFER_NUM;
  wire wr_HSCI_MASTER_REGS_HSCI_MASTER_ADDR_SIZE;
  wire wr_HSCI_MASTER_REGS_HSCI_MASTER_BYTE_NUM;
  wire wr_HSCI_MASTER_REGS_HSCI_MASTER_TARGET;
  wire wr_HSCI_MASTER_REGS_HSCI_MASTER_CTRL;
  wire wr_HSCI_MASTER_REGS_HSCI_MASTER_BRAM_ADDRESS;
  wire wr_HSCI_MASTER_REGS_HSCI_MASTER_RUN;
  wire wr_HSCI_MASTER_REGS_HSCI_MASTER_LINKUP_CTRL;
  wire wr_HSCI_MASTER_REGS_HSCI_MASTER_TEST_CTRL;
  wire wr_HSCI_MASTER_REGS_HSCI_MASTER_SCRATCH;
  wire wr_HSCI_MASTER_REGS_HSCI_RATE_CTRL;
  wire wr_HSCI_MASTER_REGS_HSCI_MASTER_RST;
  assign wr_HSCI_MASTER_REGS_HSCI_MASTER_MODE               = ((I_wr_stb==1'b1) && (I_wr_addr==16'h8001));
  assign wr_HSCI_MASTER_REGS_HSCI_MASTER_XFER_NUM           = ((I_wr_stb==1'b1) && (I_wr_addr==16'h8002));
  assign wr_HSCI_MASTER_REGS_HSCI_MASTER_ADDR_SIZE          = ((I_wr_stb==1'b1) && (I_wr_addr==16'h8003));
  assign wr_HSCI_MASTER_REGS_HSCI_MASTER_BYTE_NUM           = ((I_wr_stb==1'b1) && (I_wr_addr==16'h8004));
  assign wr_HSCI_MASTER_REGS_HSCI_MASTER_TARGET             = ((I_wr_stb==1'b1) && (I_wr_addr==16'h8005));
  assign wr_HSCI_MASTER_REGS_HSCI_MASTER_CTRL               = ((I_wr_stb==1'b1) && (I_wr_addr==16'h8006));
  assign wr_HSCI_MASTER_REGS_HSCI_MASTER_BRAM_ADDRESS       = ((I_wr_stb==1'b1) && (I_wr_addr==16'h8007));
  assign wr_HSCI_MASTER_REGS_HSCI_MASTER_RUN                = ((I_wr_stb==1'b1) && (I_wr_addr==16'h8008));
  assign wr_HSCI_MASTER_REGS_HSCI_MASTER_LINKUP_CTRL        = ((I_wr_stb==1'b1) && (I_wr_addr==16'h800a));
  assign wr_HSCI_MASTER_REGS_HSCI_MASTER_TEST_CTRL          = ((I_wr_stb==1'b1) && (I_wr_addr==16'h800b));
  assign wr_HSCI_MASTER_REGS_HSCI_RATE_CTRL                 = ((I_wr_stb==1'b1) && (I_wr_addr==16'h8011));
  assign wr_HSCI_MASTER_REGS_HSCI_MASTER_RST                = ((I_wr_stb==1'b1) && (I_wr_addr==16'h8012));
  assign wr_HSCI_MASTER_REGS_HSCI_MASTER_SCRATCH            = ((I_wr_stb==1'b1) && (I_wr_addr==16'h801f));

  // BitField: hsci_revision_id (r)
  assign O.hsci_revision_id.data = 16'h1;

  // BitField: hsci_xfer_mode (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_xfer_mode.data <= 2'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_MODE) begin
      O.hsci_xfer_mode.data <= I_wr_data[1:0];
    end
  end

  // BitField: ver_b__na (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.ver_b__na.data <= 1'h1;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_MODE) begin
      O.ver_b__na.data <= I_wr_data[4];
    end
  end

  // BitField: hsci_xfer_num (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_xfer_num.data <= 16'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_XFER_NUM) begin
      O.hsci_xfer_num.data <= I_wr_data[15:0];
    end
  end

  // BitField: hsci_addr_size (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_addr_size.data <= 3'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_ADDR_SIZE) begin
      O.hsci_addr_size.data <= I_wr_data[2:0];
    end
  end

  // BitField: hsci_byte_num (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_byte_num.data <= 17'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_BYTE_NUM) begin
      O.hsci_byte_num.data <= I_wr_data[16:0];
    end
  end

  // BitField: spi_target (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.spi_target.data <= 32'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_TARGET) begin
      O.spi_target.data <= I_wr_data[31:0];
    end
  end

  // BitField: hsci_cmd_sel (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_cmd_sel.data <= 2'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_CTRL) begin
      O.hsci_cmd_sel.data <= I_wr_data[1:0];
    end
  end

  // BitField: hsci_slave_ahb_tsize (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_slave_ahb_tsize.data <= 2'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_CTRL) begin
      O.hsci_slave_ahb_tsize.data <= I_wr_data[5:4];
    end
  end

  // BitField: hsci_bram_start_address (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_bram_start_address.data <= 16'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_BRAM_ADDRESS) begin
      O.hsci_bram_start_address.data <= I_wr_data[15:0];
    end
  end

  // BitField: hsci_run (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_run.data <= 1'h0;
    end else if(I.hsci_run.sclr) begin
      O.hsci_run.data <= 1'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_RUN) begin
      O.hsci_run.data <= I_wr_data[0];
    end
  end

  // BitField: master_done (r)   Volatile

  // BitField: master_running (r)   Volatile

  // BitField: master_wr_in_prog (r)   Volatile

  // BitField: master_rd_in_prog (r)   Volatile

  // BitField: miso_test_lfsr_acq (r)   Volatile

  // BitField: hsci_man_linkup_word (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_man_linkup_word.data <= 10'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_LINKUP_CTRL) begin
      O.hsci_man_linkup_word.data <= I_wr_data[9:0];
    end
  end

  // BitField: hsci_man_linkup (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_man_linkup.data <= 1'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_LINKUP_CTRL) begin
      O.hsci_man_linkup.data <= I_wr_data[10];
    end
  end

  // BitField: hsci_auto_linkup (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_auto_linkup.data <= 1'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_LINKUP_CTRL) begin
      O.hsci_auto_linkup.data <= I_wr_data[11];
    end
  end

  // BitField: mosi_clk_inv (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.mosi_clk_inv.data <= 1'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_LINKUP_CTRL) begin
      O.mosi_clk_inv.data <= I_wr_data[12];
    end
  end

  // BitField: miso_clk_inv (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.miso_clk_inv.data <= 1'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_LINKUP_CTRL) begin
      O.miso_clk_inv.data <= I_wr_data[13];
    end
  end

  // BitField: hsci_mosi_test_mode (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_mosi_test_mode.data <= 1'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_TEST_CTRL) begin
      O.hsci_mosi_test_mode.data <= I_wr_data[0];
    end
  end

  // BitField: hsci_miso_test_mode (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_miso_test_mode.data <= 1'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_TEST_CTRL) begin
      O.hsci_miso_test_mode.data <= I_wr_data[1];
    end
  end

  // BitField: hsci_capture_mode (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_capture_mode.data <= 1'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_TEST_CTRL) begin
      O.hsci_capture_mode.data <= I_wr_data[2];
    end
  end

  // BitField: link_active (r)   Volatile

  // BitField: alink_txclk_adj (r)   Volatile

  // BitField: alink_txclk_inv (r)   Volatile

  // BitField: txclk_adj_mismatch (r)   Volatile

  // BitField: txclk_inv_mismatch (r)   Volatile

  // BitField: alink_table (r)   Volatile

  // BitField: alink_fsm (r)   Volatile

  // BitField: enc_fsm (r)   Volatile

  // BitField: dec_fsm (r)   Volatile

  // BitField: capture_word (r)   Volatile

  // BitField: parity_error (r)   Volatile

  // BitField: unkown_instruction_error (r)   Volatile

  // BitField: slave_error_code (r)   Volatile

  // BitField: miso_test_ber (r)   Volatile

  // BitField: hsci_link_err_info (r)   Volatile

  // BitField: scratch_reg (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.scratch_reg.data <= 32'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_SCRATCH) begin
      O.scratch_reg.data <= I_wr_data[31:0];
    end
  end

  // BitField: hsci_mmcm_drp_trig (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_mmcm_drp_trig.data <= 1'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_RATE_CTRL) begin
      O.hsci_mmcm_drp_trig.data <= I_wr_data[0];
    end
  end

  // BitField: hsci_rate_sel (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_rate_sel.data <= 2'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_RATE_CTRL) begin
      O.hsci_rate_sel.data <= I_wr_data[2:1];
    end
  end

  // BitField: hsci_pll_reset (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_pll_reset.data <= 1'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_RATE_CTRL) begin
      O.hsci_pll_reset.data <= I_wr_data[8];
    end
  end

  // BitField: hsci_master_clear_errors (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_master_clear_errors.data <= 1'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_RST) begin
      O.hsci_master_clear_errors.data <= I_wr_data[4];
    end
  end

  // BitField: hsci_master_rstn (r/w)
  always_ff @( posedge clk) begin
    if(!srstn) begin
      O.hsci_master_rstn.data <= 1'h0;
    end else if(wr_HSCI_MASTER_REGS_HSCI_MASTER_RST) begin
      O.hsci_master_rstn.data <= I_wr_data[8];
    end
  end

  // BitField: hsci_reset_seq_done (r)   Volatile

  // BitField: hsci_phy_pll_locked (r)   Volatile

  // BitField: hsci_vtc_rdy_tx (r)   Volatile

  // BitField: hsci_vtc_rdy_rx (r)   Volatile

  // BitField: hsci_dly_rdy_tx (r)   Volatile

  // BitField: hsci_dly_rdy_rx (r)   Volatile

  wire [31:0] rdata_HSCI_MASTER_REGS_REVISION_ID;                        // Revision ID for SPI Master Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_MASTER_MODE;                   // HSCI Master Mode Selection Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_MASTER_XFER_NUM;               // HSCI Master Number of Transactions Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_MASTER_ADDR_SIZE;              // HSCI Master Address Size Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_MASTER_BYTE_NUM;               // HSCI Master Data Size Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_MASTER_TARGET;                 // HSCI Master Target Chip Select Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_MASTER_CTRL;                   // HSCI Master CTRL Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_MASTER_BRAM_ADDRESS;           // BRAM Sequence Start Addr Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_MASTER_RUN;                    // HSCI Master RUN Trigger Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_MASTER_STATUS;                 // HSCI Master Status Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_MASTER_LINKUP_CTRL;            // HSCI Master Linkup CTRL Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_MASTER_TEST_CTRL;              // HSCI Master Test CTRL Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_MASTER_LINKUP_STATUS;          // HSCI Master Linkup Status Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_MASTER_LINKUP_STATUS2;         // HSCI Master Linkup Status 2 Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_DEBUG_STATUS;                  // HSCI Master FSM Status Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_MISO_TEST_BER;                      // MISO Test BER Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_MASTER_LINK_ERR_INFO;          // HSCI Master Link Error Info Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_MASTER_SCRATCH;                // Scratch Register Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_RATE_CTRL;                     // HSCI Rate Control Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_MASTER_RST;                    // HSCI Master Reset Controls Read Data
  wire [31:0] rdata_HSCI_MASTER_REGS_HSCI_PHY_STATUS;                    // HSCI PHY STATUS Read Data
  assign rdata_HSCI_MASTER_REGS_REVISION_ID[31:0]                = {16'h0, O.hsci_revision_id.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_MASTER_MODE[31:0]           = {27'h0, O.ver_b__na.data, 2'h0, O.hsci_xfer_mode.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_MASTER_XFER_NUM[31:0]       = {16'h0, O.hsci_xfer_num.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_MASTER_ADDR_SIZE[31:0]      = {29'h0, O.hsci_addr_size.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_MASTER_BYTE_NUM[31:0]       = {15'h0, O.hsci_byte_num.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_MASTER_TARGET[31:0]         = {O.spi_target.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_MASTER_CTRL[31:0]           = {26'h0, O.hsci_slave_ahb_tsize.data, 2'h0, O.hsci_cmd_sel.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_MASTER_BRAM_ADDRESS[31:0]   = {16'h0, O.hsci_bram_start_address.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_MASTER_RUN[31:0]            = {31'h0, O.hsci_run.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_MASTER_STATUS[31:0]         = {27'h0, I.miso_test_lfsr_acq.data, I.master_rd_in_prog.data, I.master_wr_in_prog.data, I.master_running.data, I.master_done.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_MASTER_LINKUP_CTRL[31:0]    = {18'h0, O.miso_clk_inv.data, O.mosi_clk_inv.data, O.hsci_auto_linkup.data, O.hsci_man_linkup.data, O.hsci_man_linkup_word.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_MASTER_TEST_CTRL[31:0]      = {29'h0, O.hsci_capture_mode.data, O.hsci_miso_test_mode.data, O.hsci_mosi_test_mode.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_MASTER_LINKUP_STATUS[31:0]  = {20'h0, I.txclk_inv_mismatch.data, I.txclk_adj_mismatch.data, 1'h0, I.alink_txclk_inv.data, I.alink_txclk_adj.data, 3'h0, I.link_active.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_MASTER_LINKUP_STATUS2[31:0] = {12'h0, I.alink_fsm.data, I.alink_table.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_DEBUG_STATUS[31:0]          = {4'h0, I.slave_error_code.data, I.unkown_instruction_error.data, I.parity_error.data, I.capture_word.data, 1'h0, I.dec_fsm.data, I.enc_fsm.data};
  assign rdata_HSCI_MASTER_REGS_MISO_TEST_BER[31:0]              = {I.miso_test_ber.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_MASTER_LINK_ERR_INFO[31:0]  = {1'h0, I.hsci_link_err_info.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_MASTER_SCRATCH[31:0]        = {O.scratch_reg.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_RATE_CTRL[31:0]             = {23'h0, O.hsci_pll_reset.data, 5'h0, O.hsci_rate_sel.data, O.hsci_mmcm_drp_trig.data};
  assign rdata_HSCI_MASTER_REGS_HSCI_MASTER_RST[31:0]            = {23'h0, O.hsci_master_rstn.data, 3'h0, O.hsci_master_clear_errors.data, 4'h0};
  assign rdata_HSCI_MASTER_REGS_HSCI_PHY_STATUS[31:0]            = {26'h0, I.hsci_dly_rdy_rx.data, I.hsci_dly_rdy_tx.data, I.hsci_vtc_rdy_rx.data, I.hsci_vtc_rdy_tx.data, I.hsci_phy_pll_locked.data, I.hsci_reset_seq_done.data};

  always_comb begin
    case (I_rd_addr)
      16'h0000 : O_read_data = rdata_HSCI_MASTER_REGS_REVISION_ID;
      16'h8001 : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_MASTER_MODE;
      16'h8002 : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_MASTER_XFER_NUM;
      16'h8003 : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_MASTER_ADDR_SIZE;
      16'h8004 : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_MASTER_BYTE_NUM;
      16'h8005 : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_MASTER_TARGET;
      16'h8006 : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_MASTER_CTRL;
      16'h8007 : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_MASTER_BRAM_ADDRESS;
      16'h8008 : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_MASTER_RUN;
      16'h8009 : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_MASTER_STATUS;
      16'h800a : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_MASTER_LINKUP_CTRL;
      16'h800b : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_MASTER_TEST_CTRL;
      16'h800c : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_MASTER_LINKUP_STATUS;
      16'h800d : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_MASTER_LINKUP_STATUS2;
      16'h800e : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_DEBUG_STATUS;
      16'h800f : O_read_data = rdata_HSCI_MASTER_REGS_MISO_TEST_BER;
      16'h8010 : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_MASTER_LINK_ERR_INFO;
      16'h8011 : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_RATE_CTRL;
      16'h8012 : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_MASTER_RST;
      16'h8013 : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_PHY_STATUS;
      16'h801f : O_read_data = rdata_HSCI_MASTER_REGS_HSCI_MASTER_SCRATCH;
    default :
              O_read_data = 32'h0;
    endcase
  end

endmodule
