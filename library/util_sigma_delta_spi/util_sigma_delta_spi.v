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

module util_sigma_delta_spi (
  input clk,
  input resetn,

  input spi_active,

  input s_sclk,
  input s_sdo,
  input s_sdo_t,
  output s_sdi,
  input [NUM_OF_CS-1:0] s_cs,

  output m_sclk,
  output m_sdo,
  output m_sdo_t,
  input m_sdi,
  output [NUM_OF_CS-1:0] m_cs,

  output reg data_ready
);

parameter NUM_OF_CS = 1;
parameter CS_PIN = 0;
parameter IDLE_TIMEOUT = 63;

/*
 * For converters from the ADI SigmaDelta family the data ready interrupt signal
 * uses the same physical wire as the the DOUT signal for the SPI bus. This
 * module extracts the data ready signal from the SPI bus and makes sure to
 * suppress false positives. The data ready signal is indicated by the converter
 * by pulling DOUT low. This will only happen if the CS pin for the converter is
 * low and no SPI transfer is active. There is a small delay between the end of
 * the SPI transfer and the point where the converter starts to indicate the
 * data ready signal. IDLE_TIMEOUT allows to specify the amount of clock cycles
 * the bus needs to be idle before the data ready signal is detected.
 */

assign m_sclk = s_sclk;
assign m_sdo = s_sdo;
assign m_sdo_t = s_sdo_t;
assign s_sdi = m_sdi;
assign m_cs = s_cs;

reg [$clog2(IDLE_TIMEOUT)-1:0] counter = IDLE_TIMEOUT;
reg [2:0] sdi_d = 'h00;

always @(posedge clk) begin
  if (resetn == 1'b0) begin
    counter <= IDLE_TIMEOUT;
  end else begin
    if (s_cs[CS_PIN] == 1'b0 && spi_active == 1'b0) begin
      if (counter != 'h00)
        counter <= counter - 1'b1;
    end else begin
      counter <= IDLE_TIMEOUT;
    end
  end
end

always @(posedge clk) begin
  /* The data ready signal is fully asynchronous */
  sdi_d <= {sdi_d[1:0], m_sdi};
end

always @(posedge clk) begin
  if (counter == 'h00 && sdi_d[2] == 1'b0) begin
    data_ready <= 1'b1;
  end else begin
    data_ready <= 1'b0;
  end
end

endmodule
