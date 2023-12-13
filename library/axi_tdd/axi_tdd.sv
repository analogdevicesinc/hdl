// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

module axi_tdd #(

  // Peripheral ID
  parameter         ID = 0,

  // Number of active channels
  parameter         CHANNEL_COUNT = 8,

  // Default polarity per channel
  parameter         DEFAULT_POLARITY = 8'h00,

  // Timing register width, determines how long a single frame can be.
  // T_max = (2^REGISTER_WIDTH) / f_clk
  parameter         REGISTER_WIDTH = 32,

  // Burst count register width. Determines the maximum amount of repetitions
  // of a frame.
  parameter         BURST_COUNT_WIDTH = 32,

  // Synchronization / triggering options. These are not mutually exclusive, and
  // both internal and external triggering can be available and selected at
  // runtime.
  parameter         SYNC_INTERNAL = 1,
  parameter         SYNC_EXTERNAL = 0,
  // Whether to insert a CDC stage with false path constraint for the external
  // synchronization input.
  parameter         SYNC_EXTERNAL_CDC = 0,
  parameter         SYNC_COUNT_WIDTH = 64
) (

  input  logic                     clk,
  input  logic                     resetn,

  // Sync signal
  input  logic                     sync_in,
  output logic                     sync_out,

  // Output channels
  output logic [CHANNEL_COUNT-1:0] tdd_channel,

  // AXI BUS
  input  logic                     s_axi_aresetn,
  input  logic                     s_axi_aclk,
  input  logic                     s_axi_awvalid,
  input  logic [ 9:0]              s_axi_awaddr,
  input  logic [ 2:0]              s_axi_awprot,
  output logic                     s_axi_awready,
  input  logic                     s_axi_wvalid,
  input  logic [31:0]              s_axi_wdata,
  input  logic [ 3:0]              s_axi_wstrb,
  output logic                     s_axi_wready,
  output logic                     s_axi_bvalid,
  output logic [ 1:0]              s_axi_bresp,
  input  logic                     s_axi_bready,
  input  logic                     s_axi_arvalid,
  input  logic [ 9:0]              s_axi_araddr,
  input  logic [ 2:0]              s_axi_arprot,
  output logic                     s_axi_arready,
  output logic                     s_axi_rvalid,
  output logic [ 1:0]              s_axi_rresp,
  output logic [31:0]              s_axi_rdata,
  input  logic                     s_axi_rready
);

  // Package import
  import axi_tdd_pkg::*;

  // Internal up bus, translated by up_axi
  logic                         up_rstn;
  logic                         up_clk;
  logic                         up_wreq;
  logic [ 7:0]                  up_waddr;
  logic [31:0]                  up_wdata;
  logic                         up_wack;
  logic                         up_rreq;
  logic [ 7:0]                  up_raddr;
  logic [31:0]                  up_rdata;
  logic                         up_rack;

  assign up_clk  = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  // Control signals
  logic                         tdd_enable;
  logic                         tdd_sync_rst;
  logic                         tdd_sync_int;
  logic                         tdd_sync_ext;
  logic                         tdd_sync_soft;

  // Config wires
  logic [BURST_COUNT_WIDTH-1:0] asy_tdd_burst_count;
  logic [REGISTER_WIDTH-1:0]    asy_tdd_startup_delay;
  logic [REGISTER_WIDTH-1:0]    asy_tdd_frame_length;

  // Synchronization config
  logic [SYNC_COUNT_WIDTH-1:0]  asy_tdd_sync_period;

  // Channel config
  logic [CHANNEL_COUNT-1:0]     tdd_channel_en;
  logic [CHANNEL_COUNT-1:0]     asy_tdd_channel_pol;
  logic [REGISTER_WIDTH-1:0]    asy_tdd_channel_on  [0:CHANNEL_COUNT-1];
  logic [REGISTER_WIDTH-1:0]    asy_tdd_channel_off [0:CHANNEL_COUNT-1];

  // Current counter value
  logic  [REGISTER_WIDTH-1:0]   tdd_counter;

  // Current FSM state
  state_t                       tdd_cstate;

  // Asserted to indicate the end of a tdd frame. This allows the channels to
  // reset outputs which are still open due to a potential misconfiguration.
  logic                         tdd_endof_frame;

  axi_tdd_regmap #(
    .ID                (ID),
    .CHANNEL_COUNT     (CHANNEL_COUNT),
    .DEFAULT_POLARITY  (DEFAULT_POLARITY),
    .REGISTER_WIDTH    (REGISTER_WIDTH),
    .BURST_COUNT_WIDTH (BURST_COUNT_WIDTH),
    .SYNC_INTERNAL     (SYNC_INTERNAL),
    .SYNC_EXTERNAL     (SYNC_EXTERNAL),
    .SYNC_EXTERNAL_CDC (SYNC_EXTERNAL_CDC),
    .SYNC_COUNT_WIDTH  (SYNC_COUNT_WIDTH)
  ) i_regmap (
    .up_rstn               (up_rstn),
    .up_clk                (up_clk),

    .up_wreq               (up_wreq),
    .up_waddr              (up_waddr),
    .up_wdata              (up_wdata),
    .up_wack               (up_wack),
    .up_rreq               (up_rreq),
    .up_raddr              (up_raddr),
    .up_rdata              (up_rdata),
    .up_rack               (up_rack),

    .tdd_clk               (clk),
    .tdd_resetn            (resetn),

    .tdd_cstate            (tdd_cstate),

    .tdd_enable            (tdd_enable),

    .tdd_channel_en        (tdd_channel_en),
    .asy_tdd_channel_pol   (asy_tdd_channel_pol),

    .asy_tdd_burst_count   (asy_tdd_burst_count),
    .asy_tdd_startup_delay (asy_tdd_startup_delay),
    .asy_tdd_frame_length  (asy_tdd_frame_length),

    .asy_tdd_channel_on    (asy_tdd_channel_on),
    .asy_tdd_channel_off   (asy_tdd_channel_off),

    .asy_tdd_sync_period   (asy_tdd_sync_period),

    .tdd_sync_rst          (tdd_sync_rst),
    .tdd_sync_int          (tdd_sync_int),
    .tdd_sync_ext          (tdd_sync_ext),
    .tdd_sync_soft         (tdd_sync_soft));

  axi_tdd_counter #(
    .REGISTER_WIDTH    (REGISTER_WIDTH),
    .BURST_COUNT_WIDTH (BURST_COUNT_WIDTH)
  ) i_counter (
    .clk                   (clk),
    .resetn                (resetn),

    .tdd_enable            (tdd_enable),
    .tdd_sync_rst          (tdd_sync_rst),
    .tdd_sync              (sync_out),

    .asy_tdd_burst_count   (asy_tdd_burst_count),
    .asy_tdd_startup_delay (asy_tdd_startup_delay),
    .asy_tdd_frame_length  (asy_tdd_frame_length),

    .tdd_counter           (tdd_counter),
    .tdd_cstate            (tdd_cstate),
    .tdd_endof_frame       (tdd_endof_frame));

  axi_tdd_sync_gen #(
    .SYNC_INTERNAL     (SYNC_INTERNAL),
    .SYNC_EXTERNAL     (SYNC_EXTERNAL),
    .SYNC_EXTERNAL_CDC (SYNC_EXTERNAL_CDC),
    .SYNC_COUNT_WIDTH  (SYNC_COUNT_WIDTH)
  ) i_sync_gen (
    .clk                 (clk),
    .resetn              (resetn),

    .sync_in             (sync_in),
    .sync_out            (sync_out),

    .tdd_enable          (tdd_enable),
    .tdd_sync_int        (tdd_sync_int),
    .tdd_sync_ext        (tdd_sync_ext),
    .tdd_sync_soft       (tdd_sync_soft),

    .asy_tdd_sync_period (asy_tdd_sync_period));

  genvar i;
  generate
    for (i = 0; i < CHANNEL_COUNT; i=i+1) begin
      axi_tdd_channel #(
        .DEFAULT_POLARITY (DEFAULT_POLARITY[i]),
        .REGISTER_WIDTH   (REGISTER_WIDTH)
      ) i_channel (
        .clk             (clk),
        .resetn          (resetn),

        .tdd_counter     (tdd_counter),
        .tdd_cstate      (tdd_cstate),
        .tdd_enable      (tdd_enable),
        .tdd_endof_frame (tdd_endof_frame),

        .ch_en           (tdd_channel_en[i]),
        .asy_ch_pol      (asy_tdd_channel_pol[i]),
        .asy_t_high      (asy_tdd_channel_on[i]),
        .asy_t_low       (asy_tdd_channel_off[i]),

        .out             (tdd_channel[i]));
    end
  endgenerate

  up_axi #(
    .AXI_ADDRESS_WIDTH(10)
  ) i_up_axi (
    .up_rstn(s_axi_aresetn),
    .up_clk(s_axi_aclk),

    .up_axi_awvalid(s_axi_awvalid),
    .up_axi_awaddr(s_axi_awaddr),
    .up_axi_awready(s_axi_awready),
    .up_axi_wvalid(s_axi_wvalid),
    .up_axi_wdata(s_axi_wdata),
    .up_axi_wstrb(s_axi_wstrb),
    .up_axi_wready(s_axi_wready),
    .up_axi_bvalid(s_axi_bvalid),
    .up_axi_bresp(s_axi_bresp),
    .up_axi_bready(s_axi_bready),
    .up_axi_arvalid(s_axi_arvalid),
    .up_axi_araddr(s_axi_araddr),
    .up_axi_arready(s_axi_arready),
    .up_axi_rvalid(s_axi_rvalid),
    .up_axi_rresp(s_axi_rresp),
    .up_axi_rdata(s_axi_rdata),
    .up_axi_rready(s_axi_rready),

    .up_wreq(up_wreq),
    .up_waddr(up_waddr),
    .up_wdata(up_wdata),
    .up_wack(up_wack),
    .up_rreq(up_rreq),
    .up_raddr(up_raddr),
    .up_rdata(up_rdata),
    .up_rack(up_rack));

endmodule
