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

// Inserts the invalid samples Apollo's interpolator discards.
//
// A phase accumulator picks which sample slots of each beat carry no data;
// tx_fsrc_make_holes opens those slots and marks them FSRC_INVALID_SAMPLE. One
// accumulator serves every converter, so the holes land at the same slots on all
// of them and the receive side can compact each converter independently.
//
// Opening holes reduces how many samples per beat the source may deliver, so
// this core back-pressures: in_ready is a real ready and the source must honour
// it. util_upack2 cannot - its fifo_rd_en is a pull with one cycle of latency and
// no hold - so the block design puts a lookahead FIFO between them.

module axi_fsrc_tx #(

  // Beat width of a single converter, not of the whole link
  parameter DATA_WIDTH = 512,
  parameter NP = 16,
  parameter MAX_CONV = 8,
  parameter ACCUM_WIDTH = 64
) (
  input                        clk,
  input                        reset,
  input                        tx_data_start,

  // Converter major: converter i occupies data_in[i*DATA_WIDTH +: DATA_WIDTH].
  // The block design splits this into one port per converter, see
  // library/axi_fsrc/scripts/axi_fsrc.tcl.
  input      [MAX_CONV*DATA_WIDTH-1:0] data_in,
  input                        data_in_valid,
  output                       data_in_ready,

  output     [MAX_CONV*DATA_WIDTH-1:0] data_out,
  output                       data_out_valid,
  input                        data_out_ready,

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

  localparam NUM_SAMPLES = DATA_WIDTH / NP;

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

  // Every register map output below is already synchronised to clk, and the
  // single cycle controls are already edge detected there.

  wire                     fsrc_enable;
  wire                     fsrc_ext_trig_en;
  wire                     fsrc_start;
  wire                     fsrc_stop;
  wire                     fsrc_change_rate;
  wire                     fsrc_accum_set;
  wire              [15:0] fsrc_conv_mask;
  wire   [ACCUM_WIDTH-1:0] fsrc_accum_add_val;
  wire   [ACCUM_WIDTH-1:0] fsrc_accum_step_val;
  wire   [7:0]             fsrc_group_beats_m1;
  wire   [7:0]             fsrc_group_start;
  wire [NUM_SAMPLES-1:0][ACCUM_WIDTH-1:0] fsrc_accum_set_val;

  wire              [31:0] fsrc_debug_flags;

  axi_fsrc_tx_regmap #(
    .ID (0),
    .CORE_VERSION (CORE_VERSION),
    .CORE_MAGIC (CORE_MAGIC),
    .ACCUM_WIDTH (ACCUM_WIDTH),
    .NUM_SAMPLES (NUM_SAMPLES)
  ) i_tx_regmap (
    .clk (clk),
    .reset (reset),
    .enable (fsrc_enable),
    .ext_trig_en (fsrc_ext_trig_en),
    .start (fsrc_start),
    .stop (fsrc_stop),
    .change_rate (fsrc_change_rate),
    .accum_set (fsrc_accum_set),
    .conv_mask (fsrc_conv_mask),
    .accum_add_val (fsrc_accum_add_val),
    .accum_step_val (fsrc_accum_step_val),
    .group_beats_m1 (fsrc_group_beats_m1),
    .group_start (fsrc_group_start),
    .accum_set_val (fsrc_accum_set_val),
    .debug_flags (fsrc_debug_flags),
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

  wire [MAX_CONV-1:0] conv_mask = fsrc_conv_mask[MAX_CONV-1:0];

  // Data may start either on the sequencer's sysref aligned pulse or on a
  // register write, so software can bring the path up without a sequencer.

  wire data_start = tx_data_start | (fsrc_start & ~fsrc_ext_trig_en);

  reg fsrc_data_en;

  always @(posedge clk) begin
    if (reset) begin
      fsrc_data_en <= 1'b0;
    end else begin
      if (fsrc_stop) begin
        fsrc_data_en <= 1'b0;
      end else if (data_start) begin
        fsrc_data_en <= 1'b1;
      end
    end
  end

  wire [MAX_CONV-1:0][DATA_WIDTH-1:0] fsrc_in_data;
  wire [MAX_CONV-1:0][DATA_WIDTH-1:0] fsrc_out_data;
  wire [MAX_CONV-1:0]                 fsrc_in_ready;
  wire [MAX_CONV-1:0]                 fsrc_out_valid;

  assign fsrc_in_data = data_in;

  tx_fsrc #(
    .NP (NP),
    .DATA_WIDTH (DATA_WIDTH),
    .MAX_CONV (MAX_CONV),
    .ACCUM_WIDTH (ACCUM_WIDTH)
  ) i_tx_fsrc (
    .clk (clk),
    .reset (reset),

    .fsrc_en (fsrc_enable),
    .fsrc_data_en (fsrc_data_en),
    .conv_mask (conv_mask),
    .accum_set_val (fsrc_accum_set_val),
    .accum_set (fsrc_accum_set),
    .accum_add_val (fsrc_accum_add_val),
    .accum_step_val (fsrc_accum_step_val),
    .group_beats_m1 (fsrc_group_beats_m1),
    .group_start (fsrc_group_start),

    .in_ready (fsrc_in_ready),
    .in_data (fsrc_in_data),
    .in_valid ({MAX_CONV{data_in_valid}} & conv_mask),

    .out_data (fsrc_out_data),
    .out_valid (fsrc_out_valid),
    .out_ready ({MAX_CONV{data_out_ready}}));

  // The converters move together, so the scalar handshake the transport layer
  // and the gearbox use is the handshake of every enabled converter.

  assign data_in_ready  = &(fsrc_in_ready  | ~conv_mask);
  assign data_out_valid = &(fsrc_out_valid | ~conv_mask);

  assign data_out = fsrc_out_data;

  assign fsrc_debug_flags = {28'h0,
                             fsrc_data_en,
                             fsrc_change_rate,
                             data_in_ready,
                             data_out_valid};

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
