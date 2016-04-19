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
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module up_hdmi_tx (

  // hdmi interface

  hdmi_clk,
  hdmi_rst,
  hdmi_full_range,
  hdmi_csc_bypass,
  hdmi_ss_bypass,
  hdmi_srcsel,
  hdmi_const_rgb,
  hdmi_hl_active,
  hdmi_hl_width,
  hdmi_hs_width,
  hdmi_he_max,
  hdmi_he_min,
  hdmi_vf_active,
  hdmi_vf_width,
  hdmi_vs_width,
  hdmi_ve_max,
  hdmi_ve_min,
  hdmi_clip_max,
  hdmi_clip_min,
  hdmi_status,
  hdmi_tpm_oos,
  hdmi_clk_ratio,

  // vdma interface

  vdma_clk,
  vdma_rst,
  vdma_ovf,
  vdma_unf,
  vdma_tpm_oos,

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

  localparam  PCORE_VERSION = 32'h00040063;
  parameter   ID = 0;

  // hdmi interface

  input           hdmi_clk;
  output          hdmi_rst;
  output          hdmi_full_range;
  output          hdmi_csc_bypass;
  output          hdmi_ss_bypass;
  output  [ 1:0]  hdmi_srcsel;
  output  [23:0]  hdmi_const_rgb;
  output  [15:0]  hdmi_hl_active;
  output  [15:0]  hdmi_hl_width;
  output  [15:0]  hdmi_hs_width;
  output  [15:0]  hdmi_he_max;
  output  [15:0]  hdmi_he_min;
  output  [15:0]  hdmi_vf_active;
  output  [15:0]  hdmi_vf_width;
  output  [15:0]  hdmi_vs_width;
  output  [15:0]  hdmi_ve_max;
  output  [15:0]  hdmi_ve_min;
  output  [23:0]  hdmi_clip_max;
  output  [23:0]  hdmi_clip_min;
  input           hdmi_status;
  input           hdmi_tpm_oos;
  input   [31:0]  hdmi_clk_ratio;

  // vdma interface

  input           vdma_clk;
  output          vdma_rst;
  input           vdma_ovf;
  input           vdma_unf;
  input           vdma_tpm_oos;

  // bus interface

  input           up_rstn;
  input           up_clk;
  input           up_wreq;
  input   [13:0]  up_waddr;
  input   [31:0]  up_wdata;
  output          up_wack;
  input           up_rreq;
  input   [13:0]  up_raddr;
  output  [31:0]  up_rdata;
  output          up_rack;

  // internal registers

  reg             up_core_preset = 'd0;
  reg             up_wack = 'd0;
  reg     [31:0]  up_scratch = 'd0;
  reg             up_resetn = 'd0;
  reg             up_full_range = 'd0;
  reg             up_csc_bypass = 'd0;
  reg             up_ss_bypass = 'd0;
  reg     [ 1:0]  up_srcsel = 'd1;
  reg     [23:0]  up_const_rgb = 'd0;
  reg             up_vdma_ovf = 'd0;
  reg             up_vdma_unf = 'd0;
  reg             up_hdmi_tpm_oos = 'd0;
  reg             up_vdma_tpm_oos = 'd0;
  reg     [15:0]  up_hl_active = 'd0;
  reg     [15:0]  up_hl_width = 'd0;
  reg     [15:0]  up_hs_width = 'd0;
  reg     [15:0]  up_he_max = 'd0;
  reg     [15:0]  up_he_min = 'd0;
  reg     [15:0]  up_vf_active = 'd0;
  reg     [15:0]  up_vf_width = 'd0;
  reg     [15:0]  up_vs_width = 'd0;
  reg     [15:0]  up_ve_max = 'd0;
  reg     [15:0]  up_ve_min = 'd0;
  reg     [23:0]  up_clip_max = 'd0;
  reg     [23:0]  up_clip_min = 'd0;
  reg             up_rack = 'd0;
  reg     [31:0]  up_rdata = 'd0;

  // internal signals

  wire            up_wreq_s;
  wire            up_rreq_s;
  wire            up_hdmi_status_s;
  wire            up_hdmi_tpm_oos_s;
  wire    [31:0]  up_hdmi_clk_count_s;
  wire            up_vdma_ovf_s;
  wire            up_vdma_unf_s;
  wire            up_vdma_tpm_oos_s;

  // decode block select

  assign up_wreq_s = (up_waddr[13:12] == 2'd0) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:12] == 2'd0) ? up_rreq : 1'b0;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_core_preset <= 1'd1;
      up_wack <= 'd0;
      up_scratch <= 'd0;
      up_resetn <= 'd0;
      up_full_range <= 'd0;
      up_csc_bypass <= 'd0;
      up_ss_bypass <= 'd0;
      up_srcsel <= 'd1;
      up_const_rgb <= 'd0;
      up_vdma_ovf <= 'd0;
      up_vdma_unf <= 'd0;
      up_hdmi_tpm_oos <= 'd0;
      up_vdma_tpm_oos <= 'd0;
      up_hl_active <= 'd0;
      up_hl_width <= 'd0;
      up_hs_width <= 'd0;
      up_he_max <= 'd0;
      up_he_min <= 'd0;
      up_vf_active <= 'd0;
      up_vf_width <= 'd0;
      up_vs_width <= 'd0;
      up_ve_max <= 'd0;
      up_ve_min <= 'd0;
      up_clip_max <= 24'hf0ebf0;
      up_clip_min <= 24'h101010;
    end else begin
      up_core_preset <= ~up_resetn;
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h002)) begin
        up_scratch <= up_wdata;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h010)) begin
        up_resetn <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h011)) begin
        up_ss_bypass <= up_wdata[2];
        up_full_range <= up_wdata[1];
        up_csc_bypass <= up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h012)) begin
        up_srcsel <= up_wdata[1:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h013)) begin
        up_const_rgb <= up_wdata[23:0];
      end
      if (up_vdma_ovf_s == 1'b1) begin
        up_vdma_ovf <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h018)) begin
        up_vdma_ovf <= up_vdma_ovf & ~up_wdata[1];
      end
      if (up_vdma_unf_s == 1'b1) begin
        up_vdma_unf <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h018)) begin
        up_vdma_unf <= up_vdma_unf & ~up_wdata[0];
      end
      if (up_hdmi_tpm_oos_s == 1'b1) begin
        up_hdmi_tpm_oos <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h019)) begin
        up_hdmi_tpm_oos <= up_hdmi_tpm_oos & ~up_wdata[1];
      end
      if (up_vdma_tpm_oos_s == 1'b1) begin
        up_vdma_tpm_oos <= 1'b1;
      end else if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h019)) begin
        up_vdma_tpm_oos <= up_vdma_tpm_oos & ~up_wdata[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h011)) begin
        if ((up_wdata[1]== 1'b1) || (up_wdata[0] == 1'b1)) begin
          up_clip_max <= 24'hfefefe;
          up_clip_min <= 24'h010101;
        end else begin
          up_clip_max <= 24'hf0ebf0;
          up_clip_min <= 24'h101010;
        end
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h01a)) begin
        up_clip_max <= up_wdata[23:0];
      end
	  if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h01b)) begin
        up_clip_min <= up_wdata[23:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h100)) begin
        up_hl_active <= up_wdata[31:16];
        up_hl_width <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h101)) begin
        up_hs_width <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h102)) begin
        up_he_max <= up_wdata[31:16];
        up_he_min <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h110)) begin
        up_vf_active <= up_wdata[31:16];
        up_vf_width <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h111)) begin
        up_vs_width <= up_wdata[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[11:0] == 12'h112)) begin
        up_ve_max <= up_wdata[31:16];
        up_ve_min <= up_wdata[15:0];
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr[11:0])
          12'h000: up_rdata <= PCORE_VERSION;
          12'h001: up_rdata <= ID;
          12'h002: up_rdata <= up_scratch;
          12'h010: up_rdata <= {31'd0, up_resetn};
          12'h011: up_rdata <= {29'd0, up_ss_bypass, up_full_range, up_csc_bypass};
          12'h012: up_rdata <= {30'd0, up_srcsel};
          12'h013: up_rdata <= {8'd0, up_const_rgb};
          12'h015: up_rdata <= up_hdmi_clk_count_s;
          12'h016: up_rdata <= hdmi_clk_ratio;
          12'h017: up_rdata <= {31'd0, up_hdmi_status_s};
          12'h018: up_rdata <= {30'd0, up_vdma_ovf, up_vdma_unf};
          12'h019: up_rdata <= {30'd0, up_hdmi_tpm_oos, up_vdma_tpm_oos};
          12'h01a: up_rdata <= {8'd0, up_clip_max};
          12'h01b: up_rdata <= {8'd0, up_clip_min};

          12'h100: up_rdata <= {up_hl_active, up_hl_width};
          12'h101: up_rdata <= {16'd0, up_hs_width};
          12'h102: up_rdata <= {up_he_max, up_he_min};
          12'h110: up_rdata <= {up_vf_active, up_vf_width};
          12'h111: up_rdata <= {16'd0, up_vs_width};
          12'h112: up_rdata <= {up_ve_max, up_ve_min};
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  // resets

  ad_rst i_core_rst_reg (.preset(up_core_preset), .clk(hdmi_clk),   .rst(hdmi_rst));
  ad_rst i_vdma_rst_reg (.preset(up_core_preset), .clk(vdma_clk),   .rst(vdma_rst));

  // hdmi control & status

  up_xfer_cntrl #(.DATA_WIDTH(237)) i_xfer_cntrl (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_cntrl ({ up_ss_bypass,
                      up_full_range,
                      up_csc_bypass,
                      up_srcsel,
                      up_const_rgb,
                      up_hl_active,
                      up_hl_width,
                      up_hs_width,
                      up_he_max,
                      up_he_min,
                      up_vf_active,
                      up_vf_width,
                      up_vs_width,
                      up_ve_max,
                      up_ve_min,
                      up_clip_max,
                      up_clip_min}),
    .up_xfer_done (),
    .d_rst (hdmi_rst),
    .d_clk (hdmi_clk),
    .d_data_cntrl ({  hdmi_ss_bypass,
                      hdmi_full_range,
                      hdmi_csc_bypass,
                      hdmi_srcsel,
                      hdmi_const_rgb,
                      hdmi_hl_active,
                      hdmi_hl_width,
                      hdmi_hs_width,
                      hdmi_he_max,
                      hdmi_he_min,
                      hdmi_vf_active,
                      hdmi_vf_width,
                      hdmi_vs_width,
                      hdmi_ve_max,
                      hdmi_ve_min,
                      hdmi_clip_max,
                      hdmi_clip_min}));

  up_xfer_status #(.DATA_WIDTH(2)) i_xfer_status (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_status ({up_hdmi_status_s,
                      up_hdmi_tpm_oos_s}),
    .d_rst (hdmi_rst),
    .d_clk (hdmi_clk),
    .d_data_status ({ hdmi_status,
                      hdmi_tpm_oos}));

  // hdmi clock monitor

  up_clock_mon i_clock_mon (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_d_count (up_hdmi_clk_count_s),
    .d_rst (hdmi_rst),
    .d_clk (hdmi_clk));

  // vdma control & status

  up_xfer_status #(.DATA_WIDTH(3)) i_vdma_xfer_status (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_status ({up_vdma_ovf_s,
                      up_vdma_unf_s,
                      up_vdma_tpm_oos_s}),
    .d_rst (vdma_rst),
    .d_clk (vdma_clk),
    .d_data_status ({ vdma_ovf, 
                      vdma_unf,
                      vdma_tpm_oos}));

endmodule

// ***************************************************************************
// ***************************************************************************
