// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
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

// Re-ordering module for Flexi-SPI
//
module spi_axis_reorder #(

  parameter [3:0] NUM_OF_LANES = 2
) (
  input                          axis_aclk,
  input                          axis_aresetn,

  input                          s_axis_valid,
  output                         s_axis_ready,
  input [(NUM_OF_LANES * 32)-1:0]  s_axis_data,

  output                         m_axis_valid,
  input                          m_axis_ready,
  output     [63:0]              m_axis_data
);

  // re-packager is always ready
  assign s_axis_ready = 1'b1;

  genvar i, j;
  generate
  if (NUM_OF_LANES == 1) begin : g_reorder_1_lane_interleaved

    reg wr_addr = 0;
    reg [63:0] axis_data_int;
    reg mem_is_full;

    // address control
    // NOTE: ready is ignored, taking the fact that the module is always ready
    always @(posedge axis_aclk) begin
      if (axis_aresetn == 1'b0) begin
        wr_addr <= 1'b0;
        axis_data_int <= 64'b0;
      end else begin
        if ((s_axis_valid == 1'b1) && (s_axis_ready == 1'b1)) begin
          wr_addr <= wr_addr + 1'b1;
          axis_data_int <= (wr_addr) ? {s_axis_data, axis_data_int[31:0]} :
                                       {axis_data_int[63:32], s_axis_data};
        end
      end
    end

    // latch the state of the memory
    always @(posedge axis_aclk) begin
      if (axis_aresetn == 1'b0) begin
        mem_is_full <= 1'b0;
      end else begin
        if ((wr_addr == 1'b1) && (s_axis_valid == 1'b1)) begin
          mem_is_full <= 1'b1;
        end else begin
          mem_is_full <= 1'b0;
        end
      end
    end

    // reorder the interleaved data
    assign m_axis_valid = mem_is_full;
    for (i=0; i<32; i=i+1) begin
      assign m_axis_data[   i] = axis_data_int[2*i+1];
      assign m_axis_data[32+i] = axis_data_int[2*i];
    end

  end else if (NUM_OF_LANES == 2) begin : g_reorder_2_lanes

    assign m_axis_valid = s_axis_valid;
    assign m_axis_data = s_axis_data;

  end else if (NUM_OF_LANES == 4) begin : g_reorder_4_lanes

    assign m_axis_valid = s_axis_valid;
    for (i=0; i<16; i=i+1) begin
      // first channel
      assign m_axis_data[2*i  ]  = s_axis_data[32+i];
      assign m_axis_data[2*i+1]  = s_axis_data[   i];
      // second channel
      assign m_axis_data[2*i+32] = s_axis_data[96+i];
      assign m_axis_data[2*i+33] = s_axis_data[64+i];
    end

  end else if (NUM_OF_LANES == 8) begin : g_reorder_8_lanes

    assign m_axis_valid = s_axis_valid;
    for (i=0; i<8; i=i+1) begin
      // first channel
      assign m_axis_data[4*i  ]  = s_axis_data[96+i];
      assign m_axis_data[4*i+1]  = s_axis_data[64+i];
      assign m_axis_data[4*i+2]  = s_axis_data[32+i];
      assign m_axis_data[4*i+3]  = s_axis_data[   i];
      // second channel
      assign m_axis_data[4*i+32] = s_axis_data[224+i];
      assign m_axis_data[4*i+33] = s_axis_data[192+i];
      assign m_axis_data[4*i+34] = s_axis_data[160+i];
      assign m_axis_data[4*i+35] = s_axis_data[128+i];
    end

  end else begin
    // WARNING: Invalid configuration, leave everybody in the air
  end
  endgenerate

endmodule
