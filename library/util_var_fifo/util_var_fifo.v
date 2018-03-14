// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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

module util_var_fifo #(

  // parameters

  parameter DATA_WIDTH = 32,
  parameter ADDRESS_WIDTH =  13) (

  input                       clk,
  input                       rst,

  input   [31:0]              depth,

  input   [DATA_WIDTH -1:0]   data_in,
  input                       data_in_valid,

  output  [DATA_WIDTH-1:0]    data_out,
  output                      data_out_valid,

  output                      wea_w,
  output                      en_w,
  output  [ADDRESS_WIDTH-1:0] addr_w,
  output  [DATA_WIDTH-1:0]    din_w,
  output                      en_r,
  output  [ADDRESS_WIDTH-1:0] addr_r,
  input   [DATA_WIDTH-1:0]    dout_r);

  localparam      MAX_DEPTH = (2 ** ADDRESS_WIDTH) - 1;


  // internal registers

  reg [ADDRESS_WIDTH-1:0]    addra = 'd0;
  reg [ADDRESS_WIDTH-1:0]    addrb = 'd0;

  reg [31:0]            depth_d1 = 'd0;
  reg [DATA_WIDTH-1:0]  data_in_d1 = 'd0;
  reg [DATA_WIDTH-1:0]  data_in_d2 = 'd0;
  reg [DATA_WIDTH-1:0]  data_in_d3 = 'd0;
  reg [DATA_WIDTH-1:0]  data_in_d4 = 'd0;
  reg                   data_active = 'd0;
  reg                   fifo_active = 'd0;

  reg                   data_in_valid_d1 = 'd0;
  reg                   data_in_valid_d2 = 'd0;
  reg                   interpolation_on = 'd0;
  reg                   interpolation_on_d1 = 'd0;
  reg                   interpolation_by_2 = 'd0;
  reg                   interpolation_by_2_d1 = 'd0;
  reg [DATA_WIDTH-1:0]  data_out_d1 = 'd0;
  reg [DATA_WIDTH-1:0]  data_out_d2 = 'd0;
  reg [DATA_WIDTH-1:0]  data_out_d3 = 'd0;

  // internal signals

  wire                    reset;
  wire  [DATA_WIDTH-1:0]  data_out_s;
  wire                    data_out_valid_s;

  assign reset = ((rst == 1'b1) || (depth != depth_d1) || (interpolation_on != interpolation_on_d1) || (interpolation_by_2 != interpolation_by_2_d1)) ? 1 : 0;

  assign data_out = fifo_active ? data_out_s : data_in_d4;
  assign data_out_valid_s = data_active & data_in_valid;
  assign data_out_valid = fifo_active ? data_out_valid_s : data_in_valid;

  assign wea_w = data_in_valid & fifo_active;
  assign en_w = fifo_active;
  assign addr_w = addra;
  assign din_w = data_in;
  assign en_r = fifo_active;
  assign addr_r = addrb;
  assign data_out_s = interpolation_on ? (interpolation_by_2 ? data_out_d2 : data_out_d3) : dout_r;

  // in case the interpolation is on, the data is available with one sample
  // delay. If interpolation is off, the data is available with two or three
  // sample delay. Add an extra delay if interpolation is on.
  always @(posedge clk) begin
    data_in_valid_d1 <= data_in_valid;
    data_in_valid_d2 <= data_in_valid_d1;
    interpolation_on_d1 = interpolation_on;
    interpolation_by_2_d1 = interpolation_by_2;
    if  (data_in_valid == 1'b1) begin
      if (data_in_valid_d1 == 1'b1) begin
        interpolation_on <= 1'b0;
      end else begin
        interpolation_on <= 1'b1;
        if (data_in_valid_d2 == 1'b1) begin
          interpolation_by_2 <= 1'b1;
        end else begin
          interpolation_by_2 <= 1'b0;
        end
      end
    end
    if(data_out_valid == 1'b1) begin
      data_out_d1 <= dout_r;
      data_out_d2 <= data_out_d1;
      data_out_d3 <= data_out_d2;
    end
  end

  always @(posedge clk) begin
    depth_d1 <= depth;
    if (depth == 32'h0) begin
      fifo_active <= 0;
    end else begin
      fifo_active <= 1;
    end
    if (data_in_valid == 1'b1 && fifo_active == 1'b0) begin
      data_in_d1 <= data_in;
      data_in_d2 <= data_in_d1;
      data_in_d3 <= data_in_d2;
      data_in_d4 <= data_in_d3;
    end
  end

  always @(posedge clk) begin
    if(reset == 1'b1 || fifo_active == 1'b0) begin
      addra <= 0;
      addrb <= 0;
      data_active <= 1'b0;
    end else begin
      if (data_in_valid == 1'b1) begin
        addra <= addra + 1;
        if (data_active == 1'b1) begin
          addrb <= addrb + 1;
        end
      end
      if (addra > depth || addra > MAX_DEPTH - 2) begin
        data_active <= 1'b1;
      end
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
