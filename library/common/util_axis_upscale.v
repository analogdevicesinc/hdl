// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
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
//  + A simple AXI stream data upscale module, which can be used with devices
//    with resolution which can not be aligned to a WORD (32 bits). Eg. 24 bits
//  + It has the same control interface as the ad_datafmt module, which controls
//    the data format inside a generic AXI converter core.
//  + Supports multiple channels. Contains a single register stage.

`timescale 1ns/100ps

module util_axis_upscale #(

  parameter NUM_OF_CHANNELS = 4,
  parameter DATA_WIDTH = 24,
  parameter UDATA_WIDTH = 32
) (
  input                                           clk,
  input                                           resetn,

  input                                           s_axis_valid,
  output  reg                                     s_axis_ready,
  input       [(NUM_OF_CHANNELS*DATA_WIDTH)-1:0]  s_axis_data,

  output  reg                                     m_axis_valid,
  input                                           m_axis_ready,
  output  reg [(NUM_OF_CHANNELS*UDATA_WIDTH)-1:0] m_axis_data,

  input                                           dfmt_enable,
  input                                           dfmt_type,
  input                                           dfmt_se
);

  wire                                        type_s;
  wire                                        signext_s;
  wire    [(NUM_OF_CHANNELS*UDATA_WIDTH)-1:0] data_out_s;

  localparam MSB_WIDTH = UDATA_WIDTH - DATA_WIDTH;

  assign type_s = dfmt_enable & dfmt_type;
  assign signext_s = dfmt_enable & dfmt_se;

  genvar i;
  generate
    for (i=1; i <= NUM_OF_CHANNELS; i=i+1) begin : signext_data
      wire sign_s;

      assign sign_s = signext_s & (type_s ^ s_axis_data[(i*DATA_WIDTH-1)]);
      assign data_out_s[(i*UDATA_WIDTH-1):(i*UDATA_WIDTH-MSB_WIDTH)] = {(MSB_WIDTH){sign_s}};
      assign data_out_s[((i-1)*UDATA_WIDTH+DATA_WIDTH-1)] = type_s ^ s_axis_data[(i*DATA_WIDTH-1)];
      assign data_out_s[((i-1)*UDATA_WIDTH+DATA_WIDTH-2):((i-1)*UDATA_WIDTH)] = s_axis_data[(i*DATA_WIDTH-2):((i-1)*DATA_WIDTH)];
    end
  endgenerate

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      m_axis_valid <= 1'b0;
      s_axis_ready <= 1'b0;
      m_axis_data <= {(NUM_OF_CHANNELS*UDATA_WIDTH){1'b0}};
    end else begin
      m_axis_valid <= s_axis_valid;
      s_axis_ready <= m_axis_ready;
      m_axis_data <= data_out_s;
    end
  end

endmodule
