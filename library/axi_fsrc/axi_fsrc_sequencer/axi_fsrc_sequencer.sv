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

module axi_fsrc_sequencer #(
  parameter CTRL_WIDTH = 40,
  parameter COUNTER_WIDTH = 4,
  parameter NUM_TRIG = 4
) (
  input                   clk,
  input                   reset,
  input                   sysref,
  input                   trig_in,
  output [NUM_TRIG-1:0]   trig_out,
  output                  rx_data_start,
  output                  tx_data_start,
  output [CTRL_WIDTH-1:0] ctrl,

  output                  tx_sequencer_non_fsrc_delay_en,
  output                  seq_debug,

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

  assign seq_debug = 1'b0;

  localparam [31:0] CORE_VERSION = {16'h0000,     /* MAJOR */
                                    8'h01,        /* MINOR */
                                    8'h00};       /* PATCH */
                                                  // 0.01.0
  localparam [31:0] CORE_MAGIC = 32'h46534551;    // FSEQ

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

  wire [CTRL_WIDTH-1:0]    fsrc_next_ctrl_value;
  wire [COUNTER_WIDTH-1:0] fsrc_ctrl_change_cnt;
  wire [COUNTER_WIDTH-1:0] fsrc_accum_reset_cnt;
  wire [COUNTER_WIDTH-1:0] fsrc_rx_delay_cnt;
  wire                     fsrc_seq_ext_trig_en;
  wire                     fsrc_reg_start;
  wire                     seq_en;
  wire                     fsrc_trig_in;
  wire [NUM_TRIG-1:0]      fsrc_trig_out;
  wire [NUM_TRIG-1:0]      seq_trig_out;

  wire [NUM_TRIG-1:0] [COUNTER_WIDTH-1:0] fsrc_first_trig_cnt;

  assign trig_out = seq_en ? fsrc_trig_out : seq_trig_out;

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

  axi_fsrc_sequencer_regmap #(
    .ID (0),
    .CORE_VERSION (CORE_VERSION),
    .CORE_MAGIC (CORE_MAGIC),
    .COUNTER_WIDTH (COUNTER_WIDTH),
    .NUM_TRIG (NUM_TRIG)
  ) i_regmap (
    .clk (clk),
    .reset (reset),

    .reg_o_seq_gpio_change_cnt (fsrc_ctrl_change_cnt),

    .reg_o_seq_start (fsrc_reg_start),
    .reg_o_seq_en (seq_en),
    .reg_o_tx_sequencer_non_fsrc_delay_en (tx_sequencer_non_fsrc_delay_en),
    .reg_o_seq_tx_accum_reset_cnt (fsrc_accum_reset_cnt),

    .reg_o_seq_ext_trig_en (fsrc_seq_ext_trig_en),
    .reg_o_seq_rx_delay_cnt (fsrc_rx_delay_cnt),

    .reg_o_dut_seq_gpio_w (fsrc_next_ctrl_value),
    .reg_o_trig_out (seq_trig_out),

    .reg_o_first_trig_cnt (fsrc_first_trig_cnt),
    .reg_o_second_trig_cnt (fsrc_second_trig_cnt),
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

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) fsrc_trig_sync (
    .in_bits(seq_ext_trig_s),
    .out_clk(clk),
    .out_resetn(~reset),
    .out_bits(fsrc_trig_in));

  tx_fsrc_ctrl #(
    .CTRL_WIDTH (CTRL_WIDTH),
    .COUNTER_WIDTH (COUNTER_WIDTH),
    .NUM_TRIG (NUM_TRIG)
  ) tx_fsrc_sequencer (
    .clk (clk),
    .reset (reset),
    .sysref_int (sysref),
    .reg_start (fsrc_reg_start),
    .next_ctrl_value (fsrc_next_ctrl_value),
    .ctrl_change_cnt (fsrc_ctrl_change_cnt),
    .first_trig_cnt (fsrc_first_trig_cnt),
    .second_trig_cnt (fsrc_second_trig_cnt),
    .accum_reset_cnt (fsrc_accum_reset_cnt),
    .rx_delay_cnt (fsrc_rx_delay_cnt),
    .trig_out (fsrc_trig_out),
    .seq_trig_in (fsrc_trig_in),
    .seq_ext_trig_en (fsrc_seq_ext_trig_en),
    .rx_data_start (rx_data_start),
    .tx_data_start (tx_data_start),
    .ctrl (ctrl));

  assign seq_ext_trig_s = trig_in;

endmodule