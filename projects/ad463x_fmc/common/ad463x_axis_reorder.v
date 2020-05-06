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

// Re-ordering module for ad463x devices (Flexi-SPI)
//
module ad463x_axis_reorder #(

  parameter NUM_OF_SDI = 2) (

  input         axis_aclk,
  input         axis_aresetn,

  input         s_axis_valid,
  output        s_axis_ready,
  input [(NUM_OF_SDI * 32)-1:0]  s_axis_data,

  output        m_axis_valid,
  input         m_axis_ready,
  output [(NUM_OF_SDI * 32)-1:0] m_axis_data
);

  // re-packager is always ready
  assign s_axis_ready = 1'b1;

  genvar i, j;
  generate
  if (NUM_OF_SDI == 1) begin : g_reorder_1_lane

    reg m_axis_valid_int = 0;
    reg wr_addr = 0;
    reg rd_addr = 0;
    reg [63:0] axis_data_int;
    reg mem_is_full;

    // address control
    // NOTE: ready is ignored, taking the fact that the module is always ready
    always @(posedge axis_aclk) begin
      if (axis_aresetn == 1'b0) begin
        wr_addr <= 1'b0;
        rd_addr <= 1'b0;
        axis_data_int <= 64'b0;
      end else begin
        if (s_axis_valid) begin
          wr_addr <= wr_addr + 1'b1;
          axis_data_int <= (wr_addr) ? {s_axis_data, axis_data_int[31:0]} :
                                       {axis_data_int[63:32], s_axis_data};
        end
        if (m_axis_valid) begin
          rd_addr <= rd_addr + 1'b1;
        end
      end
    end

    // latch the state of the memory
    always @(posedge axis_aclk) begin
      if (axis_aresetn == 1'b0) begin
        mem_is_full <= 1'b0;
      end else begin
        if (wr_addr & s_axis_valid) begin
          mem_is_full <= 1'b1;
        end
        if (rd_addr & m_axis_valid) begin
          mem_is_full <= 1'b0;
        end
      end
    end

    // valid generation
    always @(posedge axis_aclk) begin
      if (axis_aresetn == 1'b0) begin
        m_axis_valid_int <= 1'b0;
      end else begin
        if (mem_is_full) begin
          m_axis_valid_int <= 1'b1;
        end
        if (rd_addr) begin
          m_axis_valid_int <= 1'b0;
        end
      end
    end
    assign m_axis_valid = m_axis_valid_int;

    // reorder the interleaved data
    for (i=0; i<32; i=i+1) begin
      assign m_axis_data[i] = (rd_addr) ? axis_data_int[2*i] : axis_data_int[2*i+1];
    end

  end else begin : g_reorder_248_lanes

    assign m_axis_valid = s_axis_valid;
    for (i=0; i<32; i=i+1) begin
      for (j=0; j<NUM_OF_SDI; j=j+1) begin
        assign m_axis_data[NUM_OF_SDI*i+j] = s_axis_data[i+j*32];
      end
    end

  end
  endgenerate

endmodule
