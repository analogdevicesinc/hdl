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

/* Current logic contains a configurable number of sessions - RTP engines
* connected to the MUX design. The TDATA widths are not configurable and
* are hardcoded to 8 bytes (64 bits) in the packaged FPGA IP
*/
module rtp_session_mux #(
  parameter         SESSION_NUMBER = 8,
  parameter         S_TDATA_WIDTH = 64,
  parameter         S_TKEEP_WIDTH = S_TDATA_WIDTH/8,
  parameter         M_TDATA_WIDTH = 64,
  parameter         M_TKEEP_WIDTH = M_TDATA_WIDTH/8
) (

  input                         aclk,
  input                         aresetn,

  /* AXI stream slave interfaces */

  input                         s_axis_tvalid_s0,
  input  [(S_TDATA_WIDTH-1):0]  s_axis_tdata_s0,
  input                         s_axis_tlast_s0,
  output                        s_axis_tready_s0,
  input  [(S_TKEEP_WIDTH-1):0]  s_axis_tkeep_s0,

  input                         s_axis_tvalid_s1,
  input  [(S_TDATA_WIDTH-1):0]  s_axis_tdata_s1,
  input                         s_axis_tlast_s1,
  output                        s_axis_tready_s1,
  input  [(S_TKEEP_WIDTH-1):0]  s_axis_tkeep_s1,

  input                         s_axis_tvalid_s2,
  input  [(S_TDATA_WIDTH-1):0]  s_axis_tdata_s2,
  input                         s_axis_tlast_s2,
  output                        s_axis_tready_s2,
  input  [(S_TKEEP_WIDTH-1):0]  s_axis_tkeep_s2,

  input                         s_axis_tvalid_s3,
  input  [(S_TDATA_WIDTH-1):0]  s_axis_tdata_s3,
  input                         s_axis_tlast_s3,
  output                        s_axis_tready_s3,
  input  [(S_TKEEP_WIDTH-1):0]  s_axis_tkeep_s3,

  input                         s_axis_tvalid_s4,
  input  [(S_TDATA_WIDTH-1):0]  s_axis_tdata_s4,
  input                         s_axis_tlast_s4,
  output                        s_axis_tready_s4,
  input  [(S_TKEEP_WIDTH-1):0]  s_axis_tkeep_s4,

  input                         s_axis_tvalid_s5,
  input  [(S_TDATA_WIDTH-1):0]  s_axis_tdata_s5,
  input                         s_axis_tlast_s5,
  output                        s_axis_tready_s5,
  input  [(S_TKEEP_WIDTH-1):0]  s_axis_tkeep_s5,

  input                         s_axis_tvalid_s6,
  input  [(S_TDATA_WIDTH-1):0]  s_axis_tdata_s6,
  input                         s_axis_tlast_s6,
  output                        s_axis_tready_s6,
  input  [(S_TKEEP_WIDTH-1):0]  s_axis_tkeep_s6,

  input                         s_axis_tvalid_s7,
  input  [(S_TDATA_WIDTH-1):0]  s_axis_tdata_s7,
  input                         s_axis_tlast_s7,
  output                        s_axis_tready_s7,
  input  [(S_TKEEP_WIDTH-1):0]  s_axis_tkeep_s7,

  /* AXI stream master interface */

  output                         m_axis_tvalid,
  output  [(M_TDATA_WIDTH-1):0]  m_axis_tdata,
  output                         m_axis_tlast,
  input                          m_axis_tready,
  output  [(M_TKEEP_WIDTH-1):0]  m_axis_tkeep,

  /* output port for the start of video transfer logic
  * SW configurable - will decide which configuration
  * is used: 0 - only the data from SW-controlled NIC
  * is transferred; 1 - the NIC/FPGA-based video paths
  * are multiplexed and all the data from them is sent
  */
  output                         start_video_transfer,

  /* AXI control interface */

  input                          s_axi_aclk,
  input                          s_axi_aresetn,
  input                          s_axi_awvalid,
  input   [15:0]                 s_axi_awaddr,
  input   [ 2:0]                 s_axi_awprot,
  output                         s_axi_awready,
  input                          s_axi_wvalid,
  input   [31:0]                 s_axi_wdata,
  input   [ 3:0]                 s_axi_wstrb,
  output                         s_axi_wready,
  output                         s_axi_bvalid,
  output  [ 1:0]                 s_axi_bresp,
  input                          s_axi_bready,
  input                          s_axi_arvalid,
  input   [15:0]                 s_axi_araddr,
  input   [ 2:0]                 s_axi_arprot,
  output                         s_axi_arready,
  output                         s_axi_rvalid,
  output  [ 1:0]                 s_axi_rresp,
  output  [31:0]                 s_axi_rdata,
  input                          s_axi_rready
);

  /* internal axi4-lite signals */
  wire            up_clk;
  wire            up_rstn;
  wire            up_rreq_s;
  wire            up_wack_s;
  wire            up_rack_s;
  wire   [13:0]   up_raddr_s;
  wire   [31:0]   up_rdata_s;
  wire            up_wreq_s;
  wire   [13:0]   up_waddr_s;
  wire   [31:0]   up_wdata_s;

  wire            areset;

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;
  assign areset = ~aresetn;

  wire [SESSION_NUMBER*S_TDATA_WIDTH-1:0] s_axis_tdata;
  wire [SESSION_NUMBER-1:0] s_axis_tvalid;
  wire [SESSION_NUMBER-1:0] s_axis_tlast;
  wire [SESSION_NUMBER-1:0] s_axis_tready;
  wire [SESSION_NUMBER*S_TKEEP_WIDTH-1:0] s_axis_tkeep;

  wire interconn_m_axis_tvalid;
  wire interconn_m_axis_tlast;
  wire interconn_m_axis_tready;
  wire [M_TDATA_WIDTH-1:0] interconn_m_axis_tdata;
  wire [M_TKEEP_WIDTH-1:0] interconn_m_axis_tkeep;

  generate
    if (SESSION_NUMBER == 1) begin
      assign s_axis_tdata = s_axis_tdata_s0;
      assign s_axis_tvalid = s_axis_tvalid_s0;
      assign s_axis_tlast = s_axis_tlast_s0;
      assign s_axis_tready_s0 = s_axis_tready[0];
      assign s_axis_tkeep = s_axis_tkeep_s0;
    end else if (SESSION_NUMBER == 2) begin
      assign s_axis_tdata = {s_axis_tdata_s0,s_axis_tdata_s1};
      assign s_axis_tvalid = {s_axis_tvalid_s0,s_axis_tvalid_s1};
      assign s_axis_tlast = {s_axis_tlast_s0,s_axis_tlast_s1};
      assign s_axis_tready_s0 = s_axis_tready[1];
      assign s_axis_tready_s1 = s_axis_tready[0];
      assign s_axis_tkeep = {s_axis_tkeep_s0,s_axis_tkeep_s1};
    end else if (SESSION_NUMBER == 3) begin
      assign s_axis_tdata = {s_axis_tdata_s0,s_axis_tdata_s1,s_axis_tdata_s2};
      assign s_axis_tvalid = {s_axis_tvalid_s0,s_axis_tvalid_s1,s_axis_tvalid_s2};
      assign s_axis_tlast = {s_axis_tlast_s0,s_axis_tlast_s1,s_axis_tlast_s2};
      assign s_axis_tready_s0 = s_axis_tready[2];
      assign s_axis_tready_s1 = s_axis_tready[1];
      assign s_axis_tready_s2 = s_axis_tready[0];
      assign s_axis_tkeep = {s_axis_tkeep_s0,s_axis_tkeep_s1,s_axis_tkeep_s2};
    end else if (SESSION_NUMBER == 4) begin
      assign s_axis_tdata = {s_axis_tdata_s0,s_axis_tdata_s1,s_axis_tdata_s2,s_axis_tdata_s3};
      assign s_axis_tvalid = {s_axis_tvalid_s0,s_axis_tvalid_s1,s_axis_tvalid_s2,s_axis_tvalid_s3};
      assign s_axis_tlast = {s_axis_tlast_s0,s_axis_tlast_s1,s_axis_tlast_s2,s_axis_tlast_s3};
      assign s_axis_tready_s0 = s_axis_tready[3];
      assign s_axis_tready_s1 = s_axis_tready[2];
      assign s_axis_tready_s2 = s_axis_tready[1];
      assign s_axis_tready_s3 = s_axis_tready[0];
      assign s_axis_tkeep = {s_axis_tkeep_s0,s_axis_tkeep_s1,s_axis_tkeep_s2,s_axis_tkeep_s3};
    end else if (SESSION_NUMBER == 5) begin
      assign s_axis_tdata = {s_axis_tdata_s0,s_axis_tdata_s1,s_axis_tdata_s2,s_axis_tdata_s3,s_axis_tdata_s4};
      assign s_axis_tvalid = {s_axis_tvalid_s0,s_axis_tvalid_s1,s_axis_tvalid_s2,s_axis_tvalid_s3,s_axis_tvalid_s4};
      assign s_axis_tlast = {s_axis_tlast_s0,s_axis_tlast_s1,s_axis_tlast_s2,s_axis_tlast_s3,s_axis_tlast_s4};
      assign s_axis_tready_s0 = s_axis_tready[4];
      assign s_axis_tready_s1 = s_axis_tready[3];
      assign s_axis_tready_s2 = s_axis_tready[2];
      assign s_axis_tready_s3 = s_axis_tready[1];
      assign s_axis_tready_s4 = s_axis_tready[0];
      assign s_axis_tkeep = {s_axis_tkeep_s0,s_axis_tkeep_s1,s_axis_tkeep_s2,s_axis_tkeep_s3,s_axis_tkeep_s4};
    end else if (SESSION_NUMBER == 6) begin
      assign s_axis_tdata = {s_axis_tdata_s0,s_axis_tdata_s1,s_axis_tdata_s2,s_axis_tdata_s3,s_axis_tdata_s4,s_axis_tdata_s5};
      assign s_axis_tvalid = {s_axis_tvalid_s0,s_axis_tvalid_s1,s_axis_tvalid_s2,s_axis_tvalid_s3,s_axis_tvalid_s4,s_axis_tvalid_s5};
      assign s_axis_tlast = {s_axis_tlast_s0,s_axis_tlast_s1,s_axis_tlast_s2,s_axis_tlast_s3,s_axis_tlast_s4,s_axis_tlast_s5};
      assign s_axis_tready_s0 = s_axis_tready[5];
      assign s_axis_tready_s1 = s_axis_tready[4];
      assign s_axis_tready_s2 = s_axis_tready[3];
      assign s_axis_tready_s3 = s_axis_tready[2];
      assign s_axis_tready_s4 = s_axis_tready[1];
      assign s_axis_tready_s5 = s_axis_tready[0];
      assign s_axis_tkeep = {s_axis_tkeep_s0,s_axis_tkeep_s1,s_axis_tkeep_s2,s_axis_tkeep_s3,s_axis_tkeep_s4,s_axis_tkeep_s5};
    end else if (SESSION_NUMBER == 7) begin
      assign s_axis_tdata = {s_axis_tdata_s0,s_axis_tdata_s1,s_axis_tdata_s2,s_axis_tdata_s3,s_axis_tdata_s4,s_axis_tdata_s5,s_axis_tdata_s6};
      assign s_axis_tvalid = {s_axis_tvalid_s0,s_axis_tvalid_s1,s_axis_tvalid_s2,s_axis_tvalid_s3,s_axis_tvalid_s4,s_axis_tvalid_s5,s_axis_tvalid_s6};
      assign s_axis_tlast = {s_axis_tlast_s0,s_axis_tlast_s1,s_axis_tlast_s2,s_axis_tlast_s3,s_axis_tlast_s4,s_axis_tlast_s5,s_axis_tlast_s6};
      assign s_axis_tready_s0 = s_axis_tready[6];
      assign s_axis_tready_s1 = s_axis_tready[5];
      assign s_axis_tready_s2 = s_axis_tready[4];
      assign s_axis_tready_s3 = s_axis_tready[3];
      assign s_axis_tready_s4 = s_axis_tready[2];
      assign s_axis_tready_s5 = s_axis_tready[1];
      assign s_axis_tready_s6 = s_axis_tready[0];
      assign s_axis_tkeep = {s_axis_tkeep_s0,s_axis_tkeep_s1,s_axis_tkeep_s2,s_axis_tkeep_s3,s_axis_tkeep_s4,s_axis_tkeep_s5,s_axis_tkeep_s6};
    end else if (SESSION_NUMBER == 8) begin
      assign s_axis_tdata = {s_axis_tdata_s0,s_axis_tdata_s1,s_axis_tdata_s2,s_axis_tdata_s3,s_axis_tdata_s4,s_axis_tdata_s5,s_axis_tdata_s6,s_axis_tdata_s7};
      assign s_axis_tvalid = {s_axis_tvalid_s0,s_axis_tvalid_s1,s_axis_tvalid_s2,s_axis_tvalid_s3,s_axis_tvalid_s4,s_axis_tvalid_s5,s_axis_tvalid_s6,s_axis_tvalid_s7};
      assign s_axis_tlast = {s_axis_tlast_s0,s_axis_tlast_s1,s_axis_tlast_s2,s_axis_tlast_s3,s_axis_tlast_s4,s_axis_tlast_s5,s_axis_tlast_s6,s_axis_tlast_s7};
      assign s_axis_tready_s0 = s_axis_tready[7];
      assign s_axis_tready_s1 = s_axis_tready[6];
      assign s_axis_tready_s2 = s_axis_tready[5];
      assign s_axis_tready_s3 = s_axis_tready[4];
      assign s_axis_tready_s4 = s_axis_tready[3];
      assign s_axis_tready_s5 = s_axis_tready[2];
      assign s_axis_tready_s6 = s_axis_tready[1];
      assign s_axis_tready_s7 = s_axis_tready[0];
      assign s_axis_tkeep = {s_axis_tkeep_s0,s_axis_tkeep_s1,s_axis_tkeep_s2,s_axis_tkeep_s3,s_axis_tkeep_s4,s_axis_tkeep_s5,s_axis_tkeep_s6,s_axis_tkeep_s7};
    end
  endgenerate

  rtp_session_mux_regmap i_regmap (
    .start_video_transfer (start_video_transfer),
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

  up_axi #(
    .AXI_ADDRESS_WIDTH(16)
  ) i_up_axi (
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

  axis_arb_mux #(
    .S_COUNT (SESSION_NUMBER),
    .DATA_WIDTH (S_TDATA_WIDTH),
    .USER_ENABLE (0)
  ) axis_arb_mux_inst (
    .clk(aclk),
    .rst(areset),
    .s_axis_tdata (s_axis_tdata),
    .s_axis_tvalid (s_axis_tvalid),
    .s_axis_tlast (s_axis_tlast),
    .s_axis_tkeep (s_axis_tkeep),
    .s_axis_tready (s_axis_tready),
    .m_axis_tvalid (interconn_m_axis_tvalid),
    .m_axis_tdata (interconn_m_axis_tdata),
    .m_axis_tlast (interconn_m_axis_tlast),
    .m_axis_tkeep (interconn_m_axis_tkeep),
    .m_axis_tready (interconn_m_axis_tready)
  );

  axis_fifo #(
    .DEPTH(262144),
    .DATA_WIDTH (S_TDATA_WIDTH),
    .DEST_ENABLE (0),
    .DEST_WIDTH (1),
    .USER_ENABLE (0),
    .RAM_PIPELINE (8),
    .OUTPUT_FIFO_ENABLE (1),
    .FRAME_FIFO (1))
  storage_cam_data (
    .clk (aclk),
    .rst (areset),
    .s_axis_tdata (interconn_m_axis_tdata),
    .s_axis_tkeep (interconn_m_axis_tkeep),
    .s_axis_tvalid (interconn_m_axis_tvalid),
    .s_axis_tready (interconn_m_axis_tready),
    .s_axis_tlast (interconn_m_axis_tlast),
    .m_axis_tdata (m_axis_tdata),
    .m_axis_tvalid (m_axis_tvalid),
    .m_axis_tready (m_axis_tready),
    .m_axis_tlast (m_axis_tlast),
    .m_axis_tkeep (m_axis_tkeep));

endmodule;
