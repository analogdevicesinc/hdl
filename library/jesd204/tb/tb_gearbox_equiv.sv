// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

// Equivalence testbench for the 64b/66b and 66b/64b gearboxes.
//
// The DUTs (gearbox_64b66b / gearbox_66b64b) implement the gear select as a
// funnel (barrel) shift. This TB embeds reference copies of the original 33:1
// mux formulation and drives identical stimulus into DUT and reference,
// checking that the registered outputs match on every cycle.

`timescale 1ns / 100ps
`default_nettype none

module tb_gearbox_equiv;

  localparam int NUM_CYCLES = 100000;

  // Override on the command line with, e.g., +VCD_FILE=foo.vcd
  string vcd_file = "tb_gearbox_equiv.vcd";

  logic clk = 1'b0;
  logic reset;
  logic failed = 1'b0;

  always #5 clk = ~clk;

  initial begin
    void'($value$plusargs("VCD_FILE=%s", vcd_file));
    $dumpfile(vcd_file);
    $dumpvars(0, tb_gearbox_equiv);
  end

  // ---------------------------------------------------------------------------
  // 64b -> 66b
  // ---------------------------------------------------------------------------
  logic [63:0] tx_i_data;

  logic [65:0] tx_o_data_dut;
  logic        tx_o_valid_dut;
  logic [65:0] tx_o_data_ref;
  logic        tx_o_valid_ref;

  gearbox_64b66b i_dut_64b66b (
    .clk     (clk),
    .reset   (reset),
    .i_data  (tx_i_data),
    .o_data  (tx_o_data_dut),
    .o_valid (tx_o_valid_dut));

  gearbox_64b66b_ref i_ref_64b66b (
    .clk     (clk),
    .reset   (reset),
    .i_data  (tx_i_data),
    .o_data  (tx_o_data_ref),
    .o_valid (tx_o_valid_ref));

  // ---------------------------------------------------------------------------
  // 66b -> 64b
  // ---------------------------------------------------------------------------
  logic [65:0] rx_i_data;
  logic        rx_i_valid;

  logic [63:0] rx_o_data_dut;
  logic        rx_o_rd_en_dut;
  logic [63:0] rx_o_data_ref;
  logic        rx_o_rd_en_ref;

  gearbox_66b64b i_dut_66b64b (
    .clk     (clk),
    .reset   (reset),
    .i_data  (rx_i_data),
    .i_valid (rx_i_valid),
    .o_data  (rx_o_data_dut),
    .o_rd_en (rx_o_rd_en_dut));

  gearbox_66b64b_ref i_ref_66b64b (
    .clk     (clk),
    .reset   (reset),
    .i_data  (rx_i_data),
    .i_valid (rx_i_valid),
    .o_data  (rx_o_data_ref),
    .o_rd_en (rx_o_rd_en_ref));

  // ---------------------------------------------------------------------------
  // Stimulus
  // ---------------------------------------------------------------------------
  int cycle;

  initial begin
    reset      = 1'b1;
    tx_i_data  = '0;
    rx_i_data  = '0;
    rx_i_valid = 1'b0;
    repeat (5) @(posedge clk);
    reset = 1'b0;
  end

  // New random inputs every cycle; identical to DUT and reference
  always @(posedge clk) begin
    tx_i_data  <= {$random, $random};
    rx_i_data  <= {$random, $random};
    rx_i_valid <= $random; // exercise the i_valid-gated buffer update
  end

  // ---------------------------------------------------------------------------
  // Checkers (compare one cycle after inputs settle, only when out of reset)
  // ---------------------------------------------------------------------------
  always @(posedge clk) begin
    if (!reset) begin
      // o_valid qualifies o_data for the 64b->66b direction
      if (tx_o_valid_dut !== tx_o_valid_ref) begin
        $error("[64b66b] cycle %0d o_valid mismatch dut=%b ref=%b",
               cycle, tx_o_valid_dut, tx_o_valid_ref);
        failed = 1'b1;
      end
      if (tx_o_valid_ref && (tx_o_data_dut !== tx_o_data_ref)) begin
        $error("[64b66b] cycle %0d o_data mismatch dut=%h ref=%h",
               cycle, tx_o_data_dut, tx_o_data_ref);
        failed = 1'b1;
      end

      if (rx_o_rd_en_dut !== rx_o_rd_en_ref) begin
        $error("[66b64b] cycle %0d o_rd_en mismatch dut=%b ref=%b",
               cycle, rx_o_rd_en_dut, rx_o_rd_en_ref);
        failed = 1'b1;
      end
      if (rx_o_data_dut !== rx_o_data_ref) begin
        $error("[66b64b] cycle %0d o_data mismatch dut=%h ref=%h",
               cycle, rx_o_data_dut, rx_o_data_ref);
        failed = 1'b1;
      end
    end
  end

  initial begin
    cycle = 0;
    @(negedge reset);
    for (cycle = 0; cycle < NUM_CYCLES; cycle = cycle + 1) begin
      @(posedge clk);
    end
    if (failed)
      $display("FAILED");
    else
      $display("SUCCESS: %0d cycles, both gearbox directions equivalent", NUM_CYCLES);
    $finish;
  end

