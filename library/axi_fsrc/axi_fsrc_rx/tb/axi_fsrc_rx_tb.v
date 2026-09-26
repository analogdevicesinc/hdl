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

// Two instances of the same core, one at NUM_CONV = 4 and one at NUM_CONV = 1,
// fed the same sentinel pattern on every converter but a payload range that
// identifies which converter a sample came from.
//
// Checks:
//   - no sample ever appears on a converter other than its own, which is the
//     regression for the scrambling a converter major concatenation produced;
//   - the four internal compactors stay in lockstep, so one data_out_valid can
//     stand for all of them;
//   - converter 0 of the wide instance is bit identical to the narrow instance,
//     so NUM_CONV = 1 still behaves exactly like the core the BU delivered;
//   - enable reaches the datapath through the AXI slave, which is what the
//     missing up_axi instance used to break.

module axi_fsrc_rx_tb;
  parameter VCD_FILE = {"axi_fsrc_rx_tb.vcd"};

  `define TIMEOUT 300000
  `include "../../../common/tb/tb_base.v"

  localparam NP = 16;
  localparam SAMPLES = 4;
  localparam DW = NP * SAMPLES;
  localparam CONV = 4;
  localparam HOLE = {1'b1, {(NP-1){1'b0}}};

  // Converter c carries payloads in [c*4096+1 .. c*4096+4095], so the converter
  // a sample belongs to is readable off the sample itself.
  localparam SPAN = 4096;

  wire resetn = ~reset;

  reg  [DW-1:0] din [0:CONV-1];
  reg           din_valid = 1'b0;
  wire [DW-1:0] dout [0:CONV-1];
  wire          dout_valid;
  wire [DW-1:0] dout_one;
  wire          dout_one_valid;

  // axi slave side, driven by the register write tasks below
  reg          awvalid = 1'b0;
  reg  [15:0]  awaddr = 16'h0;
  reg          wvalid = 1'b0;
  reg  [31:0]  wdata = 32'h0;
  reg          bready = 1'b1;
  wire         awready, wready, bvalid;

  axi_fsrc_rx #(
    .DATA_WIDTH (DW),
    .NP (NP),
    .NUM_CONV (CONV)
  ) i_dut (
    .clk (clk),
    .reset (reset),
    .data_in_0 (din[0]),
    .data_in_1 (din[1]),
    .data_in_2 (din[2]),
    .data_in_3 (din[3]),
    .data_in_4 ({DW{1'b0}}),
    .data_in_5 ({DW{1'b0}}),
    .data_in_6 ({DW{1'b0}}),
    .data_in_7 ({DW{1'b0}}),
    .data_in_valid (din_valid),
    .data_out_0 (dout[0]),
    .data_out_1 (dout[1]),
    .data_out_2 (dout[2]),
    .data_out_3 (dout[3]),
    .data_out_4 (),
    .data_out_5 (),
    .data_out_6 (),
    .data_out_7 (),
    .data_out_valid (dout_valid),
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
    .s_axi_bready (bready),
    .s_axi_arvalid (1'b0),
    .s_axi_araddr (16'h0),
    .s_axi_arprot (3'h0),
    .s_axi_arready (),
    .s_axi_rvalid (),
    .s_axi_rresp (),
    .s_axi_rdata (),
    .s_axi_rready (1'b1));

  // Same stimulus, single converter, sharing the register writes.
  axi_fsrc_rx #(
    .DATA_WIDTH (DW),
    .NP (NP),
    .NUM_CONV (1)
  ) i_dut_one (
    .clk (clk),
    .reset (reset),
    .data_in_0 (din[0]),
    .data_in_1 ({DW{1'b0}}),
    .data_in_2 ({DW{1'b0}}),
    .data_in_3 ({DW{1'b0}}),
    .data_in_4 ({DW{1'b0}}),
    .data_in_5 ({DW{1'b0}}),
    .data_in_6 ({DW{1'b0}}),
    .data_in_7 ({DW{1'b0}}),
    .data_in_valid (din_valid),
    .data_out_0 (dout_one),
    .data_out_1 (),
    .data_out_2 (),
    .data_out_3 (),
    .data_out_4 (),
    .data_out_5 (),
    .data_out_6 (),
    .data_out_7 (),
    .data_out_valid (dout_one_valid),
    .s_axi_aclk (clk),
    .s_axi_aresetn (resetn),
    .s_axi_awvalid (awvalid),
    .s_axi_awaddr (awaddr),
    .s_axi_awprot (3'h0),
    .s_axi_awready (),
    .s_axi_wvalid (wvalid),
    .s_axi_wdata (wdata),
    .s_axi_wstrb (4'hf),
    .s_axi_wready (),
    .s_axi_bvalid (),
    .s_axi_bresp (),
    .s_axi_bready (bready),
    .s_axi_arvalid (1'b0),
    .s_axi_araddr (16'h0),
    .s_axi_arprot (3'h0),
    .s_axi_arready (),
    .s_axi_rvalid (),
    .s_axi_rresp (),
    .s_axi_rdata (),
    .s_axi_rready (1'b1));

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

  localparam EXP_DEPTH = 2048;
  reg [NP-1:0] expected [0:CONV*EXP_DEPTH-1];
  integer wr = 0;
  integer rd = 0;
  integer payload = 1;
  integer enabled = 0;

  integer i;
  integer c;
  reg [SAMPLES-1:0] holes;

  task drive_beat;
    begin
      for (i = 0; i < SAMPLES; i = i + 1) begin
        for (c = 0; c < CONV; c = c + 1) begin
          if (holes[i] == 1'b1) begin
            din[c][i*NP +: NP] = HOLE;
          end else begin
            din[c][i*NP +: NP] = c*SPAN + payload;
          end
        end
        if (holes[i] == 1'b0) begin
          for (c = 0; c < CONV; c = c + 1)
            expected[c*EXP_DEPTH + (wr % EXP_DEPTH)] = c*SPAN + payload;
          wr = wr + 1;
          payload = payload + 1;
          if (payload >= SPAN) payload = 1;
        end
      end
      din_valid = 1'b1;
    end
  endtask

  integer beat = 0;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      din_valid <= 1'b0;
      for (c = 0; c < CONV; c = c + 1) din[c] <= {DW{1'b0}};
    end else if (enabled == 1) begin
      case (beat)
        0: holes = {SAMPLES{1'b0}};
        1: holes = {SAMPLES{1'b1}};
        2: holes = {{(SAMPLES-1){1'b0}}, 1'b1};
        3: holes = {1'b1, {(SAMPLES-1){1'b0}}};
        default: holes = $random;
      endcase
      beat = beat + 1;
      drive_beat;
    end
  end

  initial begin
    while (reset === 1'b1) @(posedge clk);
    // 0x4 bit 0 is the datapath enable. Reaching it at all proves the register
    // map is wired to the AXI slave.
    axi_write(16'h10, 32'h1);
    repeat (8) @(posedge clk);
    enabled = 1;
  end

  // Every sample must land on its own converter, and the converters must agree
  // on when a beat is ready.
  always @(posedge clk) begin
    if (reset == 1'b0 && dout_valid == 1'b1) begin
      for (c = 0; c < CONV; c = c + 1) begin
        for (i = 0; i < SAMPLES; i = i + 1) begin
          if (dout[c][i*NP +: NP] !== expected[c*EXP_DEPTH + ((rd + i) % EXP_DEPTH)]) begin
            $display("ERROR: conv %0d sample %0d: got %h expected %h", c, rd + i,
                     dout[c][i*NP +: NP],
                     expected[c*EXP_DEPTH + ((rd + i) % EXP_DEPTH)]);
            failed <= 1'b1;
          end
          if (dout[c][i*NP +: NP] / SPAN !== c) begin
            $display("ERROR: conv %0d sample %0d came from conv %0d", c, rd + i,
                     dout[c][i*NP +: NP] / SPAN);
            failed <= 1'b1;
          end
        end
      end
      rd = rd + SAMPLES;
    end
  end

  // NUM_CONV = 1 equivalence, and the lockstep check in one comparison.
  always @(posedge clk) begin
    if (reset == 1'b0 && enabled == 1) begin
      if (dout_valid !== dout_one_valid) begin
        $display("ERROR: NUM_CONV=4 valid %b but NUM_CONV=1 valid %b",
                 dout_valid, dout_one_valid);
        failed <= 1'b1;
      end
      if (dout_valid == 1'b1 && dout[0] !== dout_one) begin
        $display("ERROR: NUM_CONV=4 conv 0 %h but NUM_CONV=1 %h", dout[0], dout_one);
        failed <= 1'b1;
      end
    end
  end

  initial begin
    #(`TIMEOUT - 100);
    $display("INFO: pushed %0d samples per converter, checked %0d", wr, rd);
    if (rd < wr - 8*SAMPLES) begin
      $display("ERROR: only %0d of %0d samples came out", rd, wr);
      failed <= 1'b1;
    end
  end

endmodule
