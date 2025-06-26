// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

module axi_fsrc_tx #(
  parameter DATA_WIDTH = 256,
  parameter ACCUM_WIDTH = 64,
  parameter NP = 16
) (
  input                       clk,
  input                       reset,
  input                       tx_data_start,

  input                       s_axis_valid,
  output reg                  s_axis_ready,
  input      [DATA_WIDTH-1:0] s_axis_data,

  output reg                  m_axis_valid,
  input                       m_axis_ready,
  output reg [DATA_WIDTH-1:0] m_axis_data,

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
  input                   s_axi_rready
);

  localparam [31:0] CORE_VERSION = {16'h0000,     /* MAJOR */
                                     8'h01,       /* MINOR */
                                     8'h00};      /* PATCH */
                                                  // 0.01.0
  localparam [31:0] CORE_MAGIC = 32'h504c5347;    // FSRC

  localparam NUM_SAMPLES = DATA_WIDTH / NP;

  // internal signals

  wire        up_clk;
  wire        up_rstn;
  wire        up_rreq_s;
  wire        up_wack_s;
  wire        up_rack_s;
  wire [13:0] up_raddr_s;
  wire [31:0] up_rdata_s;
  wire        up_wreq_s;
  wire [13:0] up_waddr_s;
  wire [31:0] up_wdata_s;

  wire        enable;
  wire        stop;
  wire        start;
  wire        accum_set;
  wire [15:0] conv_mask;
  wire [ACCUM_WIDTH-1:0] accum_add_val;
  wire [NUM_SAMPLES-1:0][ACCUM_WIDTH-1:0] accum_set_val;

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

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
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));

  axi_fsrc_tx_regmap #(
    .ID (0),
    .CORE_VERSION (CORE_VERSION),
    .CORE_MAGIC (CORE_MAGIC),
    .ACCUM_WIDTH (ACCUM_WIDTH),
    .NUM_SAMPLES (NUM_SAMPLES)
  ) i_regmap (
    .clk (clk),
    .reset (reset),
    .enable (enable),
    .start (start),
    .stop (stop),
    .change_rate (),
    .accum_set (accum_set),
    .conv_mask (conv_mask),
    .accum_add_val (accum_add_val),
    .accum_set_val (accum_set_val),

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

  wire                   data_in_ready_s;
  wire                   data_out_valid_s;
  wire [DATA_WIDTH-1:0]  data_out_s;

  wire [NUM_SAMPLES-1:0][NP-1:0] data_in_per_converter;
  wire [NUM_SAMPLES-1:0][NP-1:0] data_out_per_converter;

  /* Map a flat array to a 2d array (needed by the tx_fsrc) and vice-versa */
  genvar ii;
  for (ii = 0; ii < NUM_SAMPLES; ii = ii + 1) begin
    assign data_in_per_converter[ii] = s_axis_data[ii*NP+:NP];
    assign data_out_s[ii*NP+:NP] = data_out_per_converter[ii];
  end

  tx_fsrc #(
    .NP (NP),
    .DATA_WIDTH (DATA_WIDTH),
    .ACCUM_WIDTH (ACCUM_WIDTH),
    .NUM_SAMPLES (NUM_SAMPLES)
  ) i_tx_fsrc (
    .clk (clk),
    .reset (reset),

    .enable (enable),
    .start(tx_data_start | start),
    .stop (stop),
    .conv_mask (conv_mask),
    .accum_set_val (accum_set_val),
    .accum_set (accum_set),
    .accum_add_val (accum_add_val),

    .in_ready (data_in_ready_s),
    .in_data (data_in_per_converter),
    .in_valid (s_axis_valid),

    .out_data (data_out_per_converter),
    .out_valid (data_out_valid_s),
    .out_ready (m_axis_ready));

  always @(posedge clk) begin
    m_axis_data <= data_out_s;
    m_axis_valid <= data_out_valid_s;
    s_axis_ready <= data_in_ready_s;
  end

endmodule