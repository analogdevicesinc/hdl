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

module axi_hdmi_tx_vdma (

  // hdmi interface

  hdmi_fs_toggle,
  hdmi_raddr_g,

  // vdma interface

  vdma_clk,
  vdma_rst,
  vdma_fs,
  vdma_fs_ret,
  vdma_valid,
  vdma_data,
  vdma_ready,
  vdma_wr,
  vdma_waddr,
  vdma_wdata,
  vdma_fs_ret_toggle,
  vdma_fs_waddr,
  vdma_tpm_oos,
  vdma_ovf,
  vdma_unf);

  // parameters

  localparam      BUF_THRESHOLD_LO = 9'd3;
  localparam      BUF_THRESHOLD_HI = 9'd509;
  localparam      RDY_THRESHOLD_LO = 9'd450;
  localparam      RDY_THRESHOLD_HI = 9'd500;

  // hdmi interface

  input           hdmi_fs_toggle;
  input   [ 8:0]  hdmi_raddr_g;

  // vdma interface

  input           vdma_clk;
  input           vdma_rst;
  output          vdma_fs;
  input           vdma_fs_ret;
  input           vdma_valid;
  input   [63:0]  vdma_data;
  output          vdma_ready;
  output          vdma_wr;
  output  [ 8:0]  vdma_waddr;
  output  [47:0]  vdma_wdata;
  output          vdma_fs_ret_toggle;
  output  [ 8:0]  vdma_fs_waddr;
  output          vdma_tpm_oos;
  output          vdma_ovf;
  output          vdma_unf;

  // internal registers

  reg             vdma_fs_toggle_m1 = 'd0;
  reg             vdma_fs_toggle_m2 = 'd0;
  reg             vdma_fs_toggle_m3 = 'd0;
  reg             vdma_fs = 'd0;
  reg     [ 8:0]  vdma_fs_waddr = 'd0;
  reg             vdma_fs_ret_toggle = 'd0;
  reg             vdma_wr = 'd0;
  reg     [ 8:0]  vdma_waddr = 'd0;
  reg     [47:0]  vdma_wdata = 'd0;
  reg     [22:0]  vdma_tpm_data = 'd0;
  reg             vdma_tpm_oos = 'd0;
  reg     [ 8:0]  vdma_raddr_g_m1 = 'd0;
  reg     [ 8:0]  vdma_raddr_g_m2 = 'd0;
  reg     [ 8:0]  vdma_raddr = 'd0;
  reg     [ 8:0]  vdma_addr_diff = 'd0;
  reg             vdma_ready = 'd0;
  reg             vdma_almost_full = 'd0;
  reg             vdma_almost_empty = 'd0;
  reg             vdma_ovf = 'd0;
  reg             vdma_unf = 'd0;

  // internal wires

  wire    [47:0]  vdma_tpm_data_s;
  wire            vdma_tpm_oos_s;
  wire    [ 9:0]  vdma_addr_diff_s;
  wire            vdma_ovf_s;
  wire            vdma_unf_s;

  // grey to binary conversion

  function [8:0] g2b;
    input [8:0] g;
    reg   [8:0] b;
    begin
      b[8] = g[8];
      b[7] = b[8] ^ g[7];
      b[6] = b[7] ^ g[6];
      b[5] = b[6] ^ g[5];
      b[4] = b[5] ^ g[4];
      b[3] = b[4] ^ g[3];
      b[2] = b[3] ^ g[2];
      b[1] = b[2] ^ g[1];
      b[0] = b[1] ^ g[0];
      g2b = b;
    end
  endfunction

  // get fs from hdmi side, return fs and sof write address back

  always @(posedge vdma_clk) begin
    if (vdma_rst == 1'b1) begin
      vdma_fs_toggle_m1 <= 'd0;
      vdma_fs_toggle_m2 <= 'd0;
      vdma_fs_toggle_m3 <= 'd0;
    end else begin
      vdma_fs_toggle_m1 <= hdmi_fs_toggle;
      vdma_fs_toggle_m2 <= vdma_fs_toggle_m1;
      vdma_fs_toggle_m3 <= vdma_fs_toggle_m2;
    end
    vdma_fs <= vdma_fs_toggle_m2 ^ vdma_fs_toggle_m3;
    if (vdma_fs_ret == 1'b1) begin
      vdma_fs_waddr <= vdma_waddr;
      vdma_fs_ret_toggle <= ~vdma_fs_ret_toggle;
    end
  end

  // vdma write

  always @(posedge vdma_clk) begin
    vdma_wr <= vdma_valid & vdma_ready;
    if (vdma_rst == 1'b1) begin
      vdma_waddr <= 9'd0;
    end else if (vdma_wr == 1'b1) begin
      vdma_waddr <= vdma_waddr + 1'b1;
    end
    vdma_wdata <= {vdma_data[55:32], vdma_data[23:0]};
  end

  // test error conditions

  assign vdma_tpm_data_s = {vdma_tpm_data, 1'b1, vdma_tpm_data, 1'b0};
  assign vdma_tpm_oos_s = (vdma_wdata == vdma_tpm_data_s) ? 1'b0 : vdma_wr;

  always @(posedge vdma_clk) begin
    if ((vdma_rst == 1'b1) || (vdma_fs_ret == 1'b1)) begin
      vdma_tpm_data <= 23'd0;
      vdma_tpm_oos <= 1'd0;
    end else if (vdma_wr == 1'b1) begin
      vdma_tpm_data <= vdma_tpm_data + 1'b1;
      vdma_tpm_oos <= vdma_tpm_oos_s;
    end
  end

  // overflow or underflow status

  assign vdma_addr_diff_s = {1'b1, vdma_waddr} - vdma_raddr;
  assign vdma_ovf_s = (vdma_addr_diff < BUF_THRESHOLD_LO) ? vdma_almost_full : 1'b0;
  assign vdma_unf_s = (vdma_addr_diff > BUF_THRESHOLD_HI) ? vdma_almost_empty : 1'b0;

  always @(posedge vdma_clk) begin
    if (vdma_rst == 1'b1) begin
      vdma_raddr_g_m1 <= 9'd0;
      vdma_raddr_g_m2 <= 9'd0;
    end else begin
      vdma_raddr_g_m1 <= hdmi_raddr_g;
      vdma_raddr_g_m2 <= vdma_raddr_g_m1;
    end
    vdma_raddr <= g2b(vdma_raddr_g_m2);
    vdma_addr_diff <= vdma_addr_diff_s[8:0];
    if (vdma_addr_diff >= RDY_THRESHOLD_HI) begin
      vdma_ready <= 1'b0;
    end else if (vdma_addr_diff <= RDY_THRESHOLD_LO) begin
      vdma_ready <= 1'b1;
    end
    if (vdma_addr_diff > BUF_THRESHOLD_HI) begin
      vdma_almost_full <= 1'b1;
    end else begin
      vdma_almost_full <= 1'b0;
    end
    if (vdma_addr_diff < BUF_THRESHOLD_LO) begin
      vdma_almost_empty <= 1'b1;
    end else begin
      vdma_almost_empty <= 1'b0;
    end
    vdma_ovf <= vdma_ovf_s;
    vdma_unf <= vdma_unf_s;
  end

endmodule

// ***************************************************************************
// ***************************************************************************
