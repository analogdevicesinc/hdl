// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
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

// Uses Ficonacci style LFSR

`timescale 1ns/100ps

module ber_tester #(

  // Structural configuration
  parameter IF_COUNT = 1,
  parameter PORTS_PER_IF = 1,

  // Ethernet interface configuration (direct, async)
  parameter AXIS_DATA_WIDTH = 512,
  parameter AXIS_KEEP_WIDTH = AXIS_DATA_WIDTH/8,
  parameter AXIS_TX_USER_WIDTH = 17,
  parameter AXIS_RX_USER_WIDTH = 17
) (

  input  wire                                                      ber_test,
  input  wire                                                      reset_ber,
  input  wire                                                      insert_bit_error,

  output wire [63:0]                                               total_bits,
  output wire [63:0]                                               error_bits_total,
  output wire [31:0]                                               out_of_sync_total,

  // Ethernet (direct MAC interface - lowest latency raw traffic)
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          direct_tx_clk,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          direct_tx_rst,

  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]          s_axis_direct_tx_tdata,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]          s_axis_direct_tx_tkeep,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_direct_tx_tvalid,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_direct_tx_tready,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_direct_tx_tlast,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_TX_USER_WIDTH-1:0]       s_axis_direct_tx_tuser,

  output wire [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]          m_axis_direct_tx_tdata,
  output wire [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]          m_axis_direct_tx_tkeep,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_direct_tx_tvalid,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_direct_tx_tready,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_direct_tx_tlast,
  output wire [IF_COUNT*PORTS_PER_IF*AXIS_TX_USER_WIDTH-1:0]       m_axis_direct_tx_tuser,

  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          direct_rx_clk,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          direct_rx_rst,

  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]          s_axis_direct_rx_tdata,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]          s_axis_direct_rx_tkeep,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_direct_rx_tvalid,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_direct_rx_tready,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          s_axis_direct_rx_tlast,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH-1:0]       s_axis_direct_rx_tuser,

  output wire [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]          m_axis_direct_rx_tdata,
  output wire [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]          m_axis_direct_rx_tkeep,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_direct_rx_tvalid,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_direct_rx_tready,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                          m_axis_direct_rx_tlast,
  output wire [IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH-1:0]       m_axis_direct_rx_tuser
);

  ber_tester_tx #(
    .IF_COUNT(IF_COUNT),
    .PORTS_PER_IF(PORTS_PER_IF),
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
    .AXIS_KEEP_WIDTH(AXIS_KEEP_WIDTH),
    .AXIS_TX_USER_WIDTH(AXIS_TX_USER_WIDTH)
  ) ber_tester_tx_inst (
    .ber_test(ber_test),
    .insert_bit_error(insert_bit_error),
    .direct_tx_clk(direct_tx_clk),
    .direct_tx_rst(direct_tx_rst),
    .s_axis_direct_tx_tdata(s_axis_direct_tx_tdata),
    .s_axis_direct_tx_tkeep(s_axis_direct_tx_tkeep),
    .s_axis_direct_tx_tvalid(s_axis_direct_tx_tvalid),
    .s_axis_direct_tx_tready(s_axis_direct_tx_tready),
    .s_axis_direct_tx_tlast(s_axis_direct_tx_tlast),
    .s_axis_direct_tx_tuser(s_axis_direct_tx_tuser),
    .m_axis_direct_tx_tdata(m_axis_direct_tx_tdata),
    .m_axis_direct_tx_tkeep(m_axis_direct_tx_tkeep),
    .m_axis_direct_tx_tvalid(m_axis_direct_tx_tvalid),
    .m_axis_direct_tx_tready(m_axis_direct_tx_tready),
    .m_axis_direct_tx_tlast(m_axis_direct_tx_tlast),
    .m_axis_direct_tx_tuser(m_axis_direct_tx_tuser));

  ber_tester_rx #(
    .IF_COUNT(IF_COUNT),
    .PORTS_PER_IF(PORTS_PER_IF),
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
    .AXIS_KEEP_WIDTH(AXIS_KEEP_WIDTH),
    .AXIS_RX_USER_WIDTH(AXIS_RX_USER_WIDTH)
  ) ber_tester_rx_inst (
    .ber_test(ber_test),
    .reset_ber(reset_ber),
    .total_bits(total_bits),
    .error_bits_total(error_bits_total),
    .out_of_sync_total(out_of_sync_total),
    .direct_rx_clk(direct_rx_clk),
    .direct_rx_rst(direct_rx_rst),
    .s_axis_direct_rx_tdata(s_axis_direct_rx_tdata),
    .s_axis_direct_rx_tkeep(s_axis_direct_rx_tkeep),
    .s_axis_direct_rx_tvalid(s_axis_direct_rx_tvalid),
    .s_axis_direct_rx_tready(s_axis_direct_rx_tready),
    .s_axis_direct_rx_tlast(s_axis_direct_rx_tlast),
    .s_axis_direct_rx_tuser(s_axis_direct_rx_tuser),
    .m_axis_direct_rx_tdata(m_axis_direct_rx_tdata),
    .m_axis_direct_rx_tkeep(m_axis_direct_rx_tkeep),
    .m_axis_direct_rx_tvalid(m_axis_direct_rx_tvalid),
    .m_axis_direct_rx_tready(m_axis_direct_rx_tready),
    .m_axis_direct_rx_tlast(m_axis_direct_rx_tlast),
    .m_axis_direct_rx_tuser(m_axis_direct_rx_tuser));

endmodule
