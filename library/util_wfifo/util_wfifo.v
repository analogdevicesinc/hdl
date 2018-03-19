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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module util_wfifo #(

  parameter   NUM_OF_CHANNELS = 4,
  parameter   DIN_DATA_WIDTH = 32,
  parameter   DOUT_DATA_WIDTH = 64,
  parameter   DIN_ADDRESS_WIDTH = 8) (

  // d-in interface

  input                   din_rst,
  input                   din_clk,
  input                   din_enable_0,
  input                   din_valid_0,
  input       [DIN_DATA_WIDTH-1:0]  din_data_0,
  input                   din_enable_1,
  input                   din_valid_1,
  input       [DIN_DATA_WIDTH-1:0]  din_data_1,
  input                   din_enable_2,
  input                   din_valid_2,
  input       [DIN_DATA_WIDTH-1:0]  din_data_2,
  input                   din_enable_3,
  input                   din_valid_3,
  input       [DIN_DATA_WIDTH-1:0]  din_data_3,
  input                   din_enable_4,
  input                   din_valid_4,
  input       [DIN_DATA_WIDTH-1:0]  din_data_4,
  input                   din_enable_5,
  input                   din_valid_5,
  input       [DIN_DATA_WIDTH-1:0]  din_data_5,
  input                   din_enable_6,
  input                   din_valid_6,
  input       [DIN_DATA_WIDTH-1:0]  din_data_6,
  input                   din_enable_7,
  input                   din_valid_7,
  input       [DIN_DATA_WIDTH-1:0]  din_data_7,
  output  reg             din_ovf,

  // d-out interface

  input                   dout_rstn,
  input                   dout_clk,
  output                  dout_enable_0,
  output                  dout_valid_0,
  output      [DOUT_DATA_WIDTH-1:0]  dout_data_0,
  output                  dout_enable_1,
  output                  dout_valid_1,
  output      [DOUT_DATA_WIDTH-1:0]  dout_data_1,
  output                  dout_enable_2,
  output                  dout_valid_2,
  output      [DOUT_DATA_WIDTH-1:0]  dout_data_2,
  output                  dout_enable_3,
  output                  dout_valid_3,
  output      [DOUT_DATA_WIDTH-1:0]  dout_data_3,
  output                  dout_enable_4,
  output                  dout_valid_4,
  output      [DOUT_DATA_WIDTH-1:0]  dout_data_4,
  output                  dout_enable_5,
  output                  dout_valid_5,
  output      [DOUT_DATA_WIDTH-1:0]  dout_data_5,
  output                  dout_enable_6,
  output                  dout_valid_6,
  output      [DOUT_DATA_WIDTH-1:0]  dout_data_6,
  output                  dout_enable_7,
  output                  dout_valid_7,
  output      [DOUT_DATA_WIDTH-1:0]  dout_data_7,
  input                   dout_ovf);


  localparam  M_MEM_RATIO = DOUT_DATA_WIDTH/DIN_DATA_WIDTH;
  localparam  ADDRESS_WIDTH = (DIN_ADDRESS_WIDTH > 4) ? DIN_ADDRESS_WIDTH : 4;
  localparam  DATA_WIDTH = DOUT_DATA_WIDTH * NUM_OF_CHANNELS;
  localparam  T_DIN_DATA_WIDTH = DIN_DATA_WIDTH * 8;
  localparam  T_DOUT_DATA_WIDTH = DOUT_DATA_WIDTH * 8;

  // internal registers

  reg     [(DATA_WIDTH-1):0]          din_wdata = 'd0;
  reg     [ 7:0]                      din_enable = 'd0;
  reg                                 din_wr = 'd0;
  reg     [(ADDRESS_WIDTH-1):0]       din_waddr = 'd0;
  reg                                 din_req_t = 'd0;
  reg     [(ADDRESS_WIDTH-4):0]       din_rinit = 'd0;
  reg                                 din_ovf_m1 = 'd0;
  reg                                 dout_req_t_m1 = 'd0;
  reg                                 dout_req_t_m2 = 'd0;
  reg                                 dout_req_t_m3 = 'd0;
  reg                                 dout_req_t = 'd0;
  reg     [(ADDRESS_WIDTH-4):0]       dout_rinit = 'd0;
  reg                                 dout_ovf_d = 'd0;
  reg     [ 3:0]                      dout_req_cnt = 'd0;
  reg     [(ADDRESS_WIDTH-1):0]       dout_raddr = 'd8;
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
  wire    [ 2:0]                      din_dcnt_s;

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

  generate
  if (M_MEM_RATIO == 1) begin
    assign din_dcnt_s = 'b0;
  end else begin
    reg [ 2:0] din_dcnt = 'd0;

    always @(posedge din_clk)
    if (din_rst == 1'b1) begin
      din_dcnt <= 'd0;
    end else begin
      if (din_valid_s[0] == 1'b1) begin
        din_dcnt <= din_dcnt + 1'b1;
      end
    end

    assign din_dcnt_s = din_dcnt;
  end
  endgenerate
  always @(posedge din_clk) begin
    if (din_rst == 1'b1) begin
      din_enable <= 8'd0;
      din_wr <= 1'd0;
      din_waddr <= 'd0;
      din_req_t <= 1'd0;
      din_rinit <= 'd0;
      din_ovf_m1 <= 'd0;
      din_ovf <= 'd0;
    end else begin
      din_enable <= din_enable_s;
     case (M_MEM_RATIO)
        8: din_wr <= din_valid_s[0] & din_dcnt_s[0] & din_dcnt_s[1] & din_dcnt_s[2];
        4: din_wr <= din_valid_s[0] & din_dcnt_s[0] & din_dcnt_s[1];
        2: din_wr <= din_valid_s[0] & din_dcnt_s[0];
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
    .reb (1'b1),
    .addrb (dout_raddr),
    .doutb (dout_rdata_s));

endmodule

// ***************************************************************************
// ***************************************************************************
