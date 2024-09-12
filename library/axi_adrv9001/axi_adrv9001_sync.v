// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023-2025 Analog Devices, Inc. All rights reserved.
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

module axi_adrv9001_sync #(
  parameter FPGA_TECHNOLOGY = 0,
  parameter DRP_WIDTH = 5
) (
  input                   ref_clk,
  input                   request_mcs,
  input       [31:0]      sync_config,
  input       [31:0]      mcs_sync_pulse_width,
  input       [31:0]      mcs_sync_pulse_1_delay,
  input       [31:0]      mcs_sync_pulse_2_delay,
  input       [31:0]      mcs_sync_pulse_3_delay,
  input       [31:0]      mcs_sync_pulse_4_delay,
  input       [31:0]      mcs_sync_pulse_5_delay,
  input       [31:0]      mcs_sync_pulse_6_delay,
  output                  mcs_out,
  output                  mcs_6th_pulse,
  output                  mcs_tx_rate_sync,
  output                  mcs_src,
  output                  rf_enable,
  input                   mssi_sync_in,
  output reg              mssi_sync,
  output                  transfer_sync
);

  // internal registers

  reg           mcs_out_i = 'd0;
  reg           mcs_out_d = 'd0;
  reg           request_m1 = 'd0;
  reg           request_m2 = 'd0;
  reg           request_mn = 'd0;
  reg           mssi_sync_in_d = 'd0;
  reg           mcs_src_d = 'd0;
  reg   [31:0]  mcs_sync_pulse_width_cnt = 32'd0;
  reg   [31:0]  mcs_sync_pulse_delay_cnt = 32'd0;
  reg   [ 2:0]  mcs_sync_pulse_num = 3'd0;
  reg           mcs_sync_busy = 1'b0;
  reg           mcs_rise_edge = 1'b0;
  reg           mcs_fall_edge = 1'b0;
  reg           if_sync = 1'b0;
  reg   [31:0]  transfer_cnt = 32'd0;
  reg           transfer_busy = 1'b0;
  reg           rf_enable_d = 1'b1;

  // internal signals

  wire          mcs_start;
  wire          transfer_start;
  wire          req_rise_edge;
  wire          req_fall_edge;
  wire          mcs_out_rise_edge;
  wire          mcs_out_fall_edge;
  wire          mcs_6_pulse_train_seq_s;
  wire          mcs_req_src_s;
  wire          manual_sync_req_s;
  wire          mcs_or_transfer_trig_n_s;

  // MCS pulses src internal = 1 or external = 0
  assign mcs_6_pulse_train_seq_s = sync_config[0];
  // MCS request src internal = 1 or external = 0
  assign mcs_req_src_s = sync_config[1];
  // use to synchronize the channels of one system
  assign manual_sync_req_s = sync_config[2];
  // use to synchronize the transfer start of all channels
  assign mcs_or_transfer_trig_n_s = sync_config[3];

  assign mcs_src = mcs_6_pulse_train_seq_s;
  // consider ref_clk = 30.72MHz (32.552ns)
  // the MCS sync requires 6 pulses of min 10us with a in between delay of min 100us
  // mcs_sync_pulse_width = 32'd62;        //   2.02 us (ref_clk = 30.72MHz)
  // mcs_sync_pulse_max_delay = 32'd3073;  // 100.03 us (ref_clk = 30.72MHz)
  // mcs_sync_pulse_min_delay = 32'd31;    //   1.01 us (ref_clk = 30.72MHz)

  // multi-chip or system synchronization

  always @(negedge ref_clk) begin
    request_m1 <= request_mcs;
    // the mcs 6 pulse train source or mcs request source can overwrite the source to external
    request_m2 <= (!mcs_or_transfer_trig_n_s | mcs_6_pulse_train_seq_s) & mcs_req_src_s ? manual_sync_req_s : request_m1;
    request_mn <= request_m2 & request_m1; // the pulse should be min 2 clk cycles
    mcs_src_d <= mcs_6_pulse_train_seq_s;
  end

  assign req_fall_edge = request_mn & !request_m1;
  assign req_rise_edge = !request_mn & request_m1;
  assign mcs_start = req_rise_edge & !mcs_sync_busy & mcs_or_transfer_trig_n_s;
  assign transfer_start = req_rise_edge & !transfer_busy & !mcs_or_transfer_trig_n_s;

  always @(negedge ref_clk) begin
    if (mcs_start) begin
      mcs_sync_busy <= 1'b1;
      mcs_sync_pulse_width_cnt <= mcs_sync_pulse_width;
      mcs_sync_pulse_delay_cnt <= mcs_sync_pulse_1_delay;
      mcs_out_i <= 1'b0;
    end else if (mcs_sync_busy == 1'b1) begin
      mcs_out_d <= mcs_out_i;
      if (mcs_sync_pulse_width_cnt != 32'd0) begin
        mcs_sync_pulse_width_cnt <= mcs_sync_pulse_width_cnt - 32'd1;
        mcs_out_i <= 1'b1;
      end else if (mcs_sync_pulse_delay_cnt != 32'd0) begin
        mcs_sync_pulse_delay_cnt <= mcs_sync_pulse_delay_cnt - 32'd1;
        mcs_out_i <= 1'b0;
      end else begin
        if (mcs_sync_pulse_num == 0) begin
          mcs_sync_pulse_width_cnt <= mcs_sync_pulse_width;
          mcs_sync_pulse_delay_cnt <= mcs_sync_pulse_2_delay;
        end else if (mcs_sync_pulse_num == 1) begin
          mcs_sync_pulse_width_cnt <= mcs_sync_pulse_width;
          mcs_sync_pulse_delay_cnt <= mcs_sync_pulse_3_delay;
        end else if (mcs_sync_pulse_num == 2) begin
          mcs_sync_pulse_width_cnt <= mcs_sync_pulse_width;
          mcs_sync_pulse_delay_cnt <= mcs_sync_pulse_4_delay;
        end else if (mcs_sync_pulse_num == 3) begin
          mcs_sync_pulse_width_cnt <= mcs_sync_pulse_width;
          mcs_sync_pulse_delay_cnt <= mcs_sync_pulse_5_delay;
        end else if (mcs_sync_pulse_num == 4) begin
          mcs_sync_pulse_width_cnt <= mcs_sync_pulse_width;
          mcs_sync_pulse_delay_cnt <= mcs_sync_pulse_6_delay;
        end else begin
          mcs_sync_busy <= 1'b0;
        end
        mcs_out_i <= 1'b0;
      end
    end
  end

  always @(posedge ref_clk) begin
    if (mcs_start) begin
      rf_enable_d <=  1'b0;
    end else if (mcs_sync_pulse_num == 5 && mcs_out_fall_edge == 1'b1) begin
      rf_enable_d <=  1'b1;
    end
  end

  assign rf_enable = rf_enable_d;

  assign mcs_out_fall_edge = mcs_out_d & !mcs_out_i;
  assign mcs_out_rise_edge = !mcs_out_d & mcs_out_i;

  always @(negedge ref_clk) begin
    if (mcs_6_pulse_train_seq_s) begin // internal mcs
      if (mcs_start) begin
        mcs_sync_pulse_num <= 3'd0;
      end else begin
        if (mcs_sync_busy == 1'b1 && mcs_sync_pulse_delay_cnt == 32'd0) begin
          mcs_sync_pulse_num <= mcs_sync_pulse_num + 1;
        end
      end
      mcs_rise_edge <= mcs_out_rise_edge;
      mcs_fall_edge <= mcs_out_fall_edge;
    end else begin  // external mcs
      // reset the mcs counter by toggeling the mcs_6_pulse_train_seq_s
      if (mcs_src_d & !mcs_6_pulse_train_seq_s) begin
        mcs_sync_pulse_num <= 3'd0;
      end else begin
        if (req_rise_edge) begin
          mcs_sync_pulse_num <= mcs_sync_pulse_num + 1;
        end
      end
      mcs_rise_edge <= req_fall_edge;
      mcs_fall_edge <= req_rise_edge;
    end
  end

  assign mcs_tx_rate_sync = (mcs_sync_pulse_num == 3'd4) ? mcs_fall_edge : 1'b0;
  assign mcs_6th_pulse = (mcs_sync_pulse_num == 3'd5) ? mcs_out_i : 1'b0;

  // MSSI reset on 4'th pulse fslling edge
  always @(posedge ref_clk) begin
    if (mcs_sync_pulse_num == 3'd3) begin
      if (mcs_rise_edge == 1'd1) begin
        if_sync <= 1'b1;
      end
    end else if (mcs_sync_pulse_num == 3'd4) begin
      if (mcs_rise_edge == 1'd1) begin
        if_sync <= 1'b0;
      end
    end else begin
      if_sync <= if_sync;
    end
  end

  always @(posedge ref_clk) begin
    mssi_sync_in_d <= mssi_sync_in;
  end

  always @(posedge ref_clk) begin
    mssi_sync <= if_sync | mssi_sync_in_d;
  end

  always @(posedge ref_clk) begin
    if (transfer_start) begin
      transfer_busy <= 1'b1;
      transfer_cnt <= 32'h0;
    end else if (transfer_busy == 1'b1) begin
      if (transfer_cnt == 32'h7ff) begin // the request might have multiple edges
        transfer_busy <= 1'b0;
        transfer_cnt <= transfer_cnt;
      end else begin
        transfer_busy <= 1'b1;
        transfer_cnt <= transfer_cnt + 1;
      end
    end
  end

  assign transfer_sync = transfer_busy;
  assign mcs_out = mcs_out_i;

endmodule
