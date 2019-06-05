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
// this module is a helper core for linux. as much as possible, try not to use this core.
// best thing to do is look at no-os and implement a proper frame work in linux.
// most controls are scattered around other cores, here we collect them to provide a common access.

`timescale 1ns/100ps

module axi_fmcadc5_sync #(

  parameter integer ID = 0,
  parameter [ 7:0]  FPGA_TECHNOLOGY = 0,
  parameter [ 7:0]  FPGA_FAMILY = 0,
  parameter [ 7:0]  SPEED_GRADE = 0,
  parameter [ 7:0]  DEV_PACKAGE = 0,
  parameter         DELAY_REFCLK_FREQUENCY = 200) (

    // receive interface

  input             rx_clk,
  output            rx_sysref,
  input             rx_sync_0,
  input             rx_sync_1,
  output            rx_sysref_p,
  output            rx_sysref_n,
  output            rx_sync_0_p,
  output            rx_sync_0_n,
  output            rx_sync_1_p,
  output            rx_sync_1_n,
  input             rx_enable_0,
  input   [255:0]   rx_data_0,
  input             rx_enable_1,
  input   [255:0]   rx_data_1,
  output            rx_enable,
  output  [511:0]   rx_data,

  // calibration signal

  output            vcal,

  // switching regulator clocks

  output            psync,

  // delay interface

  input             delay_rst,
  input             delay_clk,

  // spi override

  input   [  7:0]   spi_csn_o,
  input             spi_clk_o,
  input             spi_sdo_o,

  output  [  7:0]   spi_csn,
  output            spi_clk,
  output            spi_mosi,
  input             spi_miso,

  // axi interface

  input             s_axi_aclk,
  input             s_axi_aresetn,
  input             s_axi_awvalid,
  input   [ 15:0]   s_axi_awaddr,
  output            s_axi_awready,
  input             s_axi_wvalid,
  input   [ 31:0]   s_axi_wdata,
  input   [  3:0]   s_axi_wstrb,
  output            s_axi_wready,
  output            s_axi_bvalid,
  output  [  1:0]   s_axi_bresp,
  input             s_axi_bready,
  input             s_axi_arvalid,
  input   [ 15:0]   s_axi_araddr,
  output            s_axi_arready,
  output            s_axi_rvalid,
  output  [ 31:0]   s_axi_rdata,
  output  [  1:0]   s_axi_rresp,
  input             s_axi_rready,
  input   [  2:0]   s_axi_awprot,
  input   [  2:0]   s_axi_arprot);

  // version

  localparam  [31:0]  PCORE_VERSION = 32'h00040063;

  // internal registers

  reg     [  7:0]   up_psync_count = 'd0;
  reg               up_psync = 'd0;
  reg               up_cal_done_t_m1 = 'd0;
  reg               up_cal_done_t_m2 = 'd0;
  reg               up_cal_done_t_m3 = 'd0;
  reg     [ 15:0]   up_cal_max_0 = 'd0;
  reg     [ 15:0]   up_cal_min_0 = 'd0;
  reg     [ 15:0]   up_cal_max_1 = 'd0;
  reg     [ 15:0]   up_cal_min_1 = 'd0;
  reg               up_cal_enable = 'd0;
  reg               up_cor_enable    = 'd0;
  reg               up_cor_enable_t = 'd0;
  reg     [ 15:0]   up_cor_scale_0 = 'd0;
  reg     [ 15:0]   up_cor_offset_0 = 'd0;
  reg     [ 15:0]   up_cor_scale_1 = 'd0;
  reg     [ 15:0]   up_cor_offset_1 = 'd0;
  reg     [  7:0]   up_vcal_8 = 'd0;
  reg               up_vcal = 'd0;
  reg     [  7:0]   up_vcal_cnt = 'd0;
  reg               up_vcal_enable = 'd0;
  reg               up_sysref_ack_t_m1 = 'd0;
  reg               up_sysref_ack_t_m2 = 'd0;
  reg               up_sysref_ack_t_m3 = 'd0;
  reg               up_sysref_control_t = 'd0;
  reg     [  1:0]   up_sysref_mode_e = 'd0;
  reg               up_sysref_mode_i = 'd0;
  reg               up_sysref_req_t = 'd0;
  reg               up_sysref_status = 'd0;
  reg               up_sync_control_t = 'd0;
  reg               up_sync_mode = 'd0;
  reg               up_sync_disable_1 = 'd0;
  reg               up_sync_disable_0 = 'd0;
  reg               up_sync_status_t_m1 = 'd0;
  reg               up_sync_status_t_m2 = 'd0;
  reg               up_sync_status_t_m3 = 'd0;
  reg               up_sync_status_1 = 'd0;
  reg               up_sync_status_0 = 'd0;
  reg               up_delay_ld = 'd0;
  reg     [  4:0]   up_delay_wdata = 'd0;
  reg     [  7:0]   up_spi_csn_int = 'd0;
  reg               up_spi_clk_int = 'd0;
  reg               up_spi_mosi_int = 'd0;
  reg               up_spi_gnt = 'd0;
  reg               up_spi_req = 'd0;
  reg     [  7:0]   up_spi_csn = 'd0;
  reg     [  5:0]   up_spi_cnt = 'd0;
  reg     [ 31:0]   up_spi_clk_32 = 'd0;
  reg     [ 31:0]   up_spi_out_32 = 'd0;
  reg     [ 31:0]   up_spi_in_32 = 'd0;
  reg     [  7:0]   up_spi_out = 'd0;
  reg     [ 31:0]   up_scratch = 'd0;
  reg     [ 31:0]   up_timer = 'd0;
  reg               up_wack = 'd0;
  reg               up_rack = 'd0;
  reg     [ 31:0]   up_rdata = 'd0;
  reg               rx_cal_enable_m1 = 'd0;
  reg               rx_cal_enable = 'd0;
  reg               rx_cor_enable_t_m1 = 'd0;
  reg               rx_cor_enable_t_m2 = 'd0;
  reg               rx_cor_enable_t_m3 = 'd0;
  reg               rx_cor_enable = 'd0;
  reg     [ 15:0]   rx_cor_scale_0 = 'd0;
  reg     [ 15:0]   rx_cor_offset_0 = 'd0;
  reg     [ 15:0]   rx_cor_scale_1 = 'd0;
  reg     [ 15:0]   rx_cor_offset_1 = 'd0;
  reg     [ 15:0]   rx_cor_scale_d_0 = 'd0;
  reg     [ 15:0]   rx_cor_offset_d_0 = 'd0;
  reg     [ 15:0]   rx_cor_scale_d_1 = 'd0;
  reg     [ 15:0]   rx_cor_offset_d_1 = 'd0;
  reg     [  7:0]   rx_sysref_cnt = 'd0;
  reg               rx_sysref_control_t_m1 = 'd0;
  reg               rx_sysref_control_t_m2 = 'd0;
  reg               rx_sysref_control_t_m3 = 'd0;
  reg     [  1:0]   rx_sysref_mode_e = 'd0;
  reg               rx_sysref_mode_i = 'd0;
  reg               rx_sysref_req_t_m1 = 'd0;
  reg               rx_sysref_req_t_m2 = 'd0;
  reg               rx_sysref_req_t_m3 = 'd0;
  reg               rx_sysref_req = 'd0;
  reg               rx_sysref_e = 'd0;
  reg               rx_sysref_i = 'd0;
  reg               rx_sysref_ack_t = 'd0;
  reg               rx_sysref_enb_e = 'd0;
  reg               rx_sysref_enb_i = 'd0;
  reg               rx_sync_control_t_m1 = 'd0;
  reg               rx_sync_control_t_m2 = 'd0;
  reg               rx_sync_control_t_m3 = 'd0;
  reg               rx_sync_mode = 'd0;
  reg               rx_sync_disable_1 = 'd0;
  reg               rx_sync_disable_0 = 'd0;
  reg               rx_sync_out_1 = 'd0;
  reg               rx_sync_out_0 = 'd0;
  reg     [  7:0]   rx_sync_cnt = 'd0;
  reg               rx_sync_hold_1 = 'd0;
  reg               rx_sync_hold_0 = 'd0;
  reg               rx_sync_status_t = 'd0;
  reg               rx_sync_status_1 = 'd0;
  reg               rx_sync_status_0 = 'd0;

  // internal signals

  wire              up_cal_done_t_s;
  wire              up_sysref_ack_t_s;
  wire              up_sync_status_t_s;
  wire              up_spi_gnt_s;
  wire    [ 31:0]   up_spi_out_32_s;
  wire    [  7:0]   up_spi_in_s;
  wire              rx_cor_enable_t_s;
  wire              rx_cal_done_t_s;
  wire    [ 15:0]   rx_cal_max_0_s;
  wire    [ 15:0]   rx_cal_min_0_s;
  wire    [ 15:0]   rx_cal_max_1_s;
  wire    [ 15:0]   rx_cal_min_1_s;
  wire              rx_sysref_control_t_s;
  wire              rx_sysref_req_t_s;
  wire              rx_sysref_enb_e_s;
  wire              rx_sync_control_t_s;
  wire    [  4:0]   up_delay_rdata_s;
  wire              up_delay_locked_s;
  wire              up_wreq_s;
  wire    [ 13:0]   up_waddr_s;
  wire    [ 31:0]   up_wdata_s;
  wire              up_rreq_s;
  wire    [ 13:0]   up_raddr_s;
  wire              up_rstn;
  wire              up_clk;

  // signal name changes

  assign up_rstn = s_axi_aresetn;
  assign up_clk = s_axi_aclk;

  // switching regulator clocks (~602K)

  assign psync = up_psync;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_psync_count <= 7'd0;
      up_psync <= 1'b0;
    end else begin
      if (up_psync_count >= 7'h52) begin
        up_psync_count <= 7'd0;
      end else begin
        up_psync_count <= up_psync_count + 1'b1;
      end
      if (up_psync_count >= 7'h4f) begin
        up_psync <= ~up_psync;
      end
    end
  end

  // calibration (offset & gain only)

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_cal_done_t_m1 <= 1'd0;
      up_cal_done_t_m2 <= 1'd0;
      up_cal_done_t_m3 <= 1'd0;
    end else begin
      up_cal_done_t_m1 <= rx_cal_done_t_s;
      up_cal_done_t_m2 <= up_cal_done_t_m1;
      up_cal_done_t_m3 <= up_cal_done_t_m2;
    end
  end

  assign up_cal_done_t_s = up_cal_done_t_m3 ^ up_cal_done_t_m2;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_cal_max_0 <= 16'd0;
      up_cal_min_0 <= 16'd0;
      up_cal_max_1 <= 16'd0;
      up_cal_min_1 <= 16'd0;
    end else begin
      if (up_cal_done_t_s == 1'b1) begin
        up_cal_max_0 <= rx_cal_max_0_s;
        up_cal_min_0 <= rx_cal_min_0_s;
        up_cal_max_1 <= rx_cal_max_1_s;
        up_cal_min_1 <= rx_cal_min_1_s;
      end
    end
  end

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_cal_enable <= 1'd0;
      up_cor_enable <= 1'd0;
      up_cor_enable_t <= 1'd0;
      up_cor_scale_0 <= 16'd0;
      up_cor_offset_0 <= 16'd0;
      up_cor_scale_1 <= 16'd0;
      up_cor_offset_1 <= 16'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h0060)) begin
        up_cal_enable <= up_wdata_s[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h0061)) begin
        up_cor_enable <= up_wdata_s[0];
        up_cor_enable_t <= ~up_cor_enable_t;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h0068)) begin
        up_cor_scale_0 <= up_wdata_s[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h0069)) begin
        up_cor_offset_0 <= up_wdata_s[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h006a)) begin
        up_cor_scale_1 <= up_wdata_s[15:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h006b)) begin
        up_cor_offset_1 <= up_wdata_s[15:0];
      end
    end
  end

  // calibration signal register(s)

  assign vcal = up_vcal;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_vcal_8 <= 8'd0;
      up_vcal <= 1'd0;
      up_vcal_cnt <= 8'd0;
      up_vcal_enable <= 1'd0;
    end else begin
      if (up_vcal_8 >= up_vcal_cnt) begin
        up_vcal_8 <= 8'd0;
        up_vcal <= ~up_vcal & up_vcal_enable;
      end else begin
        up_vcal_8 <= up_vcal_8 + 1'b1;
        up_vcal <= up_vcal;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h0050)) begin
        up_vcal_cnt <= up_wdata_s[7:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h0051)) begin
        up_vcal_enable <= up_wdata_s[0];
      end
    end
  end

  // sysref register(s)

  assign up_sysref_ack_t_s = up_sysref_ack_t_m3 ^ up_sysref_ack_t_m2;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 1'b0) begin
      up_sysref_ack_t_m1 <= 1'd0;
      up_sysref_ack_t_m2 <= 1'd0;
      up_sysref_ack_t_m3 <= 1'd0;
    end else begin
      up_sysref_ack_t_m1 <= rx_sysref_ack_t;
      up_sysref_ack_t_m2 <= up_sysref_ack_t_m1;
      up_sysref_ack_t_m3 <= up_sysref_ack_t_m2;
    end
  end

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_sysref_control_t <= 1'd0;
      up_sysref_mode_e <= 2'd0;
      up_sysref_mode_i <= 1'd0;
      up_sysref_req_t <= 1'd0;
      up_sysref_status <= 1'b0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h0040)) begin
        up_sysref_control_t <= ~up_sysref_control_t;
        up_sysref_mode_e <= up_wdata_s[5:4];
        up_sysref_mode_i <= up_wdata_s[0];
      end
      if (up_sysref_status == 1'b1) begin
        if (up_sysref_ack_t_s == 1'b1) begin
          up_sysref_req_t <= up_sysref_req_t;
          up_sysref_status <= 1'b0;
        end
      end else if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h0041)) begin
        if (up_wdata_s[0] == 1'b1) begin
          up_sysref_req_t <= ~up_sysref_req_t;
          up_sysref_status <= 1'b1;
        end
      end
    end
  end

  // sync register(s)

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_sync_control_t <= 1'd0;
      up_sync_mode <= 1'd0;
      up_sync_disable_1 <= 1'd0;
      up_sync_disable_0 <= 1'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h0030)) begin
        up_sync_control_t <= ~up_sync_control_t;
        up_sync_mode <= up_wdata_s[2];
        up_sync_disable_1 <= up_wdata_s[1];
        up_sync_disable_0 <= up_wdata_s[0];
      end
    end
  end

  // simple current status (no persistence)

  assign up_sync_status_t_s = up_sync_status_t_m3 ^ up_sync_status_t_m2;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_sync_status_t_m1 <= 1'd0;
      up_sync_status_t_m2 <= 1'd0;
      up_sync_status_t_m3 <= 1'd0;
      up_sync_status_1 <= 1'd0;
      up_sync_status_0 <= 1'd0;
    end else begin
      up_sync_status_t_m1 <= rx_sync_status_t;
      up_sync_status_t_m2 <= up_sync_status_t_m1;
      up_sync_status_t_m3 <= up_sync_status_t_m2;
      if (up_sync_status_t_s == 1'b1) begin
        up_sync_status_1 <= rx_sync_status_1;
        up_sync_status_0 <= rx_sync_status_0;
      end
    end
  end

  // delay register(s)

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_delay_ld <= 1'd0;
      up_delay_wdata <= 5'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h0020)) begin
        up_delay_ld <= 1'b1;
      end else begin
        up_delay_ld <= 1'b0;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h0020)) begin
        up_delay_wdata <= up_wdata_s[4:0];
      end
    end
  end

  // switching must be glitchless

  assign spi_csn = up_spi_csn_int;
  assign spi_clk = up_spi_clk_int;
  assign spi_mosi = up_spi_mosi_int;

  always @(negedge up_clk) begin
    if (up_spi_gnt == 1'b1) begin
      up_spi_csn_int <= up_spi_csn;
      up_spi_clk_int <= up_spi_clk_32[31];
      up_spi_mosi_int <= up_spi_out_32[31];
    end else begin
      up_spi_csn_int <= spi_csn_o;
      up_spi_clk_int <= spi_clk_o;
      up_spi_mosi_int <= spi_sdo_o;
    end
  end

  assign up_spi_gnt_s = (&spi_csn_o) & ~spi_clk_o;

  always @(posedge up_clk or negedge up_rstn) begin
    if (up_rstn == 1'b0) begin
      up_spi_gnt <= 1'd0;
    end else begin
      if (up_spi_gnt_s == 1'b1) begin
        up_spi_gnt <= up_spi_req;
      end
    end
  end

  // spi data stretching

  assign up_spi_out_32_s[31:28] = {4{up_wdata_s[7]}};
  assign up_spi_out_32_s[27:24] = {4{up_wdata_s[6]}};
  assign up_spi_out_32_s[23:20] = {4{up_wdata_s[5]}};
  assign up_spi_out_32_s[19:16] = {4{up_wdata_s[4]}};
  assign up_spi_out_32_s[15:12] = {4{up_wdata_s[3]}};
  assign up_spi_out_32_s[11: 8] = {4{up_wdata_s[2]}};
  assign up_spi_out_32_s[ 7: 4] = {4{up_wdata_s[1]}};
  assign up_spi_out_32_s[ 3: 0] = {4{up_wdata_s[0]}};

  assign up_spi_in_s[7] = up_spi_in_32[28];
  assign up_spi_in_s[6] = up_spi_in_32[24];
  assign up_spi_in_s[5] = up_spi_in_32[20];
  assign up_spi_in_s[4] = up_spi_in_32[16];
  assign up_spi_in_s[3] = up_spi_in_32[12];
  assign up_spi_in_s[2] = up_spi_in_32[ 8];
  assign up_spi_in_s[1] = up_spi_in_32[ 4];
  assign up_spi_in_s[0] = up_spi_in_32[ 0];

  // spi register(s)

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_spi_req <= 1'd0;
      up_spi_csn <= {8{1'b1}};
      up_spi_cnt <= 6'd0;
      up_spi_clk_32 <= 32'd0;
      up_spi_out_32 <= 32'd0;
      up_spi_in_32 <= 32'd0;
      up_spi_out <= 8'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h0010)) begin
        up_spi_req <= up_wdata_s[0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h0012)) begin
        up_spi_csn <= up_wdata_s[7:0];
      end
      if (up_spi_cnt[5] == 1'b1) begin
        up_spi_cnt <= up_spi_cnt + 1'b1;
        up_spi_clk_32 <= {up_spi_clk_32[30:0], 1'd0};
        up_spi_out_32 <= {up_spi_out_32[30:0], 1'd0};
        up_spi_in_32 <= {up_spi_in_32[30:0], spi_miso};
        up_spi_out <= up_spi_out;
      end else if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h0013)) begin
        up_spi_cnt <= 6'h20;
        up_spi_clk_32 <= {8{4'h6}};
        up_spi_out_32 <= up_spi_out_32_s;
        up_spi_in_32 <= {31'd0, spi_miso};
        up_spi_out <= up_wdata_s[7:0];
      end
    end
  end

  // scratch register(s)

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_scratch <= 'd0;
      up_timer <= 'd0;
    end else begin
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h0002)) begin
        up_scratch <= up_wdata_s;
      end
      if ((up_wreq_s == 1'b1) && (up_waddr_s == 14'h0003)) begin
        up_timer <= up_wdata_s;
      end else if (up_timer > 0) begin
        up_timer <= up_timer - 1'b1;
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_wack <= up_wreq_s;
      up_rack <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr_s)
          14'h0000: up_rdata <= PCORE_VERSION;
          14'h0001: up_rdata <= ID;
          14'h0002: up_rdata <= up_scratch;
          14'h0003: up_rdata <= up_timer;
	  14'h0007: up_rdata <= {FPGA_TECHNOLOGY,FPGA_FAMILY,SPEED_GRADE,DEV_PACKAGE}; // [8,8,8,8]
          14'h0010: up_rdata <= {31'd0, up_spi_req};
          14'h0011: up_rdata <= {31'd0, up_spi_gnt};
          14'h0012: up_rdata <= {24'd0, up_spi_csn};
          14'h0013: up_rdata <= {24'd0, up_spi_out};
          14'h0014: up_rdata <= {24'd0, up_spi_in_s};
          14'h0015: up_rdata <= {31'd0, up_spi_cnt[5]};
          14'h0020: up_rdata <= {27'd0, up_delay_wdata};
          14'h0021: up_rdata <= {27'd0, up_delay_rdata_s};
          14'h0022: up_rdata <= {31'd0, up_delay_locked_s};
          14'h0030: up_rdata <= {29'd0, up_sync_mode, up_sync_disable_1, up_sync_disable_0};
          14'h0031: up_rdata <= {30'd0, up_sync_status_1, up_sync_status_0};
          14'h0040: up_rdata <= {26'd0, up_sysref_mode_e, 3'b0, up_sysref_mode_i};
          14'h0041: up_rdata <= {31'd0, up_sysref_status};
          14'h0050: up_rdata <= {24'd0, up_vcal_cnt};
          14'h0051: up_rdata <= {31'd0, up_vcal_enable};
          14'h0060: up_rdata <= {30'd0, up_cal_enable};
          14'h0061: up_rdata <= {30'd0, up_cor_enable};
          14'h0064: up_rdata <= {16'd0, up_cal_max_0};
          14'h0065: up_rdata <= {16'd0, up_cal_min_0};
          14'h0066: up_rdata <= {16'd0, up_cal_max_1};
          14'h0067: up_rdata <= {16'd0, up_cal_min_1};
          14'h0068: up_rdata <= {16'd0, up_cor_scale_0};
          14'h0069: up_rdata <= {16'd0, up_cor_offset_0};
          14'h006a: up_rdata <= {16'd0, up_cor_scale_1};
          14'h006b: up_rdata <= {16'd0, up_cor_offset_1};
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  // calibration at receive clock

  always @(posedge rx_clk) begin
    rx_cal_enable_m1 <= up_cal_enable;
    rx_cal_enable <= rx_cal_enable_m1;
    rx_cor_enable_t_m1 <= up_cor_enable_t;
    rx_cor_enable_t_m2 <= rx_cor_enable_t_m1;
    rx_cor_enable_t_m3 <= rx_cor_enable_t_m2;
  end

  assign rx_cor_enable_t_s = rx_cor_enable_t_m3 ^ rx_cor_enable_t_m2;

  always @(posedge rx_clk) begin
    if (rx_cor_enable_t_s == 1'b1) begin
      rx_cor_enable <= up_cor_enable;
      rx_cor_scale_0 <= up_cor_scale_0;
      rx_cor_offset_0 <= up_cor_offset_0;
      rx_cor_scale_1 <= up_cor_scale_1;
      rx_cor_offset_1 <= up_cor_offset_1;
    end
  end

  always @(posedge rx_clk) begin
    if (rx_cor_enable == 1'b0) begin
      rx_cor_scale_d_0 <= 16'h8000;
      rx_cor_offset_d_0 <= 16'h0000;
      rx_cor_scale_d_1 <= 16'h8000;
      rx_cor_offset_d_1 <= 16'h0000;
    end else begin
      rx_cor_scale_d_0 <= rx_cor_scale_0;
      rx_cor_offset_d_0 <= rx_cor_offset_0;
      rx_cor_scale_d_1 <= rx_cor_scale_1;
      rx_cor_offset_d_1 <= rx_cor_offset_1;
    end
  end

  axi_fmcadc5_sync_calcor i_calcor (
    .rx_clk (rx_clk),
    .rx_enable_0 (rx_enable_0),
    .rx_data_0 (rx_data_0),
    .rx_enable_1 (rx_enable_1),
    .rx_data_1 (rx_data_1),
    .rx_enable (rx_enable),
    .rx_data (rx_data),
    .rx_cal_enable (rx_cal_enable),
    .rx_cal_done_t (rx_cal_done_t_s),
    .rx_cal_max_0 (rx_cal_max_0_s),
    .rx_cal_min_0 (rx_cal_min_0_s),
    .rx_cal_max_1 (rx_cal_max_1_s),
    .rx_cal_min_1 (rx_cal_min_1_s),
    .rx_cor_scale_0 (rx_cor_scale_d_0),
    .rx_cor_offset_0 (rx_cor_offset_d_0),
    .rx_cor_scale_1 (rx_cor_scale_d_1),
    .rx_cor_offset_1 (rx_cor_offset_d_1));

  // sysref-control at receive clock

  always @(posedge rx_clk) begin
    rx_sysref_cnt <= rx_sysref_cnt + 1'b1;
  end

  assign rx_sysref_control_t_s = rx_sysref_control_t_m3 ^ rx_sysref_control_t_m2;
  assign rx_sysref_req_t_s = rx_sysref_req_t_m3 ^ rx_sysref_req_t_m2;

  always @(posedge rx_clk) begin
    rx_sysref_control_t_m1 <= up_sysref_control_t;
    rx_sysref_control_t_m2 <= rx_sysref_control_t_m1;
    rx_sysref_control_t_m3 <= rx_sysref_control_t_m2;
    if (rx_sysref_control_t_s == 1'b1) begin
      rx_sysref_mode_e <= up_sysref_mode_e;
      rx_sysref_mode_i <= up_sysref_mode_i;
    end
    rx_sysref_req_t_m1 <= up_sysref_req_t;
    rx_sysref_req_t_m2 <= rx_sysref_req_t_m1;
    rx_sysref_req_t_m3 <= rx_sysref_req_t_m2;
    if ((rx_sysref_cnt == 8'd0) || (rx_sysref_req_t_s == 1'b1)) begin
      rx_sysref_req <= rx_sysref_req_t_s;
    end
  end

  assign rx_sysref_enb_e_s = (rx_sysref_mode_e == 2'b10) ? rx_sysref_req :
    ((rx_sysref_mode_e == 2'b00) ? 1'b1 : 1'b0);

  always @(posedge rx_clk) begin
    rx_sysref_e <= rx_sysref_cnt[7] & rx_sysref_enb_e;
    rx_sysref_i <= rx_sysref_cnt[7] & rx_sysref_enb_i;
    if (rx_sysref_cnt == 8'd0) begin
      if (rx_sysref_enb_e == 1'b1) begin
        rx_sysref_ack_t <= ~rx_sysref_ack_t;
      end
      rx_sysref_enb_e <= rx_sysref_enb_e_s;
      rx_sysref_enb_i <= ~rx_sysref_mode_i;
    end
  end

  // sync-control at receive clock

  assign rx_sync_control_t_s = rx_sync_control_t_m3 ^ rx_sync_control_t_m2;

  always @(posedge rx_clk) begin
    rx_sync_control_t_m1 <= up_sync_control_t;
    rx_sync_control_t_m2 <= rx_sync_control_t_m1;
    rx_sync_control_t_m3 <= rx_sync_control_t_m2;
    if (rx_sync_control_t_s == 1'b1) begin
      rx_sync_mode <= up_sync_mode;
      rx_sync_disable_1 <= up_sync_disable_1;
      rx_sync_disable_0 <= up_sync_disable_0;
    end
    if (rx_sync_mode == 1'b1) begin
      rx_sync_out_1 <= ~rx_sync_disable_1 & rx_sync_1 & rx_sync_0;
      rx_sync_out_0 <= ~rx_sync_disable_0 & rx_sync_1 & rx_sync_0;
    end else begin
      rx_sync_out_1 <= ~rx_sync_disable_1 & rx_sync_1;
      rx_sync_out_0 <= ~rx_sync_disable_0 & rx_sync_0;
    end
  end

  always @(posedge rx_clk) begin
    rx_sync_cnt <= rx_sync_cnt + 1'b1;
    if ((rx_sync_cnt == 8'd0) || (rx_sync_1 == 1'b0)) begin
      rx_sync_hold_1 <= rx_sync_1;
    end
    if ((rx_sync_cnt == 8'd0) || (rx_sync_0 == 1'b0)) begin
      rx_sync_hold_0 <= rx_sync_0;
    end
    if (rx_sync_cnt == 8'd0) begin
      rx_sync_status_t <= ~rx_sync_status_t;
      rx_sync_status_1 <= rx_sync_hold_1;
      rx_sync_status_0 <= rx_sync_hold_0;
    end
  end

  // sync buffers

  OBUFDS i_obufds_rx_sync_1 (
    .I (rx_sync_out_1),
    .O (rx_sync_1_p),
    .OB (rx_sync_1_n));

  OBUFDS i_obufds_rx_sync_0 (
    .I (rx_sync_out_0),
    .O (rx_sync_0_p),
    .OB (rx_sync_0_n));

  // sysref delay control

  assign rx_sysref = rx_sysref_i;

  ad_data_out #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .SINGLE_ENDED (0),
    .IODELAY_ENABLE (1),
    .IODELAY_CTRL (1),
    .IODELAY_GROUP ("FMCADC5_SYSREF_IODELAY_GROUP"),
    .REFCLK_FREQUENCY (DELAY_REFCLK_FREQUENCY))
  i_rx_sysref (
    .tx_clk (rx_clk),
    .tx_data_p (rx_sysref_e),
    .tx_data_n (rx_sysref_e),
    .tx_data_out_p (rx_sysref_p),
    .tx_data_out_n (rx_sysref_n),
    .up_clk (up_clk),
    .up_dld (up_delay_ld),
    .up_dwdata (up_delay_wdata),
    .up_drdata (up_delay_rdata_s),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (up_delay_locked_s));

  // up == micro("u") processor

  up_axi i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule

// ***************************************************************************
// ***************************************************************************
