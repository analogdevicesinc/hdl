// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

// Removes the samples Apollo marked invalid and compacts the beat.
//
// Apollo tags the sample slots its fractional rate converter did not fill with
// FSRC_INVALID_SAMPLE. Every converter on the link is tagged at the same slots -
// the transmit side drives all of them from one accumulator through one
// tx_fsrc_make_holes - so the compaction is identical on every converter and the
// per converter instances below stay in lockstep.
//
// Compaction runs per converter rather than over one flat bus: fill_holes treats
// what it is given as a single run of samples, so a converter major concatenation
// would let one converter's samples slide into another's slots.

module axi_fsrc_rx #(

  // Beat width of a single converter, not of the whole link
  parameter DATA_WIDTH = 512,
  parameter NP = 16,
  parameter NUM_CONV = 1
) (
  input                        clk,
  input                        reset,

  // Converter major: converter i occupies data_in[i*DATA_WIDTH +: DATA_WIDTH].
  // The block design splits this into one port per converter, see
  // library/axi_fsrc/scripts/axi_fsrc.tcl.
  input  [NUM_CONV*DATA_WIDTH-1:0] data_in,
  input                        data_in_valid,

  output [NUM_CONV*DATA_WIDTH-1:0] data_out,
  output                       data_out_valid,

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
  localparam [31:0] CORE_MAGIC = 32'h504c5347;   // Value the existing driver checks

  // internal signals

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

  assign up_clk = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  wire fsrc_enable;

  // One register map for the whole link. enable comes out already
  // synchronised to clk.

  axi_fsrc_rx_regmap #(
    .ID (0),
    .CORE_VERSION (CORE_VERSION),
    .CORE_MAGIC (CORE_MAGIC)
  ) i_rx_regmap (
    .clk (clk),
    .reset (reset),
    .enable (fsrc_enable),
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

  wire [NUM_CONV-1:0] data_out_valid_s;

  generate
  genvar i;
  for (i = 0; i < NUM_CONV; i = i + 1) begin: remove_invalid_gen

    wire [DATA_WIDTH-1:0] conv_data_out;
    wire                  conv_data_out_valid;

    rx_fsrc_remove_invalid #(
      .DATA_WIDTH (DATA_WIDTH),
      .NP (NP)
    ) i_remove_invalid (
      .clk (clk),
      .reset (reset),
      .fsrc_en (fsrc_enable),
      .in_data (data_in[i*DATA_WIDTH+:DATA_WIDTH]),
      .in_valid (data_in_valid),
      .out_data (conv_data_out),
      .out_valid (conv_data_out_valid));

    reg [DATA_WIDTH-1:0] data_out_reg;

    always @(posedge clk) begin
      data_out_reg <= conv_data_out;
    end

    assign data_out[i*DATA_WIDTH+:DATA_WIDTH] = data_out_reg;
    assign data_out_valid_s[i] = conv_data_out_valid;

  end
  endgenerate

  // The instances share reset, enable and in_valid, so converter 0 speaks for
  // all of them.

  reg data_out_valid_reg;

  always @(posedge clk) begin
    data_out_valid_reg <= data_out_valid_s[0];
  end

  assign data_out_valid = data_out_valid_reg;

  up_axi #(
    .AXI_ADDRESS_WIDTH (16)
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

endmodule
