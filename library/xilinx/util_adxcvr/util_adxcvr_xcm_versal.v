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

module util_adxcvr_xcm_versal #(
  parameter   integer HSCLK1_USED = 1
) (
  input             up_rstn,
  input             up_clk,
  input             up_powergood,

  input             up_rx_qm_enb,
  input   [15:0]    up_rx_qm_addr,
  input             up_rx_qm_wr,
  input   [31:0]    up_rx_qm_wdata,
  output  [31:0]    up_rx_qm_rdata,
  output            up_rx_qm_ready,
  output            up_rx_qm_slverr,
  output            up_rx_qm_powergood,

  input             up_tx_qm_enb,
  input   [15:0]    up_tx_qm_addr,
  input             up_tx_qm_wr,
  input   [31:0]    up_tx_qm_wdata,
  output  [31:0]    up_tx_qm_rdata,
  output            up_tx_qm_ready,
  output            up_tx_qm_slverr,
  output            up_tx_qm_powergood,

  input             up_cm_enb,
  output  [15:0]    up_cm_rdata,
  output            up_cm_ready,

  input             gt_lcplllock0,
  input             gt_lcplllock1,
  output            up_lcplllock,
  output  [ 3:0]    gt_iloreset,

  output            m_axi_awvalid,
  output  [17:0]    m_axi_awaddr,
  input             m_axi_awready,
  output            m_axi_wvalid,
  output  [31:0]    m_axi_wdata,
  input             m_axi_wready,
  input             m_axi_bvalid,
  input   [ 1:0]    m_axi_bresp,
  output            m_axi_bready,
  output            m_axi_arvalid,
  output  [17:0]    m_axi_araddr,
  input             m_axi_arready,
  input             m_axi_rvalid,
  input   [31:0]    m_axi_rdata,
  input   [ 1:0]    m_axi_rresp,
  output            m_axi_rready
);

  localparam  [ 1:0]  S_IDLE = 2'd0;
  localparam  [ 1:0]  S_ADDR = 2'd1;
  localparam  [ 1:0]  S_RESP = 2'd2;

  reg     [ 1:0]  up_state = S_IDLE;
  reg             up_rx_pend = 1'b0;
  reg     [15:0]  up_rx_addr_l = 16'd0;
  reg             up_rx_wr_l = 1'b0;
  reg     [31:0]  up_rx_wdata_l = 32'd0;
  reg             up_tx_pend = 1'b0;
  reg     [15:0]  up_tx_addr_l = 16'd0;
  reg             up_tx_wr_l = 1'b0;
  reg     [31:0]  up_tx_wdata_l = 32'd0;
  reg             up_owner = 1'b0;
  reg             up_last = 1'b1;
  reg     [15:0]  up_addr = 16'd0;
  reg             up_wr = 1'b0;
  reg     [31:0]  up_wdata = 32'd0;
  reg             up_awvalid = 1'b0;
  reg             up_wvalid = 1'b0;
  reg             up_arvalid = 1'b0;
  reg     [31:0]  up_rdata = 32'd0;
  reg             up_slverr = 1'b0;
  reg             up_rx_ready_int = 1'b0;
  reg             up_tx_ready_int = 1'b0;
  reg             up_cm_ready_int = 1'b0;

  wire            up_rx_grant;
  wire    [15:0]  up_next_addr;
  wire            up_next_wr;
  wire            up_next_bad;
  wire            gt_lcplllock;
  wire    [ 1:0]  up_lcplllock_s;

  assign up_rx_grant = up_rx_pend & (~up_tx_pend | up_last);
  assign up_next_addr = up_rx_grant ? up_rx_addr_l : up_tx_addr_l;
  assign up_next_wr = up_rx_grant ? up_rx_wr_l : up_tx_wr_l;

  // AM002: APB3 addresses 0x00-0x0C must not be accessed; 0x5FFD-0x5FFF
  // belong to the wizard's memcell arbiter.
  assign up_next_bad = (up_next_addr <= 16'h000c) ||
                       ((up_next_addr >= 16'h5ffd) && (up_next_addr <= 16'h5fff));

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_state <= S_IDLE;
      up_rx_pend <= 1'b0;
      up_rx_addr_l <= 16'd0;
      up_rx_wr_l <= 1'b0;
      up_rx_wdata_l <= 32'd0;
      up_tx_pend <= 1'b0;
      up_tx_addr_l <= 16'd0;
      up_tx_wr_l <= 1'b0;
      up_tx_wdata_l <= 32'd0;
      up_addr <= 16'd0;
      up_wr <= 1'b0;
      up_wdata <= 32'd0;
      up_owner <= 1'b0;
      up_last <= 1'b1;
      up_awvalid <= 1'b0;
      up_wvalid <= 1'b0;
      up_arvalid <= 1'b0;
      up_rdata <= 32'd0;
      up_slverr <= 1'b0;
      up_rx_ready_int <= 1'b0;
      up_tx_ready_int <= 1'b0;
    end else begin
      up_rx_ready_int <= 1'b0;
      up_tx_ready_int <= 1'b0;
      if (up_rx_qm_enb == 1'b1) begin
        up_rx_pend <= 1'b1;
        up_rx_addr_l <= up_rx_qm_addr;
        up_rx_wr_l <= up_rx_qm_wr;
        up_rx_wdata_l <= up_rx_qm_wdata;
      end
      if (up_tx_qm_enb == 1'b1) begin
        up_tx_pend <= 1'b1;
        up_tx_addr_l <= up_tx_qm_addr;
        up_tx_wr_l <= up_tx_qm_wr;
        up_tx_wdata_l <= up_tx_qm_wdata;
      end
      case (up_state)
        S_IDLE: begin
          if (up_rx_pend == 1'b1 || up_tx_pend == 1'b1) begin
            up_owner <= ~up_rx_grant;
            up_last <= ~up_rx_grant;
            if (up_rx_grant == 1'b1) begin
              up_rx_pend <= 1'b0;
            end else begin
              up_tx_pend <= 1'b0;
            end
            if (up_next_bad == 1'b1) begin
              up_rdata <= 32'd0;
              up_slverr <= 1'b1;
              up_rx_ready_int <= up_rx_grant;
              up_tx_ready_int <= ~up_rx_grant;
            end else begin
              up_addr <= up_next_addr;
              up_wr <= up_next_wr;
              up_wdata <= up_rx_grant ? up_rx_wdata_l : up_tx_wdata_l;
              up_awvalid <= up_next_wr;
              up_wvalid <= up_next_wr;
              up_arvalid <= ~up_next_wr;
              up_state <= S_ADDR;
            end
          end
        end
        S_ADDR: begin
          if (m_axi_awready == 1'b1) begin
            up_awvalid <= 1'b0;
          end
          if (m_axi_wready == 1'b1) begin
            up_wvalid <= 1'b0;
          end
          if (m_axi_arready == 1'b1) begin
            up_arvalid <= 1'b0;
          end
          if ((up_awvalid == 1'b0 || m_axi_awready == 1'b1) &&
              (up_wvalid == 1'b0 || m_axi_wready == 1'b1) &&
              (up_arvalid == 1'b0 || m_axi_arready == 1'b1)) begin
            up_state <= S_RESP;
          end
        end
        S_RESP: begin
          if ((up_wr == 1'b1 && m_axi_bvalid == 1'b1) ||
              (up_wr == 1'b0 && m_axi_rvalid == 1'b1)) begin
            up_rdata <= up_wr ? 32'd0 : m_axi_rdata;
            up_slverr <= up_wr ? m_axi_bresp[1] : m_axi_rresp[1];
            up_rx_ready_int <= ~up_owner;
            up_tx_ready_int <= up_owner;
            up_state <= S_IDLE;
          end
        end
        default: begin
          up_state <= S_IDLE;
        end
      endcase
    end
  end

  assign up_rx_qm_rdata = up_rdata;
  assign up_rx_qm_ready = up_rx_ready_int;
  assign up_rx_qm_slverr = up_slverr;
  assign up_rx_qm_powergood = up_powergood;
  assign up_tx_qm_rdata = up_rdata;
  assign up_tx_qm_ready = up_tx_ready_int;
  assign up_tx_qm_slverr = up_slverr;
  assign up_tx_qm_powergood = up_powergood;

  assign m_axi_awvalid = up_awvalid;
  assign m_axi_awaddr = {up_addr, 2'b00};
  assign m_axi_wvalid = up_wvalid;
  assign m_axi_wdata = up_wdata;
  assign m_axi_bready = (up_state == S_RESP) & up_wr;
  assign m_axi_arvalid = up_arvalid;
  assign m_axi_araddr = {up_addr, 2'b00};
  assign m_axi_rready = (up_state == S_RESP) & ~up_wr;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_cm_ready_int <= 1'b0;
    end else begin
      up_cm_ready_int <= up_cm_enb;
    end
  end

  assign up_cm_rdata = 16'd0;
  assign up_cm_ready = up_cm_ready_int;

  // HSCLK1 (channels 2-3) is only enabled in quads with more than two lanes;
  // otherwise its LCPLL never locks and must be ignored.
  assign gt_lcplllock = gt_lcplllock0 & (gt_lcplllock1 | (HSCLK1_USED == 0));
  // AM002: the ILO must be (re)initialized after its PLL locks.
  assign gt_iloreset = {4{~gt_lcplllock}};

  sync_bits #(
    .NUM_OF_BITS (2)
  ) i_sync_lcplllock (
    .in_bits ({gt_lcplllock1, gt_lcplllock0}),
    .out_resetn (up_rstn),
    .out_clk (up_clk),
    .out_bits (up_lcplllock_s));

  assign up_lcplllock = up_lcplllock_s[0] & (up_lcplllock_s[1] | (HSCLK1_USED == 0));

endmodule
