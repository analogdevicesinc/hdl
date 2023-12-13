// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
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

module axi_tdd_sync_gen #(
  parameter  SYNC_INTERNAL = 1,
  parameter  SYNC_EXTERNAL = 0,
  parameter  SYNC_EXTERNAL_CDC = 0,
  parameter  SYNC_COUNT_WIDTH = 64
) (

  input  logic                        clk,
  input  logic                        resetn,

  input  logic                        sync_in,
  output logic                        sync_out,

  input  logic                        tdd_enable,
  input  logic                        tdd_sync_ext,
  input  logic                        tdd_sync_int,
  input  logic                        tdd_sync_soft,
  input  logic [SYNC_COUNT_WIDTH-1:0] asy_tdd_sync_period
);

  // internal signals
  logic [1:0]                  sync_source;

  // Connect the enable signal to the enable flop lines
  (* direct_enable = "yes" *) logic enable;
  assign enable = tdd_enable;

  // first sync source (external)
  generate
    if (SYNC_EXTERNAL == 1) begin
      if (SYNC_EXTERNAL_CDC == 1) begin

        logic tdd_sync_m1 = 1'b0;
        logic tdd_sync_m2 = 1'b0;
        logic tdd_sync_m3 = 1'b0;

        // synchronization of sync_in
        always @(posedge clk) begin
          if (resetn == 1'b0) begin
            tdd_sync_m1 <= 1'b0;
            tdd_sync_m2 <= 1'b0;
            tdd_sync_m3 <= 1'b0;
          end else begin
            tdd_sync_m1 <= sync_in;
            tdd_sync_m2 <= tdd_sync_m1;
            tdd_sync_m3 <= tdd_sync_m2;
          end
        end

        assign sync_source[0] = ~tdd_sync_m3 & tdd_sync_m2;

      end else begin
        assign sync_source[0] = sync_in;
      end
    end else begin
      assign sync_source[0] = 1'b0;
    end
  endgenerate

  // second sync source (internal)
  generate
    if (SYNC_INTERNAL == 1) begin

      logic                        tdd_sync_trigger = 1'b0;
      logic [SYNC_COUNT_WIDTH-1:0] tdd_sync_counter = '0;
      logic [SYNC_COUNT_WIDTH-1:0] tdd_sync_period = '0;

      // Save the async register values only when the module is enabled
      always @(posedge clk) begin
        if (resetn == 1'b0) begin
          tdd_sync_period <= '0;
        end else begin
          if (enable) begin
            tdd_sync_period <= asy_tdd_sync_period;
          end
        end
      end

      always @(posedge clk) begin
        if (resetn == 1'b0) begin
          tdd_sync_trigger <= 1'b0;
        end else begin
          if (tdd_sync_counter == (tdd_sync_period - 1'b1)) begin
            tdd_sync_trigger <= 1'b1;
          end else begin
            tdd_sync_trigger <= 1'b0;
          end
        end
      end

      // sync counter
      always @(posedge clk) begin
        if (resetn == 1'b0) begin
          tdd_sync_counter <= '0;
        end else begin
          if (tdd_enable) begin
            tdd_sync_counter <= (tdd_sync_trigger == 1'b1) ? '0 : tdd_sync_counter + 1'b1;
          end else begin
            tdd_sync_counter <= '0;
          end
        end
      end

      assign sync_source[1] = tdd_sync_trigger;

    end else begin
      assign sync_source[1] = 1'b0;
    end
  endgenerate

  // creating the output sync signal
  assign sync_out = (tdd_sync_ext & sync_source[0]) | (tdd_sync_int & sync_source[1]) | tdd_sync_soft;

endmodule
