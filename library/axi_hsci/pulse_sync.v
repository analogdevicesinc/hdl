// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
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

`timescale 1ps/1ps

module pulse_sync (
  output wire dout,
  input  wire inclk,
  input  wire rst_inclk,
  input  wire outclk,
  input  wire rst_outclk,
  input  wire din
);

  (* ASYNC_REG = "TRUE" *) reg din_d1;
  (* ASYNC_REG = "TRUE" *) reg t;
  reg [2:0] t_d;
  reg       dout_r;

  always @(posedge inclk) begin
    if(rst_inclk) begin
      din_d1 <= 1'b0;
      t <= 1'b0;
    end else begin
      din_d1 <= din;
      if(din && !din_d1) begin
         t <= ~t;
      end
    end
  end

  always @(posedge outclk) begin
    if(rst_outclk) begin
      t_d <= 'b0;
      dout_r <= 1'b0;
    end else begin
      t_d <= {t_d[1:0], t};
      dout_r <= t_d[2] ^ t_d[1];
    end
  end

  assign dout = dout_r;

endmodule
