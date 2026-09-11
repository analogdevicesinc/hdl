// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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

module rtp_video_transm_handler #(
  parameter         S_TDATA_WIDTH = 64,
  parameter         S_TKEEP_WIDTH = S_TDATA_WIDTH/8,
  parameter         TX_DESC_TABLE_SIZE = 32,
  parameter         TX_TAG_WIDTH = $clog2(TX_DESC_TABLE_SIZE)+1,
  parameter         S_TUSER_WIDTH = TX_TAG_WIDTH+1,
  parameter         M_TDATA_WIDTH = 64,
  parameter         M_TKEEP_WIDTH = M_TDATA_WIDTH/8,
  parameter         M_TUSER_WIDTH = S_TUSER_WIDTH
) (

  input                         aclk,
  input                         areset,

  /* AXI stream slave interfaces */

  /* AXIS slave interface for the NIC path */
  input                         s_axis_tvalid_s0,
  input  [(S_TDATA_WIDTH-1):0]  s_axis_tdata_s0,
  input                         s_axis_tlast_s0,
  output                        s_axis_tready_s0,
  input  [(S_TKEEP_WIDTH-1):0]  s_axis_tkeep_s0,
  input  [(S_TUSER_WIDTH-1):0]  s_axis_tuser_s0,

  /* AXIS slave interface for the video path */
  input                         s_axis_tvalid_s1,
  input  [(S_TDATA_WIDTH-1):0]  s_axis_tdata_s1,
  input                         s_axis_tlast_s1,
  output                        s_axis_tready_s1,
  input  [(S_TKEEP_WIDTH-1):0]  s_axis_tkeep_s1,

  /* AXI stream master interface */

  output                         m_axis_tvalid_res,
  output  [(M_TDATA_WIDTH-1):0]  m_axis_tdata_res,
  output                         m_axis_tlast_res,
  input                          m_axis_tready_res,
  output  [(M_TKEEP_WIDTH-1):0]  m_axis_tkeep_res,
  output  [(M_TUSER_WIDTH-1):0]  m_axis_tuser_res
);

  wire [S_TDATA_WIDTH-1:0] m_axis_sync_tx_tdata_conn;
  wire [S_TKEEP_WIDTH-1:0] m_axis_sync_tx_tkeep_conn;
  wire                     m_axis_sync_tx_tvalid_conn;
  wire                     m_axis_sync_tx_tready_conn;
  wire                     m_axis_sync_tx_tlast_conn;
  wire [S_TUSER_WIDTH-1:0] m_axis_sync_tx_tuser_conn;
  wire                     s_axis_sync_tx_tready_out;

  wire [1:0]                   s_axis_tvalid_combined;
  wire [1:0]                   s_axis_tlast_combined;
  wire [(2*S_TDATA_WIDTH)-1:0] s_axis_tdata_combined;
  wire [(2*S_TKEEP_WIDTH)-1:0] s_axis_tkeep_combined;
  wire [1:0]                   s_axis_tready_combined;
  wire [(2*S_TUSER_WIDTH)-1:0] s_axis_tuser_combined;

  wire                     m_axis_tvalid_s0;
  wire                     m_axis_tlast_s0;
  wire [S_TDATA_WIDTH-1:0] m_axis_tdata_s0;
  wire [S_TKEEP_WIDTH-1:0] m_axis_tkeep_s0;
  wire                     m_axis_tready_s0;
  wire [S_TUSER_WIDTH-1:0] m_axis_tuser_s0;
  wire [S_TUSER_WIDTH-1:0] m_axis_tuser_s1 = 'h0;

  assign s_axis_tdata_combined = {m_axis_tdata_s0,s_axis_tdata_s1};
  assign s_axis_tkeep_combined = {m_axis_tkeep_s0,s_axis_tkeep_s1};
  assign s_axis_tvalid_combined = {m_axis_tvalid_s0,s_axis_tvalid_s1};
  assign s_axis_tlast_combined = {m_axis_tlast_s0,s_axis_tlast_s1};
  assign s_axis_tuser_combined = {m_axis_tuser_s0,m_axis_tuser_s1};
  assign m_axis_tready_s0 = s_axis_tready_combined[1];
  assign s_axis_tready_s1 = s_axis_tready_combined[0];

  axis_rate_limit #(
    .DATA_WIDTH(S_TDATA_WIDTH),
    .USER_WIDTH(S_TKEEP_WIDTH))
  axis_rate_lim_inst (
    .clk (aclk),
    .rst (areset),
    .s_axis_tdata(s_axis_tdata_s0),
    .s_axis_tkeep(s_axis_tkeep_s0),
    .s_axis_tvalid(s_axis_tvalid_s0),
    .s_axis_tready(s_axis_tready_s0),
    .s_axis_tlast(s_axis_tlast_s0),
    .s_axis_tuser(s_axis_tuser_s0),
    .m_axis_tdata(m_axis_sync_tx_tdata_conn),
    .m_axis_tkeep(m_axis_sync_tx_tkeep_conn),
    .m_axis_tvalid(m_axis_sync_tx_tvalid_conn),
    .m_axis_tready(m_axis_sync_tx_tready_conn),
    .m_axis_tlast(m_axis_sync_tx_tlast_conn),
    .m_axis_tuser(m_axis_sync_tx_tuser_conn),
    .rate_num(1),
    .rate_denom(100),
    .rate_by_frame(1));

  axis_fifo #(
    .DEPTH (32768),
    .DATA_WIDTH (M_TDATA_WIDTH),
    .DEST_ENABLE (0),
    .DEST_WIDTH (1),
    .USER_ENABLE (1),
    .USER_WIDTH (S_TUSER_WIDTH),
    .FRAME_FIFO (1))
  storage_s0_data (
    .clk (aclk),
    .rst (areset),
    .s_axis_tdata (m_axis_sync_tx_tdata_conn),
    .s_axis_tkeep (m_axis_sync_tx_tkeep_conn),
    .s_axis_tvalid (m_axis_sync_tx_tvalid_conn),
    .s_axis_tready (m_axis_sync_tx_tready_conn),
    .s_axis_tlast (m_axis_sync_tx_tlast_conn),
    .s_axis_tuser (m_axis_sync_tx_tuser_conn),
    .m_axis_tdata (m_axis_tdata_s0),
    .m_axis_tkeep (m_axis_tkeep_s0),
    .m_axis_tvalid (m_axis_tvalid_s0),
    .m_axis_tready (m_axis_tready_s0),
    .m_axis_tlast (m_axis_tlast_s0),
    .m_axis_tuser (m_axis_tuser_s0));

  axis_arb_mux #(
    .S_COUNT (2),
    .DATA_WIDTH (M_TDATA_WIDTH),
    .USER_ENABLE (1),
    .ARB_TYPE_ROUND_ROBIN (1),
    .USER_WIDTH (S_TUSER_WIDTH)
  ) axis_arb_mux_inst (
    .clk (aclk),
    .rst (areset),
    .s_axis_tdata (s_axis_tdata_combined),
    .s_axis_tvalid (s_axis_tvalid_combined),
    .s_axis_tlast (s_axis_tlast_combined),
    .s_axis_tkeep (s_axis_tkeep_combined),
    .s_axis_tready (s_axis_tready_combined),
    .s_axis_tuser (s_axis_tuser_combined),
    .m_axis_tvalid (m_axis_tvalid_res),
    .m_axis_tdata (m_axis_tdata_res),
    .m_axis_tlast (m_axis_tlast_res),
    .m_axis_tkeep (m_axis_tkeep_res),
    .m_axis_tready (m_axis_tready_res),
    .m_axis_tuser (m_axis_tuser_res));

endmodule;
