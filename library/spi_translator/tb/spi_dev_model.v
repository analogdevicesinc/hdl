// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

/*
 * Behavioural downstream SPI device. Records every MOSI byte in mem[] and
 * answers SEED, SEED+1, ... on MISO, one value per byte. Only decodes its own
 * mode, so a target driven in the wrong CPOL/CPHA records the wrong bytes;
 * mode_err also flags an SCLK idle level that does not match CPOL at CS assert.
 */

module spi_dev_model #(
  parameter CPOL = 0,
  parameter CPHA = 0,
  parameter [7:0] SEED = 8'ha0
) (
  input             cs_n,
  input             sclk,
  input             mosi,
  output  reg       miso = 1'b0
);

  reg   [7:0]       mem [0:255];
  integer           count = 0;
  reg               mode_err = 1'b0;

  reg   [7:0]       rx_sh = 8'h00;
  reg   [7:0]       tx_sh = 8'h00;
  reg   [7:0]       txv = SEED;
  integer           bitc = 0;
  reg               lead;

  always @(negedge cs_n) begin
    if (sclk !== CPOL[0]) begin
      mode_err = 1'b1;
    end
    bitc = 0;
    tx_sh = txv;
    if (CPHA == 0) begin
      miso <= #5 tx_sh[7];
      tx_sh = {tx_sh[6:0], 1'b0};
    end
  end

  always @(sclk) begin
    if (cs_n === 1'b0) begin
      lead = (CPOL == 0) ? sclk : ~sclk;
      if (lead ^ (CPHA != 0)) begin
        // sample edge
        rx_sh = {rx_sh[6:0], mosi};
        bitc = bitc + 1;
        if (bitc == 8) begin
          mem[count] = rx_sh;
          count = count + 1;
          bitc = 0;
          txv = txv + 1'b1;
          tx_sh = txv;
        end
      end else begin
        // drive edge
        miso <= #5 tx_sh[7];
        tx_sh = {tx_sh[6:0], 1'b0};
      end
    end
  end

endmodule
