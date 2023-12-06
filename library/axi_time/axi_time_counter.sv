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
`timescale 1ns/1ps

module axi_time_counter #(
  parameter  COUNT_WIDTH = 64,
  parameter  SYNC_EXTERNAL = 1,
  parameter  SYNC_EXTERNAL_CDC = 1
) (

  input  logic                         clk,
  input  logic                         resetn,

  input  logic                         sync_in,

  input  logic                         time_enable,
  input  logic                         time_sync_ext,
  input  logic                         time_sync_soft,

  output logic                         time_overwrite_ready,
  input  logic                         time_overwrite_valid,

  output logic [COUNT_WIDTH-1:0]       time_counter,
  input  logic [COUNT_WIDTH-1:0]       time_overwrite
);

  // package import
  import axi_time_pkg::*;

  // internal registers/wires
  logic overwrite_valid;
  logic time_reset;
  logic time_sync;

  // initial values
  initial begin
    time_counter = '0;
  end

  // External sync
  generate
    if (SYNC_EXTERNAL == 1) begin
      if (SYNC_EXTERNAL_CDC == 1) begin

        logic time_sync_m1 = 1'b0;
        logic time_sync_m2 = 1'b0;
        logic time_sync_m3 = 1'b0;

        // synchronization of sync_in
        always @(posedge clk) begin
          if (resetn == 1'b0) begin
            time_sync_m1 <= 1'b0;
            time_sync_m2 <= 1'b0;
            time_sync_m3 <= 1'b0;
          end else begin
            time_sync_m1 <= sync_in;
            time_sync_m2 <= time_sync_m1;
            time_sync_m3 <= time_sync_m2;
          end
        end

        assign time_sync = ~time_sync_m3 & time_sync_m2;

      end else begin
        assign time_sync = sync_in;
      end
    end else begin
      assign time_sync = 1'b0;
    end
  endgenerate

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      overwrite_valid <= 1'b0;
    end else begin
      if (time_enable && time_overwrite_valid) begin
        overwrite_valid <= 1'b1;
      end else begin
        if (time_reset) begin
          overwrite_valid <= 1'b0;
        end
      end
    end
  end

  assign time_overwrite_ready = ~overwrite_valid;
  assign time_reset = (time_sync & time_sync_ext) | time_sync_soft;

  // Timestamp free running counter
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      time_counter <= 'h0;
    end else begin
      if (time_reset) begin
        time_counter <= overwrite_valid ? time_overwrite : 'h0;
      end else begin
        if (time_enable) begin
          time_counter <= time_counter + 1'b1;
        end
      end
    end
  end

endmodule
