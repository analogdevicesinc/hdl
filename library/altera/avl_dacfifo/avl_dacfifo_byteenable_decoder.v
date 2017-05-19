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

