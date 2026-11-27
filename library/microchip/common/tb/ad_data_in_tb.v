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

module ad_data_in_tb;

  localparam real RX_HALF_PERIOD_NS = 4.0;

  reg rx_clk = 1'b0;
  wire rx_data_in_p;
  wire rx_data_in_n;
  wire rx_data_ddr_direct_p;
  wire rx_data_ddr_direct_n;
  wire rx_data_ddr_direct_init0_p;
  wire rx_data_ddr_direct_init0_n;

  reg up_dld_ddr_direct = 1'b0;
  reg [4:0] up_dwdata_ddr_direct = 5'd0;
  wire [4:0] up_drdata_ddr_direct;
  wire [4:0] up_drdata_ddr_direct_init0;
  reg up_dld_static = 1'b0;
  wire [4:0] up_drdata_static;

  reg delay_rst = 1'b1;
  wire delay_locked_ddr_direct;
  wire delay_locked_ddr_direct_init0;
  wire delay_locked_static;
  wire up_clk;
  wire delay_clk;

  assign rx_data_in_p = rx_clk;
  assign rx_data_in_n = ~rx_clk;
  assign up_clk = rx_clk;
  assign delay_clk = rx_clk;

  ad_data_in #(
    .DDR_SDR_N (1),
    .IODELAY_MODE (2),
    .RX_DELAY_VAL_X2 (1'b1)
  ) dut_ddr_direct (
    .rx_clk (rx_clk),
    .rx_data_in_p (rx_data_in_p),
    .rx_data_in_n (rx_data_in_n),
    .rx_data_p (rx_data_ddr_direct_p),
    .rx_data_n (rx_data_ddr_direct_n),
    .up_clk (up_clk),
    .up_dld (up_dld_ddr_direct),
    .up_dwdata (up_dwdata_ddr_direct),
    .up_drdata (up_drdata_ddr_direct),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked_ddr_direct)
  );

  ad_data_in #(
    .DDR_SDR_N (1),
    .IODELAY_MODE (2),
    .RX_DELAY_VAL_X2 (1'b1)
  ) dut_ddr_direct_init0 (
    .rx_clk (rx_clk),
    .rx_data_in_p (rx_data_in_p),
    .rx_data_in_n (rx_data_in_n),
    .rx_data_p (rx_data_ddr_direct_init0_p),
    .rx_data_n (rx_data_ddr_direct_init0_n),
    .up_clk (up_clk),
    .up_dld (1'b0),
    .up_dwdata (5'd0),
    .up_drdata (up_drdata_ddr_direct_init0),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked_ddr_direct_init0)
  );

  // IODELAY_MODE=1, static delay, 93 / 3 is read back as 31
  ad_data_in #(
    .DDR_SDR_N (1),
    .IODELAY_MODE (1),
    .RX_DELAY_VAL_X2 (1'b1),
    .IOD_DELAY_INIT (8'd93)
  ) dut_static (
    .rx_clk (rx_clk),
    .rx_data_in_p (rx_data_in_p),
    .rx_data_in_n (rx_data_in_n),
    .rx_data_p (),
    .rx_data_n (),
    .up_clk (up_clk),
    .up_dld (up_dld_static),
    .up_dwdata (5'd0),
    .up_drdata (up_drdata_static),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked_static)
  );

  // delay sweep on a faster clock: the 0..31 sweep (0..93 taps) moves the
  // sampling point over a data edge at least once; the delay control stays on
  // the slow clock, asynchronous to the data clock
  //
  // This clock is only for the delay test, it is not the limit of the real
  // interface. In the model a tap is 25 ps over a ~225 ps base, so the sweep
  // reaches ~2.55 ns and the first flip comes at half a period (code 17 at
  // 1.5 ns). If the IOD did not run at this clock, a slower one works as long
  // as half a period stays below ~2.5 ns (or use a larger
  // DELAY_STEP_COEFFICIENT, up to 255 taps with RX_DELAY_VAL_X2).

  localparam real SWEEP_HALF_PERIOD_NS = 1.5;

  reg sweep_clk = 1'b0;
  reg up_dld_sweep = 1'b0;
  reg [4:0] up_dwdata_sweep = 5'd0;
  wire [4:0] up_drdata_sweep;
  wire delay_locked_sweep;
  wire rx_data_sweep_p;
  wire rx_data_sweep_n;

  ad_data_in #(
    .DDR_SDR_N (1),
    .IODELAY_MODE (2),
    .RX_DELAY_VAL_X2 (1'b1),
    .IOD_DELAY_INIT (8'd0)
  ) dut_sweep (
    .rx_clk (sweep_clk),
    .rx_data_in_p (sweep_clk),
    .rx_data_in_n (~sweep_clk),
    .rx_data_p (rx_data_sweep_p),
    .rx_data_n (rx_data_sweep_n),
    .up_clk (up_clk),
    .up_dld (up_dld_sweep),
    .up_dwdata (up_dwdata_sweep),
    .up_drdata (up_drdata_sweep),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked_sweep)
  );

  always #(RX_HALF_PERIOD_NS) rx_clk = ~rx_clk;
  always #(SWEEP_HALF_PERIOD_NS) sweep_clk = ~sweep_clk;

  integer lock_wait;
  integer sweep_code;
  integer sweep_flips;
  reg sweep_valid;
  reg sweep_stable;
  reg sweep_p;
  reg sweep_n;
  reg sweep_last_p;

  // static delay: loaded once after reset, never moved, locked after the load

  reg static_loaded = 1'b0;

  always @(posedge delay_clk) begin
    if (dut_static.delay_load_s === 1'b1)
      static_loaded <= 1'b1;
  end

  always @(posedge dut_static.delay_move_s) begin
    $fatal(1, "ad_data_in static path moved the delay line");
  end

  always @(posedge delay_locked_static) begin
    if ((static_loaded !== 1'b1) || (dut_static.delay_load_s !== 1'b0))
      $fatal(1, "ad_data_in static path delay_locked asserted before the delay load");
  end

  task pulse_delay_load_direct;
    input [4:0] value;
    begin
      @(negedge up_clk);
      up_dwdata_ddr_direct <= value;
      up_dld_ddr_direct <= 1'b1;
      @(negedge up_clk);
      up_dld_ddr_direct <= 1'b0;
    end
  endtask

  task wait_for_delay_settle;
    begin
      while (up_drdata_ddr_direct != up_dwdata_ddr_direct) begin
        @(posedge up_clk);
      end
    end
  endtask

  initial begin
    repeat (4) @(negedge up_clk);
    delay_rst <= 1'b0;

    // delay_locked crosses to up_clk, wait for it with a timeout
    lock_wait = 0;
    while (((delay_locked_ddr_direct !== 1'b1) || (delay_locked_ddr_direct_init0 !== 1'b1) ||
            (delay_locked_static !== 1'b1)) && (lock_wait < 64)) begin
      @(posedge up_clk);
      lock_wait = lock_wait + 1;
    end
    if (delay_locked_ddr_direct !== 1'b1)
      $fatal(1, "ad_data_in direct path delay_locked did not assert after reset");
    if (delay_locked_ddr_direct_init0 !== 1'b1)
      $fatal(1, "ad_data_in init0 path delay_locked did not assert after reset");
    if (delay_locked_static !== 1'b1)
      $fatal(1, "ad_data_in static path delay_locked did not assert after reset");
    if (up_drdata_static !== 5'd31)
      $fatal(1, "ad_data_in static path readback is not the static delay");

    repeat (16) @(posedge rx_clk);

    // a delay request does not change the static delay
    @(negedge up_clk);
    up_dld_static <= 1'b1;
    @(negedge up_clk);
    up_dld_static <= 1'b0;
    repeat (16) @(posedge up_clk);
    if (up_drdata_static !== 5'd31)
      $fatal(1, "ad_data_in static path readback changed after a delay request");
    if (delay_locked_static !== 1'b1)
      $fatal(1, "ad_data_in static path delay_locked dropped after a delay request");

    // Delay step 0 -> 31
    pulse_delay_load_direct(5'd31);
    repeat (2) @(posedge up_clk);
    if (delay_locked_ddr_direct !== 1'b1)
      $fatal(1, "ad_data_in direct path delay_locked dropped during delay update to 31");
    if (up_drdata_ddr_direct !== 5'd0)
      $fatal(1, "ad_data_in direct path readback did not hold settled value 0 during update to 31");
    wait_for_delay_settle();
    repeat (2) @(posedge up_clk);
    if (delay_locked_ddr_direct !== 1'b1)
      $fatal(1, "ad_data_in direct path delay_locked not asserted after settling to 31");
    repeat (16) @(posedge rx_clk);

    // Delay step 31 -> 0
    pulse_delay_load_direct(5'd0);
    repeat (2) @(posedge up_clk);
    if (delay_locked_ddr_direct !== 1'b1)
      $fatal(1, "ad_data_in direct path delay_locked dropped during delay update to 0");
    if (up_drdata_ddr_direct !== 5'd31)
      $fatal(1, "ad_data_in direct path readback did not hold settled value 31 during update to 0");
    wait_for_delay_settle();
    repeat (2) @(posedge up_clk);
    if (delay_locked_ddr_direct !== 1'b1)
      $fatal(1, "ad_data_in direct path delay_locked not asserted after settling to 0");
    repeat (16) @(posedge rx_clk);

    // delay sweep: the data is the clock, so the rising and the falling
    // sample are complementary and swap when the delay passes a data edge
    if (delay_locked_sweep !== 1'b1)
      $fatal(1, "ad_data_in sweep path delay_locked did not assert after reset");
    sweep_flips = 0;
    sweep_valid = 1'b0;
    sweep_last_p = 1'b0;
    for (sweep_code = 0; sweep_code < 32; sweep_code = sweep_code + 1) begin
      @(negedge up_clk);
      up_dwdata_sweep <= sweep_code;
      up_dld_sweep <= 1'b1;
      @(negedge up_clk);
      up_dld_sweep <= 1'b0;
      repeat (2) @(posedge up_clk);
      while (up_drdata_sweep != sweep_code) @(posedge up_clk);
      repeat (8) @(posedge sweep_clk);
      @(posedge sweep_clk);
      #0.1;
      sweep_p = rx_data_sweep_p;
      sweep_n = rx_data_sweep_n;
      sweep_stable = 1'b1;
      repeat (7) begin
        @(posedge sweep_clk);
        #0.1;
        if ((rx_data_sweep_p !== sweep_p) || (rx_data_sweep_n !== sweep_n))
          sweep_stable = 1'b0;
      end
      $display("AD_DATA_IN_SWEEP code=%0d taps=%0d p=%b n=%b%s", sweep_code,
        dut_sweep.i_delay_ctrl.delay_value, sweep_p, sweep_n,
        sweep_stable ? "" : " unstable");
      if (sweep_stable == 1'b1) begin
        if ($isunknown({sweep_p, sweep_n}) || (sweep_p === sweep_n))
          $fatal(1, "ad_data_in sweep samples are not complementary at code %0d", sweep_code);
        if ((sweep_valid == 1'b1) && (sweep_p !== sweep_last_p)) begin
          sweep_flips = sweep_flips + 1;
          $display("AD_DATA_IN_SWEEP_FLIP code=%0d taps=%0d", sweep_code,
            dut_sweep.i_delay_ctrl.delay_value);
        end
        sweep_last_p = sweep_p;
        sweep_valid = 1'b1;
      end
    end
    if (sweep_flips == 0)
      $fatal(1, "ad_data_in delay sweep did not move the sampling point over a data edge");

    $finish;
  end

endmodule