endmodule

// ===========================================================================
// Reference: original 33:1 mux formulation of gearbox_64b66b
// ===========================================================================
module gearbox_64b66b_ref (
  input  wire       clk,
  input  wire       reset,
  input  wire [63:0] i_data,
  output reg  [65:0] o_data,
  output reg        o_valid
);

  reg  [63:0] buff_r;
  reg  [ 5:0] gear_cnt;
  wire        invalid;
  wire [65:0] gears [0:32];

  always @(posedge clk) begin
    buff_r <= i_data;
  end

  always @(posedge clk) begin
    if (reset) begin
      gear_cnt <= 6'd0;
    end else if (gear_cnt[5]) begin
      gear_cnt <= 6'd0;
    end else begin
      gear_cnt <= gear_cnt + 1'b1;
    end
  end

  assign invalid = gear_cnt == 0;

  generate
    genvar i;
    for (i=0; i < 33; i=i+1) begin
      if (i == 0) begin
        assign gears[0] = 66'h0; // invalid, don't care (0 instead of x for compare)
      end else begin
        assign gears[i] = {i_data[2*i-1:0], buff_r[63:2*(i-1)]};
      end
    end
  endgenerate

  always @(posedge clk) begin
    o_data <= gears[gear_cnt];
    o_valid <= ~invalid;
  end

endmodule

// ===========================================================================
// Reference: original 33:1 mux formulation of gearbox_66b64b
// ===========================================================================
module gearbox_66b64b_ref (
  input  wire       clk,
  input  wire       reset,
  input  wire [65:0] i_data,
  input  wire       i_valid,
  output reg  [63:0] o_data,
  output wire       o_rd_en
);

  reg  [65:0] buff_r;
  reg  [ 5:0] gear_cnt;
  wire        pause;
  wire [63:0] gears [0:32];

  always @(posedge clk) begin
    if (i_valid) begin
      buff_r <= i_data;
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      gear_cnt <= 6'd0;
    end else if (gear_cnt[5]) begin
      gear_cnt <= 6'd0;
    end else begin
      gear_cnt <= gear_cnt + 1'b1;
    end
  end

  assign pause = gear_cnt[5];

  generate
    genvar i;
    for (i=0; i < 33; i=i+1) begin
      if (i == 0) begin
        assign gears[0] = i_data[63:0];
      end else if (i == 32) begin
        assign gears[32] = buff_r[65:2];
      end else begin
        assign gears[i] = {i_data[63-2*i:0], buff_r[65:66-2*i]};
      end
    end
  endgenerate

  always @(posedge clk) begin
    o_data <= gears[gear_cnt];
  end

  assign o_rd_en = ~pause;

endmodule

`default_nettype wire
