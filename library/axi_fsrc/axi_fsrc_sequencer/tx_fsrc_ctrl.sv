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

// Controls sequence for TX FSRC.
// Sequence:
// User sets next_ctrl_value, first_trig_cnt, second_trig_cnt
// User asserts start
// tx_data_start asserted
// Counter start at 0, increments when sysref_int is asserted
// When counter equals ctrl_change_cnt, set ctrl = next_ctrl_value
// When counter equals first_trig_cnt, pulse trig
// When counter equals second_trig_cnt, pulse trig
// When counter equals accum_reset_cnt, tx_data_start deasserted

`default_nettype none

module tx_fsrc_ctrl #(
  parameter CTRL_WIDTH = 8,
  parameter COUNTER_WIDTH = 16,
  parameter NUM_TRIG = 1
)(
  input  wire                                      clk,
  input  wire                                      reset,
  input  wire                                      sysref_int,           // Single-cycle pulse input
  input  wire                                      start,                // Single-cycle pulse input
  input  wire [CTRL_WIDTH-1:0]                     next_ctrl_value,      // Set before start is asserted, hold the value until ctrl value is changed
  input  wire [COUNTER_WIDTH-1:0]                  ctrl_change_cnt,
  input  wire [NUM_TRIG-1:0] [COUNTER_WIDTH-1:0]   first_trig_cnt,
  input  wire [NUM_TRIG-1:0] [COUNTER_WIDTH-1:0]   second_trig_cnt,
  input  wire [COUNTER_WIDTH-1:0]                  accum_reset_cnt,      // Must be greater than first_trig_cnt and second_trig_cnt
  input  wire [COUNTER_WIDTH-1:0]                  rx_delay_cnt,
  input  wire                                      seq_trig_in,
  input  wire                                      seq_ext_trig_en,
         
  output logic [NUM_TRIG-1:0]                      trig_out,
  output logic                                     rx_data_start,
  output logic                                     tx_data_start,
  output logic [CTRL_WIDTH-1:0]                    ctrl
  // TODO: need to set TX FSRC NS value here?
);

  localparam TRIG_PULSE_WIDTH = 4;

  logic                                         sysref_int_d;
  logic                                         count_en;
  logic                                         delay_count_en;
  logic [NUM_TRIG-1:0]                          trig_pulse;
  logic [NUM_TRIG-1:0] [TRIG_PULSE_WIDTH-1:0]   trig_shift;
  logic [COUNTER_WIDTH-1:0]                     count;
  logic [COUNTER_WIDTH-1:0]                     delay_count;
  logic                                         seq_trig_in_mask;
  logic                                         seq_trig_in_d;
  logic                                         seq_trig_re;
  logic                                         trig_start_pulse;
  logic                                         trig_start;
  logic                                         trig_start_pending;
  

  always_ff @(posedge clk) begin
    if(reset) begin
      sysref_int_d <= 1'b0;
    end else begin
      sysref_int_d <= sysref_int;
    end
  end
  
  // Posedge detect for seq_trig_in
  always_ff @(posedge clk) begin
      seq_trig_in_d <= seq_trig_in;
  end

  assign seq_trig_re = seq_trig_in & ~seq_trig_in_d;
  
  // If seq_ext_trig_en enabled use seq_trig_re else use seq_start.
  assign trig_start_pulse = seq_ext_trig_en ? seq_trig_re : start;

  // The start request arrives on clk but the sequence has to begin on a sysref
  // boundary, so hold the request and release it as a single cycle pulse at the
  // next sysref. The original clocked a pulse synchroniser off sysref_int, which
  // makes a clock out of a data signal and stretches trig_start over a whole
  // sysref period, holding the counters in reset for the first interval.
  always_ff @(posedge clk) begin
    if(reset) begin
      trig_start_pending <= 1'b0;
      trig_start <= 1'b0;
    end else begin
      trig_start <= 1'b0;
      if(trig_start_pulse) begin
        trig_start_pending <= 1'b1;
      end
      if(sysref_int && (trig_start_pending || trig_start_pulse)) begin
        trig_start_pending <= 1'b0;
        trig_start <= 1'b1;
      end
    end
  end

  // Counter and count enable for tx_data_start and trigs
  always_ff @(posedge clk) begin
    if(reset) begin
      count_en <= 1'b0;
      count <= '0;
    end else begin
      if(trig_start) begin
        count_en <= 1'b1;
        count <= '0;
      end else if(count_en) begin
        // Disable counter when it reaches accum_reset_cnt
        if(count == accum_reset_cnt) begin
          count_en <= 1'b0;
          count <= '0;
        end
        if(sysref_int) begin
          count <= count + 1'b1;
        end
      end
    end
  end
  
    // Counter and count enable for rx_data_start
  always_ff @(posedge clk) begin
    if(reset) begin
      delay_count_en <= 1'b0;
      delay_count <= '0;
    end else begin
      if(trig_start) begin
        delay_count_en <= 1'b1;
        delay_count <= '0;
      end else if(delay_count_en) begin
        // Disable counter when it reaches rx_delay_cnt
        if(delay_count == rx_delay_cnt) begin
          delay_count_en <= 1'b0;
          delay_count <= '0;
        end
        if(sysref_int) begin
          delay_count <= delay_count + 1'b1;
        end
      end
    end
  end
  
  // Pulse rx_data_start when count is reached
  always_ff @(posedge clk) begin
    if(reset) begin
      rx_data_start <= 1'b0;
    end else begin
      rx_data_start <= 1'b0;
      if (rx_delay_cnt==0) begin
        rx_data_start <= 1'b1; 
      end else if(sysref_int_d && (delay_count == rx_delay_cnt)) begin
        rx_data_start <= 1'b1;
      end
    end
  end

  // Pulse tx_data_start when count equals accum_reset_cnt
  always_ff @(posedge clk) begin
    if(reset) begin
      tx_data_start <= 1'b0;
    end else begin
      tx_data_start <= 1'b0;
      if (accum_reset_cnt==0) begin
        tx_data_start <= 1'b1; 
      end else if(sysref_int_d && (count == accum_reset_cnt)) begin
        tx_data_start <= 1'b1;
      end
    end
  end

  // Set ctrl output
  always_ff @(posedge clk) begin
    if(reset) begin
      ctrl <= '0;
    end else begin
      if(sysref_int_d && (count == ctrl_change_cnt)) begin
        ctrl <= next_ctrl_value;
      end
    end
  end

  // TRIG_OUT ctrl
  genvar ii;
  for (ii=0; ii<NUM_TRIG; ii=ii+1) begin

   // Pulse trigger when count equals first_trig_cnt or second_trig_cnt, only
   // in a sequence: the idle count of zero would match a zero trigger count.
   always_ff @(posedge clk) begin
      if(reset) begin
         trig_pulse[ii] <= 1'b0;
      end else begin
         trig_pulse[ii] <= 1'b0;
         if(count_en && sysref_int_d && ((count == first_trig_cnt[ii]) || (count == second_trig_cnt[ii]))) begin
         trig_pulse[ii] <= 1'b1;
         end
      end
   end

   // Stretch trig pulse to TRIG_PULSE_WIDTH cycles
   always_ff @(posedge clk) begin
      if(reset) begin
         trig_shift[ii] <= '0;
      end else begin
         trig_shift[ii] <= {trig_shift[ii][TRIG_PULSE_WIDTH-2:0], trig_pulse[ii]};
      end
   end

   // Trigger output
   always_ff @(posedge clk) begin
      if(reset) begin
         trig_out[ii] <= 1'b0;
      end else begin
         trig_out[ii] <= |trig_shift[ii];
      end
   end

  end

endmodule

`default_nettype wire
