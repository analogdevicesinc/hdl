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

// Starts the FSRC datapath on a sysref aligned cycle and carries the rate
// change word to Apollo.
//
// Software stages a control word, the trigger counts and the accumulator reset
// count, then writes start. From there tx_fsrc_ctrl counts sysref pulses and
// acts on the counts, so the FPGA and Apollo change rate on the same cycle
// without software having to be cycle accurate.
//
// The trigger counts arrive as four bit fields packed four bits apart, which is
// the layout the driver already writes, so they are widened to the counter width
// tx_fsrc_ctrl uses.

module axi_fsrc_sequencer #(
  parameter CTRL_WIDTH = 40,
  parameter COUNTER_WIDTH = 16,
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

  // Width of the packed trigger count fields in the register map. Four bits per
  // trigger, four bits apart, which is what the driver writes.
  localparam REG_COUNTER_WIDTH = 4;

  localparam [31:0] CORE_VERSION = {16'h0000,     /* MAJOR */
                                    8'h01,       /* MINOR */
                                    8'h00};      /* PATCH */
                                                 // 0.01.0
  localparam [31:0] CORE_MAGIC = 32'h46534551;   // FSEQ

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

  // Every register map output below is already synchronised to clk.

  wire                     [31:0] reg_gpio_change_cnt;
  wire                            reg_start;
  wire                            reg_en;
  // Kept so the existing driver's register layout is unchanged. The sequencer
  // core has no corresponding input, so nothing consumes it yet.
  wire                            reg_non_fsrc_delay_en;
  wire [REG_COUNTER_WIDTH-1:0]    reg_accum_reset_cnt;
  wire                            reg_ext_trig_en;
  wire [REG_COUNTER_WIDTH-1:0]    reg_rx_delay_cnt;
  wire        [CTRL_WIDTH-1:0]    reg_ctrl_value;
  wire         [NUM_TRIG-1:0]     reg_trig_out;
  wire [NUM_TRIG-1:0][REG_COUNTER_WIDTH-1:0] reg_first_trig_cnt;
  wire [NUM_TRIG-1:0][REG_COUNTER_WIDTH-1:0] reg_second_trig_cnt;

  axi_fsrc_sequencer_regmap #(
    .ID (0),
    .CORE_VERSION (CORE_VERSION),
    .CORE_MAGIC (CORE_MAGIC),
    .CTRL_WIDTH (CTRL_WIDTH),
    .COUNTER_WIDTH (REG_COUNTER_WIDTH),
    .NUM_TRIG (NUM_TRIG)
  ) i_sequencer_regmap (
    .clk (clk),
    .reset (reset),
    .reg_o_seq_gpio_change_cnt (reg_gpio_change_cnt),
    .reg_o_seq_start (reg_start),
    .reg_o_seq_en (reg_en),
    .reg_o_tx_sequencer_non_fsrc_delay_en (reg_non_fsrc_delay_en),
    .reg_o_seq_tx_accum_reset_cnt (reg_accum_reset_cnt),
    .reg_o_seq_ext_trig_en (reg_ext_trig_en),
    .reg_o_seq_rx_delay_cnt (reg_rx_delay_cnt),
    .reg_o_dut_seq_gpio_w (reg_ctrl_value),
    .reg_o_trig_out (reg_trig_out),
    .reg_o_first_trig_cnt (reg_first_trig_cnt),
    .reg_o_second_trig_cnt (reg_second_trig_cnt),
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

  // start is a level in the register map and already synchronised, so the pulse
  // tx_fsrc_ctrl wants is an edge detect here rather than a clock crossing.

  reg  reg_start_d;
  wire seq_start;

  always @(posedge clk) begin
    if (reset) begin
      reg_start_d <= 1'b0;
    end else begin
      reg_start_d <= reg_start;
    end
  end

  assign seq_start = reg_start & ~reg_start_d & reg_en;

  wire [COUNTER_WIDTH-1:0] seq_ctrl_change_cnt = reg_gpio_change_cnt[COUNTER_WIDTH-1:0];
  wire [COUNTER_WIDTH-1:0] seq_accum_reset_cnt =
    {{(COUNTER_WIDTH-REG_COUNTER_WIDTH){1'b0}}, reg_accum_reset_cnt};
  wire [COUNTER_WIDTH-1:0] seq_rx_delay_cnt =
    {{(COUNTER_WIDTH-REG_COUNTER_WIDTH){1'b0}}, reg_rx_delay_cnt};

  wire [NUM_TRIG-1:0][COUNTER_WIDTH-1:0] seq_first_trig_cnt;
  wire [NUM_TRIG-1:0][COUNTER_WIDTH-1:0] seq_second_trig_cnt;

  generate
  genvar i;
  for (i = 0; i < NUM_TRIG; i = i + 1) begin: trig_cnt_gen
    assign seq_first_trig_cnt[i] =
      {{(COUNTER_WIDTH-REG_COUNTER_WIDTH){1'b0}}, reg_first_trig_cnt[i]};
    assign seq_second_trig_cnt[i] =
      {{(COUNTER_WIDTH-REG_COUNTER_WIDTH){1'b0}}, reg_second_trig_cnt[i]};
  end
  endgenerate

  wire seq_trig_in;

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_trig_in_sync (
    .in_bits (trig_in),
    .out_clk (clk),
    .out_resetn (~reset),
    .out_bits (seq_trig_in));

  // sysref is an asynchronous level; tx_fsrc_ctrl counts single cycle pulses.

  wire seq_sysref;
  reg  seq_sysref_d;
  wire seq_sysref_pulse;

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_sysref_sync (
    .in_bits (sysref),
    .out_clk (clk),
    .out_resetn (~reset),
    .out_bits (seq_sysref));

  always @(posedge clk) begin
    if (reset) begin
      seq_sysref_d <= 1'b0;
    end else begin
      seq_sysref_d <= seq_sysref;
    end
  end

  assign seq_sysref_pulse = seq_sysref & ~seq_sysref_d;

  wire [NUM_TRIG-1:0] seq_trig_out;

  tx_fsrc_ctrl #(
    .CTRL_WIDTH (CTRL_WIDTH),
    .COUNTER_WIDTH (COUNTER_WIDTH),
    .NUM_TRIG (NUM_TRIG)
  ) i_tx_fsrc_ctrl (
    .clk (clk),
    .reset (reset),
    .sysref_int (seq_sysref_pulse),
    .start (seq_start),
    .next_ctrl_value (reg_ctrl_value),
    .ctrl_change_cnt (seq_ctrl_change_cnt),
    .first_trig_cnt (seq_first_trig_cnt),
    .second_trig_cnt (seq_second_trig_cnt),
    .accum_reset_cnt (seq_accum_reset_cnt),
    .rx_delay_cnt (seq_rx_delay_cnt),
    .trig_out (seq_trig_out),
    .seq_trig_in (seq_trig_in),
    .seq_ext_trig_en (reg_ext_trig_en),
    .rx_data_start (rx_data_start),
    .tx_data_start (tx_data_start),
    .ctrl (ctrl));

  // reg_trig_out lets software pulse a trigger without running a sequence,
  // which is how the clock chip channels are calibrated.

  assign trig_out = seq_trig_out | reg_trig_out;

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
