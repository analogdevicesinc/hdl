// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
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

// CRC polynomial 0x755B = x^16 + x^14 + x^13 + x^12 + x^10 + x^8 + x^6 + x^4 + x^3 + x + 1
// CRC width:          16 bits
// Input word width:   8 bits
// Initial value:      0x0000
// Direction:          shift left

module axi_ad4858_crc (
  input             rst,
  input             clk,
  input             crc_en,
  input      [ 7:0] d_in,
  output            crc_valid,
  output     [15:0] crc_res
);

  reg [15:0] lfsr;
  reg [15:0] crc_en_d;

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      lfsr <= 16'd0;
      crc_en_d <= 1'b0;
    end else begin
      crc_en_d <= crc_en;
      if (crc_en == 1'b1) begin
        lfsr[0]  <= lfsr[8] ^ lfsr[10] ^ lfsr[11] ^ lfsr[14] ^ lfsr[15] ^ d_in[0] ^ d_in[2] ^ d_in[3] ^ d_in[6] ^ d_in[7];
        lfsr[1]  <= lfsr[8] ^ lfsr[9] ^ lfsr[10] ^ lfsr[12] ^ lfsr[14] ^ d_in[0] ^ d_in[1] ^ d_in[2] ^ d_in[4] ^ d_in[6];
        lfsr[2]  <= lfsr[9] ^ lfsr[10] ^ lfsr[11] ^ lfsr[13] ^ lfsr[15] ^ d_in[1] ^ d_in[2] ^ d_in[3] ^ d_in[5] ^ d_in[7];
        lfsr[3]  <= lfsr[8] ^ lfsr[12] ^ lfsr[15] ^ d_in[0] ^ d_in[4] ^ d_in[7];
        lfsr[4]  <= lfsr[8] ^ lfsr[9] ^ lfsr[10] ^ lfsr[11] ^ lfsr[13] ^ lfsr[14] ^ lfsr[15] ^ d_in[0] ^ d_in[1] ^ d_in[2] ^ d_in[3] ^ d_in[5] ^ d_in[6] ^ d_in[7];
        lfsr[5]  <= lfsr[9] ^ lfsr[10] ^ lfsr[11] ^ lfsr[12] ^ lfsr[14] ^ lfsr[15] ^ d_in[1] ^ d_in[2] ^ d_in[3] ^ d_in[4] ^ d_in[6] ^ d_in[7];
        lfsr[6]  <= lfsr[8] ^ lfsr[12] ^ lfsr[13] ^ lfsr[14] ^ d_in[0] ^ d_in[4] ^ d_in[5] ^ d_in[6];
        lfsr[7]  <= lfsr[9] ^ lfsr[13] ^ lfsr[14] ^ lfsr[15] ^ d_in[1] ^ d_in[5] ^ d_in[6] ^ d_in[7];
        lfsr[8]  <= lfsr[0] ^ lfsr[8] ^ lfsr[11] ^ d_in[0] ^ d_in[3];
        lfsr[9]  <= lfsr[1] ^ lfsr[9] ^ lfsr[12] ^ d_in[1] ^ d_in[4];
        lfsr[10] <= lfsr[2] ^ lfsr[8] ^ lfsr[11] ^ lfsr[13] ^ lfsr[14] ^ lfsr[15] ^ d_in[0] ^ d_in[3] ^ d_in[5] ^ d_in[6] ^ d_in[7];
        lfsr[11] <= lfsr[3] ^ lfsr[9] ^ lfsr[12] ^ lfsr[14] ^ lfsr[15] ^ d_in[1] ^ d_in[4] ^ d_in[6] ^ d_in[7];
        lfsr[12] <= lfsr[4] ^ lfsr[8] ^ lfsr[11] ^ lfsr[13] ^ lfsr[14] ^ d_in[0] ^ d_in[3] ^ d_in[5] ^ d_in[6];
        lfsr[13] <= lfsr[5] ^ lfsr[8] ^ lfsr[9] ^ lfsr[10] ^ lfsr[11] ^ lfsr[12] ^ d_in[0] ^ d_in[1] ^ d_in[2] ^ d_in[3] ^ d_in[4];
        lfsr[14] <= lfsr[6] ^ lfsr[8] ^ lfsr[9] ^ lfsr[12] ^ lfsr[13] ^ lfsr[14] ^ lfsr[15] ^ d_in[0] ^ d_in[1] ^ d_in[4] ^ d_in[5] ^ d_in[6] ^ d_in[7];
        lfsr[15] <= lfsr[7] ^ lfsr[9] ^ lfsr[10] ^ lfsr[13] ^ lfsr[14] ^ lfsr[15] ^ d_in[1] ^ d_in[2] ^ d_in[5] ^ d_in[6] ^ d_in[7];
      end
    end
  end

  assign crc_res = lfsr;
  assign crc_valid = !crc_en & crc_en_d;
endmodule
