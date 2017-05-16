// ***************************************************************************
// ***************************************************************************
// Copyright 2016(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module avl_dacfifo_byteenable_coder #(

  parameter MEM_RATIO = 8,
  parameter LAST_BEATS_WIDTH = 3) (

  input                                 avl_clk,

  input       [LAST_BEATS_WIDTH-1:0]    avl_last_beats,
  input                                 avl_enable,

  output  reg [ 63:0]                   avl_byteenable

);

  always @(posedge avl_clk) begin
    if (avl_enable == 1'b1) begin
      case (avl_last_beats)
        0 : begin
          case (MEM_RATIO)
             2 : avl_byteenable <= {32'b0, {32{1'b1}}};
             4 : avl_byteenable <= {48'b0, {16{1'b1}}};
             8 : avl_byteenable <= {56'b0, {8{1'b1}}};
            16 : avl_byteenable <= {60'b0, {4{1'b1}}};
            32 : avl_byteenable <= {62'b0, {2{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        1 : begin
          case (MEM_RATIO)
             4 : avl_byteenable <= {32'b0, {32{1'b1}}};
             8 : avl_byteenable <= {48'b0, {16{1'b1}}};
            16 : avl_byteenable <= {56'b0, {8{1'b1}}};
            32 : avl_byteenable <= {60'b0, {4{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        2 : begin
          case (MEM_RATIO)
             4 : avl_byteenable <= {16'b0, {48{1'b1}}};
             8 : avl_byteenable <= {40'b0, {24{1'b1}}};
            16 : avl_byteenable <= {52'b0, {12{1'b1}}};
            32 : avl_byteenable <= {58'b0, {6{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        3 : begin
          case (MEM_RATIO)
             8 : avl_byteenable <= {32'b0, {32{1'b1}}};
            16 : avl_byteenable <= {48'b0, {16{1'b1}}};
            32 : avl_byteenable <= {56'b0, {8{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        4 : begin
          case (MEM_RATIO)
             8 : avl_byteenable <= {24'b0, {40{1'b1}}};
            16 : avl_byteenable <= {44'b0, {20{1'b1}}};
            32 : avl_byteenable <= {54'b0, {10{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        5 : begin
          case (MEM_RATIO)
             8 : avl_byteenable <= {16'b0, {48{1'b1}}};
            16 : avl_byteenable <= {40'b0, {24{1'b1}}};
            32 : avl_byteenable <= {52'b0, {12{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        6 : begin
          case (MEM_RATIO)
             8 : avl_byteenable <= {8'b0, {56{1'b1}}};
            16 : avl_byteenable <= {36'b0, {28{1'b1}}};
            32 : avl_byteenable <= {50'b0, {14{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        7 : begin
          case (MEM_RATIO)
            16 : avl_byteenable <= {32'b0, {32{1'b1}}};
            32 : avl_byteenable <= {48'b0, {16{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        8 : begin
          case (MEM_RATIO)
            16 : avl_byteenable <= {28'b0, {36{1'b1}}};
            32 : avl_byteenable <= {46'b0, {18{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        9 : begin
          case (MEM_RATIO)
            16 : avl_byteenable <= {24'b0, {40{1'b1}}};
            32 : avl_byteenable <= {44'b0, {20{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        10 : begin
          case (MEM_RATIO)
            16 : avl_byteenable <= {20'b0, {44{1'b1}}};
            32 : avl_byteenable <= {42'b0, {22{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        11 : begin
          case (MEM_RATIO)
            16 : avl_byteenable <= {16'b0, {48{1'b1}}};
            32 : avl_byteenable <= {40'b0, {24{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        12 : begin
          case (MEM_RATIO)
            16 : avl_byteenable <= {12'b0, {52{1'b1}}};
            32 : avl_byteenable <= {38'b0, {26{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        13 : begin
          case (MEM_RATIO)
            16 : avl_byteenable <= {8'b0, {56{1'b1}}};
            32 : avl_byteenable <= {36'b0, {28{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        14 : begin
          case (MEM_RATIO)
            16 : avl_byteenable <= {4'b0, {60{1'b1}}};
            32 : avl_byteenable <= {34'b0, {30{1'b1}}};
            default : avl_byteenable <= {64{1'b1}};
          endcase
        end
        15 : begin
          case (MEM_RATIO)
            32 : avl_byteenable <= {32'b0, {32{1'b1}}};
            default: avl_byteenable <= {64{1'b1}};
          endcase
        end
        16 : begin
          avl_byteenable <= {30'b0, {34{1'b1}}};
        end
        17 : begin
          avl_byteenable <= {28'b0, {36{1'b1}}};
        end
        18 : begin
          avl_byteenable <= {26'b0, {38{1'b1}}};
        end
        19 : begin
          avl_byteenable <= {24'b0, {40{1'b1}}};
        end
        20 : begin
          avl_byteenable <= {22'b0, {42{1'b1}}};
        end
        21 : begin
          avl_byteenable <= {20'b0, {44{1'b1}}};
        end
        22 : begin
          avl_byteenable <= {18'b0, {46{1'b1}}};
        end
        23 : begin
          avl_byteenable <= {16'b0, {48{1'b1}}};
        end
        24 : begin
          avl_byteenable <= {14'b0, {50{1'b1}}};
        end
        25 : begin
          avl_byteenable <= {12'b0, {52{1'b1}}};
        end
        26 : begin
          avl_byteenable <= {10'b0, {54{1'b1}}};
        end
        27 : begin
          avl_byteenable <= {8'b0, {56{1'b1}}};
        end
        28 : begin
          avl_byteenable <= {6'b0, {58{1'b1}}};
        end
        29 : begin
          avl_byteenable <= {4'b0, {60{1'b1}}};
        end
        30 : begin
          avl_byteenable <= {2'b0, {62{1'b1}}};
        end
        default : avl_byteenable <= {64{1'b1}};
      endcase
    end else begin
      avl_byteenable <= {64{1'b1}};
    end
  end

endmodule
