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

module axi_ad9671 #(

  parameter ID = 0,
  parameter   FPGA_TECHNOLOGY = 0,
  parameter   FPGA_FAMILY = 0,
  parameter   SPEED_GRADE = 0,
  parameter   DEV_PACKAGE = 0,
  parameter QUAD_OR_DUAL_N = 1
) (

  // jesd interface
  // rx_clk is (line-rate/40)

  input                   rx_clk,
  input       [ 3:0]      rx_sof,
  input                   rx_valid,
  input       [(64*QUAD_OR_DUAL_N)+63:0]  rx_data,
  output                  rx_ready,

  // dma interface

  output                  adc_clk,
  output      [ 7:0]      adc_valid,
  output      [ 7:0]      adc_enable,
  output      [127:0]     adc_data,
  input                   adc_dovf,
  input                   adc_sync_in,
  output                  adc_sync_out,
  input       [ 3:0]      adc_raddr_in,
  output      [ 3:0]      adc_raddr_out,

  // axi interface

  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [ 15:0]     s_axi_awaddr,
  input       [ 2:0]      s_axi_awprot,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input       [ 31:0]     s_axi_wdata,
  input       [ 3:0]      s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output      [ 1:0]      s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input       [ 15:0]     s_axi_araddr,
  input       [ 2:0]      s_axi_arprot,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [ 1:0]      s_axi_rresp,
  output      [ 31:0]     s_axi_rdata,
  input                   s_axi_rready
);

  // internal registers

  reg                                   up_status_pn_err = 'd0;
  reg                                   up_status_pn_oos = 'd0;
  reg                                   up_status_or = 'd0;
  reg     [ 31:0]                       up_rdata = 'd0;
  reg                                   up_rack = 'd0;
  reg                                   up_wack = 'd0;

  // internal clocks & resets

  wire                                  adc_rst;
  wire                                  up_rstn;
  wire                                  up_clk;

  // internal signals

  wire                                  adc_status_s;
  wire                                  adc_sync_status_s;
  wire                                  adc_valid_s;
  wire    [ 15:0]                       adc_data_s[7:0];
  wire    [  7:0]                       adc_or_s;
  wire    [  7:0]                       up_adc_pn_err_s;
  wire    [  7:0]                       up_adc_pn_oos_s;
  wire    [  7:0]                       up_adc_or_s;
  wire                                  up_wreq_s;
  wire    [ 13:0]                       up_waddr_s;
  wire    [ 31:0]                       up_wdata_s;
  wire                                  up_rreq_s;
  wire    [ 13:0]                       up_raddr_s;
  wire    [ 31:0]                       up_rdata_s[8:0];
  wire                                  up_rack_s[8:0];
  wire                                  up_wack_s[8:0];
  wire    [ 31:0]                       adc_start_code;
  wire                                  adc_sync;

  // signal name changes

  assign rx_ready = 1'b1;
  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_status_pn_err <= 'd0;
      up_status_pn_oos <= 'd0;
      up_status_or <= 'd0;
      up_rdata <= 'd0;
      up_rack <= 'd0;
      up_wack <= 'd0;
    end else begin
      up_status_pn_err <= | up_adc_pn_err_s;
      up_status_pn_oos <= | up_adc_pn_oos_s;
      up_status_or <= | up_adc_or_s;
      up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2] | up_rdata_s[3] |
        up_rdata_s[4] | up_rdata_s[5] | up_rdata_s[6] | up_rdata_s[7] | up_rdata_s[8];
      up_rack <=  up_rack_s[0] | up_rack_s[1] | up_rack_s[2] | up_rack_s[3] |
        up_rack_s[4] | up_rack_s[5] | up_rack_s[6] | up_rack_s[7] | up_rack_s[8];
      up_wack <=  up_wack_s[0] | up_wack_s[1] | up_wack_s[2] | up_wack_s[3] |
        up_wack_s[4] | up_wack_s[5] | up_wack_s[6] | up_wack_s[7] | up_wack_s[8];
    end
  end

  // main (device interface)

  axi_ad9671_if #(
    .QUAD_OR_DUAL_N (QUAD_OR_DUAL_N),
    .ID (ID)
  )  i_if (
    .rx_clk (rx_clk),
    .rx_data (rx_data),
    .rx_sof (rx_sof),
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid_s),
    .adc_data_a (adc_data_s[0]),
    .adc_or_a (adc_or_s[0]),
    .adc_data_b (adc_data_s[1]),
    .adc_or_b (adc_or_s[1]),
    .adc_data_c (adc_data_s[2]),
    .adc_or_c (adc_or_s[2]),
    .adc_data_d (adc_data_s[3]),
    .adc_or_d (adc_or_s[3]),
    .adc_data_e (adc_data_s[4]),
    .adc_or_e (adc_or_s[4]),
    .adc_data_f (adc_data_s[5]),
    .adc_or_f (adc_or_s[5]),
    .adc_data_g (adc_data_s[6]),
    .adc_or_g (adc_or_s[6]),
    .adc_data_h (adc_data_s[7]),
    .adc_or_h (adc_or_s[7]),
    .adc_start_code (adc_start_code),
    .adc_sync (adc_sync),
    .adc_sync_in (adc_sync_in),
    .adc_sync_out (adc_sync_out),
    .adc_sync_status (adc_sync_status_s),
    .adc_status (adc_status_s),
    .adc_raddr_in (adc_raddr_in),
    .adc_raddr_out (adc_raddr_out));

  // channels

  genvar n;
  generate
  for (n = 0; n < 8; n = n + 1) begin: g_channel
  axi_ad9671_channel #(
    .CHANNEL_ID(n)
  ) i_channel (
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_valid (adc_valid_s),
    .adc_data (adc_data_s[n]),
    .adc_or (adc_or_s[n]),
    .adc_dfmt_valid (adc_valid[n]),
    .adc_dfmt_data (adc_data[(n*16)+15:(n*16)]),
    .adc_enable (adc_enable[n]),
    .up_adc_pn_err (up_adc_pn_err_s[n]),
    .up_adc_pn_oos (up_adc_pn_oos_s[n]),
    .up_adc_or (up_adc_or_s[n]),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[n]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[n]),
    .up_rack (up_rack_s[n]));
  end
  endgenerate

  // common processor control

  up_adc_common #(
    .ID (ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE)
  ) i_up_adc_common (
    .mmcm_rst (),
    .adc_clk (adc_clk),
    .adc_rst (adc_rst),
    .adc_r1_mode (),
    .adc_ddr_edgesel (),
    .adc_pin_mode (),
    .adc_status (adc_status_s),
    .adc_sync_status (adc_sync_status_s),
    .adc_status_ovf (adc_dovf),
    .adc_clk_ratio (32'd1),
    .adc_start_code (adc_start_code),
    .adc_sref_sync (),
    .adc_sync (adc_sync),
    .adc_ext_sync_arm (),
    .adc_ext_sync_disarm (),
    .adc_ext_sync_manual_req (),
    .adc_num_lanes (),
    .adc_custom_control (),
    .adc_crc_enable (),
    .adc_sdr_ddr_n (),
    .adc_symb_op (),
    .adc_symb_8_16b (),
    .up_pps_rcounter ('d0),
    .up_pps_status ('d0),
    .up_pps_irq_mask (),
    .up_adc_r1_mode (),
    .up_adc_ce (),
    .up_status_pn_err (up_status_pn_err),
    .up_status_pn_oos (up_status_pn_oos),
    .up_status_or (up_status_or),
    .up_drp_sel (),
    .up_drp_wr (),
    .up_drp_addr (),
    .up_drp_wdata (),
    .up_drp_rdata (32'd0),
    .up_drp_ready (1'd0),
    .up_drp_locked (1'd1),
    .adc_config_wr (),
    .adc_config_ctrl (),
    .adc_config_rd ('d0),
    .adc_ctrl_status ('d0),
    .up_usr_chanmax_out (),
    .up_usr_chanmax_in (8'd7),
    .up_adc_gpio_in (32'd0),
    .up_adc_gpio_out (),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[8]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[8]),
    .up_rack (up_rack_s[8]));

  // up bus interface

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
