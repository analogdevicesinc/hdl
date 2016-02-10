// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
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

module util_mfifo (

  // d-in interface

  din_rst,
  din_clk,
  din_valid,
  din_data_0,
  din_data_1,
  din_data_2,
  din_data_3,
  din_data_4,
  din_data_5,
  din_data_6,
  din_data_7,

  // d-out interface

  dout_rst,
  dout_clk,
  dout_valid,
  dout_data_0,
  dout_data_1,
  dout_data_2,
  dout_data_3,
  dout_data_4,
  dout_data_5,
  dout_data_6,
  dout_data_7);

  // parameters

  parameter   NUM_OF_CHANNELS = 4;
  parameter   DIN_DATA_WIDTH = 32;
  parameter   ADDRESS_WIDTH = 8;

  // d-in interface

  input                               din_rst;
  input                               din_clk;
  input                               din_valid;
  input   [DIN_DATA_WIDTH-1:0]        din_data_0;
  input   [DIN_DATA_WIDTH-1:0]        din_data_1;
  input   [DIN_DATA_WIDTH-1:0]        din_data_2;
  input   [DIN_DATA_WIDTH-1:0]        din_data_3;
  input   [DIN_DATA_WIDTH-1:0]        din_data_4;
  input   [DIN_DATA_WIDTH-1:0]        din_data_5;
  input   [DIN_DATA_WIDTH-1:0]        din_data_6;
  input   [DIN_DATA_WIDTH-1:0]        din_data_7;

  // dout interface

  input                               dout_rst;
  input                               dout_clk;
  output                              dout_valid;
  output  [15:0]                      dout_data_0;
  output  [15:0]                      dout_data_1;
  output  [15:0]                      dout_data_2;
  output  [15:0]                      dout_data_3;
  output  [15:0]                      dout_data_4;
  output  [15:0]                      dout_data_5;
  output  [15:0]                      dout_data_6;
  output  [15:0]                      dout_data_7;

  // internal registers

  reg                                 din_dout_toggle_m1 = 'd0;
  reg                                 din_dout_toggle_m2 = 'd0;
  reg                                 din_dout_toggle_m3 = 'd0;
  reg                                 din_wr = 'd0;
  reg     [(ADDRESS_WIDTH-1):0]       din_waddr = 'd0;
  reg                                 din_enable = 'd0;
  reg                                 din_toggle = 'd0;
  reg                                 dout_din_toggle_m1 = 'd0;
  reg                                 dout_din_toggle_m2 = 'd0;
  reg                                 dout_din_toggle_m3 = 'd0;
  reg     [ 4:0]                      dout_cnt = 'd0;
  reg                                 dout_ld = 'd0;
  reg                                 dout_ld_d = 'd0;
  reg     [(ADDRESS_WIDTH-1):0]       dout_raddr = 'd0;
  reg                                 dout_enable = 'd0;
  reg                                 dout_toggle = 'd0;
  reg                                 dout_valid = 'd0;
  reg     [(DIN_DATA_WIDTH-1):0]      dout_rdata_0 = 'd0;
  reg     [(DIN_DATA_WIDTH-1):0]      dout_rdata_1 = 'd0;
  reg     [(DIN_DATA_WIDTH-1):0]      dout_rdata_2 = 'd0;
  reg     [(DIN_DATA_WIDTH-1):0]      dout_rdata_3 = 'd0;
  reg     [(DIN_DATA_WIDTH-1):0]      dout_rdata_4 = 'd0;
  reg     [(DIN_DATA_WIDTH-1):0]      dout_rdata_5 = 'd0;
  reg     [(DIN_DATA_WIDTH-1):0]      dout_rdata_6 = 'd0;
  reg     [(DIN_DATA_WIDTH-1):0]      dout_rdata_7 = 'd0;

  // internal signals

  wire    [(DIN_DATA_WIDTH-1):0]      din_wdata_s[0:7];
  wire                                din_waddr_max_s;
  wire                                din_dout_toggle_s;
  wire                                dout_raddr_max_s;
  wire                                dout_rd_s;
  wire                                dout_din_toggle_s;
  wire    [(DIN_DATA_WIDTH-1):0]      dout_rdata_s[0:7];

  // variables

  genvar                              n;

  // write interface

  assign din_wdata_s[7] = din_data_7;
  assign din_wdata_s[6] = din_data_6;
  assign din_wdata_s[5] = din_data_5;
  assign din_wdata_s[4] = din_data_4;
  assign din_wdata_s[3] = din_data_3;
  assign din_wdata_s[2] = din_data_2;
  assign din_wdata_s[1] = din_data_1;
  assign din_wdata_s[0] = din_data_0;
  assign din_waddr_max_s = & din_waddr;
  assign din_dout_toggle_s = din_dout_toggle_m3 ^ din_dout_toggle_m2;

  always @(posedge din_clk or posedge din_rst) begin
    if (din_rst == 1'b1) begin
      din_dout_toggle_m1 <= 1'd0;
      din_dout_toggle_m2 <= 1'd0;
      din_dout_toggle_m3 <= 1'd0;
      din_wr <= 1'd0;
      din_waddr <= 'd0;
      din_enable <= 1'd0;
      din_toggle <= 1'd0;
    end else begin
      din_dout_toggle_m1 <= dout_toggle;
      din_dout_toggle_m2 <= din_dout_toggle_m1;
      din_dout_toggle_m3 <= din_dout_toggle_m2;
      din_wr <= din_valid & din_enable;
      if (din_dout_toggle_s == 1'b1) begin
        din_waddr <= 'd0;
        din_enable <= 1'b1;
      end else if (din_wr == 1'b1) begin
        din_waddr <= din_waddr + 1'b1;
        if (din_waddr_max_s == 1) begin
          din_enable <= 1'b0;
        end
      end
      if ((din_wr == 1'b1) && (din_waddr_max_s == 1)) begin
        din_toggle <= ~din_toggle;
      end
    end
  end

  // read interface

  assign dout_raddr_max_s = & dout_raddr;
  assign dout_rd_s = (dout_cnt == 5'd0) ? dout_enable : 1'b0;
  assign dout_din_toggle_s = dout_din_toggle_m3 ^ dout_din_toggle_m2;

  always @(posedge dout_clk or posedge dout_rst) begin
    if (dout_rst == 1'b1) begin
      dout_din_toggle_m1 <= 1'd0;
      dout_din_toggle_m2 <= 1'd0;
      dout_din_toggle_m3 <= 1'd0;
      dout_cnt <= 'd0;
      dout_ld <= 'd0;
      dout_ld_d <= 'd0;
      dout_raddr <= 'd0;
      dout_enable <= 1'd0;
      dout_toggle <= 1'd1;
    end else begin
      dout_din_toggle_m1 <= din_toggle;
      dout_din_toggle_m2 <= dout_din_toggle_m1;
      dout_din_toggle_m3 <= dout_din_toggle_m2;
      if ((dout_din_toggle_s == 1'b1) || (dout_cnt >= ((DIN_DATA_WIDTH/16) - 1))) begin
        dout_cnt <= 'd0;
      end else begin
        dout_cnt <= dout_cnt + 1'b1;
      end
      dout_ld <= | dout_cnt;
      dout_ld_d <= dout_ld;
      if (dout_din_toggle_s == 1'b1) begin
        dout_raddr <= 'd0;
        dout_enable <= 1'b1;
      end else if (dout_rd_s == 1'b1) begin
        dout_raddr <= dout_raddr + 1'b1;
        if (dout_raddr_max_s == 1'b1) begin
          dout_enable <= 1'b0;
        end
      end
      if ((dout_rd_s == 1'b1) && (dout_raddr_max_s == 1'b1)) begin
        dout_toggle <= ~dout_toggle;
      end
    end
  end

  always @(posedge dout_clk or posedge dout_rst) begin
    if (dout_rst == 1'b1) begin
      dout_valid <= 'd0;
      dout_rdata_0 <= 'd0;
      dout_rdata_1 <= 'd0;
      dout_rdata_2 <= 'd0;
      dout_rdata_3 <= 'd0;
      dout_rdata_4 <= 'd0;
      dout_rdata_5 <= 'd0;
      dout_rdata_6 <= 'd0;
      dout_rdata_7 <= 'd0;
    end else begin
      if (dout_ld_d == 1'b0) begin
        dout_valid <= dout_enable;
        dout_rdata_0 <= dout_rdata_s[0];
        dout_rdata_1 <= dout_rdata_s[1];
        dout_rdata_2 <= dout_rdata_s[2];
        dout_rdata_3 <= dout_rdata_s[3];
        dout_rdata_4 <= dout_rdata_s[4];
        dout_rdata_5 <= dout_rdata_s[5];
        dout_rdata_6 <= dout_rdata_s[6];
        dout_rdata_7 <= dout_rdata_s[7];
      end else begin
        dout_valid <= dout_valid;
        dout_rdata_0 <= {16'd0, dout_rdata_0[(DIN_DATA_WIDTH-1):16]};
        dout_rdata_1 <= {16'd0, dout_rdata_1[(DIN_DATA_WIDTH-1):16]};
        dout_rdata_2 <= {16'd0, dout_rdata_2[(DIN_DATA_WIDTH-1):16]};
        dout_rdata_3 <= {16'd0, dout_rdata_3[(DIN_DATA_WIDTH-1):16]};
        dout_rdata_4 <= {16'd0, dout_rdata_4[(DIN_DATA_WIDTH-1):16]};
        dout_rdata_5 <= {16'd0, dout_rdata_5[(DIN_DATA_WIDTH-1):16]};
        dout_rdata_6 <= {16'd0, dout_rdata_6[(DIN_DATA_WIDTH-1):16]};
        dout_rdata_7 <= {16'd0, dout_rdata_7[(DIN_DATA_WIDTH-1):16]};
      end
    end
  end

  assign dout_data_0 = dout_rdata_0[15:0];
  assign dout_data_1 = dout_rdata_1[15:0];
  assign dout_data_2 = dout_rdata_2[15:0];
  assign dout_data_3 = dout_rdata_3[15:0];
  assign dout_data_4 = dout_rdata_4[15:0];
  assign dout_data_5 = dout_rdata_5[15:0];
  assign dout_data_6 = dout_rdata_6[15:0];
  assign dout_data_7 = dout_rdata_7[15:0];

  // instantiations

  generate

  if (NUM_OF_CHANNELS < 8) begin
  for (n = NUM_OF_CHANNELS; n < 8; n = n + 1) begin: g_channels_unused
  assign dout_rdata_s[n] = 'd0;
  end
  end

  for (n = 0; n < NUM_OF_CHANNELS; n = n + 1) begin: g_channels
  ad_mem #(
    .ADDRESS_WIDTH (ADDRESS_WIDTH),
    .DATA_WIDTH (DIN_DATA_WIDTH))
  i_mem (
    .clka (din_clk),
    .wea (din_wr),
    .addra (din_waddr),
    .dina (din_wdata_s[n]),
    .clkb (dout_clk),
    .addrb (dout_raddr),
    .doutb (dout_rdata_s[n]));
  end

  endgenerate

endmodule

// ***************************************************************************
// ***************************************************************************
