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

module packetizer #(

  parameter AXIS_DATA_WIDTH = 512
) (

  input  wire                         clk,
  input  wire                         rstn,

  // input
  output wire                         input_axis_tready,
  input  wire                         input_axis_tvalid,
  input  wire [AXIS_DATA_WIDTH-1:0]   input_axis_tdata,
  input  wire [AXIS_DATA_WIDTH/8-1:0] input_axis_tkeep,

  // output
  input  wire                         output_axis_tready,
  output wire                         output_axis_tvalid,
  output wire [AXIS_DATA_WIDTH-1:0]   output_axis_tdata,
  output wire [AXIS_DATA_WIDTH/8-1:0] output_axis_tkeep,
  output wire                         output_axis_tlast,

  input  wire [31:0]                  packet_size
);

  reg [31:0] sample_counter;
  reg        packet_last;

  always @(posedge clk)
  begin
    if (!rstn) begin
      if (sample_counter < packet_size-1) begin
        sample_counter <= 32'd1;
        packet_last <= 1'b0;
      end else begin
        sample_counter <= 32'd0;
        packet_last <= 1'b1;
      end
    end else begin
      if (input_axis_tvalid && input_axis_tready) begin
        if (sample_counter < packet_size-1) begin
          sample_counter <= sample_counter + 1;
          packet_last <= 1'b0;
        end else begin
          sample_counter <= 32'd0;
          packet_last <= 1'b1;
        end
      end
    end
  end

  util_axis_fifo #(
    .DATA_WIDTH(AXIS_DATA_WIDTH),
    .ADDRESS_WIDTH(2),
    .ASYNC_CLK(0),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(),
    .ALMOST_FULL_THRESHOLD(),
    .TLAST_EN(1),
    .TKEEP_EN(1),
    .REMOVE_NULL_BEAT_EN(0)
  ) packet_buffer_fifo (
    .m_axis_aclk(clk),
    .m_axis_aresetn(rstn),
    .m_axis_ready(output_axis_tready),
    .m_axis_valid(output_axis_tvalid),
    .m_axis_data(output_axis_tdata),
    .m_axis_tkeep(output_axis_tkeep),
    .m_axis_tlast(output_axis_tlast),
    .m_axis_level(),
    .m_axis_empty(),
    .m_axis_almost_empty(),
    .m_axis_full(),
    .m_axis_almost_full(),

    .s_axis_aclk(clk),
    .s_axis_aresetn(rstn),
    .s_axis_ready(input_axis_tready),
    .s_axis_valid(input_axis_tvalid),
    .s_axis_data(input_axis_tdata),
    .s_axis_tkeep(input_axis_tkeep),
    .s_axis_tlast(packet_last),
    .s_axis_room(),
    .s_axis_empty(),
    .s_axis_almost_empty(),
    .s_axis_full(),
    .s_axis_almost_full());

endmodule
