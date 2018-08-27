// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
// Transmit HDMI, video dma data in, hdmi separate syncs data out.

`timescale 1ns/100ps

module axi_hdmi_tx_core #(

  parameter   CR_CB_N = 0,
  parameter   EMBEDDED_SYNC = 0) (

  // hdmi interface

  input                   hdmi_clk,
  input                   hdmi_rst,

  // 16-bit interface

  output  reg             hdmi_16_hsync,
  output  reg             hdmi_16_vsync,
  output  reg             hdmi_16_data_e,
  output  reg [15:0]      hdmi_16_data,
  output  reg [15:0]      hdmi_16_es_data,

  // 24-bit interface

  output  reg             hdmi_24_hsync,
  output  reg             hdmi_24_vsync,
  output  reg             hdmi_24_data_e,
  output  reg [23:0]      hdmi_24_data,

  // 36-bit interface

  output  reg             hdmi_36_hsync,
  output  reg             hdmi_36_vsync,
  output  reg             hdmi_36_data_e,
  output  reg [35:0]      hdmi_36_data,

  // control signals

  output  reg             hdmi_fs_toggle,
  output  reg [ 8:0]      hdmi_raddr_g,
  output  reg             hdmi_tpm_oos,
  output  reg             hdmi_status,

  // vdma interface

  input                   vdma_clk,
  input                   vdma_wr,
  input       [ 8:0]      vdma_waddr,
  input       [47:0]      vdma_wdata,
  input                   vdma_fs_ret_toggle,
  input       [ 8:0]      vdma_fs_waddr,

  // processor interface

  input                   hdmi_csc_bypass,
  input                   hdmi_ss_bypass,
  input       [ 1:0]      hdmi_srcsel,
  input       [23:0]      hdmi_const_rgb,
  input       [15:0]      hdmi_hl_active,
  input       [15:0]      hdmi_hl_width,
  input       [15:0]      hdmi_hs_width,
  input       [15:0]      hdmi_he_max,
  input       [15:0]      hdmi_he_min,
  input       [15:0]      hdmi_vf_active,
  input       [15:0]      hdmi_vf_width,
  input       [15:0]      hdmi_vs_width,
  input       [15:0]      hdmi_ve_max,
  input       [15:0]      hdmi_ve_min,
  input       [23:0]      hdmi_clip_max,
  input       [23:0]      hdmi_clip_min);


  // internal registers

  reg             hdmi_enable = 'd0;
  reg     [15:0]  hdmi_hs_count = 'd0;
  reg     [15:0]  hdmi_vs_count = 'd0;
  reg             hdmi_fs = 'd0;
  reg             hdmi_fs_ret_toggle_m1 = 'd0;
  reg             hdmi_fs_ret_toggle_m2 = 'd0;
  reg             hdmi_fs_ret_toggle_m3 = 'd0;
  reg             hdmi_fs_ret = 'd0;
  reg     [ 8:0]  hdmi_fs_waddr = 'd0;
  reg             hdmi_hs = 'd0;
  reg             hdmi_vs = 'd0;
  reg             hdmi_hs_de = 'd0;
  reg             hdmi_vs_de = 'd0;
  reg     [ 9:0]  hdmi_raddr = 'd0;
  reg             hdmi_hs_d = 'd0;
  reg             hdmi_vs_d = 'd0;
  reg             hdmi_hs_de_d = 'd0;
  reg             hdmi_vs_de_d = 'd0;
  reg             hdmi_de_d = 'd0;
  reg             hdmi_data_sel_d = 'd0;
  reg             hdmi_hs_2d = 'd0;
  reg             hdmi_vs_2d = 'd0;
  reg             hdmi_hs_de_2d = 'd0;
  reg             hdmi_vs_de_2d = 'd0;
  reg             hdmi_de_2d = 'd0;
  reg             hdmi_data_sel_2d = 'd0;
  reg     [47:0]  hdmi_data_2d = 'd0;
  reg     [23:0]  hdmi_tpm_data = 'd0;
  reg             hdmi_hsync = 'd0;
  reg             hdmi_vsync = 'd0;
  reg             hdmi_hsync_data_e = 'd0;
  reg             hdmi_vsync_data_e = 'd0;
  reg             hdmi_data_e = 'd0;
  reg     [23:0]  hdmi_data = 'd0;
  reg             hdmi_24_csc_hsync = 'd0;
  reg             hdmi_24_csc_vsync = 'd0;
  reg             hdmi_24_csc_hsync_data_e = 'd0;
  reg             hdmi_24_csc_vsync_data_e = 'd0;
  reg             hdmi_24_csc_data_e = 'd0;
  reg     [23:0]  hdmi_24_csc_data = 'd0;
  reg             hdmi_16_hsync_d = 'd0;
  reg             hdmi_16_vsync_d = 'd0;
  reg             hdmi_16_hsync_data_e_d = 'd0;
  reg             hdmi_16_vsync_data_e_d = 'd0;
  reg             hdmi_16_data_e_d = 'd0;
  reg     [15:0]  hdmi_16_data_d = 'd0;
  reg             hdmi_es_hs_de = 'd0;
  reg             hdmi_es_vs_de = 'd0;
  reg     [15:0]  hdmi_es_data = 'd0;
  reg     [23:0]  hdmi_clip_data = 'd0;
  reg             hdmi_clip_hs_de_d = 'd0;
  reg             hdmi_clip_vs_de_d = 'd0;
  reg             hdmi_clip_hs_d = 'd0;
  reg             hdmi_clip_vs_d = 'd0;
  reg             hdmi_clip_de_d = 'd0;

  // internal wires

  wire    [15:0]  hdmi_hl_width_s;
  wire    [15:0]  hdmi_vf_width_s;
  wire    [15:0]  hdmi_he_width_s;
  wire    [15:0]  hdmi_ve_width_s;
  wire            hdmi_fs_ret_s;
  wire            hdmi_de_s;
  wire    [47:0]  hdmi_rdata_s;
  wire    [23:0]  hdmi_data_2d_s;
  wire            hdmi_tpm_mismatch_s;
  wire    [23:0]  hdmi_tpg_data_s;
  wire            hdmi_csc_hsync_s;
  wire            hdmi_csc_vsync_s;
  wire            hdmi_csc_hsync_data_e_s;
  wire            hdmi_csc_vsync_data_e_s;
  wire            hdmi_csc_data_e_s;
  wire    [23:0]  hdmi_csc_data_s;
  wire            hdmi_ss_hsync_s;
  wire            hdmi_ss_vsync_s;
  wire            hdmi_ss_hsync_data_e_s;
  wire            hdmi_ss_vsync_data_e_s;
  wire            hdmi_ss_data_e_s;
  wire    [15:0]  hdmi_ss_data_s;
  wire    [15:0]  hdmi_es_data_s;

  // binary to grey conversion

  function [8:0] b2g;
    input [8:0] b;
    reg   [8:0] g;
    begin
      g[8] = b[8];
      g[7] = b[8] ^ b[7];
      g[6] = b[7] ^ b[6];
      g[5] = b[6] ^ b[5];
      g[4] = b[5] ^ b[4];
      g[3] = b[4] ^ b[3];
      g[2] = b[3] ^ b[2];
      g[1] = b[2] ^ b[1];
      g[0] = b[1] ^ b[0];
      b2g = g;
    end
  endfunction

  // status and enable

  always @(posedge hdmi_clk) begin
    if (hdmi_rst == 1'b1) begin
      hdmi_status <= 1'b0;
      hdmi_enable <= 1'b0;
    end else begin
      hdmi_status <= 1'b1;
      hdmi_enable <= hdmi_srcsel[1] | hdmi_srcsel[0];
    end
  end

  // calculate useful limits

  assign hdmi_hl_width_s = hdmi_hl_width - 1'b1;
  assign hdmi_vf_width_s = hdmi_vf_width - 1'b1;
  assign hdmi_he_width_s = hdmi_hl_width - (hdmi_hl_active + 1'b1);
  assign hdmi_ve_width_s = hdmi_vf_width - (hdmi_vf_active + 1'b1);

  // hdmi counters

  always @(posedge hdmi_clk) begin
    if (hdmi_hs_count >= hdmi_hl_width_s) begin
      hdmi_hs_count <= 0;
    end else begin
      hdmi_hs_count <= hdmi_hs_count + 1'b1;
    end
    if (hdmi_hs_count >= hdmi_hl_width_s) begin
      if (hdmi_vs_count >= hdmi_vf_width_s) begin
        hdmi_vs_count <= 0;
      end else begin
        hdmi_vs_count <= hdmi_vs_count + 1'b1;
      end
    end
  end

  // hdmi start of frame

  always @(posedge hdmi_clk) begin
    if (hdmi_rst == 1'b1) begin
      hdmi_fs_toggle <= 1'b0;
      hdmi_fs <= 1'b0;
    end else begin
      if (EMBEDDED_SYNC == 1) begin
        if ((hdmi_hs_count == 1) && (hdmi_vs_count == hdmi_ve_width_s)) begin
          hdmi_fs <= hdmi_enable;
        end else begin
          hdmi_fs <= 1'b0;
        end
      end else begin
        if ((hdmi_hs_count == 1) && (hdmi_vs_count == hdmi_vs_width)) begin
          hdmi_fs <= hdmi_enable;
        end else begin
          hdmi_fs <= 1'b0;
        end
      end
      if (hdmi_fs == 1'b1) begin
        hdmi_fs_toggle <= ~hdmi_fs_toggle;
      end
    end
  end

  // hdmi sof write address

  assign hdmi_fs_ret_s = hdmi_fs_ret_toggle_m2 ^ hdmi_fs_ret_toggle_m3;

  always @(posedge hdmi_clk or posedge hdmi_rst) begin
    if (hdmi_rst == 1'b1) begin
      hdmi_fs_ret_toggle_m1 <= 1'd0;
      hdmi_fs_ret_toggle_m2 <= 1'd0;
      hdmi_fs_ret_toggle_m3 <= 1'd0;
    end else begin
      hdmi_fs_ret_toggle_m1 <= vdma_fs_ret_toggle;
      hdmi_fs_ret_toggle_m2 <= hdmi_fs_ret_toggle_m1;
      hdmi_fs_ret_toggle_m3 <= hdmi_fs_ret_toggle_m2;
    end
  end

  always @(posedge hdmi_clk) begin
      hdmi_fs_ret <= hdmi_fs_ret_s;
      hdmi_fs_waddr <= vdma_fs_waddr;
  end

  // hdmi sync signals

  always @(posedge hdmi_clk) begin
    if (EMBEDDED_SYNC == 1) begin
      hdmi_hs <= 1'b0;
      hdmi_vs <= 1'b0;
      if (hdmi_hs_count <= hdmi_he_width_s) begin
        hdmi_hs_de <= 1'b0;
      end else begin
        hdmi_hs_de <= hdmi_enable;
      end
      if (hdmi_vs_count <= hdmi_ve_width_s) begin
        hdmi_vs_de <= 1'b0;
      end else begin
        hdmi_vs_de <= hdmi_enable;
      end
    end else begin
      if (hdmi_hs_count < hdmi_hs_width) begin
        hdmi_hs <= hdmi_enable;
      end else begin
        hdmi_hs <= 1'b0;
      end
      if (hdmi_vs_count < hdmi_vs_width) begin
        hdmi_vs <= hdmi_enable;
      end else begin
        hdmi_vs <= 1'b0;
      end
      if ((hdmi_hs_count < hdmi_he_min) || (hdmi_hs_count >= hdmi_he_max)) begin
        hdmi_hs_de <= 1'b0;
      end else begin
        hdmi_hs_de <= hdmi_enable;
      end
      if ((hdmi_vs_count < hdmi_ve_min) || (hdmi_vs_count >= hdmi_ve_max)) begin
        hdmi_vs_de <= 1'b0;
      end else begin
        hdmi_vs_de <= hdmi_enable;
      end
    end
  end

  // hdmi read data

  assign hdmi_de_s = hdmi_hs_de & hdmi_vs_de;

  always @(posedge hdmi_clk) begin
    if (hdmi_rst == 1'b1) begin
      hdmi_raddr <= 10'd0;
    end else if (hdmi_fs == 1'b1) begin
      hdmi_raddr <= {hdmi_fs_waddr, 1'b0};
    end else if (hdmi_de_s == 1'b1) begin
      hdmi_raddr <= hdmi_raddr + 1'b1;
    end
    hdmi_raddr_g <= b2g(hdmi_raddr[9:1]);
  end

  // control and data pipe line

  always @(posedge hdmi_clk) begin
    hdmi_hs_d <= hdmi_hs;
    hdmi_vs_d <= hdmi_vs;
    hdmi_hs_de_d <= hdmi_hs_de;
    hdmi_vs_de_d <= hdmi_vs_de;
    hdmi_de_d <= hdmi_de_s;
    hdmi_data_sel_d <= hdmi_raddr[0];
    hdmi_hs_2d <= hdmi_hs_d;
    hdmi_vs_2d <= hdmi_vs_d;
    hdmi_hs_de_2d <= hdmi_hs_de_d;
    hdmi_vs_de_2d <= hdmi_vs_de_d;
    hdmi_de_2d <= hdmi_de_d;
    hdmi_data_sel_2d <= hdmi_data_sel_d;
    hdmi_data_2d <= hdmi_rdata_s;
  end

  // hdmi data count (may be used to monitor or insert)

  assign hdmi_data_2d_s = (hdmi_data_sel_2d == 1'b1) ? hdmi_data_2d[47:24] : hdmi_data_2d[23:0];
  assign hdmi_tpm_mismatch_s = (hdmi_data_2d_s == hdmi_tpm_data) ? 1'b0 : hdmi_de_2d;
  assign hdmi_tpg_data_s = hdmi_tpm_data;

  always @(posedge hdmi_clk) begin
    if ((hdmi_rst == 1'b1) || (hdmi_fs_ret == 1'b1)) begin
      hdmi_tpm_data <= 'd0;
    end else if (hdmi_de_2d == 1'b1) begin
      hdmi_tpm_data <= hdmi_tpm_data + 1'b1;
    end
    hdmi_tpm_oos <= hdmi_tpm_mismatch_s;
  end

  // hdmi data select

  always @(posedge hdmi_clk) begin
    hdmi_hsync <= hdmi_hs_2d;
    hdmi_vsync <= hdmi_vs_2d;
    hdmi_hsync_data_e <= hdmi_hs_de_2d;
    hdmi_vsync_data_e <= hdmi_vs_de_2d;
    hdmi_data_e <= hdmi_de_2d;
    case (hdmi_srcsel)
      2'b11: hdmi_data <= hdmi_const_rgb;
      2'b10: hdmi_data <= hdmi_tpg_data_s;
      2'b01: hdmi_data <= hdmi_data_2d_s;
      default: hdmi_data <= 24'd0;
    endcase
  end

  // Color space conversion bypass (RGB/YCbCr)

  always @(posedge hdmi_clk) begin
    if (hdmi_csc_bypass == 1'b1) begin
      hdmi_24_csc_hsync <= hdmi_hsync;
      hdmi_24_csc_vsync <= hdmi_vsync;
      hdmi_24_csc_hsync_data_e <= hdmi_hsync_data_e;
      hdmi_24_csc_vsync_data_e <= hdmi_vsync_data_e;
      hdmi_24_csc_data_e <= hdmi_data_e;
      hdmi_24_csc_data <= hdmi_data;
    end else begin
      hdmi_24_csc_hsync <= hdmi_csc_hsync_s;
      hdmi_24_csc_vsync <= hdmi_csc_vsync_s;
      hdmi_24_csc_hsync_data_e <= hdmi_csc_hsync_data_e_s;
      hdmi_24_csc_vsync_data_e <= hdmi_csc_vsync_data_e_s;
      hdmi_24_csc_data_e <= hdmi_csc_data_e_s;
      hdmi_24_csc_data <= hdmi_csc_data_s;
    end
  end

  // hdmi clipping

  always @(posedge hdmi_clk) begin
    hdmi_clip_hs_d <= hdmi_24_csc_hsync;
    hdmi_clip_vs_d <= hdmi_24_csc_vsync;
    hdmi_clip_hs_de_d <= hdmi_24_csc_hsync_data_e;
    hdmi_clip_vs_de_d <= hdmi_24_csc_vsync_data_e;
    hdmi_clip_de_d <= hdmi_24_csc_data_e;

    // Cr (red-diff) / red

    if (hdmi_24_csc_data[23:16] > hdmi_clip_max[23:16]) begin
      hdmi_clip_data[23:16] <= hdmi_clip_max[23:16];
    end else if (hdmi_24_csc_data[23:16] < hdmi_clip_min[23:16]) begin
      hdmi_clip_data[23:16] <= hdmi_clip_min[23:16];
    end else begin
      hdmi_clip_data[23:16] <= hdmi_24_csc_data[23:16];
    end

    // Y (luma) / green

    if (hdmi_24_csc_data[15:8] > hdmi_clip_max[15:8]) begin
      hdmi_clip_data[15:8] <= hdmi_clip_max[15:8];
    end else if (hdmi_24_csc_data[15:8] < hdmi_clip_min[15:8]) begin
      hdmi_clip_data[15:8] <= hdmi_clip_min[15:8];
    end else begin
      hdmi_clip_data[15:8] <= hdmi_24_csc_data[15:8];
    end

    // Cb (blue-diff) / blue

    if (hdmi_24_csc_data[7:0] > hdmi_clip_max[7:0]) begin
      hdmi_clip_data[7:0] <= hdmi_clip_max[7:0];
    end else if (hdmi_24_csc_data[7:0] < hdmi_clip_min[7:0]) begin
      hdmi_clip_data[7:0] <= hdmi_clip_min[7:0];
    end else begin
      hdmi_clip_data[7:0] <= hdmi_24_csc_data[7:0];
    end
  end

  // hdmi csc 16, 24 and 36 outputs

  always @(posedge hdmi_clk) begin

    hdmi_36_hsync <= hdmi_clip_hs_d;
    hdmi_36_vsync <= hdmi_clip_vs_d;
    hdmi_36_data_e <= hdmi_clip_de_d;
    hdmi_36_data[35:24] <= {hdmi_clip_data[23:16], hdmi_clip_data[23:20]};
    hdmi_36_data[23:12] <= {hdmi_clip_data[15: 8], hdmi_clip_data[15:12]};
    hdmi_36_data[11: 0] <= {hdmi_clip_data[ 7: 0], hdmi_clip_data[ 7: 4]};

    hdmi_24_hsync <= hdmi_clip_hs_d;
    hdmi_24_vsync <= hdmi_clip_vs_d;
    hdmi_24_data_e <= hdmi_clip_de_d;
    hdmi_24_data <= hdmi_clip_data;

    hdmi_16_hsync <= hdmi_16_hsync_d;
    hdmi_16_vsync <= hdmi_16_vsync_d;
    hdmi_16_data_e <= hdmi_16_data_e_d;
    hdmi_16_data <= hdmi_16_data_d;
    hdmi_16_es_data <= hdmi_es_data_s;

    if (hdmi_ss_bypass == 1'b1) begin
      hdmi_16_hsync_d <= hdmi_clip_hs_d;
      hdmi_16_vsync_d <= hdmi_clip_vs_d;
      hdmi_16_hsync_data_e_d <= hdmi_clip_hs_de_d;
      hdmi_16_vsync_data_e_d <= hdmi_clip_vs_de_d;
      hdmi_16_data_e_d <= hdmi_clip_de_d;
      hdmi_16_data_d <= hdmi_clip_data[15:0]; // Ignore the upper 8 bit
    end else begin
      hdmi_16_hsync_d <= hdmi_ss_hsync_s;
      hdmi_16_vsync_d <= hdmi_ss_vsync_s;
      hdmi_16_hsync_data_e_d <= hdmi_ss_hsync_data_e_s;
      hdmi_16_vsync_data_e_d <= hdmi_ss_vsync_data_e_s;
      hdmi_16_data_e_d <= hdmi_ss_data_e_s;
      hdmi_16_data_d <= hdmi_ss_data_s;
    end
  end

  // hdmi embedded sync

  always @(posedge hdmi_clk) begin
    hdmi_es_hs_de <= hdmi_16_hsync_data_e_d;
    hdmi_es_vs_de <= hdmi_16_vsync_data_e_d;
    if (hdmi_16_data_e_d == 1'b0) begin
      hdmi_es_data[15:8] <= 8'h80;
    end else begin
      hdmi_es_data[15:8] <= hdmi_16_data_d[15:8];
    end
    if (hdmi_16_data_e_d == 1'b0) begin
      hdmi_es_data[7:0] <= 8'h80;
    end else begin
      hdmi_es_data[7:0] <= hdmi_16_data_d[7:0];
    end
  end

  // data memory

  ad_mem #(.DATA_WIDTH(48), .ADDRESS_WIDTH(9)) i_mem (
    .clka (vdma_clk),
    .wea (vdma_wr),
    .addra (vdma_waddr),
    .dina (vdma_wdata),
    .clkb (hdmi_clk),
    .reb (1'b1),
    .addrb (hdmi_raddr[9:1]),
    .doutb (hdmi_rdata_s));

  // color space coversion, RGB to CrYCb

  ad_csc_RGB2CrYCb #(.DELAY_DATA_WIDTH(5)) i_csc_RGB2CrYCb (
    .clk (hdmi_clk),
    .RGB_sync ({hdmi_hsync,
      hdmi_vsync,
      hdmi_hsync_data_e,
      hdmi_vsync_data_e,
      hdmi_data_e}),
    .RGB_data (hdmi_data),
    .CrYCb_sync ({hdmi_csc_hsync_s,
      hdmi_csc_vsync_s,
      hdmi_csc_hsync_data_e_s,
      hdmi_csc_vsync_data_e_s,
      hdmi_csc_data_e_s}),
    .CrYCb_data (hdmi_csc_data_s));

  // sub sampling, 444 to 422

  ad_ss_444to422 #(.DELAY_DATA_WIDTH(5), .CR_CB_N(CR_CB_N)) i_ss_444to422 (
    .clk (hdmi_clk),
    .s444_de (hdmi_clip_de_d),
    .s444_sync ({hdmi_clip_hs_d,
      hdmi_clip_vs_d,
      hdmi_clip_hs_de_d,
      hdmi_clip_vs_de_d,
      hdmi_clip_de_d}),
    .s444_data (hdmi_clip_data),
    .s422_sync ({hdmi_ss_hsync_s,
      hdmi_ss_vsync_s,
      hdmi_ss_hsync_data_e_s,
      hdmi_ss_vsync_data_e_s,
      hdmi_ss_data_e_s}),
    .s422_data (hdmi_ss_data_s));

  // embedded sync

  axi_hdmi_tx_es #(.DATA_WIDTH(16)) i_es (
    .hdmi_clk (hdmi_clk),
    .hdmi_hs_de (hdmi_es_hs_de),
    .hdmi_vs_de (hdmi_es_vs_de),
    .hdmi_data_de (hdmi_es_data),
    .hdmi_data (hdmi_es_data_s));

endmodule

// ***************************************************************************
// ***************************************************************************
