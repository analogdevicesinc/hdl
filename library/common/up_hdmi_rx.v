// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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

module up_hdmi_rx #(

  parameter   ID = 0
) (

  // hdmi interface

  input                   hdmi_clk,
  output                  hdmi_rst,
  output                  hdmi_edge_sel,
  output                  hdmi_bgr,
  output                  hdmi_packed,
  output                  hdmi_csc_bypass,
  output      [15:0]      hdmi_vs_count,
  output      [15:0]      hdmi_hs_count,
  input                   hdmi_dma_ovf,
  input                   hdmi_dma_unf,
  input                   hdmi_tpm_oos,
  input                   hdmi_vs_oos,
  input                   hdmi_hs_oos,
  input                   hdmi_vs_mismatch,
  input                   hdmi_hs_mismatch,
  input       [15:0]      hdmi_vs,
  input       [15:0]      hdmi_hs,
  input       [31:0]      hdmi_clk_ratio,

  // bus interface

  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input       [13:0]      up_waddr,
  input       [31:0]      up_wdata,
  output  reg             up_wack,
  input                   up_rreq,
  input       [13:0]      up_raddr,
  output  reg [31:0]      up_rdata,
  output  reg             up_rack
);

  localparam [31:0] CORE_VERSION = {16'h0004,     /* MAJOR */
                                     8'h00,       /* MINOR */
                                     8'h63};      /* PATCH */

  // internal registers

  reg             up_core_preset = 'd0;
  reg             up_resetn = 'd0;
  reg     [31:0]  up_scratch = 'd0;
  reg             up_edge_sel = 'd0;
  reg             up_bgr = 'd0;
  reg             up_packed = 'd0;
  reg             up_csc_bypass = 'd0;
  reg             up_dma_ovf = 'd0;
  reg             up_dma_unf = 'd0;
  reg             up_tpm_oos = 'd0;
  reg             up_vs_oos = 'd0;
  reg             up_hs_oos = 'd0;
  reg             up_vs_mismatch = 'd0;
  reg             up_hs_mismatch = 'd0;
  reg     [15:0]  up_vs_count = 'd0;
  reg     [15:0]  up_hs_count = 'd0;

  // internal signals

  wire            up_wreq_s;
  wire            up_rreq_s;
  wire            up_dma_ovf_s;
  wire            up_dma_unf_s;
  wire            up_vs_oos_s;
  wire            up_hs_oos_s;
  wire            up_vs_mismatch_s;
  wire            up_hs_mismatch_s;
  wire    [15:0]  up_vs_s;
  wire    [15:0]  up_hs_s;
  wire    [31:0]  up_clk_count_s;

  // decode block select

  assign up_wreq_s = (up_waddr[13:12] == 2'd0) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:12] == 2'd0) ? up_rreq : 1'b0;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_core_preset <= 1'd1;
      up_resetn <= 'd0;
      up_wack <= 'd0;
      up_scratch <= 'd0;
      up_edge_sel <= 'd0;
      up_bgr <= 'd0;
      up_packed <= 'd0;
      up_csc_bypass <= 'd0;
      up_dma_ovf <= 'd0;
      up_dma_unf <= 'd0;
      up_tpm_oos <= 'd0;
      up_vs_oos <= 'd0;
      up_hs_oos <= 'd0;
      up_vs_mismatch <= 'd0;
      up_hs_mismatch <= 'd0;
      up_vs_count <= 'd0;
      up_hs_count <= 'd0;
    end else begin
      up_wack <= up_wreq_s;
      up_core_preset <= ~up_resetn;
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h002)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h010)) begin
        up_resetn <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h011)) begin
        up_edge_sel <= up_wdata[3];
        up_bgr <= up_wdata[2];
        up_packed <= up_wdata[1];
        up_csc_bypass <= up_wdata[0];
      end
      if (up_dma_ovf_s == 1'b1) begin
        up_dma_ovf <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h018)) begin
        up_dma_ovf <= up_dma_ovf & ~up_wdata[1];
      end
      if (up_dma_unf_s == 1'b1) begin
        up_dma_unf <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h018)) begin
        up_dma_unf <= up_dma_unf & ~up_wdata[0];
      end
      if (up_tpm_oos_s == 1'b1) begin
        up_tpm_oos <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h019)) begin
        up_tpm_oos <= up_tpm_oos & ~up_wdata[1];
      end
      if (up_vs_oos_s == 1'b1) begin
        up_vs_oos <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h020)) begin
        up_vs_oos <= up_vs_oos & ~up_wdata[3];
      end
      if (up_hs_oos_s == 1'b1) begin
        up_hs_oos <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h020)) begin
        up_hs_oos <= up_hs_oos & ~up_wdata[2];
      end
      if (up_vs_mismatch_s == 1'b1) begin
        up_vs_mismatch <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h020)) begin
        up_vs_mismatch <= up_vs_mismatch & ~up_wdata[1];
      end
      if (up_hs_mismatch_s == 1'b1) begin
        up_hs_mismatch <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h020)) begin
        up_hs_mismatch <= up_hs_mismatch & ~up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h100)) begin
        up_vs_count <= up_wdata[31:16];
        up_hs_count <= up_wdata[15:0];
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq_s;
      if(up_rreq_s == 1'b1) begin
        case (up_raddr[11:0])
          12'h000: up_rdata <= CORE_VERSION;
          12'h001: up_rdata <= ID;
          12'h002: up_rdata <= up_scratch;
          12'h010: up_rdata <= {31'h0, up_resetn};
          12'h011: up_rdata <= {28'h0, up_edge_sel, up_bgr, up_packed, up_csc_bypass};
          12'h015: up_rdata <= up_clk_count_s;
          12'h016: up_rdata <= hdmi_clk_ratio;
          12'h018: up_rdata <= {30'h0, up_dma_ovf, up_dma_unf};
          12'h019: up_rdata <= {30'h0, up_tpm_oos, 1'b0};
          12'h020: up_rdata <= {28'h0, up_vs_oos, up_hs_oos,
                                up_vs_mismatch, up_hs_mismatch};
          12'h100: up_rdata <= {up_vs_count, up_hs_count};
          12'h101: up_rdata <= {up_vs_s, up_hs_s};
          default: up_rdata <= 0;
        endcase
      end
    end
  end

  // resets

  ad_rst i_hdmi_rst_reg (
    .rst_async (up_core_preset),
    .clk (hdmi_clk),
    .rstn (),
    .rst (hdmi_rst));

  // hdmi control & status

  up_xfer_cntrl #(
    .DATA_WIDTH(36)
  ) i_hdmi_xfer_cntrl (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({ up_edge_sel,
                      up_bgr,
                      up_packed,
                      up_csc_bypass,
                      up_vs_count,
                      up_hs_count}),
    .up_xfer_done (),
    .d_rst (hdmi_rst),
    .d_clk (hdmi_clk),
    .d_data_cntrl ({  hdmi_edge_sel,
                      hdmi_bgr,
                      hdmi_packed,
                      hdmi_csc_bypass,
                      hdmi_vs_count,
                      hdmi_hs_count}));

  up_xfer_status #(
    .DATA_WIDTH(39)
  ) i_hdmi_xfer_status (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_status ({  up_dma_ovf_s,
                        up_dma_unf_s,
                        up_tpm_oos_s,
                        up_vs_oos_s,
                        up_hs_oos_s,
                        up_vs_mismatch_s,
                        up_hs_mismatch_s,
                        up_vs_s,
                        up_hs_s}),
    .d_rst (hdmi_rst),
    .d_clk (hdmi_clk),
    .d_data_status ({   hdmi_dma_ovf,
                        hdmi_dma_unf,
                        hdmi_tpm_oos,
                        hdmi_vs_oos,
                        hdmi_hs_oos,
                        hdmi_vs_mismatch,
                        hdmi_hs_mismatch,
                        hdmi_vs,
                        hdmi_hs}));

  up_clock_mon i_hdmi_clock_mon (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_d_count (up_clk_count_s),
    .d_rst (hdmi_rst),
    .d_clk (hdmi_clk));

endmodule
