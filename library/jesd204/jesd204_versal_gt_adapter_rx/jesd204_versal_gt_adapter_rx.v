// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2020-2022, 2024 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module  jesd204_versal_gt_adapter_rx (
  input  [127 : 0] rxdata,
  input    [5 : 0] rxheader,
  output           rxgearboxslip,
  input    [1 : 0] rxheadervalid,

  // Interface to Link layer core
  output  [63:0]  rx_data,
  output   [1:0]  rx_header,
  output          rx_block_sync,

  input           usr_clk
);

  wire       rxgearboxslip_s;
  reg [63:0] rxdata_d;
  reg [ 1:0] rxheader_d;
  reg        rxgearboxslip_d;
  reg [ 1:0] rxheadervalid_d;

  always @(posedge usr_clk) begin
    rxdata_d <= rxdata[63:0];
    rxheader_d <= rxheader[1:0];
    rxgearboxslip_d <= rxgearboxslip_s;
  end

  // Sync header alignment
  wire rx_bitslip_req_s;
  reg [5:0] rx_bitslip_done_cnt = 'h0;
  always @(posedge usr_clk) begin
    if (rx_bitslip_done_cnt[5]) begin
      rx_bitslip_done_cnt <= 'b0;
    end else if (rx_bitslip_req_s & ~rx_bitslip_done_cnt[5]) begin
      rx_bitslip_done_cnt <= rx_bitslip_done_cnt + 1;
    end
  end

  reg rx_bitslip_req_s_d = 1'b0;
  always @(posedge usr_clk) begin
     rx_bitslip_req_s_d <= rx_bitslip_req_s;
  end

  assign rxgearboxslip_s = rx_bitslip_req_s & ~rx_bitslip_req_s_d;
  assign rxgearboxslip = rxgearboxslip_d;

  wire [63:0] rxdata_flip;
  genvar i;
  for (i = 0; i < 64; i=i+1) begin
    assign rxdata_flip[63-i] = rxdata_d[i];
  end

  // Sync header alignment
  sync_header_align i_sync_header_align (
    .clk(usr_clk),
    .reset(~rxheadervalid[0]),
    // Flip header bits and data
    .i_data({rxheader_d[0],rxheader_d[1],rxdata_flip[63:0]}),
    .i_slip(rx_bitslip_req_s),
    .i_slip_done(rx_bitslip_done_cnt[5]),
    .o_data(rx_data),
    .o_header(rx_header),
    .o_block_sync(rx_block_sync));

endmodule
