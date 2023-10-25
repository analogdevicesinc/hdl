// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_adrv9001_sync #(
  parameter DISABLE = 0
) (
  input                   ref_clk,
  input                   request_mcs,
  input                   mcs_src,
  output  reg             mcs_out = 1'b0,
  input                   mcs_transfer_n,
  output                  mssi_sync,
  output                  transfer_sync
);

  // local parameters


  localparam  MCS_SYNC_PULSE_PERIOD = 32'd1000; // 26us    (ref_clk = 38.4M clk)
  localparam  MCS_SYNC_PULSE_DELAY = 32'd4000;  // 104.1us (ref_clk = 38.4M clk)

  // internal registers

  reg           request_d = 'd0;
  reg           mcs_src_d = 'd0;
  reg   [31:0]  mcs_sync_pulse_period_cnt = 32'd0;
  reg   [31:0]  mcs_sync_pulse_delay_cnt = 32'd0;
  reg   [ 2:0]  mcs_sync_pulse_num = 3'd0;
  reg           mcs_sync_busy = 1'b0;
  reg           if_sync = 1'b0;
  reg   [31:0]  transfer_cnt = 32'd0;
  reg           transfer_busy = 1'b0;
  reg           transfer_busy_d = 1'b0;

  // internal signals

  wire          mcs_start;
  wire          transfer_start;
  wire          req_rise_edge;

  // multi-chip or system synchronization

  // consider ref_clk = 38.4M (26.042n)
  // the MCS sync requires 6 pulses of min 10us with a in between delay of min 100us
  always @(posedge ref_clk) begin
    request_d <= request_mcs;
    mcs_src_d <= mcs_src;
  end

  assign req_rise_edge = !request_d & request_mcs;
  assign mcs_start = req_rise_edge & !mcs_sync_busy & mcs_transfer_n;
  assign transfer_start = req_rise_edge& !transfer_busy & !mcs_transfer_n;

  always @(posedge ref_clk) begin
    if (mcs_start) begin
      mcs_sync_busy <= 1'b1;
      mcs_sync_pulse_period_cnt <= MCS_SYNC_PULSE_PERIOD;
      mcs_sync_pulse_delay_cnt <= MCS_SYNC_PULSE_DELAY;
      mcs_out <= 1'b0;
    end else if (mcs_sync_busy == 1'b1) begin
      if (mcs_sync_pulse_period_cnt != 32'd0) begin
        mcs_sync_pulse_period_cnt <= mcs_sync_pulse_period_cnt - 32'd1;
        mcs_out <= 1'b1;
      end else if (mcs_sync_pulse_delay_cnt != 32'd0) begin
        mcs_sync_pulse_delay_cnt <= mcs_sync_pulse_delay_cnt - 32'd1;
        mcs_out <= 1'b0;
      end else begin
        if (mcs_sync_pulse_num < 5) begin
          mcs_sync_pulse_period_cnt <= MCS_SYNC_PULSE_PERIOD;
          mcs_sync_pulse_delay_cnt <= MCS_SYNC_PULSE_DELAY;
        end else begin
          mcs_sync_busy <= 1'b0;
        end
        mcs_out <= 1'b0;
      end
    end
  end

  always @(posedge ref_clk) begin
    if (mcs_src) begin // internal mcs
      if (mcs_start) begin
        mcs_sync_pulse_num <= 3'd0;
      end else begin
        if (mcs_sync_busy == 1'b1 && mcs_sync_pulse_delay_cnt == 32'd0) begin
          mcs_sync_pulse_num <= mcs_sync_pulse_num + 1;
        end
      end
    end else begin  // external mcs
      if (!mcs_src_d & mcs_src) begin // reset the mcs counter by toggeling the mcs_src
      end else begin
        if (!request_d & request_mcs) begin
          mcs_sync_pulse_num <= mcs_sync_pulse_num + 1;
        end
      end
    end
  end

  // MSSI reset on 5'th pulse
  always @(posedge ref_clk) begin
    if (mcs_sync_pulse_num == 3'd4) begin
      if_sync <= 1'b1;
    end else begin
      if_sync <= 1'b0;
    end
  end

  always @(posedge ref_clk) begin
    if (transfer_start) begin
      transfer_busy <= 1'b1;
      transfer_cnt <= MCS_SYNC_PULSE_PERIOD; // the request might have multiple edges
    end else if (transfer_busy == 1'b1) begin
      if (transfer_cnt != 32'd0) begin
        transfer_busy <= 1'b0;
      end
    end
    transfer_busy_d <= transfer_busy;
  end

  assign transfer_sync = transfer_busy_d & !transfer_busy;

endmodule
