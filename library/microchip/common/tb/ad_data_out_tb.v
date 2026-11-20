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

module ad_data_out_tb;

  localparam real TX_HALF_PERIOD_NS = 4.0;

  reg tx_clk = 1'b0;
  wire tx_data_p;
  wire tx_data_n;
  wire tx_data_out_p_direct;
  wire tx_data_out_n_direct;
  wire tx_data_out_p_nodelay;
  wire tx_data_out_n_nodelay;
  wire tx_data_out_p_static;
  wire tx_data_out_n_static;

  reg up_dld_direct = 1'b0;
  reg [4:0] up_dwdata_direct = 5'd0;
  wire [4:0] up_drdata_direct;
  wire [4:0] up_drdata_nodelay;
  reg up_dld_static = 1'b0;
  wire [4:0] up_drdata_static;

  reg delay_rst = 1'b1;
  wire delay_locked_direct;
  wire delay_locked_nodelay;
  wire delay_locked_static;
  wire up_clk;
  wire delay_clk;

  assign tx_data_p = 1'b0;
  assign tx_data_n = 1'b1;
  assign up_clk = tx_clk;
  assign delay_clk = tx_clk;

  // IODELAY_MODE=2, delay settable
  ad_data_out #(
    .SINGLE_ENDED (0),
    .IODELAY_MODE (2)
  ) dut_direct (
    .tx_clk (tx_clk),
    .tx_data_p (tx_data_p),
    .tx_data_n (tx_data_n),
    .tx_data_out_p (tx_data_out_p_direct),
    .tx_data_out_n (tx_data_out_n_direct),
    .up_clk (up_clk),
    .up_dld (up_dld_direct),
    .up_dwdata (up_dwdata_direct),
    .up_drdata (up_drdata_direct),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked_direct)
  );

  // IODELAY_MODE=0, no delay
  ad_data_out #(
    .SINGLE_ENDED (0),
    .IODELAY_MODE (0)
  ) dut_nodelay (
    .tx_clk (tx_clk),
    .tx_data_p (tx_data_p),
    .tx_data_n (tx_data_n),
    .tx_data_out_p (tx_data_out_p_nodelay),
    .tx_data_out_n (tx_data_out_n_nodelay),
    .up_clk (up_clk),
    .up_dld (1'b0),
    .up_dwdata (5'd0),
    .up_drdata (up_drdata_nodelay),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked_nodelay)
  );

  // IODELAY_MODE=1, static delay, 93 / 3 is read back as 31
  ad_data_out #(
    .SINGLE_ENDED (0),
    .IODELAY_MODE (1),
    .IOD_DELAY_INIT (8'd93)
  ) dut_static (
    .tx_clk (tx_clk),
    .tx_data_p (1'b1),
    .tx_data_n (1'b0),
    .tx_data_out_p (tx_data_out_p_static),
    .tx_data_out_n (tx_data_out_n_static),
    .up_clk (up_clk),
    .up_dld (up_dld_static),
    .up_dwdata (5'd0),
    .up_drdata (up_drdata_static),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked_static)
  );

  // the same data without delay, as the reference of the static delay
  wire tx_data_out_p_reference;
  wire tx_data_out_n_reference;

  ad_data_out #(
    .SINGLE_ENDED (0),
    .IODELAY_MODE (0)
  ) dut_reference (
    .tx_clk (tx_clk),
    .tx_data_p (1'b1),
    .tx_data_n (1'b0),
    .tx_data_out_p (tx_data_out_p_reference),
    .tx_data_out_n (tx_data_out_n_reference),
    .up_clk (up_clk),
    .up_dld (1'b0),
    .up_dwdata (5'd0),
    .up_drdata (),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked ()
  );

  // delay sweep on a faster clock, against the same data without delay; the
  // tx delay line has 127 taps, the 0..31 sweep goes to 93 taps; the output
  // is sampled a quarter period after the reference edge, so the sample flips
  // when the delay passes that point; the delay control stays on the slow
  // clock, asynchronous to the data clock
  //
  // This clock is only for the delay test, it is not the limit of the real
  // interface. In the model a tap is 25 ps over a ~225 ps base, so the sweep
  // reaches ~2.55 ns and flips at a quarter and three quarters of a period
  // (750 and 2250 ps at 1.5 ns). If the IOD did not run at this clock, a
  // slower one works as long as a quarter period stays below ~2.5 ns and the
  // full delay below one period; more taps (DELAY_STEP_COEFFICIENT up to 4)
  // are limited by the 127 taps of the tx delay line.

  localparam real SWEEP_HALF_PERIOD_NS = 1.5;

  reg sweep_clk = 1'b0;
  reg up_dld_sweep = 1'b0;
  reg [4:0] up_dwdata_sweep = 5'd0;
  wire [4:0] up_drdata_sweep;
  wire delay_locked_sweep;
  wire tx_data_out_p_sweep;
  wire tx_data_out_n_sweep;
  wire tx_data_out_p_sweep_ref;
  wire tx_data_out_n_sweep_ref;

  ad_data_out #(
    .SINGLE_ENDED (0),
    .IODELAY_MODE (2),
    .IOD_DELAY_INIT (8'd0)
  ) dut_sweep (
    .tx_clk (sweep_clk),
    .tx_data_p (1'b1),
    .tx_data_n (1'b0),
    .tx_data_out_p (tx_data_out_p_sweep),
    .tx_data_out_n (tx_data_out_n_sweep),
    .up_clk (up_clk),
    .up_dld (up_dld_sweep),
    .up_dwdata (up_dwdata_sweep),
    .up_drdata (up_drdata_sweep),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked_sweep)
  );

  ad_data_out #(
    .SINGLE_ENDED (0),
    .IODELAY_MODE (0)
  ) dut_sweep_ref (
    .tx_clk (sweep_clk),
    .tx_data_p (1'b1),
    .tx_data_n (1'b0),
    .tx_data_out_p (tx_data_out_p_sweep_ref),
    .tx_data_out_n (tx_data_out_n_sweep_ref),
    .up_clk (up_clk),
    .up_dld (1'b0),
    .up_dwdata (5'd0),
    .up_drdata (),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked ()
  );

  always #(TX_HALF_PERIOD_NS) tx_clk = ~tx_clk;
  always #(SWEEP_HALF_PERIOD_NS) sweep_clk = ~sweep_clk;

  integer lock_wait;
  integer sweep_code;
  integer sweep_flips;
  integer sweep_taps;
  integer sweep_first_taps;
  reg sweep_valid;
  reg sweep_sample;
  reg sweep_expected;
  reg sweep_last_sample;
  realtime sweep_edge = 0;
  realtime sweep_ref_time;
  realtime sweep_delay;
  realtime sweep_last_delay;
  realtime sweep_first_delay;

  always @(posedge tx_data_out_p_sweep) sweep_edge = $realtime;

  // static delay: loaded once after reset, never moved, locked after the load

  reg static_loaded = 1'b0;
  realtime static_edge = 0;
  realtime reference_edge = 0;

  always @(posedge delay_clk) begin
    if (dut_static.delay_load_s === 1'b1)
      static_loaded <= 1'b1;
  end

  always @(posedge dut_static.delay_move_s) begin
    $fatal(1, "ad_data_out static path moved the delay line");
  end

  always @(posedge delay_locked_static) begin
    if ((static_loaded !== 1'b1) || (dut_static.delay_load_s !== 1'b0))
      $fatal(1, "ad_data_out static path delay_locked asserted before the delay load");
  end

  always @(posedge tx_data_out_p_static) static_edge = $realtime;
  always @(posedge tx_data_out_p_reference) reference_edge = $realtime;

  task pulse_delay_load_direct;
    input [4:0] value;
    begin
      @(negedge up_clk);
      up_dwdata_direct <= value;
      up_dld_direct <= 1'b1;
      @(negedge up_clk);
      up_dld_direct <= 1'b0;
    end
  endtask

  task wait_for_delay_settle;
    begin
      while (up_drdata_direct != up_dwdata_direct) begin
        @(posedge up_clk);
      end
    end
  endtask

  initial begin
    repeat (4) @(negedge up_clk);
    delay_rst <= 1'b0;

    // delay_locked crosses to up_clk, wait for it with a timeout
    lock_wait = 0;
    while (((delay_locked_direct !== 1'b1) || (delay_locked_nodelay !== 1'b1) ||
            (delay_locked_static !== 1'b1)) && (lock_wait < 64)) begin
      @(posedge up_clk);
      lock_wait = lock_wait + 1;
    end
    if (delay_locked_direct !== 1'b1)
      $fatal(1, "ad_data_out direct path delay_locked did not assert after reset");
    if (delay_locked_nodelay !== 1'b1)
      $fatal(1, "ad_data_out no-delay path delay_locked did not assert after reset");
    if (delay_locked_static !== 1'b1)
      $fatal(1, "ad_data_out static path delay_locked did not assert after reset");
    if (up_drdata_static !== 5'd31)
      $fatal(1, "ad_data_out static path readback is not the static delay");

    repeat (16) @(posedge tx_clk);

    // a delay request does not change the static delay
    @(negedge up_clk);
    up_dld_static <= 1'b1;
    @(negedge up_clk);
    up_dld_static <= 1'b0;
    repeat (16) @(posedge up_clk);
    if (up_drdata_static !== 5'd31)
      $fatal(1, "ad_data_out static path readback changed after a delay request");
    if (delay_locked_static !== 1'b1)
      $fatal(1, "ad_data_out static path delay_locked dropped after a delay request");

    // the static delay against the same data without delay
    repeat (4) @(posedge tx_clk);
    @(posedge tx_data_out_p_reference);
    @(posedge tx_data_out_p_static);
    $display("AD_DATA_OUT_STATIC_DELAY %0t ps", static_edge - reference_edge);
    if ((static_edge - reference_edge) < 1.0)
      $fatal(1, "ad_data_out static path output is not delayed");

    // Delay step 0 -> 31
    pulse_delay_load_direct(5'd31);
    repeat (2) @(posedge up_clk);
    if (delay_locked_direct !== 1'b1)
      $fatal(1, "ad_data_out direct path delay_locked dropped during delay update to 31");
    if (up_drdata_direct !== 5'd0)
      $fatal(1, "ad_data_out direct path readback did not hold settled value 0 during update to 31");
    wait_for_delay_settle();
    repeat (2) @(posedge up_clk);
    if (delay_locked_direct !== 1'b1)
      $fatal(1, "ad_data_out direct path delay_locked not asserted after settling to 31");
    repeat (16) @(posedge tx_clk);

    // Delay step 31 -> 0
    pulse_delay_load_direct(5'd0);
    repeat (2) @(posedge up_clk);
    if (delay_locked_direct !== 1'b1)
      $fatal(1, "ad_data_out direct path delay_locked dropped during delay update to 0");
    if (up_drdata_direct !== 5'd31)
      $fatal(1, "ad_data_out direct path readback did not hold settled value 31 during update to 0");
    wait_for_delay_settle();
    repeat (2) @(posedge up_clk);
    if (delay_locked_direct !== 1'b1)
      $fatal(1, "ad_data_out direct path delay_locked not asserted after settling to 0");
    repeat (16) @(posedge tx_clk);

    // delay sweep: the delay against the reference grows with the taps, and
    // the sample a quarter period after the reference edge follows it
    if (delay_locked_sweep !== 1'b1)
      $fatal(1, "ad_data_out sweep path delay_locked did not assert after reset");
    sweep_flips = 0;
    sweep_valid = 1'b0;
    sweep_last_sample = 1'b0;
    sweep_last_delay = 0;
    for (sweep_code = 0; sweep_code < 32; sweep_code = sweep_code + 1) begin
      @(negedge up_clk);
      up_dwdata_sweep <= sweep_code;
      up_dld_sweep <= 1'b1;
      @(negedge up_clk);
      up_dld_sweep <= 1'b0;
      repeat (2) @(posedge up_clk);
      while (up_drdata_sweep != sweep_code) @(posedge up_clk);
      repeat (8) @(posedge sweep_clk);
      @(posedge tx_data_out_p_sweep_ref);
      sweep_ref_time = $realtime;
      #(SWEEP_HALF_PERIOD_NS / 2.0);
      sweep_sample = tx_data_out_p_sweep;
      #((SWEEP_HALF_PERIOD_NS * 1.5) - 0.001);
      // the last rising edge of the delayed output in one period
      sweep_delay = sweep_edge - sweep_ref_time;
      sweep_taps = dut_sweep.i_delay_ctrl.delay_value;
      $display("AD_DATA_OUT_SWEEP code=%0d taps=%0d delay=%0.0f ps sample=%b",
        sweep_code, sweep_taps, sweep_delay * 1000.0, sweep_sample);
      if ((sweep_delay < 0) || (sweep_delay >= (2.0 * SWEEP_HALF_PERIOD_NS)))
        $fatal(1, "ad_data_out sweep found no delayed edge at code %0d", sweep_code);
      if ((sweep_valid == 1'b1) && (sweep_delay < (sweep_last_delay - 0.002)))
        $fatal(1, "ad_data_out sweep delay went down at code %0d", sweep_code);
      // the output is high for half a period after its rising edge
      sweep_expected = (sweep_delay < (SWEEP_HALF_PERIOD_NS / 2.0)) ||
                       (sweep_delay > (SWEEP_HALF_PERIOD_NS * 1.5));
      if ((sweep_delay > ((SWEEP_HALF_PERIOD_NS / 2.0) - 0.05)) &&
          (sweep_delay < ((SWEEP_HALF_PERIOD_NS / 2.0) + 0.05)))
        sweep_expected = sweep_sample;
      if ((sweep_delay > ((SWEEP_HALF_PERIOD_NS * 1.5) - 0.05)) &&
          (sweep_delay < ((SWEEP_HALF_PERIOD_NS * 1.5) + 0.05)))
        sweep_expected = sweep_sample;
      if (sweep_sample !== sweep_expected)
        $fatal(1, "ad_data_out sweep sample does not follow the delay at code %0d", sweep_code);
      if ((sweep_valid == 1'b1) && (sweep_sample !== sweep_last_sample)) begin
        sweep_flips = sweep_flips + 1;
        $display("AD_DATA_OUT_SWEEP_FLIP code=%0d taps=%0d delay=%0.0f ps",
          sweep_code, sweep_taps, sweep_delay * 1000.0);
      end
      if (sweep_valid == 1'b0) begin
        sweep_first_delay = sweep_delay;
        sweep_first_taps = sweep_taps;
      end
      sweep_last_sample = sweep_sample;
      sweep_last_delay = sweep_delay;
      sweep_valid = 1'b1;
    end
    if (sweep_flips == 0)
      $fatal(1, "ad_data_out delay sweep did not move the output over the sampling point");
    if ((sweep_last_delay - sweep_first_delay) < 1.0)
      $fatal(1, "ad_data_out delay sweep moved the output less than 1 ns");
    $display("AD_DATA_OUT_SWEEP_TAP %0.1f ps per tap",
      (sweep_last_delay - sweep_first_delay) * 1000.0 / (sweep_taps - sweep_first_taps));

    $finish;
  end

endmodule
