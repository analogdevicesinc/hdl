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

// The whole transmit chain FSRC sits in: util_upack2's pull interface, the
// lookahead FIFO that turns it into a real AXI stream, the gearbox that resizes
// a pack beat into a transport layer beat, and axi_fsrc_tx opening the sentinel
// holes at the end of it.
//
// FSRC is the first thing on this path that can refuse a beat, so the chain only
// works if the back-pressure reaches all the way to upack. Building it with
// -DNO_LOOKAHEAD wires the gearbox straight to upack's fifo_rd_en, which is the
// mistake the FIFO exists to prevent, and the run then fails on lost samples.
//
// The register writes are the sequence the driver performs, so this also covers
// the register map reaching the datapath over the AXI slave.

module tx_chain_tb;
  parameter VCD_FILE = {"tx_chain_tb.vcd"};

  `define TIMEOUT 200000

  localparam SW = 16;
  localparam CONV = 2;
  localparam MAX_CONV = 8;
  localparam PACK_SAMPLES = 32;
  localparam TPL_SAMPLES = 24;
  localparam PACK_DW = SW * PACK_SAMPLES;
  localparam TPL_DW = SW * TPL_SAMPLES;
  localparam BUS_DW = PACK_DW * CONV;
  localparam AW = 32;
  localparam HOLE = {1'b1, {(SW-1){1'b0}}};
  localparam real RATIO = 0.75;

  `include "../../../common/tb/tb_base.v"

  wire resetn = ~reset;
  integer running = 0;

  // Sample n of converter c, so a misrouted beat cannot look correct.
  function [SW-1:0] sample;
    input integer c;
    input integer n;
    sample = {1'b0, c[1:0], n[SW-4:0]};
  endfunction

  // ---------------------------------------------------------------- upack
  //
  // util_upack2_impl.v behaviour: fifo_rd_data and fifo_rd_valid only update
  // when fifo_rd_en was high on the previous edge, and fifo_rd_valid falls when
  // it was not. There is no hold, so whoever asked has to take the answer.
  wire              rd_en;
  reg               rd_valid = 1'b0;
  reg  [BUS_DW-1:0] rd_data = {BUS_DW{1'b0}};
  reg  [31:0]       rd_word = 32'd0;

  reg  [BUS_DW-1:0] next_data;
  integer c, j;
  always @(*) begin
    for (c = 0; c < CONV; c = c + 1)
      for (j = 0; j < PACK_SAMPLES; j = j + 1)
        next_data[c*PACK_DW + j*SW +: SW] = sample(c, rd_word*PACK_SAMPLES + j);
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      rd_valid <= 1'b0;
      rd_word <= 32'd0;
    end else if (rd_en == 1'b1) begin
      rd_valid <= 1'b1;
      rd_data <= next_data;
      rd_word <= rd_word + 1;
    end else begin
      rd_valid <= 1'b0;
    end
  end

  // ------------------------------------------------------- lookahead FIFO
  wire              fifo_s_almost_full;
  wire              fifo_m_valid;
  wire              fifo_m_ready;
  wire [BUS_DW-1:0] fifo_m_data;

  wire              gb_in_valid;
  wire [BUS_DW-1:0] gb_in_data;
  wire [CONV-1:0]   gb_s_ready;

`ifdef NO_LOOKAHEAD
  assign rd_en = running && gb_s_ready[0];
  assign gb_in_valid = rd_valid;
  assign gb_in_data = rd_data;
`else
  assign rd_en = running && ~fifo_s_almost_full;
  assign gb_in_valid = fifo_m_valid;
  assign gb_in_data = fifo_m_data;
`endif

  util_axis_fifo #(
    .DATA_WIDTH (BUS_DW),
    .ADDRESS_WIDTH (3),
    .ASYNC_CLK (0),
    .ALMOST_FULL_THRESHOLD (2)
  ) i_fifo (
    .s_axis_aclk (clk),
    .s_axis_aresetn (resetn),
    .s_axis_valid (rd_valid),
    .s_axis_ready (),
    .s_axis_data (rd_data),
    .s_axis_tkeep ({BUS_DW/8{1'b1}}),
    .s_axis_tlast (1'b0),
    .s_axis_room (),
    .s_axis_full (),
    .s_axis_almost_full (fifo_s_almost_full),

    .m_axis_aclk (clk),
    .m_axis_aresetn (resetn),
    .m_axis_ready (fifo_m_ready),
    .m_axis_valid (fifo_m_valid),
    .m_axis_data (fifo_m_data),
    .m_axis_tkeep (),
    .m_axis_tlast (),
    .m_axis_level (),
    .m_axis_empty (),
    .m_axis_almost_empty ());

  assign fifo_m_ready = gb_s_ready[0];

  // ----------------------------------------------------------- gearboxes
  wire [CONV-1:0]        gb_m_valid;
  wire [CONV*TPL_DW-1:0] gb_m_data;
  wire                   fsrc_in_ready;

  genvar i;
  generate
  for (i = 0; i < CONV; i = i + 1) begin : g_conv
    util_axis_gearbox #(
      .S_DATA_WIDTH (PACK_DW),
      .M_DATA_WIDTH (TPL_DW)
    ) i_gearbox (
      .clk (clk),
      .resetn (resetn),
      .s_axis_valid (gb_in_valid),
      .s_axis_ready (gb_s_ready[i]),
      .s_axis_data (gb_in_data[i*PACK_DW +: PACK_DW]),
      .m_axis_valid (gb_m_valid[i]),
      .m_axis_ready (fsrc_in_ready),
      .m_axis_data (gb_m_data[i*TPL_DW +: TPL_DW]));
  end
  endgenerate

  // -------------------------------------------------------------- axi_fsrc_tx
  wire [CONV*TPL_DW-1:0] fsrc_out_data;
  wire                   fsrc_out_valid;
  reg                    fsrc_out_ready = 1'b1;

  reg          awvalid = 1'b0;
  reg  [15:0]  awaddr = 16'h0;
  reg          wvalid = 1'b0;
  reg  [31:0]  wdata = 32'h0;
  wire         awready, wready, bvalid;

  axi_fsrc_tx #(
    .DATA_WIDTH (TPL_DW),
    .NP (SW),
    .MAX_CONV (MAX_CONV),
    .ACCUM_WIDTH (AW)
  ) i_dut (
    .clk (clk),
    .reset (reset),
    .tx_data_start (1'b0),
    .data_in_0 (gb_m_data[0*TPL_DW +: TPL_DW]),
    .data_in_1 (gb_m_data[1*TPL_DW +: TPL_DW]),
    .data_in_2 ({TPL_DW{1'b0}}),
    .data_in_3 ({TPL_DW{1'b0}}),
    .data_in_4 ({TPL_DW{1'b0}}),
    .data_in_5 ({TPL_DW{1'b0}}),
    .data_in_6 ({TPL_DW{1'b0}}),
    .data_in_7 ({TPL_DW{1'b0}}),
    .data_in_valid (gb_m_valid[0]),
    .data_in_ready (fsrc_in_ready),
    .data_out_0 (fsrc_out_data[0*TPL_DW +: TPL_DW]),
    .data_out_1 (fsrc_out_data[1*TPL_DW +: TPL_DW]),
    .data_out_2 (),
    .data_out_3 (),
    .data_out_4 (),
    .data_out_5 (),
    .data_out_6 (),
    .data_out_7 (),
    .data_out_valid (fsrc_out_valid),
    .data_out_ready (fsrc_out_ready),
    .s_axi_aclk (clk),
    .s_axi_aresetn (resetn),
    .s_axi_awvalid (awvalid),
    .s_axi_awaddr (awaddr),
    .s_axi_awprot (3'h0),
    .s_axi_awready (awready),
    .s_axi_wvalid (wvalid),
    .s_axi_wdata (wdata),
    .s_axi_wstrb (4'hf),
    .s_axi_wready (wready),
    .s_axi_bvalid (bvalid),
    .s_axi_bresp (),
    .s_axi_bready (1'b1),
    .s_axi_arvalid (1'b0),
    .s_axi_araddr (16'h0),
    .s_axi_arprot (3'h0),
    .s_axi_arready (),
    .s_axi_rvalid (),
    .s_axi_rresp (),
    .s_axi_rdata (),
    .s_axi_rready (1'b1));

  // ------------------------------------------------------- register writes
  task axi_write;
    input [15:0] addr;
    input [31:0] data;
    begin
      @(posedge clk);
      awaddr <= addr;
      wdata <= data;
      awvalid <= 1'b1;
      wvalid <= 1'b1;
      @(posedge clk);
      while (awready !== 1'b1 || wready !== 1'b1) @(posedge clk);
      awvalid <= 1'b0;
      wvalid <= 1'b0;
      while (bvalid !== 1'b1) @(posedge clk);
      @(posedge clk);
    end
  endtask

  integer k;
  reg [AW-1:0] set_val;
  reg [AW-1:0] add_val;

  initial begin
    while (reset === 1'b1) @(posedge clk);
    add_val = $rtoi(RATIO * (2.0 ** AW));
    // 0x6 converter mask, 0x7/0x8 accumulator increment.
    axi_write(16'h18, 32'h3);
    axi_write(16'h1c, add_val);
    axi_write(16'h20, 32'h0);
    // 0xe/0xf accumulator step per beat, here the same as the increment.
    axi_write(16'h38, add_val);
    axi_write(16'h3c, 32'h0);
    // One accumulator preset per sample slot, value at 0xa/0xb then slot at 0x9.
    for (k = 0; k < TPL_SAMPLES; k = k + 1) begin
      set_val = $rtoi((k * (2.0 ** AW)) / TPL_SAMPLES);
      axi_write(16'h28, set_val);
      axi_write(16'h2c, 32'h0);
      axi_write(16'h24, k);
    end
    // 0x4 enable, then 0x5 accumulator set and start.
    axi_write(16'h10, 32'h1);
    axi_write(16'h14, 32'h4);
    axi_write(16'h14, 32'h1);
    running = 1;
  end

  // Sink stalls at random, so the back-pressure has to travel the whole chain.
  always @(posedge clk) begin
    if (reset == 1'b0) fsrc_out_ready <= ($random % 6) != 0;
  end

  // ------------------------------------------------------------- checking
  // The lookahead FIFO can hand out one stale beat at start up: its RAM is read
  // on the same edge the first word is written, so the first beat is whatever the
  // RAM held. The stream is then continuous, so the check latches where the good
  // data begins and requires strict order from there, and refuses a start point
  // further in than that single beat's worth of samples.
  integer started = 0;
  integer base = 0;
  integer out_count = 0;
  integer slots = 0;
  integer holes = 0;
  integer lost = 0;
  reg [SW-1:0] got_sample;
  reg [SW-1:0] want_sample;
  real         ratio_got;

  always @(posedge clk) begin
    if (reset == 1'b0 && running == 1 &&
        fsrc_out_valid == 1'b1 && fsrc_out_ready == 1'b1) begin
      for (j = 0; j < TPL_SAMPLES; j = j + 1) begin
        slots = slots + 1;
        if (fsrc_out_data[0*TPL_DW + j*SW +: SW] === HOLE) begin
          holes = holes + 1;
          // The hole has to be a hole on every converter or the receive side
          // cannot compact them independently.
          if (fsrc_out_data[1*TPL_DW + j*SW +: SW] !== HOLE) begin
            $display("ERROR: slot %0d is a hole on conv 0 but not on conv 1", j);
            failed <= 1'b1;
          end
        end else begin
          if (started == 0) begin
            got_sample = fsrc_out_data[0*TPL_DW + j*SW +: SW];
            if (got_sample[SW-1] === 1'b0 && (^got_sample) !== 1'bx) begin
              started = 1;
              base = got_sample[SW-4:0];
              if (base > PACK_SAMPLES) begin
                $display("ERROR: stream starts at sample %0d, more than one beat was lost", base);
                failed <= 1'b1;
              end
            end
          end
          for (c = 0; c < CONV; c = c + 1) begin
            got_sample = fsrc_out_data[c*TPL_DW + j*SW +: SW];
            want_sample = sample(c, base + out_count);
            if (started == 1 && got_sample !== want_sample) begin
              if (lost == 0)
                $display("ERROR: conv %0d sample %0d: got %h expected %h - samples were lost",
                         c, out_count, got_sample, want_sample);
              lost = lost + 1;
              failed <= 1'b1;
            end
          end
          if (started == 1) out_count = out_count + 1;
        end
      end
    end
  end

  initial begin
    #(`TIMEOUT - 100);
    ratio_got = (slots - holes) * 1.0 / slots;
    $display("INFO: %0d samples delivered over %0d slots, %f real, expected %f",
             out_count, slots, ratio_got, RATIO);
    if (started == 0 || out_count == 0) begin
      $display("ERROR: no data reached the transport layer");
      failed <= 1'b1;
    end
    if (ratio_got > RATIO + 0.02 || ratio_got < RATIO - 0.02) begin
      $display("ERROR: delivered sample rate does not match the accumulator ratio");
      failed <= 1'b1;
    end
  end

endmodule
