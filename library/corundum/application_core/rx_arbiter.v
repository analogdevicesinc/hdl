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

module rx_arbiter #(

  parameter AXIS_DATA_WIDTH = 512,
  parameter HEADER_LENGTH = 336,
  parameter VALIDATION_EN = 1
) (

  input  wire                         clk,
  input  wire                         rstn,

  input  wire                         start_app,

  // header
  input  wire [HEADER_LENGTH-1:0]     header,
  input  wire [HEADER_LENGTH-1:0]     header_routing_list,
  input  wire [HEADER_LENGTH-1:0]     header_validation_list,

  input  wire                         input_axis_tvalid,
  input  wire                         input_axis_tready,
  input  wire [AXIS_DATA_WIDTH-1:0]   input_axis_tdata,
  input  wire                         input_axis_tlast,

  output reg                          valid,
  output reg                          switch
);

  // check configuration
  initial begin
    if (AXIS_DATA_WIDTH < HEADER_LENGTH) begin
      $error("AXIS DATA WIDTH: %d must be wider than HEADER LENGTH: %d!", AXIS_DATA_WIDTH, HEADER_LENGTH);
      $finish;
    end
  end

  reg state;

  wire [HEADER_LENGTH-1:0] header_routing_checklist;
  wire [HEADER_LENGTH-1:0] header_validation_checklist;

  wire [HEADER_LENGTH-1:0] header_routing_actual;
  wire [HEADER_LENGTH-1:0] header_validation_actual;

  assign header_routing_checklist = header & header_routing_list;
  assign header_validation_checklist = header & header_validation_list;

  assign header_routing_actual = input_axis_tdata[HEADER_LENGTH-1:0] & header_routing_list;
  assign header_validation_actual = input_axis_tdata[HEADER_LENGTH-1:0] & header_validation_list;

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
      switch <= 1'b0;
      valid <= 1'b0;
    end else begin
      if (state == 1'b0 && input_axis_tvalid && input_axis_tready) begin
        switch <= 1'b0;
        valid <= 1'b0;
        if (start_app) begin
          if (header_routing_checklist == header_routing_actual) begin
            switch <= 1'b1;
            if (VALIDATION_EN) begin
              if (header_validation_checklist == header_validation_actual) begin
                valid <= 1'b1;
              end
            end else begin
              valid <= 1'b1;
            end
          end
        end
      end
    end
  end

endmodule
