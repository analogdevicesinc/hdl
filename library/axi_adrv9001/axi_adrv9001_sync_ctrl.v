// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/1ps

module axi_adrv9001_sync_ctrl #(
  parameter BASE_ADDRESS = 6'h20,
  parameter ENABLE_REF_CLK_MON = 0
) (

  // clock

  input                   ref_clk,
  input                   rx1_clk,
  input                   rx1_rst,
  input                   rx2_clk,
  input                   rx2_rst,

  input       [ 9:0]      rx1_mcs_to_strobe_delay,
  input       [ 9:0]      rx2_mcs_to_strobe_delay,

  // control signals

  output      [31:0]      sync_config,
  output      [31:0]      mcs_sync_pulse_width,
  output      [31:0]      mcs_sync_pulse_1_delay,
  output      [31:0]      mcs_sync_pulse_2_delay,
  output      [31:0]      mcs_sync_pulse_3_delay,
  output      [31:0]      mcs_sync_pulse_4_delay,
  output      [31:0]      mcs_sync_pulse_5_delay,
  output      [31:0]      mcs_sync_pulse_6_delay,

  // uP bus interface

  input                   up_rstn,
  input                   up_clk,
  input                   up_wreq,
  input       [13:0]      up_waddr,
  input       [31:0]      up_wdata,
  output                  up_wack,
  input                   up_rreq,
  input       [13:0]      up_raddr,
  output      [31:0]      up_rdata,
  output                  up_rack
);

  localparam SYNC_ID = 'h11C5;
  // The pulse timing according to datasheet aprox clock cycles for 30.72MHz
  // PULSE_WIDTH      > 2 us   (63)
  // PULSE_MAX_DELAY  > 100 us (3413)
  // PULSE_MIN_DELAY  > 1 us   (34)
  localparam MCS_SYNC_PULSE_WIDTH = 'd63;
  localparam MCS_SYNC_PULSE_DELAY = 'd3413;

  // internal registers

  reg             up_rack_int = 'd0;
  reg   [31:0]    up_rdata_int = 'd0;
  reg             up_wack_int = 'd0;
  reg             up_preset = 'd1;
  reg   [31:0]    up_sync_config = 'd1;
  reg   [31:0]    up_mcs_sync_status = 'd0;
  reg   [31:0]    up_mcs_sync_pulse_width = MCS_SYNC_PULSE_WIDTH;
  reg   [31:0]    up_mcs_sync_pulse_1_delay = MCS_SYNC_PULSE_DELAY;
  reg   [31:0]    up_mcs_sync_pulse_2_delay = MCS_SYNC_PULSE_DELAY;
  reg   [31:0]    up_mcs_sync_pulse_3_delay = MCS_SYNC_PULSE_DELAY;
  reg   [31:0]    up_mcs_sync_pulse_4_delay = MCS_SYNC_PULSE_DELAY;
  reg   [31:0]    up_mcs_sync_pulse_5_delay = MCS_SYNC_PULSE_DELAY;
  reg   [31:0]    up_mcs_sync_pulse_6_delay = MCS_SYNC_PULSE_DELAY;

  // internal signals

  wire            up_wreq_s;
  wire            up_rreq_s;
  wire  [31:0]    up_ref_clk_count_s;
  wire            ref_rst_s;
  wire  [31:0]    status_s;
  wire  [ 9:0]    up_rx1_mcs_to_strobe_delay;
  wire  [ 9:0]    up_rx2_mcs_to_strobe_delay;
  wire            up_xfer_done_s;

  // decode block select

  assign up_wreq_s = (up_waddr[13:8] == BASE_ADDRESS[5:0]) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:8] == BASE_ADDRESS[5:0]) ? up_rreq : 1'b0;

  // processor write interface

  assign up_wack = up_wack_int;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack_int <= 'd0;
    end else begin
      up_wack_int <= up_wreq_s;
    end
  end

  always @(posedge up_clk) begin
    if (up_rstn == 0) begin
      up_preset <= 1'd1;
      up_sync_config <= 'd0;
      up_mcs_sync_pulse_width <= MCS_SYNC_PULSE_WIDTH;
      up_mcs_sync_pulse_1_delay <= MCS_SYNC_PULSE_DELAY;
      up_mcs_sync_pulse_2_delay <= MCS_SYNC_PULSE_DELAY;
      up_mcs_sync_pulse_3_delay <= MCS_SYNC_PULSE_DELAY;
      up_mcs_sync_pulse_4_delay <= MCS_SYNC_PULSE_DELAY;
      up_mcs_sync_pulse_5_delay <= MCS_SYNC_PULSE_DELAY;
      up_mcs_sync_pulse_6_delay <= MCS_SYNC_PULSE_DELAY;
    end else begin
      up_preset <= 1'b0;
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h3)) begin
        up_sync_config <= up_wdata[31:0];
        if (up_xfer_done_s == 1'b1) begin
          // bit 2 is self cleard
          up_sync_config <= up_wdata[31:0] & 32'hfffffffb;
        end
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h4)) begin
        up_mcs_sync_pulse_width <= up_wdata[31:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h5)) begin
        up_mcs_sync_pulse_1_delay <= up_wdata[31:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h6)) begin
        up_mcs_sync_pulse_2_delay <= up_wdata[31:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h7)) begin
        up_mcs_sync_pulse_3_delay <= up_wdata[31:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h8)) begin
        up_mcs_sync_pulse_4_delay <= up_wdata[31:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'h9)) begin
        up_mcs_sync_pulse_5_delay <= up_wdata[31:0];
      end
      if ((up_wreq_s == 1'b1) && (up_waddr[3:0] == 4'ha)) begin
        up_mcs_sync_pulse_6_delay <= up_wdata[31:0];
      end
    end
  end

  assign status_s = {31'd0, ENABLE_REF_CLK_MON[0]};

  // processor read interface

  assign up_rack = up_rack_int;
  assign up_rdata = up_rdata_int;

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack_int <= 'd0;
      up_rdata_int <= 'd0;
    end else begin
      up_rack_int <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr[3:0])
          4'h0: up_rdata_int <= SYNC_ID;
          4'h1: up_rdata_int <= status_s;
          4'h2: up_rdata_int <= up_ref_clk_count_s;
          4'h3: up_rdata_int <= up_sync_config;
          4'h4: up_rdata_int <= up_mcs_sync_pulse_width;
          4'h5: up_rdata_int <= up_mcs_sync_pulse_1_delay;
          4'h6: up_rdata_int <= up_mcs_sync_pulse_2_delay;
          4'h7: up_rdata_int <= up_mcs_sync_pulse_3_delay;
          4'h8: up_rdata_int <= up_mcs_sync_pulse_4_delay;
          4'h9: up_rdata_int <= up_mcs_sync_pulse_5_delay;
          4'ha: up_rdata_int <= up_mcs_sync_pulse_6_delay;
          4'hb: up_rdata_int <= {22'd0,up_rx1_mcs_to_strobe_delay};
          4'hc: up_rdata_int <= {22'd0,up_rx2_mcs_to_strobe_delay};
          default: up_rdata_int <= 0;
        endcase
      end else begin
        up_rdata_int <= 32'd0;
      end
    end
  end

  ad_rst i_core_rst_reg (
    .rst_async(up_preset),
    .clk(ref_clk),
    .rstn(),
    .rst(ref_rst_s));

  up_xfer_status #(
    .DATA_WIDTH(10)
  ) i_xfer_rx1_status (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_status ({up_rx1_mcs_to_strobe_delay}),
    .d_rst (rx1_rst),
    .d_clk (rx1_clk),
    .d_data_status ({rx1_mcs_to_strobe_delay}));

  up_xfer_status #(
    .DATA_WIDTH(26)
  ) i_xfer_rx2_status (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_data_status ({up_rx2_mcs_to_strobe_delay}),
    .d_rst (rx2_rst),
    .d_clk (rx2_clk),
    .d_data_status ({rx2_mcs_to_strobe_delay}));

  up_xfer_cntrl #(
    .DATA_WIDTH(256)
  ) i_xfer (
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_data_cntrl({
                    up_sync_config,
                    up_mcs_sync_pulse_width,
                    up_mcs_sync_pulse_1_delay,
                    up_mcs_sync_pulse_2_delay,
                    up_mcs_sync_pulse_3_delay,
                    up_mcs_sync_pulse_4_delay,
                    up_mcs_sync_pulse_5_delay,
                    up_mcs_sync_pulse_6_delay}),
    .up_xfer_done(up_xfer_done_s),
    .d_rst(ref_rst_s),
    .d_clk(ref_clk),
    .d_data_cntrl({
                   sync_config,              // 32
                   mcs_sync_pulse_width,     // 32
                   mcs_sync_pulse_1_delay,   // 32
                   mcs_sync_pulse_2_delay,   // 32
                   mcs_sync_pulse_3_delay,   // 32
                   mcs_sync_pulse_4_delay,   // 32
                   mcs_sync_pulse_5_delay,   // 32
                   mcs_sync_pulse_6_delay}));// 32

      // ref clock monitor

  generate
    if (ENABLE_REF_CLK_MON == 1) begin

      up_clock_mon i_clock_mon (
        .up_rstn (up_rstn),
        .up_clk (up_clk),
        .up_d_count (up_ref_clk_count_s),
        .d_rst (ref_rst_s),
        .d_clk (ref_clk));
    end
  endgenerate

endmodule
