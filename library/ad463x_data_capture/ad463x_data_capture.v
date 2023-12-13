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

// The AD4630-24 device requires this module to capture data in master and
// echo clock mode, because the data is clocked by the BUSY/SCLKOUT line,
// independent from the SPI interface

module ad463x_data_capture #(
  parameter DDR_EN = 0,
  parameter NUM_OF_LANES = 2,
  parameter DATA_WIDTH = 32
) (
  input                                     clk,          // core clock of the SPIE
  input                                     csn,          // CSN (chip select)
  input                                     echo_sclk,    // BUSY/SCLKOUT
  input [NUM_OF_LANES-1:0]                  data_in,      // serial data lines

  output [(NUM_OF_LANES * DATA_WIDTH)-1:0]  m_axis_data,  // parallel data lines
  output                                    m_axis_valid, // data validation
  input                                     m_axis_ready  // NOTE: back pressure is ignored
);

  reg csn_d;

  wire reset;

  always @(posedge clk) begin
    csn_d <= csn;
  end

  // negative edge resets the shift registers
  assign reset = ~csn & csn_d;

  // CSN positive edge validates the output data
  // WARNING: there isn't any buffering for data, if the sink module is not
  // ready, the data will be discarded
  assign m_axis_valid = csn & ~csn_d & m_axis_ready;

  genvar i, j;
  generate
  if (DDR_EN) // Double Data Rate mode
  begin

    for (i=0; i<NUM_OF_LANES; i=i+1) begin

      reg [DATA_WIDTH-1:0] data_shift_p;
      reg [DATA_WIDTH-1:0] data_shift_n;

      // shift register for positive edge
      always @(negedge echo_sclk or posedge reset) begin
        if (reset) begin
          data_shift_n <= 0;
        end else begin
          data_shift_n <= {data_shift_n, data_in[i]};
        end
      end

      // shift register for positive edge
      always @(posedge echo_sclk or posedge reset) begin
        if (reset) begin
          data_shift_p <= 0;
        end else begin
          data_shift_p <= {data_shift_p, data_in[i]};
        end
      end

      // DDR output logic - only the first 16 bits are forwarded
      for (j=0; j<DATA_WIDTH/2; j=j+1) begin
        assign m_axis_data[DATA_WIDTH*i+(j*2)+:2] = {data_shift_p[j], data_shift_n[j]};
      end

    end /* for loop */

  end else begin  // Single Data Rate mode

    for (i=0; i<NUM_OF_LANES; i=i+1) begin

      reg [DATA_WIDTH-1:0] data_shift_n;

      // shift register for positive edge
      always @(negedge echo_sclk or posedge reset) begin
        if (reset) begin
          data_shift_n <= 0;
        end else begin
          data_shift_n <= {data_shift_n, data_in[i]};
        end
      end

      // SDR output logic
      assign m_axis_data[DATA_WIDTH*i+:DATA_WIDTH] = data_shift_n;

    end /* for loop */

  end
  endgenerate

endmodule
