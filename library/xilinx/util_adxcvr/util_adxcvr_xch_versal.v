// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module util_adxcvr_xch_versal #(
  parameter   integer XCVR_TYPE = 11,
  parameter   integer LINK_MODE = 1, // 2 - 64B/66B;  1 - 8B/10B
  parameter   integer DATA_PATH_WIDTH = LINK_MODE == 2 ? 8 : 4,
  parameter   integer TX_POLARITY = 0,
  parameter   integer RX_POLARITY = 0
) (
  input                            rx_clk,
  input                            rx_phy_clk,
  input                            rx_phy_rstn,
  input                            rx_calign,
  output  [DATA_PATH_WIDTH-1:0]    rx_charisk,
  output  [DATA_PATH_WIDTH-1:0]    rx_disperr,
  output  [DATA_PATH_WIDTH-1:0]    rx_notintable,
  output  [DATA_PATH_WIDTH*8-1:0]  rx_data,
  output  [1:0]                    rx_header,
  output                           rx_block_sync,

  input                            tx_clk,
  input                            tx_phy_clk,
  input                            tx_phy_rstn,
  input   [DATA_PATH_WIDTH-1:0]    tx_charisk,
  input   [DATA_PATH_WIDTH*8-1:0]  tx_data,
  input   [1:0]                    tx_header,

  input   [127:0]                  gt_ch_rxdata,
  input   [  5:0]                  gt_ch_rxheader,
  input   [ 15:0]                  gt_ch_rxctrl0,
  input   [ 15:0]                  gt_ch_rxctrl1,
  input   [  7:0]                  gt_ch_rxctrl3,
  input   [  1:0]                  gt_ch_rxheadervalid,
  input                            gt_ch_rxresetdone,
  input   [  2:0]                  gt_ch_rxbufstatus,
  input                            gt_ch_rxprbserr,
  input                            gt_ch_rxprbslocked,
  output                           gt_ch_rxgearboxslip,
  output                           gt_ch_rxslide,
  output  [  3:0]                  gt_ch_rxprbssel,
  output                           gt_ch_rxprbscntreset,
  output                           gt_ch_rxlpmen,
  output                           gt_ch_rxpolarity,
  output  [  7:0]                  gt_ch_rxrate,
  output                           gt_ch_eyescanreset,
  output                           gt_calign,

  output  [127:0]                  gt_ch_txdata,
  output  [  5:0]                  gt_ch_txheader,
  output  [ 15:0]                  gt_ch_txctrl0,
  output  [ 15:0]                  gt_ch_txctrl1,
  output  [  7:0]                  gt_ch_txctrl2,
  output  [  3:0]                  gt_ch_txprbssel,
  output                           gt_ch_txprbsforceerr,
  output  [  4:0]                  gt_ch_txdiffctrl,
  output  [  5:0]                  gt_ch_txpostcursor,
  output  [  5:0]                  gt_ch_txprecursor,
  output                           gt_ch_txpolarity,
  output  [  7:0]                  gt_ch_txrate,
  input                            gt_ch_txresetdone,
  input   [  1:0]                  gt_ch_txbufstatus,

  input           up_rstn,
  input           up_clk,
  input           up_pll_locked,
  input           up_es_enb,
  input   [11:0]  up_es_addr,
  input           up_es_wr,
  input   [15:0]  up_es_wdata,
  output  [15:0]  up_es_rdata,
  output          up_es_ready,
  input           up_es_reset,
  output          up_rx_pll_locked,
  input           up_rx_rst,
  input           up_rx_user_ready,
  output          up_rx_rst_done,
  input   [ 3:0]  up_rx_prbssel,
  input           up_rx_prbscntreset,
  output          up_rx_prbserr,
  output          up_rx_prbslocked,
  output  [ 1:0]  up_rx_bufstatus,
  input           up_rx_bufstatus_rst,
  input           up_rx_lpm_dfe_n,
  input   [ 2:0]  up_rx_rate,
  input           up_rx_enb,
  input   [11:0]  up_rx_addr,
  input           up_rx_wr,
  input   [15:0]  up_rx_wdata,
  output  [15:0]  up_rx_rdata,
  output          up_rx_ready,
  output          up_tx_pll_locked,
  input           up_tx_rst,
  input           up_tx_user_ready,
  output          up_tx_rst_done,
  output  [ 1:0]  up_tx_bufstatus,
  input           up_tx_prbsforceerr,
  input   [ 3:0]  up_tx_prbssel,
  input   [ 2:0]  up_tx_rate,
  input   [ 4:0]  up_tx_diffctrl,
  input   [((XCVR_TYPE == 13) ? 5 : 4):0]  up_tx_postcursor,
  input   [((XCVR_TYPE == 13) ? 5 : 4):0]  up_tx_precursor,
  input           up_tx_enb,
  input   [11:0]  up_tx_addr,
  input           up_tx_wr,
  input   [15:0]  up_tx_wdata,
  output  [15:0]  up_tx_rdata,
  output          up_tx_ready
);

  localparam TRANSCEIVER = (XCVR_TYPE == 13) ? "GTM" :
                           (XCVR_TYPE == 12) ? "GTYP" : "GTY";

  reg             up_es_ready_int = 1'b0;
  reg             up_rx_ready_int = 1'b0;
  reg             up_tx_ready_int = 1'b0;
  reg             up_gt_rxprbscntreset = 1'b0;
  reg             rx_prbserr_sticky = 1'b0;
  reg             rx_bufstatus_sticky_0 = 1'b0;
  reg             rx_bufstatus_sticky_1 = 1'b0;

  wire    [63:0]  rx_data_s;
  wire    [ 3:0]  rx_charisk_s;
  wire    [ 3:0]  rx_disperr_s;
  wire    [ 3:0]  rx_notintable_s;
  wire    [ 7:0]  rx_charisk_w;
  wire    [ 7:0]  rx_disperr_w;
  wire    [ 7:0]  rx_notintable_w;
  wire   [127:0]  tx_data_w;
  wire    [11:0]  tx_charisk_w;
  wire            rx_prbscntreset;
  wire            rx_bufstatus_rst;
  wire    [ 1:0]  rx_bufstatus;
  wire    [ 1:0]  tx_bufstatus;

  // Versal quads have no channel DRP; answer so the axi_adxcvr DRP chain
  // does not stall. Quad registers are reached through up_qm instead.
  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_es_ready_int <= 1'b0;
      up_rx_ready_int <= 1'b0;
      up_tx_ready_int <= 1'b0;
    end else begin
      up_es_ready_int <= up_es_enb;
      up_rx_ready_int <= up_rx_enb;
      up_tx_ready_int <= up_tx_enb;
    end
  end

  assign up_es_rdata = 16'd0;
  assign up_es_ready = up_es_ready_int;
  assign up_rx_rdata = 16'd0;
  assign up_rx_ready = up_rx_ready_int;
  assign up_tx_rdata = 16'd0;
  assign up_tx_ready = up_tx_ready_int;

  assign up_rx_pll_locked = up_pll_locked;
  assign up_tx_pll_locked = up_pll_locked;

  // These GT ports are ASYNC (AM002), the GT synchronizes them internally.
  // PRBSSEL/PRBSFORCEERR are ASYNC too, but the Vivado timing model times them
  // against the user clock, so they are synchronized to it below.
  // RXPRBSCNTRESET must be low during the RX reset sequences (AM002), and
  // axi_adxcvr holds it high by default: pass it only while PRBS is selected
  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_gt_rxprbscntreset <= 1'b0;
    end else begin
      up_gt_rxprbscntreset <= up_rx_prbscntreset & (up_rx_prbssel != 4'd0);
    end
  end

  assign gt_ch_rxprbscntreset = up_gt_rxprbscntreset;
  assign gt_ch_rxlpmen = up_rx_lpm_dfe_n;
  assign gt_ch_eyescanreset = up_es_reset;
  assign gt_ch_txdiffctrl = up_tx_diffctrl;
  // TX cursors: 6 bits on GTM, 5 on GTY/GTYP
  assign gt_ch_txpostcursor = (XCVR_TYPE == 13) ? up_tx_postcursor : {1'b0, up_tx_postcursor[4:0]};
  assign gt_ch_txprecursor = (XCVR_TYPE == 13) ? up_tx_precursor : {1'b0, up_tx_precursor[4:0]};
  assign gt_ch_rxpolarity = RX_POLARITY[0];
  assign gt_ch_txpolarity = TX_POLARITY[0];

  // GTY/GTYP align on commas inside the GT, enabled per channel through the
  // quad GPI (AM002: GPI[11:8] set RX_MCOMMA/PCOMMA_ALIGNEN); GTM aligns in
  // the soft PCS. The adapter's RXSLIDE-based lane_align is not used.
  assign gt_calign = rx_calign;
  assign gt_ch_rxslide = 1'b0;

  // PRBSSEL is a 4-bit code, so it crosses as one word
  sync_data #(
    .NUM_OF_BITS (4)
  ) i_sync_data_rx_prbssel (
    .in_clk (up_clk),
    .in_data (up_rx_prbssel),
    .out_clk (rx_phy_clk),
    .out_data (gt_ch_rxprbssel));

  sync_bits #(
    .NUM_OF_BITS (2)
  ) i_sync_bits_rx_in (
    .in_bits ({up_rx_prbscntreset, up_rx_bufstatus_rst}),
    .out_resetn (1'b1),
    .out_clk (rx_phy_clk),
    .out_bits ({rx_prbscntreset, rx_bufstatus_rst}));

  sync_data #(
    .NUM_OF_BITS (4)
  ) i_sync_data_tx_prbssel (
    .in_clk (up_clk),
    .in_data (up_tx_prbssel),
    .out_clk (tx_phy_clk),
    .out_data (gt_ch_txprbssel));

  sync_bits #(
    .NUM_OF_BITS (1)
  ) i_sync_bits_tx_prbs_in (
    .in_bits (up_tx_prbsforceerr),
    .out_resetn (1'b1),
    .out_clk (tx_phy_clk),
    .out_bits (gt_ch_txprbsforceerr));

  always @(posedge rx_phy_clk) begin
    if (rx_prbscntreset == 1'b1) begin
      rx_prbserr_sticky <= 1'b0;
    end else if (gt_ch_rxprbserr == 1'b1) begin
      rx_prbserr_sticky <= 1'b1;
    end
  end

  always @(posedge rx_phy_clk) begin
    if (rx_bufstatus_rst == 1'b1) begin
      rx_bufstatus_sticky_0 <= 1'b0;
      rx_bufstatus_sticky_1 <= 1'b0;
    end else begin
      if (gt_ch_rxbufstatus[0] == 1'b1) begin
        rx_bufstatus_sticky_0 <= 1'b1;
      end
      if (gt_ch_rxbufstatus[1] == 1'b1) begin
        rx_bufstatus_sticky_1 <= 1'b1;
      end
    end
  end

  // Same bit selection as util_adxcvr_xch so STATUS[6:5] keep their meaning.
  assign rx_bufstatus = (LINK_MODE == 2) ? {rx_bufstatus_sticky_1, rx_bufstatus_sticky_0} :
                                           {2{rx_bufstatus_sticky_1}};
  assign tx_bufstatus = (LINK_MODE == 2) ? gt_ch_txbufstatus : {2{gt_ch_txbufstatus[1]}};

  sync_bits #(
    .NUM_OF_BITS (6)
  ) i_sync_bits_status (
    .in_bits ({gt_ch_rxprbslocked, rx_prbserr_sticky, rx_bufstatus, tx_bufstatus}),
    .out_resetn (up_rstn),
    .out_clk (up_clk),
    .out_bits ({up_rx_prbslocked, up_rx_prbserr, up_rx_bufstatus, up_tx_bufstatus}));

  util_adxcvr_versal_rate i_rx_seq (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_rst (up_rx_rst),
    .up_user_ready (up_rx_user_ready),
    .up_rate (up_rx_rate),
    .up_rst_done (up_rx_rst_done),
    .usr_clk (rx_phy_clk),
    .gt_resetdone (gt_ch_rxresetdone),
    .gt_rate (gt_ch_rxrate));

  util_adxcvr_versal_rate i_tx_seq (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_rst (up_tx_rst),
    .up_user_ready (up_tx_user_ready),
    .up_rate (up_tx_rate),
    .up_rst_done (up_tx_rst_done),
    .usr_clk (tx_phy_clk),
    .gt_resetdone (gt_ch_txresetdone),
    .gt_rate (gt_ch_txrate));

  jesd204_versal_gt_adapter_rx #(
    .TRANSCEIVER (TRANSCEIVER),
    .LINK_MODE (LINK_MODE)
  ) i_rx_adapter (
    .rxdata (gt_ch_rxdata),
    .rxheader (gt_ch_rxheader),
    .rxctrl0 (gt_ch_rxctrl0),
    .rxctrl1 (gt_ch_rxctrl1),
    .rxctrl3 (gt_ch_rxctrl3),
    .rxgearboxslip (gt_ch_rxgearboxslip),
    .rxheadervalid (gt_ch_rxheadervalid),
    .rxslide (),
    .phy_clk (rx_phy_clk),
    .phy_rstn (rx_phy_rstn),
    .rx_data (rx_data_s),
    .rx_charisk (rx_charisk_s),
    .rx_disperr (rx_disperr_s),
    .rx_notintable (rx_notintable_s),
    .rx_header (rx_header),
    .rx_block_sync (rx_block_sync),
    .en_char_align (rx_calign),
    .usr_clk (rx_clk));

  assign rx_charisk_w = {4'd0, rx_charisk_s};
  assign rx_disperr_w = {4'd0, rx_disperr_s};
  assign rx_notintable_w = {4'd0, rx_notintable_s};
  assign rx_data = rx_data_s[DATA_PATH_WIDTH*8-1:0];
  assign rx_charisk = rx_charisk_w[DATA_PATH_WIDTH-1:0];
  assign rx_disperr = rx_disperr_w[DATA_PATH_WIDTH-1:0];
  assign rx_notintable = rx_notintable_w[DATA_PATH_WIDTH-1:0];

  assign tx_data_w = {64'd0, tx_data};
  assign tx_charisk_w = {4'd0, tx_charisk};

  jesd204_versal_gt_adapter_tx #(
    .TRANSCEIVER (TRANSCEIVER),
    .LINK_MODE (LINK_MODE)
  ) i_tx_adapter (
    .txdata (gt_ch_txdata),
    .txheader (gt_ch_txheader),
    .txctrl0 (gt_ch_txctrl0),
    .txctrl1 (gt_ch_txctrl1),
    .txctrl2 (gt_ch_txctrl2),
    .phy_clk (tx_phy_clk),
    .phy_rstn (tx_phy_rstn),
    .tx_data (tx_data_w[63:0]),
    .tx_header (tx_header),
    .tx_charisk (tx_charisk_w[3:0]),
    .usr_clk (tx_clk));

endmodule
