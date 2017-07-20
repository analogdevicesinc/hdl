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

module util_wfifo (

  // d-in interface

  din_rst,
  din_clk,
  din_enable_0,
  din_valid_0,
  din_data_0,
  din_enable_1,
  din_valid_1,
  din_data_1,
  din_enable_2,
  din_valid_2,
  din_data_2,
  din_enable_3,
  din_valid_3,
  din_data_3,
  din_enable_4,
  din_valid_4,
  din_data_4,
  din_enable_5,
  din_valid_5,
  din_data_5,
  din_enable_6,
  din_valid_6,
  din_data_6,
  din_enable_7,
  din_valid_7,
  din_data_7,
  din_ovf,

  // d-out interface

  dout_rstn,
  dout_clk,
  dout_enable_0,
  dout_valid_0,
  dout_data_0,
  dout_enable_1,
  dout_valid_1,
  dout_data_1,
  dout_enable_2,
  dout_valid_2,
  dout_data_2,
  dout_enable_3,
  dout_valid_3,
  dout_data_3,
  dout_enable_4,
  dout_valid_4,
  dout_data_4,
  dout_enable_5,
  dout_valid_5,
  dout_data_5,
  dout_enable_6,
  dout_valid_6,
  dout_data_6,
  dout_enable_7,
  dout_valid_7,
  dout_data_7,
  dout_ovf);

  // parameters

  parameter   NUM_OF_CHANNELS = 4;
  parameter   DIN_DATA_WIDTH = 32;
  parameter   DOUT_DATA_WIDTH = 64;
  parameter   DIN_ADDRESS_WIDTH = 8;

  localparam  M_MEM_RATIO = DOUT_DATA_WIDTH/DIN_DATA_WIDTH;
  localparam  ADDRESS_WIDTH = (DIN_ADDRESS_WIDTH > 4) ? DIN_ADDRESS_WIDTH : 4;
  localparam  DATA_WIDTH = DOUT_DATA_WIDTH * NUM_OF_CHANNELS;
  localparam  T_DIN_DATA_WIDTH = DIN_DATA_WIDTH * 8;
  localparam  T_DOUT_DATA_WIDTH = DOUT_DATA_WIDTH * 8;

  // d-in interface

  input                               din_rst;
  input                               din_clk;
  input                               din_enable_0;
  input                               din_valid_0;
  input   [DIN_DATA_WIDTH-1:0]        din_data_0;
  input                               din_enable_1;
  input                               din_valid_1;
  input   [DIN_DATA_WIDTH-1:0]        din_data_1;
  input                               din_enable_2;
  input                               din_valid_2;
  input   [DIN_DATA_WIDTH-1:0]        din_data_2;
  input                               din_enable_3;
  input                               din_valid_3;
  input   [DIN_DATA_WIDTH-1:0]        din_data_3;
  input                               din_enable_4;
  input                               din_valid_4;
  input   [DIN_DATA_WIDTH-1:0]        din_data_4;
  input                               din_enable_5;
  input                               din_valid_5;
  input   [DIN_DATA_WIDTH-1:0]        din_data_5;
  input                               din_enable_6;
  input                               din_valid_6;
  input   [DIN_DATA_WIDTH-1:0]        din_data_6;
  input                               din_enable_7;
  input                               din_valid_7;
  input   [DIN_DATA_WIDTH-1:0]        din_data_7;
  output                              din_ovf;

  // dout interface

  input                               dout_rstn;
  input                               dout_clk;
  output                              dout_enable_0;
  output                              dout_valid_0;
  output  [DOUT_DATA_WIDTH-1:0]       dout_data_0;
  output                              dout_enable_1;
  output                              dout_valid_1;
  output  [DOUT_DATA_WIDTH-1:0]       dout_data_1;
  output                              dout_enable_2;
  output                              dout_valid_2;
  output  [DOUT_DATA_WIDTH-1:0]       dout_data_2;
  output                              dout_enable_3;
  output                              dout_valid_3;
  output  [DOUT_DATA_WIDTH-1:0]       dout_data_3;
  output                              dout_enable_4;
  output                              dout_valid_4;
  output  [DOUT_DATA_WIDTH-1:0]       dout_data_4;
  output                              dout_enable_5;
  output                              dout_valid_5;
  output  [DOUT_DATA_WIDTH-1:0]       dout_data_5;
  output                              dout_enable_6;
  output                              dout_valid_6;
  output  [DOUT_DATA_WIDTH-1:0]       dout_data_6;
  output                              dout_enable_7;
  output                              dout_valid_7;
  output  [DOUT_DATA_WIDTH-1:0]       dout_data_7;
  input                               dout_ovf;

  // internal registers

  reg     [(DATA_WIDTH-1):0]          din_wdata = 'd0;
  reg     [ 7:0]                      din_enable = 'd0;
  reg     [ 2:0]                      din_dcnt = 'd0;
  reg                                 din_wr = 'd0;
  reg     [(ADDRESS_WIDTH-1):0]       din_waddr = 'd0;
  reg                                 din_req_t = 'd0;
  reg     [(ADDRESS_WIDTH-4):0]       din_rinit = 'd0;
  reg                                 din_ovf_m1 = 'd0;
  reg                                 din_ovf = 'd0;
  reg                                 dout_req_t_m1 = 'd0;
  reg                                 dout_req_t_m2 = 'd0;
  reg                                 dout_req_t_m3 = 'd0;
  reg                                 dout_req_t = 'd0;
  reg     [(ADDRESS_WIDTH-4):0]       dout_rinit = 'd0;
  reg                                 dout_ovf_d = 'd0;
  reg     [ 3:0]                      dout_req_cnt = 'd0;
  reg     [(ADDRESS_WIDTH-1):0]       dout_raddr = 'd0;
  reg                                 dout_rd_d = 'd0;
  reg                                 dout_valid = 'd0;
  reg     [ 7:0]                      dout_enable_m1 = 'd0;
  reg     [ 7:0]                      dout_enable = 'd0;
  reg     [(DATA_WIDTH-1):0]          dout_rdata = 'd0;

  // internal signals

  wire    [ 7:0]                      din_enable_s;
  wire    [ 7:0]                      din_valid_s;
  wire    [(T_DIN_DATA_WIDTH-1):0]    din_data_s;
  wire                                dout_req_t_s;
  wire    [(DATA_WIDTH-1):0]          dout_rdata_s;
  wire    [(T_DOUT_DATA_WIDTH+1):0]   dout_data_s;

  // variables

  genvar                              n;

  // concat signals, valid_0 must always be active

  assign din_enable_s = { din_enable_7, din_enable_6, din_enable_5, din_enable_4,
                          din_enable_3, din_enable_2, din_enable_1, din_enable_0};
  assign din_valid_s  = { din_valid_7,  din_valid_6,  din_valid_5,  din_valid_4,
                          din_valid_3,  din_valid_2,  din_valid_1,  din_valid_0};
  assign din_data_s   = { din_data_7,   din_data_6,   din_data_5,   din_data_4,
                          din_data_3,   din_data_2,   din_data_1,   din_data_0};

  // simple data transfer-- no ovf/unf handling- read-bw > write-bw (equal will NOT work)
  // dout_width >= din_width only-

  generate
  for (n = 0; n < NUM_OF_CHANNELS; n = n + 1) begin: g_in
  if (M_MEM_RATIO == 1) begin
  always @(posedge din_clk) begin
    if (din_valid_s[n] == 1'b1) begin
      din_wdata[((DOUT_DATA_WIDTH*(n+1))-1):(DOUT_DATA_WIDTH*n)] <=
        din_data_s[((DIN_DATA_WIDTH*(n+1))-1):(DIN_DATA_WIDTH*n)];
    end
  end
  end else begin
  always @(posedge din_clk) begin
    if (din_valid_s[n] == 1'b1) begin
      din_wdata[((DOUT_DATA_WIDTH*(n+1))-1):(DOUT_DATA_WIDTH*n)] <=
        {din_data_s[((DIN_DATA_WIDTH*(n+1))-1):(DIN_DATA_WIDTH*n)],
        din_wdata[((DOUT_DATA_WIDTH*(n+1))-1):(DIN_DATA_WIDTH+(DOUT_DATA_WIDTH*n))]};
    end
  end
  end
  end
  endgenerate

  always @(posedge din_clk) begin
    if (din_rst == 1'b1) begin
      din_enable <= 8'd0;
      din_dcnt <= 3'd0;
      din_wr <= 1'd0;
      din_waddr <= 'd0;
      din_req_t <= 1'd0;
      din_rinit <= 'd0;
      din_ovf_m1 <= 'd0;
      din_ovf <= 'd0;
    end else begin
      din_enable <= din_enable_s;
      if (din_valid_s[0] == 1'b1) begin
        din_dcnt <= din_dcnt + 1'b1;
      end
      case (M_MEM_RATIO)
        8: din_wr <= din_valid_s[0] & din_dcnt[0] & din_dcnt[1] & din_dcnt[2];
        4: din_wr <= din_valid_s[0] & din_dcnt[0] & din_dcnt[1];
        2: din_wr <= din_valid_s[0] & din_dcnt[0];
        default: din_wr <= din_valid_s[0];
      endcase
      if (din_wr == 1'b1) begin
        din_waddr <= din_waddr + 1'b1;
      end
      if ((din_wr == 1'b1) && (din_waddr[2:0] == 3'd7)) begin
        din_req_t <= ~din_req_t;
        din_rinit <= din_waddr[(ADDRESS_WIDTH-1):3];
      end
      din_ovf_m1 <= dout_ovf_d;
      din_ovf <= din_ovf_m1;
    end
  end

  // read interface (bus expansion and/or clock conversion)

  assign dout_req_t_s = dout_req_t_m3 ^ dout_req_t_m2;

  always @(posedge dout_clk or negedge dout_rstn) begin
    if (dout_rstn == 1'b0) begin
      dout_req_t_m1 <= 'd0;
      dout_req_t_m2 <= 'd0;
      dout_req_t_m3 <= 'd0;
      dout_req_t <= 'd0;
      dout_rinit <= 'd0;
      dout_ovf_d <= 'd0;
    end else begin
      dout_req_t_m1 <= din_req_t;
      dout_req_t_m2 <= dout_req_t_m1;
      dout_req_t_m3 <= dout_req_t_m2;
      dout_req_t <= dout_req_t_s;
      if (dout_req_t_s == 1'b1) begin
        dout_rinit <= din_rinit;
      end
      dout_ovf_d <= dout_ovf;
    end
  end

  always @(posedge dout_clk or negedge dout_rstn) begin
    if (dout_rstn == 1'b0) begin
      dout_req_cnt <= 'd0;
      dout_raddr <= 'd8;
      dout_rd_d <= 'd0;
      dout_valid <= 'd0;
    end else begin
      if (dout_req_t == 1'b1) begin
        dout_req_cnt <= 4'h8;
        dout_raddr <= {dout_rinit, 3'd0};
      end else if (dout_req_cnt[3] == 1'b1) begin
        dout_req_cnt <= dout_req_cnt + 1'b1;
        dout_raddr <= dout_raddr + 1'b1;
      end
      dout_rd_d <= dout_req_cnt[3];
      dout_valid <= dout_rd_d;
    end
  end

  always @(posedge dout_clk or negedge dout_rstn) begin
    if (dout_rstn == 1'b0) begin
      dout_enable_m1 <= 'd0;
      dout_enable <= 'd0;
    end else begin
      dout_enable_m1 <= din_enable;
      dout_enable <= dout_enable_m1;
    end
  end

  always @(posedge dout_clk) begin
    dout_rdata <= dout_rdata_s;
  end

  generate
  if (NUM_OF_CHANNELS >= 8) begin
  assign dout_data_s = dout_rdata;
  end else begin
  assign dout_data_s[(T_DOUT_DATA_WIDTH+1):DATA_WIDTH] = 'd0;
  assign dout_data_s[(DATA_WIDTH-1):0] = dout_rdata;
  end
  endgenerate

  assign dout_enable_7 = dout_enable[7];
  assign dout_valid_7 = dout_valid;
  assign dout_data_7 = dout_data_s[((DOUT_DATA_WIDTH*8)-1):(DOUT_DATA_WIDTH*7)];

  assign dout_enable_6 = dout_enable[6];
  assign dout_valid_6 = dout_valid;
  assign dout_data_6 = dout_data_s[((DOUT_DATA_WIDTH*7)-1):(DOUT_DATA_WIDTH*6)];

  assign dout_enable_5 = dout_enable[5];
  assign dout_valid_5 = dout_valid;
  assign dout_data_5 = dout_data_s[((DOUT_DATA_WIDTH*6)-1):(DOUT_DATA_WIDTH*5)];

  assign dout_enable_4 = dout_enable[4];
  assign dout_valid_4 = dout_valid;
  assign dout_data_4 = dout_data_s[((DOUT_DATA_WIDTH*5)-1):(DOUT_DATA_WIDTH*4)];

  assign dout_enable_3 = dout_enable[3];
  assign dout_valid_3 = dout_valid;
  assign dout_data_3 = dout_data_s[((DOUT_DATA_WIDTH*4)-1):(DOUT_DATA_WIDTH*3)];

  assign dout_enable_2 = dout_enable[2];
  assign dout_valid_2 = dout_valid;
  assign dout_data_2 = dout_data_s[((DOUT_DATA_WIDTH*3)-1):(DOUT_DATA_WIDTH*2)];

  assign dout_enable_1 = dout_enable[1];
  assign dout_valid_1 = dout_valid;
  assign dout_data_1 = dout_data_s[((DOUT_DATA_WIDTH*2)-1):(DOUT_DATA_WIDTH*1)];

  assign dout_enable_0 = dout_enable[0];
  assign dout_valid_0 = dout_valid;
  assign dout_data_0 = dout_data_s[((DOUT_DATA_WIDTH*1)-1):(DOUT_DATA_WIDTH*0)];

  // instantiations

  ad_mem #(.ADDRESS_WIDTH(ADDRESS_WIDTH), .DATA_WIDTH(DATA_WIDTH)) i_mem (
    .clka (din_clk),
    .wea (din_wr),
    .addra (din_waddr),
    .dina (din_wdata),
    .clkb (dout_clk),
    .addrb (dout_raddr),
    .doutb (dout_rdata_s));

endmodule

// ***************************************************************************
// ***************************************************************************
