// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
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

`include "macro_definitions.vh"

module header_checker #(

  parameter AXIS_DATA_WIDTH = 64,
  parameter HEADER_LENGTH = 336
) (

  input  wire                       clk,
  input  wire                       rstn,

  input  wire                       start_app,

  // header
  input  wire [HEADER_LENGTH-1:0]   header,
  input  wire [HEADER_LENGTH-1:0]   header_list,

  input  wire                       input_axis_tvalid,
  input  wire                       input_axis_tready,
  input  wire [AXIS_DATA_WIDTH-1:0] input_axis_tdata,
  input  wire                       input_axis_tlast,

  output reg                        matching,
  output reg                        valid
);

  localparam HEADER_PARTS = HEADER_LENGTH/AXIS_DATA_WIDTH + ((HEADER_LENGTH % AXIS_DATA_WIDTH) ? 1 : 0) - 1;

  reg state;

  generate

    if (HEADER_PARTS == 0) begin

      wire [HEADER_LENGTH-1:0] header_checklist;
      wire [HEADER_LENGTH-1:0] header_actual;

      assign header_checklist = header & header_list;
      assign header_actual = input_axis_tdata[HEADER_LENGTH-1:0] & header_list;

      always @(posedge clk)
      begin
        if (!rstn) begin
          state <= 1'b0;
        end else begin
          if (input_axis_tvalid && input_axis_tready && input_axis_tlast) begin
            state <= 1'b0;
          end else if (state == 1'b0 && input_axis_tvalid && input_axis_tready) begin
            state <= 1'b1;
          end
        end
      end

      always @(posedge clk)
      begin
        if (!rstn) begin
          matching <= 1'b0;
          valid <= 1'b0;
        end else begin
          if (state == 1'b0 && input_axis_tvalid && input_axis_tready) begin
            matching <= 1'b0;
            valid <= 1'b1;
            if (start_app) begin
              if (header_checklist == header_actual) begin
                matching <= 1'b1;
              end
            end
          end
        end
      end

    end else begin

      wire [HEADER_LENGTH-1:0] header_checklist;
      wire [HEADER_LENGTH-1:0] header_actual;

      reg  [AXIS_DATA_WIDTH*HEADER_PARTS-1:0] parts_actual;

      reg  [$clog2(HEADER_LENGTH)-1:0] header_counter;

      assign header_checklist = header & header_list;
      assign header_actual = {input_axis_tdata[HEADER_LENGTH%AXIS_DATA_WIDTH-1:0] & header_list, parts_actual};

      always @(posedge clk)
      begin
        if (!rstn) begin
          header_counter <= 'd0;
        end else begin
          if (input_axis_tvalid && input_axis_tready) begin
            if (input_axis_tlast) begin
              header_counter <= 'd0;
            end
            if (header_counter < HEADER_LENGTH) begin
              header_counter <= header_counter + 1;
            end
          end
        end
      end

      always @(posedge clk)
      begin
        if (!rstn) begin
          parts_actual <= {HEADER_LENGTH{1'b0}};
        end else begin
          if (header_counter != HEADER_LENGTH && input_axis_tvalid && input_axis_tready) begin
            parts_actual[header_counter*HEADER_LENGTH +: HEADER_LENGTH] <= input_axis_tdata;
          end
        end
      end

      always @(posedge clk)
      begin
        if (!rstn) begin
          state <= 1'b0;
        end else begin
          if (input_axis_tvalid && input_axis_tready && input_axis_tlast) begin
            state <= 1'b0;
          end else if (state == 1'b0 && input_axis_tvalid && input_axis_tready) begin
            state <= 1'b1;
          end
        end
      end

      always @(posedge clk)
      begin
        if (!rstn) begin
          matching <= 1'b0;
          valid <= 1'b0;
        end else begin
          if (state == 1'b0 && input_axis_tvalid && input_axis_tready) begin
            matching <= 1'b0;
            valid <= 1'b0;
            if (start_app) begin
              if (header_checklist == header_actual) begin
                matching <= 1'b1;
              end
            end
            if (header_counter == HEADER_LENGTH) begin
              valid <= 1'b1;
            end
          end
        end
      end

    end

  endgenerate

endmodule
