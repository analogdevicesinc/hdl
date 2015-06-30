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
// ***************************************************************************
// ***************************************************************************
// Transmit HDMI, video dma data in, hdmi separate syncs data out.

module axi_hdmi_tx_core (

  // hdmi interface

  hdmi_clk,
  hdmi_rst,

  // 16-bit interface

  hdmi_16_hsync,
  hdmi_16_vsync,
  hdmi_16_data_e,
  hdmi_16_data,
  hdmi_16_es_data,

  // 24-bit interface

  hdmi_24_hsync,
  hdmi_24_vsync,
  hdmi_24_data_e,
  hdmi_24_data,

  // 36-bit interface

  hdmi_36_hsync,
  hdmi_36_vsync,
  hdmi_36_data_e,
  hdmi_36_data,

  // control signals

  hdmi_fs_toggle,
  hdmi_raddr_g,
  hdmi_tpm_oos,
  hdmi_status,

  // vdma interface

  vdma_clk,
  vdma_wr,
  vdma_waddr,
  vdma_wdata,
  vdma_fs_ret_toggle,
  vdma_fs_waddr,

  // processor interface

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
  hdmi_ve_min);

  // parameters

  parameter   Cr_Cb_N = 0;
  parameter   EMBEDDED_SYNC = 0;

  // hdmi interface

  input           hdmi_clk;
  input           hdmi_rst;

  // 16-bit interface

  output          hdmi_16_hsync;
  output          hdmi_16_vsync;
  output          hdmi_16_data_e;
  output  [15:0]  hdmi_16_data;
  output  [15:0]  hdmi_16_es_data;

  // 24-bit interface

  output          hdmi_24_hsync;
  output          hdmi_24_vsync;
  output          hdmi_24_data_e;
  output  [23:0]  hdmi_24_data;

  // 36-bit interface

  output          hdmi_36_hsync;
  output          hdmi_36_vsync;
  output          hdmi_36_data_e;
  output  [35:0]  hdmi_36_data;

  // control signals

  output          hdmi_fs_toggle;
  output  [ 8:0]  hdmi_raddr_g;
  output          hdmi_tpm_oos;
  output          hdmi_status;

  // vdma interface

  input           vdma_clk;
  input           vdma_wr;
  input   [ 8:0]  vdma_waddr;
  input   [47:0]  vdma_wdata;
  input           vdma_fs_ret_toggle;
  input   [ 8:0]  vdma_fs_waddr;

  // processor interface

  input           hdmi_full_range;
  input           hdmi_csc_bypass;
  input           hdmi_ss_bypass;
  input   [ 1:0]  hdmi_srcsel;
  input   [23:0]  hdmi_const_rgb;
  input   [15:0]  hdmi_hl_active;
  input   [15:0]  hdmi_hl_width;
  input   [15:0]  hdmi_hs_width;
  input   [15:0]  hdmi_he_max;
  input   [15:0]  hdmi_he_min;
  input   [15:0]  hdmi_vf_active;
  input   [15:0]  hdmi_vf_width;
  input   [15:0]  hdmi_vs_width;
  input   [15:0]  hdmi_ve_max;
  input   [15:0]  hdmi_ve_min;

  // internal registers

  reg             hdmi_status = 'd0;
  reg             hdmi_enable = 'd0;
  reg     [15:0]  hdmi_hs_count = 'd0;
  reg     [15:0]  hdmi_vs_count = 'd0;
  reg             hdmi_fs = 'd0;
  reg             hdmi_fs_toggle = 'd0;
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
  reg     [ 8:0]  hdmi_raddr_g = 'd0;
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
  reg             hdmi_tpm_oos = 'd0;
  reg             hdmi_hsync = 'd0;
  reg             hdmi_vsync = 'd0;
  reg             hdmi_hsync_data_e = 'd0;
  reg             hdmi_vsync_data_e = 'd0;
  reg             hdmi_data_e = 'd0;
  reg     [23:0]  hdmi_data = 'd0;
  reg             hdmi_24_hsync = 'd0;
  reg             hdmi_24_vsync = 'd0;
  reg             hdmi_24_hsync_data_e = 'd0;
  reg             hdmi_24_vsync_data_e = 'd0;
  reg             hdmi_24_data_e = 'd0;
  reg     [23:0]  hdmi_24_data = 'd0;
  reg             hdmi_16_hsync = 'd0;
  reg             hdmi_16_vsync = 'd0;
  reg             hdmi_16_hsync_data_e = 'd0;
  reg             hdmi_16_vsync_data_e = 'd0;
  reg             hdmi_16_data_e = 'd0;
  reg     [15:0]  hdmi_16_data = 'd0;
  reg             hdmi_es_hs_de = 'd0;
  reg             hdmi_es_vs_de = 'd0;
  reg     [15:0]  hdmi_es_data = 'd0;

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
  wire            hdmi_es_hs_de_s;
  wire            hdmi_es_vs_de_s;
  wire            hdmi_es_de_s;
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

  // hdmi sof write address

  assign hdmi_fs_ret_s = hdmi_fs_ret_toggle_m2 ^ hdmi_fs_ret_toggle_m3;

  always @(posedge hdmi_clk) begin
    if (hdmi_rst == 1'b1) begin
      hdmi_fs_ret_toggle_m1 <= 1'd0;
      hdmi_fs_ret_toggle_m2 <= 1'd0;
      hdmi_fs_ret_toggle_m3 <= 1'd0;
    end else begin
      hdmi_fs_ret_toggle_m1 <= vdma_fs_ret_toggle;
      hdmi_fs_ret_toggle_m2 <= hdmi_fs_ret_toggle_m1;
      hdmi_fs_ret_toggle_m3 <= hdmi_fs_ret_toggle_m2;
    end
    hdmi_fs_ret <= hdmi_fs_ret_s;
    if (hdmi_fs_ret_s == 1'b1) begin
      hdmi_fs_waddr <= vdma_fs_waddr;
    end
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
    end else if (hdmi_fs_ret == 1'b1) begin
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

  // hdmi csc 16, 24 and 36 outputs

  assign hdmi_36_hsync = hdmi_24_hsync;
  assign hdmi_36_vsync = hdmi_24_vsync;
  assign hdmi_36_data_e = hdmi_24_data_e;
  assign hdmi_36_data[35:24] = {hdmi_24_data[23:16], hdmi_24_data[23:20]};
  assign hdmi_36_data[23:12] = {hdmi_24_data[15: 8], hdmi_24_data[15:12]};
  assign hdmi_36_data[11: 0] = {hdmi_24_data[ 7: 0], hdmi_24_data[ 7: 4]};

  always @(posedge hdmi_clk) begin
    if (hdmi_csc_bypass == 1'b1) begin
      hdmi_24_hsync <= hdmi_hsync;
      hdmi_24_vsync <= hdmi_vsync;
      hdmi_24_hsync_data_e <= hdmi_hsync_data_e;
      hdmi_24_vsync_data_e <= hdmi_vsync_data_e;
      hdmi_24_data_e <= hdmi_data_e;
      hdmi_24_data <= hdmi_data;
    end else begin
      hdmi_24_hsync <= hdmi_csc_hsync_s;
      hdmi_24_vsync <= hdmi_csc_vsync_s;
      hdmi_24_hsync_data_e <= hdmi_csc_hsync_data_e_s;
      hdmi_24_vsync_data_e <= hdmi_csc_vsync_data_e_s;
      hdmi_24_data_e <= hdmi_csc_data_e_s;
      hdmi_24_data <= hdmi_csc_data_s;
    end
    if (hdmi_ss_bypass == 1'b1) begin
      hdmi_16_hsync <= hdmi_24_hsync;
      hdmi_16_vsync <= hdmi_24_vsync;
      hdmi_16_hsync_data_e <= hdmi_24_hsync_data_e;
      hdmi_16_vsync_data_e <= hdmi_24_vsync_data_e;
      hdmi_16_data_e <= hdmi_24_data_e;
      hdmi_16_data <= hdmi_24_data[15:0]; // Ignore the upper 8 bit
    end else begin
      hdmi_16_hsync <= hdmi_ss_hsync_s;
      hdmi_16_vsync <= hdmi_ss_vsync_s;
      hdmi_16_hsync_data_e <= hdmi_ss_hsync_data_e_s;
      hdmi_16_vsync_data_e <= hdmi_ss_vsync_data_e_s;
      hdmi_16_data_e <= hdmi_ss_data_e_s;
      hdmi_16_data <= hdmi_ss_data_s;
    end
  end

  // hdmi embedded sync clipping

  assign hdmi_es_hs_de_s = hdmi_16_hsync_data_e;
  assign hdmi_es_vs_de_s = hdmi_16_vsync_data_e;
  assign hdmi_es_de_s = hdmi_16_data_e;
  assign hdmi_es_data_s = hdmi_16_data;

  always @(posedge hdmi_clk) begin
    hdmi_es_hs_de <= hdmi_es_hs_de_s;
    hdmi_es_vs_de <= hdmi_es_vs_de_s;
    if (hdmi_es_de_s == 1'b0) begin
      hdmi_es_data[15:8] <= 8'h80;
    end else if ((hdmi_full_range == 1'b0) &&
      (hdmi_es_data_s[15:8] > 8'heb)) begin
      hdmi_es_data[15:8] <= 8'heb;
    end else if ((hdmi_full_range == 1'b0) &&
      (hdmi_es_data_s[15:8] < 8'h10)) begin
      hdmi_es_data[15:8] <= 8'h10;
    end else if (hdmi_es_data_s[15:8] > 8'hfe) begin
      hdmi_es_data[15:8] <= 8'hfe;
    end else if (hdmi_es_data_s[15:8] < 8'h01) begin
      hdmi_es_data[15:8] <= 8'h01;
    end else begin
      hdmi_es_data[15:8] <= hdmi_es_data_s[15:8];
    end
    if (hdmi_es_de_s == 1'b0) begin
      hdmi_es_data[7:0] <= 8'h80;
    end else if ((hdmi_full_range == 1'b0) &&
      (hdmi_es_data_s[7:0] > 8'heb)) begin
      hdmi_es_data[7:0] <= 8'heb;
    end else if ((hdmi_full_range == 1'b0) &&
      (hdmi_es_data_s[7:0] < 8'h10)) begin
      hdmi_es_data[7:0] <= 8'h10;
    end else if (hdmi_es_data_s[7:0] > 8'hfe) begin
      hdmi_es_data[7:0] <= 8'hfe;
    end else if (hdmi_es_data_s[7:0] < 8'h01) begin
      hdmi_es_data[7:0] <= 8'h01;
    end else begin
      hdmi_es_data[7:0] <= hdmi_es_data_s[7:0];
    end
  end

  // data memory

  ad_mem #(.DATA_WIDTH(48), .ADDR_WIDTH(9)) i_mem (
    .clka (vdma_clk),
    .wea (vdma_wr),
    .addra (vdma_waddr),
    .dina (vdma_wdata),
    .clkb (hdmi_clk),
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

  ad_ss_444to422 #(.DELAY_DATA_WIDTH(5), .Cr_Cb_N(Cr_Cb_N)) i_ss_444to422 (
    .clk (hdmi_clk),
    .s444_de (hdmi_24_data_e),
    .s444_sync ({hdmi_24_hsync,
      hdmi_24_vsync,
      hdmi_24_hsync_data_e,
      hdmi_24_vsync_data_e,
      hdmi_24_data_e}),
    .s444_data (hdmi_24_data),
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
    .hdmi_data (hdmi_16_es_data));

endmodule

// ***************************************************************************
// ***************************************************************************
