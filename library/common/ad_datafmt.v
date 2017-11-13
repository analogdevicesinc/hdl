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
// data format (offset binary or 2's complement only)

`timescale 1ps/1ps

module ad_datafmt #(

  // data bus width

  parameter   DATA_WIDTH = 16,
  parameter   OCTETS_PER_SAMPLE = 2,
  parameter   DISABLE = 0) (

  // data path

  input                       clk,
  input                       valid,
  input   [(DATA_WIDTH-1):0]  data,
  output                      valid_out,
  output  [(8*OCTETS_PER_SAMPLE-1):0]  data_out,

  // control signals

  input                       dfmt_enable,
  input                       dfmt_type,
  input                       dfmt_se);

  // internal registers

  reg                         valid_int = 'd0;
  reg     [(8*OCTETS_PER_SAMPLE-1):0]  data_int = 'd0;

  // internal signals

  wire                        type_s;
  wire    [(8*OCTETS_PER_SAMPLE-1):0]  data_out_s;

  // data-path disable

  generate
  if (DISABLE == 1) begin
  assign valid_out = valid;
  assign data_out = data;
  end else begin
  assign valid_out = valid_int;
  assign data_out = data_int;
  end
  endgenerate

  // if offset-binary convert to 2's complement first

  assign type_s = dfmt_enable & dfmt_type;

  generate
  if (DATA_WIDTH < 8*OCTETS_PER_SAMPLE) begin
    wire signext_s;
    wire sign_s;

    assign signext_s = dfmt_enable & dfmt_se;
    assign sign_s = signext_s & (type_s ^ data[(DATA_WIDTH-1)]);
    assign data_out_s[(8*OCTETS_PER_SAMPLE-1):DATA_WIDTH] = {((8*OCTETS_PER_SAMPLE)-DATA_WIDTH){sign_s}};
  end
  endgenerate

  assign data_out_s[(DATA_WIDTH-1)] = type_s ^ data[(DATA_WIDTH-1)];
  assign data_out_s[(DATA_WIDTH-2):0] = data[(DATA_WIDTH-2):0];

  always @(posedge clk) begin
    valid_int <= valid;
    data_int <= data_out_s;
  end

endmodule

// ***************************************************************************
// ***************************************************************************
