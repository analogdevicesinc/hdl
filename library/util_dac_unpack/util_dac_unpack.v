// ***************************************************************************
// ***************************************************************************
// Copyright 2014(c) Analog Devices, Inc.
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
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module util_dac_unpack (

  clk,

  dac_enable_00,
  dac_valid_00,
  dac_data_00,

  dac_enable_01,
  dac_valid_01,
  dac_data_01,

  dac_enable_02,
  dac_valid_02,
  dac_data_02,

  dac_enable_03,
  dac_valid_03,
  dac_data_03,

  dac_enable_04,
  dac_valid_04,
  dac_data_04,

  dac_enable_05,
  dac_valid_05,
  dac_data_05,

  dac_enable_06,
  dac_valid_06,
  dac_data_06,

  dac_enable_07,
  dac_valid_07,
  dac_data_07,

  fifo_valid,
  dma_rd,
  dma_data);

  input           clk;

  input           dac_enable_00;
  input           dac_valid_00;
  output  [ 15:0] dac_data_00;

  input           dac_enable_01;
  input           dac_valid_01;
  output  [ 15:0] dac_data_01;

  input           dac_enable_02;
  input           dac_valid_02;
  output  [ 15:0] dac_data_02;

  input           dac_enable_03;
  input           dac_valid_03;
  output  [ 15:0] dac_data_03;

  input           dac_enable_04;
  input           dac_valid_04;
  output  [ 15:0] dac_data_04;

  input           dac_enable_05;
  input           dac_valid_05;
  output  [ 15:0] dac_data_05;

  input           dac_enable_06;
  input           dac_valid_06;
  output  [ 15:0] dac_data_06;

  input           dac_enable_07;
  input           dac_valid_07;
  output  [ 15:0] dac_data_07;

  input           fifo_valid;
  output          dma_rd;
  input   [127:0] dma_data;

  wire [3:0]      enable_cnt;
  wire            dac_chan_valid;

  wire [ 1:0] position_2;
  wire [ 1:0] position_3;
  wire [ 2:0] position_4;
  wire [ 2:0] position_5;
  wire [ 2:0] position_6;
  wire [ 2:0] position_7;

  reg [  7:0] path_enabled = 0;
  reg [  2:0] counter_0 = 0;
  reg [  2:0] counter_d1 = 0;
  reg [ 15:0] dac_data_00 = 16'h0;
  reg [ 15:0] dac_data_01 = 16'h0;
  reg [ 15:0] dac_data_02 = 16'h0;
  reg [ 15:0] dac_data_03 = 16'h0;
  reg [ 15:0] dac_data_04 = 16'h0;
  reg [ 15:0] dac_data_05 = 16'h0;
  reg [ 15:0] dac_data_06 = 16'h0;
  reg [ 15:0] dac_data_07 = 16'h0;
  reg [127:0] buffer_r = 128'h0;
  reg         dma_rd = 1'b0;
  reg         start = 1'b0;

  assign enable_cnt = dac_enable_07 + dac_enable_06 + dac_enable_05 + dac_enable_04 + dac_enable_03 + dac_enable_02 + dac_enable_01 + dac_enable_00;

  assign position_2 = dac_enable_00 + dac_enable_01;
  assign position_3 = dac_enable_00 + dac_enable_01 + dac_enable_02;
  assign position_4 = dac_enable_00 + dac_enable_01 + dac_enable_02 + dac_enable_03;
  assign position_5 = dac_enable_00 + dac_enable_01 + dac_enable_02 + dac_enable_03 + dac_enable_04;
  assign position_6 = dac_enable_00 + dac_enable_01 + dac_enable_02 + dac_enable_03 + dac_enable_04 + dac_enable_05;
  assign position_7 = dac_enable_00 + dac_enable_01 + dac_enable_02 + dac_enable_03 + dac_enable_04 + dac_enable_05 + dac_enable_06;

  assign dac_chan_valid = dac_valid_07 | dac_valid_06 | dac_valid_05 | dac_valid_04 | dac_valid_03 | dac_valid_02 | dac_valid_01 | dac_valid_00;

  always @(enable_cnt)
  begin
    case(enable_cnt)
     4'h1: path_enabled = 8'h01;
     4'h2: path_enabled = 8'h02;
     4'h4: path_enabled = 8'h08;
     4'h8: path_enabled = 8'h80;
     default: path_enabled = 8'h0;
    endcase
  end

  always @(posedge clk)
  begin
    counter_d1  <= counter_0;
    case (path_enabled)
      8'h1:
        begin
          if (counter_0 == 7 && counter_d1 == 6)
          begin
            dma_rd  <= 1'b1;
          end
          else
          begin
            dma_rd  <= 1'b0;
          end
        end
      8'h02:
        begin
          if(counter_0 == 6 && counter_d1 == 4)
          begin
            dma_rd <= 1'b1;
          end
          else
          begin
            dma_rd <= 1'b0;
          end
        end
      8'h08:
        begin
          if(counter_0 == 4 && counter_d1 == 0)
          begin
            dma_rd <= 1'b1;
          end
          else
          begin
            dma_rd <= 1'b0;
          end
        end
      8'h80:
        begin
          dma_rd <= 1'b1;
        end
      default : dma_rd <= 1'b0;
    endcase

      if (fifo_valid == 1'b1)
      begin
        buffer_r    <= dma_data;
      end
  end

  always @(posedge clk)
  begin
    if (path_enabled == 8'h0)
    begin
      counter_0 <= 3'h0;
    end
    else
    begin
      if (dac_chan_valid == 1'b1 )
      begin
        counter_0 <= counter_0 + enable_cnt;
      end
    end
  end

  always @(posedge clk)
  begin

    // channel 0
    if (dac_enable_00 == 1'b1)
    begin
      case(counter_0)
        0:
        begin
          dac_data_00 <= buffer_r[15:0];
        end
        1:
        begin
          dac_data_00 <= buffer_r[31:16];
        end
        2:
        begin
          dac_data_00 <= buffer_r[47:32];
        end
        3:
        begin
          dac_data_00 <= buffer_r [63:48];
        end
        4:
        begin
          dac_data_00 <= buffer_r [79:64];
        end
        5:
        begin
          dac_data_00 <= buffer_r [95:80];
        end
        6:
        begin
          dac_data_00 <= buffer_r [111:96];
        end
        7:
        begin
          dac_data_00 <= buffer_r [127:112];
        end
        default:
        begin
          dac_data_00 <= 16'hdead;
        end
      endcase
    end
    else
    begin
      dac_data_00 <= 16'h0;
    end

    // channel 1
    if (dac_enable_01 == 1'b1)
    begin
      case (counter_0)
        0:
        begin
          if (dac_enable_00 == 1'b0)
          begin
            dac_data_01 <= buffer_r[15:0];
          end
          else
          begin
            dac_data_01 <= buffer_r[31:16];
          end
        end
        1:
        begin
          dac_data_01   <= buffer_r[31:16];
        end
        2:
        begin
          if (dac_enable_00 == 1'b0 )
          begin
            dac_data_01 <= buffer_r[47:32];
          end
          else
          begin
            dac_data_01 <= buffer_r[63:48];
          end
        end
        3:
        begin
          dac_data_01 <= buffer_r[63:48];
        end
        4:
        begin
          begin
            if (dac_enable_00 == 1'b0)
            begin
              dac_data_01 <= buffer_r[79:64];
            end
            else
            begin
              dac_data_01 <= buffer_r[95:80];
            end
          end
        end
        5:
        begin
          dac_data_01 <= buffer_r[95:80];
        end
        6:
        begin
          if (path_enabled == 8'h1)
          begin
            dac_data_01 <= buffer_r [111:96];
          end
          if (path_enabled == 8'h2)
          begin
            if (dac_enable_00 == 1'b0)
            begin
              dac_data_01 <= buffer_r[111:96];
            end
            else
            begin
              dac_data_01 <= buffer_r[127:112];
            end
          end
        end
        7:
        begin
          dac_data_01 <= buffer_r[127:112];
        end
        default:
        begin
          dac_data_01 <= 16'hdead;
        end
      endcase
    end
    else
    begin
      dac_data_01 <= 16'h0;
    end

    // channel 2
    if (dac_enable_02 == 1'b1)
    begin
      case (counter_0)
        0:
        begin
          if (position_2 == 2'h00)
          begin
            dac_data_02 <= buffer_r[15:0];
          end
          if (position_2 == 2'h01)
          begin
            dac_data_02 <= buffer_r[31:16];
          end
          if (position_2 == 2'h02)
          begin
            dac_data_02 <= buffer_r[47:32];
          end
        end
        1:
        begin
          dac_data_02 <= buffer_r[31:16];
        end
        2:
        begin
          if (position_2 == 2'h00)
          begin
            dac_data_02 <= buffer_r[47:32];
          end
          else
          begin
            dac_data_02 <= buffer_r[63:48];
          end
        end
        3:
        begin
          dac_data_02 <= buffer_r[63:48];
        end
        4:
        begin
          if (position_2 == 2'h00)
          begin
            dac_data_02 <= buffer_r[79:64];
          end
          if (position_2 == 2'h01)
          begin
            dac_data_02 <= buffer_r[95:80];
          end
          if (position_2 == 2'h02)
          begin
            dac_data_02 <= buffer_r[111:96];
          end
        end
        5:
        begin
          dac_data_02 <= buffer_r[95:80];
        end
        6:
        begin
          if (position_2 == 2'h00)
          begin
            dac_data_02 <= buffer_r[111:96];
          end
          else
          begin
            dac_data_02 <= buffer_r[127:112];
          end
        end
        7:
        begin
          dac_data_02 <= buffer_r[127:112];
        end
        default:
        begin
          dac_data_02 <= 16'hdead;
        end
      endcase
    end
    else
    begin
      dac_data_02 <= 16'h0;
    end

    // channel 3
    if (dac_enable_03 == 1'b1)
    begin
      case (counter_0)
        0:
        begin
          if (position_3 == 2'h00)
          begin
            dac_data_03 <= buffer_r [15:0];
          end
          if (position_3 == 2'h01)
          begin
            dac_data_03 <= buffer_r [31:16];
          end
          if (position_3 == 2'h02)
          begin
            dac_data_03 <= buffer_r [47:32];
          end
          if (position_3 == 2'h03)
          begin
            dac_data_03 <= buffer_r [63:48];
          end
        end
        1:
        begin
          dac_data_03 <= buffer_r [31:16];
        end
        2:
        begin
          if (position_3 == 2'h00)
          begin
            dac_data_03 <= buffer_r [47:32];
          end
          else
          begin
            dac_data_03 <= buffer_r [63:48];
          end
        end
        3:
        begin
          dac_data_03 <= buffer_r [63:48];
        end
        4:
        begin
          if (position_3 == 2'h00)
          begin
            dac_data_03 <= buffer_r [79:64];
          end
          if (position_3 == 2'h01)
          begin
            dac_data_03 <= buffer_r [95:80];
          end
          if (position_3 == 2'h02)
          begin
            dac_data_03 <= buffer_r [111:96];
          end
          if (position_3 == 2'h03)
          begin
            dac_data_03 <= buffer_r [127:112];
          end
        end
        5:
        begin
          dac_data_03 <= buffer_r [95:80];
        end
        6:
        begin
          if (position_3 == 2'h00)
          begin
            dac_data_03 <= buffer_r [111:96];
          end
          else
          begin
            dac_data_03 <= buffer_r [127:112];
          end
        end
        7:
        begin
          dac_data_03 <= buffer_r [127:112];
        end
        default:
        begin
          dac_data_03 <= 16'hdead;
        end
      endcase
    end
    else
    begin
      dac_data_03 <= 16'h0;
    end

    // channel 4
    if (dac_enable_04 == 1'b1)
    begin
      case (counter_0)
        0:
        begin
          case (position_4)
            0: dac_data_04 <= buffer_r [15:0];
            1: dac_data_04 <= buffer_r [31:16];
            2: dac_data_04 <= buffer_r [47:32];
            3: dac_data_04 <= buffer_r [63:48];
            default: dac_data_04  <= buffer_r[79:64];
          endcase
        end
        1:
        begin
          dac_data_04 <= buffer_r [31:16];
        end
        2:
        begin
          if (position_4 == 3'h00)
          begin
            dac_data_04 <= buffer_r [47:32];
          end
          else
          begin
            dac_data_04 <= buffer_r [63:48];
          end
        end
        3:
        begin
          dac_data_04 <= buffer_r [63:48];
        end
        4:
        begin
          case (position_4)
            0: dac_data_04 <= buffer_r [79:64];
            1: dac_data_04 <= buffer_r [95:80];
            2: dac_data_04 <= buffer_r [111:96];
            default: dac_data_04 <= buffer_r [127:112];
          endcase
        end
        5:
        begin
          dac_data_04 <= buffer_r [95:80];
        end
        6:
        begin
          if (position_4 == 2'h00)
          begin
            dac_data_04 <= buffer_r [111:96];
          end
          else
          begin
            dac_data_04 <= buffer_r [127:112];
          end
        end
        7:
        begin
          dac_data_04 <= buffer_r [127:112];
        end
        default:
        begin
          dac_data_04 <= 16'hdead;
        end
      endcase
    end
    else
    begin
      dac_data_04 <= 16'h0;
    end

    // channel 5
    if (dac_enable_05 == 1'b1)
    begin
      case (counter_0)
        0:
        begin
          case (position_5)
            0: dac_data_05 <= buffer_r [15:0];
            1: dac_data_05 <= buffer_r [31:16];
            2: dac_data_05 <= buffer_r [47:32];
            3: dac_data_05 <= buffer_r [63:48];
            default: dac_data_05  <= buffer_r[95:80];
          endcase
        end
        1:
        begin
          dac_data_05 <= buffer_r [31:16];
        end
        2:
        begin
          if (position_5 == 3'h00)
          begin
            dac_data_05 <= buffer_r [47:32];
          end
          else
          begin
            dac_data_05 <= buffer_r [63:48];
          end
        end
        3:
        begin
          dac_data_05 <= buffer_r [63:48];
        end
        4:
        begin
          case (position_5)
            0: dac_data_05 <= buffer_r [79:64];
            1: dac_data_05 <= buffer_r [95:80];
            2: dac_data_05 <= buffer_r [111:96];
            default: dac_data_05 <= buffer_r [127:112];
          endcase
        end
        5:
        begin
          dac_data_05 <= buffer_r [95:80];
        end
        6:
        begin
          if (position_5 == 2'h00)
          begin
            dac_data_05 <= buffer_r [111:96];
          end
          else
          begin
            dac_data_05 <= buffer_r [127:112];
          end
        end
        7:
        begin
          dac_data_05 <= buffer_r [127:112];
        end
        default:
        begin
          dac_data_05 <= 16'hdead;
        end
      endcase
    end
    else
    begin
      dac_data_05 <= 16'h0;
    end

    // channel 6
    if (dac_enable_06 == 1'b1)
    begin
      case (counter_0)
        0:
        begin
          case (position_6)
            0: dac_data_06 <= buffer_r [15:0];
            1: dac_data_06 <= buffer_r [31:16];
            2: dac_data_06 <= buffer_r [47:32];
            3: dac_data_06 <= buffer_r [63:48];
            default: dac_data_06  <= buffer_r[111:96];
          endcase
        end
        1:
        begin
          dac_data_06 <= buffer_r [31:16];
        end
        2:
        begin
          if (position_6 == 3'h00)
          begin
            dac_data_06 <= buffer_r [47:32];
          end
          else
          begin
            dac_data_06 <= buffer_r [63:48];
          end
        end
        3:
        begin
          dac_data_06 <= buffer_r [63:48];
        end
        4:
        begin
          case (position_6)
            0: dac_data_06 <= buffer_r [79:64];
            1: dac_data_06 <= buffer_r [95:80];
            2: dac_data_06 <= buffer_r [111:96];
            default: dac_data_06 <= buffer_r [127:112];
          endcase
        end
        5:
        begin
          dac_data_06 <= buffer_r [95:80];
        end
        6:
        begin
          if (position_6 == 2'h00)
          begin
            dac_data_06 <= buffer_r [111:96];
          end
          else
          begin
            dac_data_06 <= buffer_r [127:112];
          end
        end
        7:
        begin
          dac_data_06 <= buffer_r [127:112];
        end
        default:
        begin
          dac_data_06 <= 16'hdead;
        end
      endcase
    end
    else
    begin
      dac_data_06 <= 16'h0;
    end

    // channel 7
    if (dac_enable_07 == 1'b1)
    begin
      case (counter_0)
        0:
        begin
          case (position_7)
            0: dac_data_07 <= buffer_r[15:0];
            1: dac_data_07 <= buffer_r[31:16];
            3: dac_data_07 <= buffer_r[63:48];
            default: dac_data_07  <= buffer_r[127:112];
          endcase
        end
        1:
        begin
          dac_data_07 <= buffer_r [31:16];
        end
        2:
        begin
          if (position_7 == 3'h00)
          begin
            dac_data_07 <= buffer_r [47:32];
          end
          else
          begin
            dac_data_07 <= buffer_r [63:48];
          end
        end
        3:
        begin
          dac_data_07 <= buffer_r [63:48];
        end
        4:
        begin
          case (position_7)
            0: dac_data_07 <= buffer_r [79:64];
            1: dac_data_07 <= buffer_r [95:80];
            default: dac_data_07 <= buffer_r [127:112];
          endcase
        end
        5:
        begin
          dac_data_07 <= buffer_r [95:80];
        end
        6:
        begin
          if (position_7 == 2'h00)
          begin
            dac_data_07 <= buffer_r [111:96];
          end
          else
          begin
            dac_data_07 <= buffer_r [127:112];
          end
        end
        7:
        begin
          dac_data_07 <= buffer_r [127:112];
        end
        default:
        begin
          dac_data_07 <= 16'hdead;
        end
      endcase
    end
    else
    begin
      dac_data_07 <= 16'h0;
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
