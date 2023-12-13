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

`timescale 1ns/100ps

module adrv9001_aligner8 (
  input             clk,
  input             rst,
  input       [7:0] idata,
  input             ivalid,
  input       [7:0] strobe,
  output reg  [7:0] odata,
  output            ovalid
);

  reg [7:0] idata_d = 'b0;
  reg       ivalid_d = 'b0;

  always @(posedge clk) begin
    if (rst) begin
      idata_d <= 'h0;
    end else if (ivalid) begin
      idata_d <= idata;
    end
    ivalid_d <= ivalid;
  end

  reg [2:0] phase = 'h0;
  always @(posedge clk) begin
    if (rst) begin
      phase <= 0;
    end if (ivalid) begin
      if ((strobe != 'b1111_1111) && (strobe != 'b0000_0000)) begin
        casex (strobe)
          'b1xxx_xxxx : phase <= 0;
          'b01xx_xxxx : phase <= 1;
          'b001x_xxxx : phase <= 2;
          'b0001_xxxx : phase <= 3;
          'b0000_1xxx : phase <= 4;
          'b0000_01xx : phase <= 5;
          'b0000_001x : phase <= 6;
          'b0000_0001 : phase <= 7;
          default     : phase <= phase;
        endcase
      end
    end
  end

  always @(posedge clk) begin
    case (phase)
      0 : odata <= idata_d;
      1 : odata <= {idata_d[6:0],idata[7:7]};
      2 : odata <= {idata_d[5:0],idata[7:6]};
      3 : odata <= {idata_d[4:0],idata[7:5]};
      4 : odata <= {idata_d[3:0],idata[7:4]};
      5 : odata <= {idata_d[2:0],idata[7:3]};
      6 : odata <= {idata_d[1:0],idata[7:2]};
      7 : odata <= {idata_d[0:0],idata[7:1]};
    endcase
  end
  assign ovalid = ivalid_d;

endmodule
