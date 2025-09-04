// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ps/1ps
import hsci_master_regs_pkg::*;

module hsci_master_top #(
  parameter AXI_ADDR_WIDTH    =    16,
  parameter AXI_DATA_WIDTH    =    32,
  parameter REGMAP_ADDR_WIDTH =    16,
  parameter S_AXI_ADDR_WIDTH  =    18
)(
  input  wire         axi_clk,
  input  wire         axi_resetn,

  input  wire         hsci_pclk,

  axi4_lite.slave     axi,

  output       [7:0]  hsci_menc_clk,
  output       [7:0]  hsci_mosi_data,
  input  wire  [7:0]  hsci_miso_data,

  output              hsci_pll_reset,
  input  wire         hsci_rst_seq_done,
  input  wire         hsci_pll_locked,
  input  wire         hsci_vtc_rdy_bsc_tx,
  input  wire         hsci_dly_rdy_bsc_tx,
  input  wire         hsci_vtc_rdy_bsc_rx,
  input  wire         hsci_dly_rdy_bsc_rx
);

  //--------------------------------------------------------------------------
  //----------- Local Parameters ---------------------------------------------
  //--------------------------------------------------------------------------

  //--------------------------------------------------------------------------
  //----------- Signal Declarations ------------------------------------------
  //--------------------------------------------------------------------------

  hsci_master_regs_pkg::hsci_master_regs_status_t I;
  hsci_master_regs_pkg::hsci_master_regs_regs_t   O;

  // BRAM Interface
  logic                             bram_ce;
  logic  [14:0]                     bram_addr;
  logic  [3:0]                      bram_we;
  logic  [31:0]                     bram_dout;
  logic  [31:0]                     bram_din;

  logic                             sbiterra;
  logic                             sbiterrb;
  logic                             dbiterra;
  logic                             dbiterrb;

  logic  [14:0]                     bram_strt_addr;

  wire   [REGMAP_ADDR_WIDTH-1:0]    hsci_regmap_raddr;
  wire                              hsci_regmap_rd_en;
  wire   [AXI_DATA_WIDTH-1:0]       hsci_regmap_rdata;
  wire   [REGMAP_ADDR_WIDTH-1:0]    hsci_regmap_waddr;
  wire   [AXI_DATA_WIDTH-1:0]       hsci_regmap_wdata;
  wire                              hsci_regmap_wr_en;

  wire    [AXI_ADDR_WIDTH-1:0]      axi_bram_addr;
  wire    [AXI_DATA_WIDTH-1:0]      axi_bram_wdata;
  wire    [AXI_DATA_WIDTH-1:0]      axi_bram_rdata;
  wire                              axi_bram_wr_en;

  wire                              run_s;
  wire                              hsci_clear_errors;
  logic                             hsci_rstn_async;
  logic                             hsci_rst_sync;


  assign I.hsci_reset_seq_done = hsci_rst_seq_done;
  assign I.hsci_phy_pll_locked = hsci_pll_locked;
  assign I.hsci_vtc_rdy_tx     = hsci_vtc_rdy_bsc_tx;
  assign I.hsci_dly_rdy_tx     = hsci_dly_rdy_bsc_tx;
  assign I.hsci_vtc_rdy_rx     = hsci_vtc_rdy_bsc_rx;
  assign I.hsci_dly_rdy_rx     = hsci_dly_rdy_bsc_rx;

  assign hsci_pll_reset = O.hsci_pll_reset.data;
  assign hsci_rstn_async = O.hsci_master_rstn.data & hsci_pll_locked;
  assign hsci_clear_errors = O.hsci_master_clear_errors.data;
  assign bram_strt_addr = (O.hsci_bram_start_address.data)-1;//*'h4 - 16'h4;

  ad_rst i_hsci_rstn_reg (
    .rst_async(~hsci_rstn_async),
    .clk(hsci_pclk),
    .rstn(),
    .rst(hsci_rst_sync));

  pulse_sync sync_run (
    .dout       (run_s),
    .inclk      (axi_clk),
    .rst_inclk  (~axi_resetn),
    .outclk     (hsci_pclk),
    .rst_outclk (hsci_rst_sync),
    .din        (O.hsci_run.data));

  // HSCI Core Instantiation
  hsci_mcore hsci_mcore (
    //globals
    .hsci_pclk              (hsci_pclk),
    .hsci_rstn              (hsci_rstn_async),
    // register inputs
    .hsci_master_run        (run_s),
    .hsci_cmd_sel           (O.hsci_cmd_sel.data),
    .hsci_master_xfer_num   (O.hsci_xfer_num.data),
    .hsci_master_byte_num   (O.hsci_byte_num.data),
    .hsci_master_addr_size  (O.hsci_addr_size.data),
    .hsci_master_bram_addr  (bram_strt_addr),
    .tsize                  (O.hsci_slave_ahb_tsize.data),
    .man_linkup             (O.hsci_man_linkup.data),
    .man_linkup_word        (O.hsci_man_linkup_word.data),
    .auto_linkup            (O.hsci_auto_linkup.data),
    .capture_mode           (O.hsci_capture_mode.data),
    .capture_word           (I.capture_word.data),
    .mosi_test_mode         (O.hsci_mosi_test_mode.data),
    .miso_test_mode         (O.hsci_miso_test_mode.data),
    .alink_fsm_stall        (1'b0),
    .alink_fsm_step         (1'b0),
    .clear_errors           (hsci_clear_errors),
    .ver_b_na               (O.ver_b__na.data),
    .mosi_clk_inv           (O.mosi_clk_inv.data),
    .miso_clk_inv           (O.miso_clk_inv.data),
    // status signals
    .master_done            (I.master_done.data),
    .master_running         (I.master_running.data),
    .master_wr_in_prog      (I.master_wr_in_prog.data),
    .master_rd_in_prog      (I.master_rd_in_prog.data),
    .enc_fsm                (I.enc_fsm.data),
    .dec_fsm                (I.dec_fsm.data),
    .link_active            (I.link_active.data),
    .alink_fsm              (I.alink_fsm.data),
    .alink_table            (I.alink_table.data),
    .alink_txclk_adj        (I.alink_txclk_adj.data),
    .alink_txclk_inv        (I.alink_txclk_inv.data),
    .miso_ber_cnt           (I.miso_test_ber.data),
    .miso_test_lfsr_acq     (I.miso_test_lfsr_acq.data),
    .error_code             (I.slave_error_code.data),
    .parity_err             (I.parity_error.data),
    .unk_instr_err          (I.unkown_instruction_error.data),
    .link_err_info          (I.hsci_link_err_info.data),
    .alink_fsm_stalled      (), // Output
    .txclk_adj_mismatch     (I.txclk_adj_mismatch.data),
    .txclk_inv_mismatch     (I.txclk_inv_mismatch.data),
    // tdpram i/f
    .mem_addr               (bram_addr),
    .mem_en                 (bram_ce),
    .mem_din                (bram_din),
    .mem_we                 (bram_we),
    .mem_dout               (bram_dout),
    // isedes/oserdes i/f
    .menc_clk               (hsci_menc_clk),
    .menc_data              (hsci_mosi_data),
    .mdec_data              (hsci_miso_data));

   //  Dual Port BRAM for the HSCI Master
  xpm_memory_tdpram # (
    // Common module parameters
    .MEMORY_SIZE         (1048576),               //positive integer (32KB * 32) in bits 128K = 1048576, Test= 2048, 64K (65468 bytes) = 523776
    .MEMORY_PRIMITIVE    ("auto"),                //string; "auto", "distributed", "block" or "ultra";
    .CLOCKING_MODE       ("independent_clock"),   //string; "common_clock", "independent_clock"
    .MEMORY_INIT_FILE    ("none"),                //string; "none" or "<filename>.mem"
    .MEMORY_INIT_PARAM   (""   ),                 //string;
    .USE_MEM_INIT        (1),                     //integer; 0,1
    .WAKEUP_TIME         ("disable_sleep"),       //string; "disable_sleep" or "use_sleep_pin"
    .MESSAGE_CONTROL     (0),                     //integer; 0,1
    .ECC_MODE            ("no_ecc"),              //string; "no_ecc", "encode_only", "decode_only" or "both_encode_and_decode"
    .AUTO_SLEEP_TIME     (0),                     //Do not Change
    .MEMORY_OPTIMIZATION ("true"),

    // Port A module parameters
    .WRITE_DATA_WIDTH_A  (32),                    //positive integer
    .READ_DATA_WIDTH_A   (32),                    //positive integer
    .BYTE_WRITE_WIDTH_A  (32),                    //integer; 8, 9, or WRITE_DATA_WIDTH_A value
    .ADDR_WIDTH_A        (15),                    //positive integer
    .READ_RESET_VALUE_A  ("0"),                   //string
    .READ_LATENCY_A      (2),                     //non-negative integer
    .WRITE_MODE_A        ("no_change"),           //string; "write_first", "read_first", "no_change"

    // Port B module parameters
    .WRITE_DATA_WIDTH_B  (32),                    //positive integer
    .READ_DATA_WIDTH_B   (32),                    //positive integer
    .BYTE_WRITE_WIDTH_B  (8),                     //integer; 8, 9, or WRITE_DATA_WIDTH_B value
    .ADDR_WIDTH_B        (15),                    //positive integer
    .READ_RESET_VALUE_B  ("0"),                   //vector of READ_DATA_WIDTH_B bits
    .READ_LATENCY_B      (2),                     //non-negative integer
    .WRITE_MODE_B        ("no_change")            //string; "write_first", "read_first", "no_change"
  ) xpm_memory_tdpram_inst (
    // Common module ports
    .sleep              (1'b0),
    // Port A module ports
    .clka              (axi_clk),
    .rsta              (~axi_resetn),
    .ena               (1'b1),
    .regcea            (1'b1),
    .wea               (axi_bram_wr_en),
    .addra             (axi_bram_addr),
    .dina              (axi_bram_wdata),
    .injectsbiterra    (1'b0),
    .injectdbiterra    (1'b0),
    .douta             (axi_bram_rdata),
    .sbiterra          (sbiterra),
    .dbiterra          (dbiterra),
    // Port B module ports
    .clkb              (hsci_pclk),
    .rstb              (hsci_rst_sync),
    .enb               (bram_ce),
    .regceb            (1'b1),
    .web               (bram_we),
    .addrb             (bram_addr),
    .dinb              (bram_din),
    .injectsbiterrb    (1'b0),
    .injectdbiterrb    (1'b0),
    .doutb             (bram_dout),
    .sbiterrb          (sbiterrb),
    .dbiterrb          (dbiterrb));

   // Convert AXI4 Lite to Yoda register interface
  hsci_master_axi_slave #(
    .REGMAP_ADDR_WIDTH (REGMAP_ADDR_WIDTH))
  hsci_master_axi_slave (
    .axi_clk           (axi_clk),
    .axi_resetn        (axi_resetn),
    .axi               (axi),

    .regmap_raddr      (hsci_regmap_raddr),
    .regmap_rd_en      (hsci_regmap_rd_en),
    .regmap_waddr      (hsci_regmap_waddr),
    .regmap_wdata      (hsci_regmap_wdata),
    .regmap_wr_en      (hsci_regmap_wr_en),
    .regmap_rdata      (hsci_regmap_rdata),

    .bram_addr         (axi_bram_addr),
    .bram_wdata        (axi_bram_wdata),
    .bram_rdata        (axi_bram_rdata),
    .bram_we           (axi_bram_wr_en));

   // Yoda register map
  hsci_master_logic #(
    .ADDR_WIDTH  (REGMAP_ADDR_WIDTH),
    .DATA_WIDTH  (AXI_DATA_WIDTH)
   ) hsci_master_logic (
      .clk         (axi_clk),
      .srstn       (axi_resetn),
      .I_rd_addr   (hsci_regmap_raddr),
      .I_wr_stb    (hsci_regmap_wr_en),
      .I_wr_addr   (hsci_regmap_waddr),
      .I_wr_data   (hsci_regmap_wdata),
      .O_read_data (hsci_regmap_rdata),
      .I           (I),
      .O           (O));

endmodule
