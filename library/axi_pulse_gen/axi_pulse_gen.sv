// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2019 (c) Analog Devices, Inc. All rights reserved.
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
`timescale 1ns/100ps

module axi_pulse_gen #(

  parameter       ID = 0,
  parameter [0:0] ASYNC_CLK_EN = 1,
  parameter       INCREMENTAL_COUNTER = 1,
  parameter       N_PULSES = 3,
  parameter       PULSE_1_WIDTH = 7,
  parameter       PULSE_2_WIDTH = 7,
  parameter       PULSE_3_WIDTH = 7,
  parameter       PULSE_4_WIDTH = 7,
  parameter       PULSE_5_WIDTH = 7,
  parameter       PULSE_6_WIDTH = 7,
  parameter       PULSE_7_WIDTH = 7,
  parameter       PULSE_8_WIDTH = 7,
  parameter       PULSE_9_WIDTH = 7,
  parameter       PULSE_10_WIDTH = 7,
  parameter       PULSE_11_WIDTH = 7,
  parameter       PULSE_12_WIDTH = 7,
  parameter       PULSE_13_WIDTH = 7,
  parameter       PULSE_14_WIDTH = 7,
  parameter       PULSE_15_WIDTH = 7,
  parameter       PULSE_16_WIDTH = 7,
  parameter       PULSE_1_PERIOD = 10,
  parameter       PULSE_2_PERIOD = 10,
  parameter       PULSE_3_PERIOD = 10,
  parameter       PULSE_4_PERIOD = 10,
  parameter       PULSE_5_PERIOD = 10,
  parameter       PULSE_6_PERIOD = 10,
  parameter       PULSE_7_PERIOD = 10,
  parameter       PULSE_8_PERIOD = 10,
  parameter       PULSE_9_PERIOD = 10,
  parameter       PULSE_10_PERIOD = 10,
  parameter       PULSE_11_PERIOD = 10,
  parameter       PULSE_12_PERIOD = 10,
  parameter       PULSE_13_PERIOD = 10,
  parameter       PULSE_14_PERIOD = 10,
  parameter       PULSE_15_PERIOD = 10,
  parameter       PULSE_16_PERIOD = 10,
  parameter       PULSE_1_EXT_SYNC = 0,
  parameter       PULSE_2_OFFSET = 0,
  parameter       PULSE_3_OFFSET = 0,
  parameter       PULSE_4_OFFSET = 0,
  parameter       PULSE_5_OFFSET = 0,
  parameter       PULSE_6_OFFSET = 0,
  parameter       PULSE_7_OFFSET = 0,
  parameter       PULSE_8_OFFSET = 0,
  parameter       PULSE_9_OFFSET = 0,
  parameter       PULSE_10_OFFSET = 0,
  parameter       PULSE_11_OFFSET = 0,
  parameter       PULSE_12_OFFSET = 0,
  parameter       PULSE_13_OFFSET = 0,
  parameter       PULSE_14_OFFSET = 0,
  parameter       PULSE_15_OFFSET = 0,
  parameter       PULSE_16_OFFSET = 0 )(

  // axi interface

  input                   s_axi_aclk,
  input                   s_axi_aresetn,
  input                   s_axi_awvalid,
  input       [15:0]      s_axi_awaddr,
  input       [ 2:0]      s_axi_awprot,
  output                  s_axi_awready,
  input                   s_axi_wvalid,
  input       [31:0]      s_axi_wdata,
  input       [ 3:0]      s_axi_wstrb,
  output                  s_axi_wready,
  output                  s_axi_bvalid,
  output      [ 1:0]      s_axi_bresp,
  input                   s_axi_bready,
  input                   s_axi_arvalid,
  input       [15:0]      s_axi_araddr,
  input       [ 2:0]      s_axi_arprot,
  output                  s_axi_arready,
  output                  s_axi_rvalid,
  output      [ 1:0]      s_axi_rresp,
  output      [31:0]      s_axi_rdata,
  input                   s_axi_rready,
  input                   ext_clk,
  input                   external_sync,
  output                  pulse_0,
  output                  pulse_1,
  output                  pulse_2,
  output                  pulse_3,
  output                  pulse_4,
  output                  pulse_5,
  output                  pulse_6,
  output                  pulse_7,
  output                  pulse_8,
  output                  pulse_9,
  output                  pulse_10,
  output                  pulse_11,
  output                  pulse_12,
  output                  pulse_13,
  output                  pulse_14,
  output                  pulse_15);

  // local parameters

  localparam [31:0] CORE_VERSION = {16'h0000,     /* MAJOR */
                                     8'h01,       /* MINOR */
                                     8'h00};      /* PATCH */ // 0.01.0
  localparam [31:0] CORE_MAGIC = 32'h504c5347;    // PLSG

  localparam [31:0] PULSE_WIDTH_G[1:16] = {PULSE_1_WIDTH,
                                           PULSE_2_WIDTH,
                                           PULSE_3_WIDTH,
                                           PULSE_4_WIDTH,
                                           PULSE_5_WIDTH,
                                           PULSE_6_WIDTH,
                                           PULSE_7_WIDTH,
                                           PULSE_8_WIDTH,
                                           PULSE_9_WIDTH,
                                           PULSE_10_WIDTH,
                                           PULSE_11_WIDTH,
                                           PULSE_12_WIDTH,
                                           PULSE_13_WIDTH,
                                           PULSE_14_WIDTH,
                                           PULSE_15_WIDTH,
                                           PULSE_16_WIDTH};

  localparam [31:0] PULSE_PERIOD_G[1:16] = {PULSE_1_PERIOD,
                                            PULSE_2_PERIOD,
                                            PULSE_3_PERIOD,
                                            PULSE_4_PERIOD,
                                            PULSE_5_PERIOD,
                                            PULSE_6_PERIOD,
                                            PULSE_7_PERIOD,
                                            PULSE_8_PERIOD,
                                            PULSE_9_PERIOD,
                                            PULSE_10_PERIOD,
                                            PULSE_11_PERIOD,
                                            PULSE_12_PERIOD,
                                            PULSE_13_PERIOD,
                                            PULSE_14_PERIOD,
                                            PULSE_15_PERIOD,
                                            PULSE_16_PERIOD};

  localparam [31:0] PULSE_OFFSET_G[1:16] = '{32'd0,
                                             PULSE_2_OFFSET,
                                             PULSE_3_OFFSET,
                                             PULSE_4_OFFSET,
                                             PULSE_5_OFFSET,
                                             PULSE_6_OFFSET,
                                             PULSE_7_OFFSET,
                                             PULSE_8_OFFSET,
                                             PULSE_9_OFFSET,
                                             PULSE_10_OFFSET,
                                             PULSE_11_OFFSET,
                                             PULSE_12_OFFSET,
                                             PULSE_13_OFFSET,
                                             PULSE_14_OFFSET,
                                             PULSE_15_OFFSET,
                                             PULSE_16_OFFSET};

  // internal signals

  wire            clk;
  wire            up_clk;
  wire            up_rstn;
  wire            up_rreq_s;
  wire            up_wack_s;
  wire            up_rack_s;
  wire    [13:0]  up_raddr_s;
  wire    [31:0]  up_rdata_s;
  wire            up_wreq_s;
  wire    [13:0]  up_waddr_s;
  wire    [31:0]  up_wdata_s;
  wire    [31:0]  pulse_width_s  [1:N_PULSES];
  wire    [31:0]  pulse_period_s [1:N_PULSES];
  wire    [31:0]  pulse_offset_s [1:N_PULSES];
  wire            pulse [1:N_PULSES];
  wire    [31:0]  phase_offset [1:N_PULSES];
  wire    [31:0]  pulse_counter[1:N_PULSES];
  wire            sync[1:N_PULSES];
  wire            load_config_s;
  wire            pulse_gen_resetn;

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  axi_pulse_gen_regmap #(
    .ID (ID),
    .ASYNC_CLK_EN (ASYNC_CLK_EN),
    .CORE_MAGIC (CORE_MAGIC),
    .CORE_VERSION (CORE_VERSION),
    .N_PULSES (N_PULSES),
    .PULSE_WIDTH_G (PULSE_WIDTH_G),
    .PULSE_PERIOD_G (PULSE_PERIOD_G),
    .PULSE_OFFSET_G (PULSE_OFFSET_G))
  i_regmap (
    .ext_clk (ext_clk),
    .clk_out (clk),
    .pulse_gen_resetn (pulse_gen_resetn),
    .pulse_width (pulse_width_s),
    .pulse_period (pulse_period_s),
    .pulse_offset (pulse_offset_s),
    .load_config (load_config_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

  genvar n;
  generate
    for (n = 1; n <= N_PULSES; n = n + 1) begin
      util_pulse_gen  #(
        .INCREMENTAL_COUNTER (INCREMENTAL_COUNTER),
        .PULSE_WIDTH (PULSE_WIDTH_G[n]),
        .PULSE_PERIOD (PULSE_PERIOD_G[n]))
      util_pulse_gen_i(
        .clk (clk),
        .rstn (pulse_gen_resetn),
        .pulse_width (pulse_width_s[n]),
        .pulse_period (pulse_period_s[n]),
        .load_config (load_config_s),
        .sync (sync[n]),
        .pulse (pulse[n]),
        .pulse_counter (pulse_counter[n]));

      if (n == 1) begin
        assign sync[n] = PULSE_0_EXT_SYNC ? external_sync : 1'b1;
      end else begin
        assign sync[n] = (pulse_counter[1] == phase_offset[n]) ? 1'b1 : 1'b0;
      end

      assign phase_offset[n] = pulse_offset_s[n];
    end

    if (N_PULSES >= 1) begin
      assign pulse_0 = pulse[1];
    end else begin
      assign pulse_0 = 1'b0;
    end
    if (N_PULSES >= 2) begin
      assign pulse_1 = pulse[2];
    end else begin
      assign pulse_1 = 1'b0;
    end
    if (N_PULSES >= 3) begin
      assign pulse_2 = pulse[3];
    end else begin
      assign pulse_2 = 1'b0;
    end
    if (N_PULSES >= 4) begin
      assign pulse_3 = pulse[4];
    end else begin
      assign pulse_3 = 1'b0;
    end
    if (N_PULSES >= 5) begin
      assign pulse_4 = pulse[5];
    end else begin
      assign pulse_4 = 1'b0;
    end
    if (N_PULSES >= 6) begin
      assign pulse_5 = pulse[6];
    end else begin
      assign pulse_5 = 1'b0;
    end
    if (N_PULSES >= 7) begin
      assign pulse_6 = pulse[7];
    end else begin
      assign pulse_6 = 1'b0;
    end
    if (N_PULSES >= 8) begin
      assign pulse_7 = pulse[8];
    end else begin
      assign pulse_7 = 1'b0;
    end
    if (N_PULSES >= 9) begin
      assign pulse_8 = pulse[9];
    end else begin
      assign pulse_8 = 1'b0;
    end
    if (N_PULSES >= 10) begin
      assign pulse_9 = pulse[10];
    end else begin
      assign pulse_9 = 1'b0;
    end
    if (N_PULSES >= 11) begin
      assign pulse_10 = pulse[11];
    end else begin
      assign pulse_10 = 1'b0;
    end
    if (N_PULSES >= 12) begin
      assign pulse_11 = pulse[12];
    end else begin
      assign pulse_11 = 1'b0;
    end
    if (N_PULSES >= 13) begin
      assign pulse_12 = pulse[13];
    end else begin
      assign pulse_12 = 1'b0;
    end
    if (N_PULSES >= 14) begin
      assign pulse_13 = pulse[14];
    end else begin
      assign pulse_13 = 1'b0;
    end
    if (N_PULSES >= 15) begin
      assign pulse_14 = pulse[15];
    end else begin
      assign pulse_14 = 1'b0;
    end
    if (N_PULSES == 16) begin
      assign pulse_15 = pulse[16];
    end else begin
      assign pulse_15 = 1'b0;
    end
  endgenerate

  up_axi #(
    .AXI_ADDRESS_WIDTH(16))
  i_up_axi (
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
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

endmodule
