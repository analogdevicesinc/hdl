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
// freedoms and responsabilities that he or she has by using this source/core.
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

module avl_dacfifo_byteenable_decoder #(

  parameter MEM_RATIO = 8,
  parameter LAST_BEATS_WIDTH = 3) (

  input                               avl_clk,

  input       [ 63:0]                 avl_byteenable,
  input                               avl_enable,

  output  reg [LAST_BEATS_WIDTH-1:0]  avl_last_beats
);

  always @(posedge avl_clk) begin
    if (avl_enable == 1'b1) begin
      case (avl_byteenable)
        64'b0000000000000000000000000000000000000000000000000000000000000011: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 0;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000000000000000000000000000000000000001111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 1;
            16 : avl_last_beats <= 0;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000000000000000000000000000000000000111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 2;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000000000000000000000000000000000011111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 3;
            16 : avl_last_beats <= 1;
             8 : avl_last_beats <= 0;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000000000000000000000000000000001111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 4;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000000000000000000000000000000111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 5;
            16 : avl_last_beats <= 2;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000000000000000000000000000011111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 6;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000000000000000000000000001111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 7;
            16 : avl_last_beats <= 3;
             8 : avl_last_beats <= 1;
             4 : avl_last_beats <= 0;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000000000000000000000000111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 8;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000000000000000000000011111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 9;
            16 : avl_last_beats <= 4;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000000000000000000001111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 10;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000000000000000000111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 11;
            16 : avl_last_beats <= 5;
             8 : avl_last_beats <= 2;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000000000000000011111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 12;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000000000000001111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 13;
            16 : avl_last_beats <= 6;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000000000000111111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 14;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000000000011111111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 15;
            16 : avl_last_beats <= 7;
             8 : avl_last_beats <= 3;
             4 : avl_last_beats <= 1;
             2 : avl_last_beats <= 0;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000000001111111111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 16;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000000111111111111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 17;
            16 : avl_last_beats <= 8;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000000011111111111111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 18;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000001111111111111111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 19;
            16 : avl_last_beats <= 9;
             8 : avl_last_beats <= 4;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000000111111111111111111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 20;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000000011111111111111111111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 21;
            16 : avl_last_beats <= 10;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000001111111111111111111111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 22;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000000111111111111111111111111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 23;
            16 : avl_last_beats <= 11;
             8 : avl_last_beats <= 5;
             4 : avl_last_beats <= 2;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000000011111111111111111111111111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 24;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000001111111111111111111111111111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 25;
            16 : avl_last_beats <= 12;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000000111111111111111111111111111111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 26;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000000011111111111111111111111111111111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 27;
            16 : avl_last_beats <= 13;
             8 : avl_last_beats <= 6;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000001111111111111111111111111111111111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 28;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0000111111111111111111111111111111111111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 29;
            16 : avl_last_beats <= 14;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
        64'b0011111111111111111111111111111111111111111111111111111111111111: begin
          case (MEM_RATIO)
            32 : avl_last_beats <= 30;
            default : avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
          endcase
        end
          default: avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
      endcase
    end else begin
      avl_last_beats <= {LAST_BEATS_WIDTH{1'b1}};
    end
  end

endmodule

