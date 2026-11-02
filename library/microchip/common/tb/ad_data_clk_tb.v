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

`timescale 1ns/1ps

// ad_data_clk:
//   1. locked is high in every configuration (after the delay is loaded).
//   2. CLK_MODE 0: clk and clk_div are the input clock.
//   3. CLK_MODE 1 without the delay line: clk follows the input, clk_div is
//      the input divided by 1, 2, 3.5, 4 and 5.
//   4. CLK_MODE 1 with a static delay (IODELAY_MODE 1): clk is delayed against
//      the input (measured), clk_div is not; also with a divider of 4.
//   5. CLK_MODE 2 (divider 4, IODELAY_MODE 2): hs_clk_rx and hs_clk_fifo run
//      at the input rate, clk_div at a quarter of it; rst stops clk_div only.
//   6. CLK_MODE 2 delay sweep: hs_clk_rx is delayed more with every code on
//      the up_clk interface, hs_clk_fifo is not delayed.

module ad_data_clk_tb;

  localparam real IN_HALF_PERIOD_NS = 2.0;
  localparam integer CYCLES = 70;
  localparam [7:0] DELAY_CFG = 8'd7;
  localparam integer SWEEP_CODES = 8;

  reg clk_in = 1'b0;
  always #(IN_HALF_PERIOD_NS) clk_in = ~clk_in;

  reg up_clk = 1'b0;
  always #5 up_clk = ~up_clk;

  // 0 bypass, 1..5 divided by 1, 2, 3.5, 4, 5 without delay, 6 divided by 1
  // with delay, 7 divided by 4 with delay

  localparam integer N = 8;

  wire [N-1:0] clk;
  wire [N-1:0] clk_div;
  wire [N-1:0] locked;

  ad_data_clk #(
    .SINGLE_ENDED (1),
    .CLK_MODE (0)
  ) i_bypass (
    .rst (1'b0),
    .locked (locked[0]),
    .clk_in_p (clk_in),
    .clk_in_n (1'b0),
    .clk (clk[0]),
    .clk_div (clk_div[0]),
    .hs_clk_rx (),
    .hs_clk_fifo (),
    .up_clk (up_clk),
    .up_dld (1'b0),
    .up_dwdata (5'd0),
    .up_drdata (),
    .delay_clk (up_clk),
    .delay_rst (1'b0));

  genvar i;
  generate
  for (i = 1; i < N; i = i + 1) begin: g_icb
    localparam [2:0] DIVIDER =
      (i == 1) ? 3'b001 : (i == 2) ? 3'b010 : (i == 3) ? 3'b111 :
      (i == 4) ? 3'b100 : (i == 5) ? 3'b101 : (i == 6) ? 3'b001 : 3'b100;

    ad_data_clk #(
      .SINGLE_ENDED (1),
      .CLK_MODE (1),
      .CLK_DIVIDER (DIVIDER),
      .IODELAY_MODE ((i >= 6) ? 1 : 0),
      .IOD_DELAY_INIT (DELAY_CFG)
    ) i_clk (
      .rst (1'b0),
      .locked (locked[i]),
      .clk_in_p (clk_in),
      .clk_in_n (1'b0),
      .clk (clk[i]),
      .clk_div (clk_div[i]),
      .hs_clk_rx (),
      .hs_clk_fifo (),
      .up_clk (up_clk),
      .up_dld (1'b0),
      .up_dwdata (5'd0),
      .up_drdata (),
      .delay_clk (up_clk),
      .delay_rst (1'b0));
  end
  endgenerate

  // the serdes clock tree

  reg s_rst = 1'b0;
  reg s_dld = 1'b0;
  reg [4:0] s_dwdata = 5'd0;
  wire [4:0] s_drdata;
  wire s_locked;
  wire s_hs_clk_rx;
  wire s_hs_clk_fifo;
  wire s_clk_div;

  ad_data_clk #(
    .SINGLE_ENDED (1),
    .CLK_MODE (2),
    .CLK_DIVIDER (3'b100),
    .IODELAY_MODE (2),
    .IOD_DELAY_INIT (8'd0)
  ) i_serdes_clk (
    .rst (s_rst),
    .locked (s_locked),
    .clk_in_p (clk_in),
    .clk_in_n (1'b0),
    .clk (),
    .clk_div (s_clk_div),
    .hs_clk_rx (s_hs_clk_rx),
    .hs_clk_fifo (s_hs_clk_fifo),
    .up_clk (up_clk),
    .up_dld (s_dld),
    .up_dwdata (s_dwdata),
    .up_drdata (s_drdata),
    .delay_clk (up_clk),
    .delay_rst (1'b0));

  // the expected clk_div edges in CYCLES input cycles (x2 for 3.5)

  function integer div_edges;
    input integer k;
    begin
      case (k)
        2: div_edges = CYCLES / 2;
        3: div_edges = (CYCLES * 2) / 7;
        4, 7: div_edges = CYCLES / 4;
        5: div_edges = CYCLES / 5;
        default: div_edges = CYCLES;
      endcase
    end
  endfunction

  // rising edges counted and the last rising edge times

  reg count = 1'b0;
  integer clk_edges [0:N-1];
  integer div_edges_n [0:N-1];
  realtime clk_last [0:N-1];
  realtime div_last [0:N-1];

  generate
  for (i = 0; i < N; i = i + 1) begin: g_mon
    initial begin
      clk_edges[i] = 0;
      div_edges_n[i] = 0;
      clk_last[i] = 0;
      div_last[i] = 0;
    end
    always @(posedge clk[i]) begin
      clk_last[i] = $realtime;
      if (count) clk_edges[i] = clk_edges[i] + 1;
    end
    always @(posedge clk_div[i]) begin
      div_last[i] = $realtime;
      if (count) div_edges_n[i] = div_edges_n[i] + 1;
    end
  end
  endgenerate

  integer s_rx_edges = 0;
  integer s_fifo_edges = 0;
  integer s_div_edges = 0;
  realtime s_rx_last = 0;
  realtime s_fifo_last = 0;

  always @(posedge s_hs_clk_rx) begin
    s_rx_last = $realtime;
    if (count) s_rx_edges = s_rx_edges + 1;
  end
  always @(posedge s_hs_clk_fifo) begin
    s_fifo_last = $realtime;
    if (count) s_fifo_edges = s_fifo_edges + 1;
  end
  always @(posedge s_clk_div) begin
    if (count) s_div_edges = s_div_edges + 1;
  end

  integer k;
  integer c;
  integer lock_wait;
  realtime t_in;
  realtime rx_delay;
  realtime fifo_delay;
  realtime clk_delay [0:N-1];
  realtime div_delay [0:N-1];
  realtime rx_delay_prev;
  realtime fifo_delay_0;

  // the rising edges of all the clocks in CYCLES input cycles

  task count_edges;
    begin
      @(negedge clk_in);
      s_rx_edges = 0;
      s_fifo_edges = 0;
      s_div_edges = 0;
      for (k = 0; k < N; k = k + 1) begin
        clk_edges[k] = 0;
        div_edges_n[k] = 0;
      end
      count = 1'b1;
      repeat (CYCLES) @(posedge clk_in);
      #(IN_HALF_PERIOD_NS / 2.0);
      count = 1'b0;
    end
  endtask

  // the delay of hs_clk_rx and hs_clk_fifo against the input, from the last
  // rising edge within half an input period

  task measure_serdes_delay;
    begin
      @(posedge clk_in);
      t_in = $realtime;
      #(IN_HALF_PERIOD_NS - 0.01);
      rx_delay = s_rx_last - t_in;
      fifo_delay = s_fifo_last - t_in;
    end
  endtask

  initial begin
    // the delay lines are loaded after reset, wait for locked
    lock_wait = 0;
    while (((&locked) !== 1'b1) || (s_locked !== 1'b1)) begin
      @(posedge up_clk);
      lock_wait = lock_wait + 1;
      if (lock_wait > 64)
        $fatal(1, "ad_data_clk: locked %b, serdes %b, not high after reset", locked, s_locked);
    end
    repeat (4) @(posedge clk_in);

    // the delay of clk and clk_div against the input
    @(posedge clk_in);
    t_in = $realtime;
    #(IN_HALF_PERIOD_NS - 0.01);
    for (k = 0; k < N; k = k + 1) begin
      clk_delay[k] = clk_last[k] - t_in;
      div_delay[k] = div_last[k] - t_in;
    end

    count_edges();

    for (k = 0; k < N; k = k + 1) begin
      $display("[TB] ad_data_clk %0d: clk edges %0d delay %0.0f ps, clk_div edges %0d",
        k, clk_edges[k], clk_delay[k] * 1000.0, div_edges_n[k]);
      if ((clk_edges[k] < CYCLES - 1) || (clk_edges[k] > CYCLES))
        $fatal(1, "ad_data_clk %0d: %0d clk edges, expected %0d", k, clk_edges[k], CYCLES);
      if ((div_edges_n[k] < div_edges(k) - 1) || (div_edges_n[k] > div_edges(k) + 1))
        $fatal(1, "ad_data_clk %0d: %0d clk_div edges, expected %0d", k, div_edges_n[k], div_edges(k));
    end

    // without the delay line clk follows the input; with it clk is delayed by
    // more than 100 ps but less than half an input period
    for (k = 0; k < 6; k = k + 1)
      if ((clk_delay[k] < 0) || (clk_delay[k] > 0.1))
        $fatal(1, "ad_data_clk %0d: clk %0.0f ps after the input, expected no delay", k, clk_delay[k] * 1000.0);
    for (k = 6; k < N; k = k + 1)
      if ((clk_delay[k] < 0.1) || (clk_delay[k] > IN_HALF_PERIOD_NS))
        $fatal(1, "ad_data_clk %0d: clk %0.0f ps after the input, expected a delay", k, clk_delay[k] * 1000.0);
    if ((div_delay[0] < 0) || (div_delay[0] > 0.1) || (div_delay[6] < 0) || (div_delay[6] > 0.1))
      $fatal(1, "ad_data_clk: clk_div is delayed against the input");

    // the serdes clock tree
    $display("[TB] ad_data_clk serdes: hs_clk_rx edges %0d, hs_clk_fifo edges %0d, clk_div edges %0d",
      s_rx_edges, s_fifo_edges, s_div_edges);
    if ((s_rx_edges < CYCLES - 1) || (s_rx_edges > CYCLES) ||
        (s_fifo_edges < CYCLES - 1) || (s_fifo_edges > CYCLES))
      $fatal(1, "ad_data_clk serdes: hs_clk_rx/hs_clk_fifo do not run at the input rate");
    if ((s_div_edges < CYCLES / 4 - 1) || (s_div_edges > CYCLES / 4 + 1))
      $fatal(1, "ad_data_clk serdes: %0d clk_div edges, expected %0d", s_div_edges, CYCLES / 4);

    // rst stops clk_div, the serdes clocks keep running
    @(negedge s_clk_div);
    s_rst = 1'b1;
    repeat (4) @(posedge clk_in);
    count_edges();
    $display("[TB] ad_data_clk serdes in rst: hs_clk_rx edges %0d, hs_clk_fifo edges %0d, clk_div edges %0d",
      s_rx_edges, s_fifo_edges, s_div_edges);
    if (s_div_edges != 0)
      $fatal(1, "ad_data_clk serdes: clk_div runs in rst");
    if ((s_rx_edges < CYCLES - 1) || (s_fifo_edges < CYCLES - 1))
      $fatal(1, "ad_data_clk serdes: the serdes clocks stop in rst");
    s_rst = 1'b0;
    repeat (8) @(posedge clk_in);
    count_edges();
    if ((s_div_edges < CYCLES / 4 - 1) || (s_div_edges > CYCLES / 4 + 1))
      $fatal(1, "ad_data_clk serdes: %0d clk_div edges after rst, expected %0d", s_div_edges, CYCLES / 4);

    // the clock delay sweep: hs_clk_rx is delayed more with every code (3
    // taps at REFCLK_FREQUENCY 200), hs_clk_fifo stays
    measure_serdes_delay();
    rx_delay_prev = rx_delay;
    fifo_delay_0 = fifo_delay;
    $display("[TB] ad_data_clk serdes delay code 0: hs_clk_rx %0.0f ps, hs_clk_fifo %0.0f ps",
      rx_delay * 1000.0, fifo_delay * 1000.0);
    for (c = 1; c <= SWEEP_CODES; c = c + 1) begin
      @(negedge up_clk);
      s_dwdata = c;
      s_dld = 1'b1;
      @(negedge up_clk);
      s_dld = 1'b0;
      lock_wait = 0;
      while (s_drdata != c) begin
        @(posedge up_clk);
        lock_wait = lock_wait + 1;
        if (lock_wait > 64)
          $fatal(1, "ad_data_clk serdes: the delay code %0d does not settle", c);
      end
      repeat (4) @(posedge clk_in);
      measure_serdes_delay();
      $display("[TB] ad_data_clk serdes delay code %0d: hs_clk_rx %0.0f ps, hs_clk_fifo %0.0f ps",
        c, rx_delay * 1000.0, fifo_delay * 1000.0);
      if ((rx_delay <= rx_delay_prev) || (rx_delay - rx_delay_prev > 0.1))
        $fatal(1, "ad_data_clk serdes: hs_clk_rx %0.0f ps at code %0d, %0.0f ps before",
          rx_delay * 1000.0, c, rx_delay_prev * 1000.0);
      if (fifo_delay != fifo_delay_0)
        $fatal(1, "ad_data_clk serdes: hs_clk_fifo is delayed by the clock delay");
      rx_delay_prev = rx_delay;
    end

    $display("[TB] ad_data_clk: PASS");
    $finish;
  end

endmodule
