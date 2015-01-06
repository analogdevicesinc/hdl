// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; Loos OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE PoosIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

module up_hdmi_rx (

  // hdmi interface

  hdmi_clk,
  hdmi_rst,

  hdmi_up_edge_sel,
  hdmi_up_hs_count,
  hdmi_up_vs_count,
  hdmi_up_csc_bypass,
  hdmi_up_tpg_enable,
  hdmi_up_packed,
  hdmi_up_bgr,

  hdmi_tpm_oos,
  hdmi_hs_mismatch,
  hdmi_hs,
  hdmi_vs_mismatch,
  hdmi_vs,
  hdmi_oos_hs,
  hdmi_oos_vs,

  // vdma interface

  video_overflow,

  // bus interface

  up_rstn,
  up_clk,
  up_wreq,
  up_waddr,
  up_wdata,
  up_wack,
  up_rreq,
  up_raddr,
  up_rdata,
  up_rack);

  // parameters

  localparam        PCORE_VERSION = 32'h00040063;
  parameter         PCORE_ID = 0;

  // hdmi interface

  input             hdmi_clk;
  output            hdmi_rst;

  output            hdmi_up_edge_sel;
  output   [15:0]   hdmi_up_hs_count;
  output   [15:0]   hdmi_up_vs_count;
  output            hdmi_up_csc_bypass;
  output            hdmi_up_tpg_enable;
  output            hdmi_up_packed;
  output            hdmi_up_bgr;

  input             hdmi_tpm_oos;

  // vdma interface

  input             video_overflow;
  input             hdmi_hs_mismatch;
  input   [15:0]    hdmi_hs;
  input             hdmi_vs_mismatch;
  input   [15:0]    hdmi_vs;
  input             hdmi_oos_hs;
  input             hdmi_oos_vs;

  // bus interface

  input             up_rstn;
  input             up_clk;
  input             up_wreq;
  input   [13:0]    up_waddr;
  input   [31:0]    up_wdata;
  output            up_wack;
  input             up_rreq;
  input   [13:0]    up_raddr;
  output  [31:0]    up_rdata;
  output            up_rack;

  // internal registers

  reg               up_wack = 'd0;
  reg               up_rack = 'd0;
  reg     [31:0]    up_rdata = 'd0;
  reg               up_packed = 'd0;
  reg     [31:0]    up_scratch = 'd0;
  reg               up_bgr = 'd0;
  reg               up_tpg_enable = 'd0;
  reg               up_csc_bypass = 'd0;
  reg               up_edge_sel = 'd0;
  reg               up_resetn = 'd0;
  reg     [15:0]    up_vs_count = 'd0;
  reg     [15:0]    up_hs_count = 'd0;
  reg     [ 3:0]    up_hdmi_status_hold = 'd0;
  reg               up_status = 'd0;
  reg               up_vdma_ovf_hold = 'd0;
  reg               up_hdmi_tpm_oos_hold = 'd0;

  // internal signals

  wire              up_wreq_s;
  wire              up_rreq_s;
  wire              up_preset_s;
  wire              up_hdmi_hs_mismatch;
  wire    [15:0]    up_hdmi_hs;
  wire              up_hdmi_vs_mismatch;
  wire    [15:0]    up_hdmi_vs;
  wire              up_hdmi_oos_hs;
  wire              up_hdmi_oos_vs;

  wire [3:0]        up_hdmi_status = {up_hdmi_oos_vs, up_hdmi_oos_hs, up_hdmi_vs_mismatch, up_hdmi_hs_mismatch};

  wire              up_vdma_ovf;

  // decode block select

  assign up_wreq_s    = (up_waddr[13:12] == 2'd0) ? up_wreq : 1'b0;
  assign up_rreq_s    = (up_raddr[13:12] == 2'd0) ? up_rreq : 1'b0;
  assign up_preset_s  = ~up_resetn;

  // processor write interface (see regmap.txt for details)

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack       <= 'd0;
      up_scratch    <= 'd0;
      up_packed     <= 'd0;
      up_bgr        <= 'd0;
      up_tpg_enable <= 'd0;
      up_csc_bypass <= 'd0;
      up_edge_sel   <= 'd0;
      up_resetn     <= 'd0;
      up_vs_count   <= 'd0;
      up_hs_count   <= 'd0;
      up_hdmi_status_hold <= 'd0;
      up_status     <= 'd0;
    end else begin
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h002)) begin
	up_scratch <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h010)) begin
        up_resetn <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h011)) begin
        up_edge_sel = up_wdata[3];
        up_bgr <= up_wdata[2];
        up_packed <= up_wdata[1];
        up_csc_bypass <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h012)) begin
        up_tpg_enable <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h100)) begin
        up_vs_count <= up_wdata[31:16];
        up_hs_count <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h018)) begin
        up_vdma_ovf_hold <= (up_vdma_ovf_hold & ~up_wdata[0]) | up_vdma_ovf;
      end else begin
        up_vdma_ovf_hold <= up_vdma_ovf_hold | up_vdma_ovf;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h019)) begin
        up_hdmi_tpm_oos_hold <= (up_hdmi_tpm_oos_hold & ~up_wdata[0]) | up_hdmi_tpm_oos;
      end else begin
        up_hdmi_tpm_oos_hold <= up_hdmi_tpm_oos_hold | up_hdmi_tpm_oos;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h020)) begin
        up_hdmi_status_hold <= (up_hdmi_status_hold & ~up_wdata[3:0]) | up_hdmi_status;
      end else begin
        up_hdmi_status_hold <= up_hdmi_status_hold | up_hdmi_status;
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
          12'h000: up_rdata <= PCORE_VERSION;
          12'h001: up_rdata <= PCORE_ID;
          12'h002: up_rdata <= up_scratch;
          12'h010: up_rdata <= {31'h0, up_resetn};
          12'h011: up_rdata <= {29'h0, up_bgr, up_packed, up_csc_bypass};
          12'h012: up_rdata <= {31'h0, up_tpg_enable};
          12'h018: up_rdata <= {30'h0, up_vdma_ovf_hold, 1'b0};
          12'h019: up_rdata <= {30'h0, up_hdmi_tpm_oos_hold, 1'b0};
          12'h020: up_rdata <= {28'h0, up_hdmi_status_hold};
          12'h100: up_rdata <= {up_vs_count, up_hs_count};
          12'h101: up_rdata <= {up_hdmi_vs, up_hdmi_hs};
          default: up_rdata <= 0;
        endcase
      end
    end
  end

  // resets
  ad_rst i_hdmi_rst_reg (
    .preset(up_preset_s),
    .clk(hdmi_clk),
    .rst(hdmi_rst));

  // hdmi control & status

  up_xfer_cntrl #(
    .DATA_WIDTH(37)
  ) i_hdmi_rx_xfer_cntrl (
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_data_cntrl({
        up_hs_count,
        up_vs_count,
        up_edge_sel,
        up_csc_bypass,
        up_tpg_enable,
        up_packed,
        up_bgr
    }),
    .up_xfer_done(),
    .d_rst(hdmi_rst),
    .d_clk(hdmi_clk),
    .d_data_cntrl({
        hdmi_up_hs_count,
        hdmi_up_vs_count,
        hdmi_up_edge_sel,
        hdmi_up_csc_bypass,
        hdmi_up_tpg_enable,
        hdmi_up_packed,
        hdmi_up_bgr})
  );

  // Synchronize the detected horizontal/vertical resolution to the AXI clock domain.
  // Synchronize status bits to the AXI clock domain

  up_xfer_status #(
    .DATA_WIDTH(36)
  ) i_hdmi_rx_xfer_status (
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_data_status({
        up_hdmi_hs_mismatch,
        up_hdmi_hs,
        up_hdmi_vs_mismatch,
        up_hdmi_vs,
        up_hdmi_oos_hs,
        up_hdmi_oos_vs}),
    .d_rst(hdmi_rst),
    .d_clk(hdmi_clk),
    .d_data_status({
        hdmi_hs_mismatch,
        hdmi_hs,
        hdmi_vs_mismatch,
        hdmi_vs,
        hdmi_oos_hs,
        hdmi_oos_vs}));

  up_xfer_status #(
    .DATA_WIDTH(1)
  ) i_hdmi_tpm_xfer_status (
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_data_status(up_hdmi_tpm_oos),
    .d_rst(hdmi_rst),
    .d_clk(hdmi_clk),
    .d_data_status(hdmi_tpm_oos));

  // vdma status

  up_xfer_status #(
    .DATA_WIDTH(1)
  ) i_vdma_xfer_status (
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_data_status(up_vdma_ovf),
    .d_rst(hdmi_rst),
    .d_clk(hdmi_clk),
    .d_data_status(video_overflow));

endmodule

